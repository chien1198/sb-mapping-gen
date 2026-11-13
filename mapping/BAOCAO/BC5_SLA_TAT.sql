/* =====================================================================
   BC5 - Bao cao SLA - TAT (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC5.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / ho so (moi nhanh CLOS, RLOS).
     - Pham vi: FCT_*_APPLICATION co DAYID = ngay bao cao va PROCESSED_DATE trong ngay bao cao.
     - STEPnn_* / TAT_*: SUM theo buoc cua TAT_CALENDAR_HOUR / TAT_WORKING_HOUR / TAT_CPC_HOUR tren
       FCT_*_WORKSTEP_EVENT (LLD da tinh san; buoc dang treo tinh den het ngay batch), lam tron 2 chu so.
     - FCT_*_WORKSTEP_EVENT ghi nhieu phien ban / su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat
       cua tung WORKSTEP_EVENT_BK den ngay bao cao.
     - SLA_DE / SLA_QC / QD_DDE / QD_QC: tra PDTD_DTM.REF_SLA_NLTT luc truy van
       (RLOS: PRODUCT_LINE = DIM_RLOS_PRODUCT.PRODUCTLINE_NAME; CLOS: PRODUCT_LINE = DIM_CLOS_PRODUCT.PRODUCTLINE_NAME (noi theo PRODUCTLINE_SK, lay ten moi nhat cua layer Product Line),
       NEW_CHANGE_REQUEST = CHANGE_REQUEST, SUB_PRODUCT NULL hoac bang SUB_PRODUCT cua ho so).
     - Ten truong SLA_*_RESUTL giu dung chinh ta cua SRS.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL
),
-- ===== CLOS =====
clos_app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_CLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.rpt_date
            AND a.PROCESSED_DATE >= p.rpt_date
            AND a.PROCESSED_DATE <  p.rpt_date + 1
    LEFT JOIN PDTD_DTM.DIM_LOS_COMPANY c ON c.DIMENSION_KEY = a.COMPANY_SK
    WHERE  (:p_branch_code IS NULL OR c.BRANCH_CODE = :p_branch_code)
),
-- Su kien cac buoc tinh TAT (phien ban moi nhat cua tung su kien, den ngay bao cao)
clos_ev AS (
    SELECT e.WI_NAME, e.WORKSTEP_CODE, e.DECISION_CODE, e.ENTRYDATE, e.EXITDATE,
           e.TAT_CALENDAR_HOUR, e.TAT_WORKING_HOUR, e.TAT_CPC_HOUR,
           NVL(e.EXITDATE, CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND) AS EXITDATE_EFF
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   clos_app a ON a.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.rpt_date
    WHERE  e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee')
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.rpt_date)
),
clos_agg AS (
    SELECT a.WI_NAME,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP01_BRANCH_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP01_BRANCH_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP01_BRANCH_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP02_DDE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP02_DDE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP02_DDE_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDMAKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDMAKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDMAKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UND_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_APPROVER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_APPROVER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP07_APPROVER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_COMMITTEE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_COMMITTEE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS TAT_PHONG_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS TAT_PHONG_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS TAT_KHOI_PDTD_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS TAT_KHOI_PDTD_WK_TAT,
           -- First Approval / From Second Approval: so EXITDATE (NULL -> 23:59:59 ngay vao buoc) voi lan phe duyet dau tien
           CASE WHEN MAX(CASE WHEN e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN e.EXITDATE_EFF END)
                     > MIN(CASE WHEN e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
                                 AND e.DECISION_CODE IN ('Submit','Send To HOSupport','Send To PostSanction','Reject','Submit To DisbursementMaker')
                                THEN e.EXITDATE END)
                THEN 'From Second Approval' ELSE 'First Approval' END                  AS BI_FLAG_APPROVAL,
           MIN(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.ENTRYDATE END)                   AS ENTRYDATE_DDE,
           MAX(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.EXITDATE  END)                   AS EXITDATE_DDE
    FROM   clos_app a
    LEFT JOIN clos_ev e ON e.WI_NAME = a.WI_NAME
    GROUP  BY a.WI_NAME
),
-- ===== RLOS =====
rlos_app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_RLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.rpt_date
            AND a.PROCESSED_DATE >= p.rpt_date
            AND a.PROCESSED_DATE <  p.rpt_date + 1
    LEFT JOIN PDTD_DTM.DIM_LOS_COMPANY c ON c.DIMENSION_KEY = a.COMPANY_SK
    WHERE  (:p_branch_code IS NULL OR c.BRANCH_CODE = :p_branch_code)
),
-- Su kien cac buoc tinh TAT (phien ban moi nhat cua tung su kien, den ngay bao cao)
rlos_ev AS (
    SELECT e.WI_NAME, e.WORKSTEP_CODE, e.DECISION_CODE, e.ENTRYDATE, e.EXITDATE,
           e.TAT_CALENDAR_HOUR, e.TAT_WORKING_HOUR, e.TAT_CPC_HOUR,
           NVL(e.EXITDATE, CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND) AS EXITDATE_EFF
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   rlos_app a ON a.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.rpt_date
    WHERE  e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee')
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.rpt_date)
),
rlos_agg AS (
    SELECT a.WI_NAME,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP01_BRANCH_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP01_BRANCH_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'BranchSupport' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP01_BRANCH_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP02_DDE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP02_DDE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP02_DDE_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DataInputerChecker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DataInputerChecker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'DataInputerChecker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP03_QUALITY_CHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDMAKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDMAKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterMaker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDMAKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'UnderwriterChecker' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UNDCHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP04_UND_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_APPROVER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_APPROVER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CPC_HOUR END), 0), 2)  AS STEP07_APPROVER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS STEP07_COMMITTEE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN e.TAT_WORKING_HOUR END), 0), 2)  AS STEP07_COMMITTEE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CALENDAR_HOUR END), 0), 2)  AS TAT_PHONG_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_WORKING_HOUR END), 0), 2)  AS TAT_PHONG_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_CALENDAR_HOUR END), 0)
             + CASE WHEN COUNT(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN 1 END) = 0
                    THEN NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_CALENDAR_HOUR END), 0) ELSE 0 END, 2)  AS TAT_KHOI_PDTD_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN e.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN e.TAT_WORKING_HOUR END), 0)
             + CASE WHEN COUNT(CASE WHEN e.WORKSTEP_CODE = 'CreditCommittee' THEN 1 END) = 0
                    THEN NVL(SUM(CASE WHEN e.WORKSTEP_CODE = 'CreditApproval' THEN e.TAT_WORKING_HOUR END), 0) ELSE 0 END, 2)  AS TAT_KHOI_PDTD_WK_TAT,
           -- First Approval / From Second Approval: so EXITDATE (NULL -> 23:59:59 ngay vao buoc) voi lan phe duyet dau tien
           CASE WHEN MAX(CASE WHEN e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN e.EXITDATE_EFF END)
                     > MIN(CASE WHEN e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
                                 AND e.DECISION_CODE IN ('Submit','Send To HOSupport','Send To PostSanction','Reject','Submit To DisbursementMaker')
                                THEN e.EXITDATE END)
                THEN 'From Second Approval' ELSE 'First Approval' END                  AS BI_FLAG_APPROVAL,
           MIN(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.ENTRYDATE END)                   AS ENTRYDATE_DDE,
           MAX(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.EXITDATE  END)                   AS EXITDATE_DDE
    FROM   rlos_app a
    LEFT JOIN rlos_ev e ON e.WI_NAME = a.WI_NAME
    GROUP  BY a.WI_NAME
)
-- ===== Nhanh CLOS =====
SELECT
    'CLOS'                                                  AS SYSTEMNAME,
    a.PROCESSED_DATE,
    a.WI_NAME                                               AS WINAME,
    a.APPLICATION_STATUS                                    AS BI_APPSTATUS,
    g.STEP01_BRANCH_CL_TAT,
    g.STEP01_BRANCH_WK_TAT,
    g.STEP01_BRANCH_TAT_CPC,
    g.STEP02_DDE_CL_TAT,
    g.STEP02_DDE_WK_TAT,
    g.STEP02_DDE_TAT_CPC,
    g.STEP03_QUALITY_CHECKER_CL_TAT,
    g.STEP03_QUALITY_CHECKER_WK_TAT,
    g.STEP03_QUALITY_CHECKER_TAT_CPC,
    g.STEP04_UNDMAKER_CL_TAT,
    g.STEP04_UNDMAKER_WK_TAT,
    g.STEP04_UNDMAKER_TAT_CPC,
    g.STEP04_UNDCHECKER_CL_TAT,
    g.STEP04_UNDCHECKER_WK_TAT,
    g.STEP04_UNDCHECKER_TAT_CPC,
    g.STEP04_UND_TAT_CPC,
    g.STEP07_APPROVER_CL_TAT,
    g.STEP07_APPROVER_WK_TAT,
    g.STEP07_APPROVER_TAT_CPC,
    g.STEP07_COMMITTEE_CL_TAT,
    g.STEP07_COMMITTEE_WK_TAT,
    a.REF_PRODUCT,
    a.SLA_CREDIT_OFFICER,
    a.SLA_CREDIT_APPROVER,
    a.SLA_MARKER,
    a.SLA_CHECKER,
    CASE WHEN g.STEP04_UNDMAKER_TAT_CPC > a.SLA_MARKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDMAKER_TAT_CPC <= a.SLA_MARKER THEN 'DAT' END                    AS SLA_MARKER_RESUTL,
    CASE WHEN g.STEP04_UNDCHECKER_TAT_CPC > a.SLA_CHECKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDCHECKER_TAT_CPC <= a.SLA_CHECKER THEN 'DAT' END                    AS SLA_CHECKER_RESUTL,
    CASE WHEN g.STEP04_UND_TAT_CPC > a.SLA_CREDIT_OFFICER THEN 'KHONG DAT'
         WHEN g.STEP04_UND_TAT_CPC <= a.SLA_CREDIT_OFFICER THEN 'DAT' END                    AS SLA_CO_RESUTL,
    CASE WHEN g.STEP07_APPROVER_TAT_CPC > a.SLA_CREDIT_APPROVER THEN 'KHONG DAT'
         WHEN g.STEP07_APPROVER_TAT_CPC <= a.SLA_CREDIT_APPROVER THEN 'DAT' END                    AS SLA_APPROVER_RESULT,
    CASE WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) > (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'KHONG DAT'
         WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) <= (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'DAT' END                    AS SLA_CO_APPROVER_RESULT,
    g.TAT_PHONG_CL_TAT,
    g.TAT_PHONG_WK_TAT,
    g.TAT_KHOI_PDTD_CL_TAT,
    g.TAT_KHOI_PDTD_WK_TAT,
    g.BI_FLAG_APPROVAL,
    g.ENTRYDATE_DDE,
    g.EXITDATE_DDE,
    f.SLA_DE_RESULT                                         AS SLA_DE,
    f.SLA_QC_RESULT                                         AS SLA_QC,
    CASE WHEN g.STEP02_DDE_TAT_CPC > f.SLA_DE_RESULT THEN 'KHONG DAT'
         WHEN g.STEP02_DDE_TAT_CPC <= f.SLA_DE_RESULT THEN 'DAT' END                    AS SLA_DE_RESULT,
    CASE WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC > f.SLA_QC_RESULT THEN 'KHONG DAT'
         WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC <= f.SLA_QC_RESULT THEN 'DAT' END                    AS SLA_QC_RESULT,
    CASE WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) > (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'KHONG DAT'
         WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) <= (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'DAT' END                    AS SLA_DE_TOTAL_RESULT,
    f.QD_DDE,
    f.QD_QC
FROM       clos_app a
JOIN       clos_agg g ON g.WI_NAME = a.WI_NAME
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION da ON da.DIMENSION_KEY = a.APPLICATION_SK
LEFT JOIN  (SELECT PRODUCTLINE_SK,
                   MAX(PRODUCTLINE_NAME) KEEP (DENSE_RANK LAST
                       ORDER BY NVL(PRODUCTLINE_EFF_DATE, DATE '1900-01-01'),
                                NVL(PRODUCTLINE_EXP_DATE, DATE '9999-12-31')) AS PRODUCTLINE_NAME
            FROM   PDTD_DTM.DIM_CLOS_PRODUCT
            GROUP  BY PRODUCTLINE_SK)  pr ON pr.PRODUCTLINE_SK = a.PRODUCTLINE_SK
LEFT JOIN  PDTD_DTM.REF_SLA_NLTT         f  ON f.SYSTEMNAME = 'CLOS'
                                           AND f.NEW_CHANGE_REQUEST = a.CHANGE_REQUEST
                                           AND f.PRODUCT_LINE = pr.PRODUCTLINE_NAME
                                           AND (f.SUB_PRODUCT IS NULL OR f.SUB_PRODUCT = da.SUB_PRODUCT)
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    'RLOS'                                                  AS SYSTEMNAME,
    a.PROCESSED_DATE,
    a.WI_NAME                                               AS WINAME,
    a.APPLICATION_STATUS                                    AS BI_APPSTATUS,
    g.STEP01_BRANCH_CL_TAT,
    g.STEP01_BRANCH_WK_TAT,
    g.STEP01_BRANCH_TAT_CPC,
    g.STEP02_DDE_CL_TAT,
    g.STEP02_DDE_WK_TAT,
    g.STEP02_DDE_TAT_CPC,
    g.STEP03_QUALITY_CHECKER_CL_TAT,
    g.STEP03_QUALITY_CHECKER_WK_TAT,
    g.STEP03_QUALITY_CHECKER_TAT_CPC,
    g.STEP04_UNDMAKER_CL_TAT,
    g.STEP04_UNDMAKER_WK_TAT,
    g.STEP04_UNDMAKER_TAT_CPC,
    g.STEP04_UNDCHECKER_CL_TAT,
    g.STEP04_UNDCHECKER_WK_TAT,
    g.STEP04_UNDCHECKER_TAT_CPC,
    g.STEP04_UND_TAT_CPC,
    g.STEP07_APPROVER_CL_TAT,
    g.STEP07_APPROVER_WK_TAT,
    g.STEP07_APPROVER_TAT_CPC,
    g.STEP07_COMMITTEE_CL_TAT,
    g.STEP07_COMMITTEE_WK_TAT,
    a.REF_PRODUCT,
    a.SLA_CREDIT_OFFICER,
    a.SLA_CREDIT_APPROVER,
    a.SLA_MARKER,
    a.SLA_CHECKER,
    CASE WHEN g.STEP04_UNDMAKER_TAT_CPC > a.SLA_MARKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDMAKER_TAT_CPC <= a.SLA_MARKER THEN 'DAT' END                    AS SLA_MARKER_RESUTL,
    CASE WHEN g.STEP04_UNDCHECKER_TAT_CPC > a.SLA_CHECKER THEN 'KHONG DAT'
         WHEN g.STEP04_UNDCHECKER_TAT_CPC <= a.SLA_CHECKER THEN 'DAT' END                    AS SLA_CHECKER_RESUTL,
    CASE WHEN g.STEP04_UND_TAT_CPC > a.SLA_CREDIT_OFFICER THEN 'KHONG DAT'
         WHEN g.STEP04_UND_TAT_CPC <= a.SLA_CREDIT_OFFICER THEN 'DAT' END                    AS SLA_CO_RESUTL,
    CASE WHEN g.STEP07_APPROVER_TAT_CPC > a.SLA_CREDIT_APPROVER THEN 'KHONG DAT'
         WHEN g.STEP07_APPROVER_TAT_CPC <= a.SLA_CREDIT_APPROVER THEN 'DAT' END                    AS SLA_APPROVER_RESULT,
    CASE WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) > (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'KHONG DAT'
         WHEN (g.STEP04_UND_TAT_CPC + g.STEP07_APPROVER_TAT_CPC) <= (a.SLA_CREDIT_OFFICER + a.SLA_CREDIT_APPROVER) THEN 'DAT' END                    AS SLA_CO_APPROVER_RESULT,
    g.TAT_PHONG_CL_TAT,
    g.TAT_PHONG_WK_TAT,
    g.TAT_KHOI_PDTD_CL_TAT,
    g.TAT_KHOI_PDTD_WK_TAT,
    g.BI_FLAG_APPROVAL,
    g.ENTRYDATE_DDE,
    g.EXITDATE_DDE,
    f.SLA_DE_RESULT                                         AS SLA_DE,
    f.SLA_QC_RESULT                                         AS SLA_QC,
    CASE WHEN g.STEP02_DDE_TAT_CPC > f.SLA_DE_RESULT THEN 'KHONG DAT'
         WHEN g.STEP02_DDE_TAT_CPC <= f.SLA_DE_RESULT THEN 'DAT' END                    AS SLA_DE_RESULT,
    CASE WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC > f.SLA_QC_RESULT THEN 'KHONG DAT'
         WHEN g.STEP03_QUALITY_CHECKER_TAT_CPC <= f.SLA_QC_RESULT THEN 'DAT' END                    AS SLA_QC_RESULT,
    CASE WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) > (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'KHONG DAT'
         WHEN (g.STEP02_DDE_TAT_CPC + g.STEP03_QUALITY_CHECKER_TAT_CPC) <= (f.SLA_DE_RESULT + f.SLA_QC_RESULT) THEN 'DAT' END                    AS SLA_DE_TOTAL_RESULT,
    f.QD_DDE,
    f.QD_QC
FROM       rlos_app a
JOIN       rlos_agg g ON g.WI_NAME = a.WI_NAME
LEFT JOIN  PDTD_DTM.DIM_RLOS_PRODUCT     pr ON pr.DIMENSION_KEY = a.SUB_PRODUCT_SK
LEFT JOIN  PDTD_DTM.REF_SLA_NLTT         f  ON f.SYSTEMNAME = 'RLOS'
                                           AND f.PRODUCT_LINE = pr.PRODUCTLINE_NAME
ORDER BY   SYSTEMNAME, WINAME;
