/* =====================================================================
   BC5 - Bao cao SLA - TAT (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC5.md + lld/pdtd_dtm/* (skill gen-report); review 2026-11-25 (BA: toi da 2 dong/ho so)
   Tham so:
     :p_date_from     DATE      Tu ngay (PROCESSED_DATE), mac dinh T-1
     :p_date_to       DATE      Den ngay (PROCESSED_DATE), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = :p_date_to (giu nguyen)
   Grain: toi da 2 dong / ho so (moi nhanh CLOS, RLOS); cot BI_FLAG_APPROVAL phan biet:
     - 'First Approval' (1) ho so DA phe duyet lan 1: doc bang tinh san PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL (1 dong/ho so, chi lan duyet dau, append-only),
                            loc PROCESSED_DATE trong khoang, KHONG can loc DAYID vi bang chi chua ho so da Approved/Rejected (nguoi dung chot 2026-11-25;
                            chi khi chay lai cho :p_date_to qua khu ma ho so duoc he thong thay duyet SAU ngay do thi phan live con 'Processing' trong khi bang da co dong 'Approved');
                        (2) ho so CHUA phe duyet (MIN_APP_EXITDATE IS NULL): tinh truc tiep tu FCT_*_APPLICATION + FCT_*_WORKSTEP_EVENT, BI_APPSTATUS = APPLICATION_STATUS
                            (Processing/Cancelled), TAT cac buoc den hien tai. Ho so chi o BranchSupport co PROCESSED_DATE NULL nen khong len bao cao.
     - 'From Second Approval': ho so da phe duyet lan 1 va co event buoc PDTD (ke ca PhoneVerification) SAU do (quay lai PDTD); tinh truc tiep, PD lan 3 tro di gop chung.
         PROCESSED_DATE = FCT.PROCESSED_DATE (ngay phe duyet gan nhat), TAT = cac buoc SAU lan phe duyet dau (event co NVL(EXITDATE, ENTRYDATE) > MIN_APP_EXITDATE).
         BI_APPSTATUS: 'Cancelled' neu buoc cuoi la CancelRevoke/CancelPermanent va buoc ngay truoc (PRE_WORKSTEP_CODE) thuoc PDTD;
                       'Processing' neu co event buoc PDTD tu lan phe duyet gan nhat tro di (da bi tra lai / cho phe duyet lai); con lai = APPLICATION_STATUS (Approved/Rejected).
   Phan live (tinh truc tiep):
     - FCT_*_APPLICATION co DAYID = :p_date_to va PROCESSED_DATE trong [:p_date_from, :p_date_to].
     - STEPnn_* / TAT_*: SUM theo buoc cua TAT_CALENDAR_HOUR / TAT_WORKING_HOUR / TAT_CPC_HOUR tren FCT_*_WORKSTEP_EVENT (LLD da tinh san; buoc dang treo
       dong bang den het ngay dau tien), lam tron 2 chu so.
     - FCT_*_WORKSTEP_EVENT ghi nhieu phien ban / su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK den :p_date_to.
       Day la lich su cac buoc de cong TAT nen CHI chan tren DAYID <= :p_date_to, KHONG chan duoi theo :p_date_from.
     - SLA_DE / SLA_QC / QD_DDE / QD_QC: tra PDTD_DTM.REF_SLA_NLTT luc truy van
       (RLOS: PRODUCT_LINE = DIM_RLOS_PRODUCT.PRODUCTLINE_NAME; CLOS: NEW_CHANGE_REQUEST = CHANGE_REQUEST, PRODUCT_LINE = DIM_CLOS_PRODUCT.PRODUCTLINE_NAME
       (noi theo PRODUCTLINE_SK, lay ten moi nhat cua layer Product Line), SUB_PRODUCT: dong khop SUB_PRODUCT cua ho so THANG dong mac dinh SUB_PRODUCT NULL
       (COALESCE; cung quy uoc FCT_CLOS_APPLICATION.REF_PRODUCT/SLA_*) — seed REF_SLA_NLTT co nhom co ca 2 dong nen join theo chu SRS se nhan dong; nguoi dung da chot quy tac nay 2026-11-25, ngoai chu SRS).
     - Ten truong SLA_*_RESUTL giu dung chinh ta cua SRS.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_date_from) AS d_from,
           TRUNC(:p_date_to)   AS d_to
    FROM   DUAL
),
-- ===== CLOS =====
clos_app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_CLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.d_to
            AND a.PROCESSED_DATE >= p.d_from
            AND a.PROCESSED_DATE <  p.d_to + 1
),
-- Su kien cac buoc tinh TAT (phien ban moi nhat cua tung su kien, den :p_date_to)
clos_ev AS (
    SELECT e.WI_NAME, e.WORKSTEP_CODE, e.DECISION_CODE, e.ENTRYDATE, e.EXITDATE,
           e.TAT_CALENDAR_HOUR, e.TAT_WORKING_HOUR, e.TAT_CPC_HOUR
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   clos_app a ON a.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee')
      AND  (a.MIN_APP_EXITDATE IS NULL OR NVL(e.EXITDATE, e.ENTRYDATE) > a.MIN_APP_EXITDATE)   -- da duyet lan 1: chi event SAU lan duyet dau
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
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
           -- PDTD_EVT_CNT: co event buoc PDTD sau lan duyet dau -> ho so da duyet moi co dong 'From Second Approval'; INFLIGHT_CNT: event buoc PDTD tu lan phe duyet gan nhat tro di (dang xu ly)
           COUNT(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') THEN 1 END)                                        AS PDTD_EVT_CNT,
           COUNT(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') AND e.ENTRYDATE >= a.PROCESSED_DATE THEN 1 END)    AS INFLIGHT_CNT,
           MIN(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.ENTRYDATE END)                   AS ENTRYDATE_DDE,
           MAX(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN e.EXITDATE  END)                   AS EXITDATE_DDE
    FROM   clos_app a
    LEFT JOIN clos_ev e ON e.WI_NAME = a.WI_NAME
    GROUP  BY a.WI_NAME
),
-- Tra REF_SLA_NLTT nhanh CLOS: dong khop SUB_PRODUCT cu the THANG dong mac dinh (SUB_PRODUCT NULL) - tranh nhan dong
clos_ref AS (
    SELECT a.WI_NAME,
           COALESCE(fs.SLA_DE_RESULT, fd.SLA_DE_RESULT) AS SLA_DE_RESULT,
           COALESCE(fs.SLA_QC_RESULT, fd.SLA_QC_RESULT) AS SLA_QC_RESULT,
           COALESCE(fs.QD_DDE,        fd.QD_DDE)        AS QD_DDE,
           COALESCE(fs.QD_QC,         fd.QD_QC)         AS QD_QC
    FROM   clos_app a
    LEFT JOIN PDTD_DTM.DIM_CLOS_APPLICATION da ON da.DIMENSION_KEY = a.APPLICATION_SK
    LEFT JOIN (SELECT PRODUCTLINE_SK,
                      MAX(PRODUCTLINE_NAME) KEEP (DENSE_RANK LAST
                          ORDER BY NVL(PRODUCTLINE_EFF_DATE, DATE '1900-01-01'),
                                   NVL(PRODUCTLINE_EXP_DATE, DATE '9999-12-31')) AS PRODUCTLINE_NAME
               FROM   PDTD_DTM.DIM_CLOS_PRODUCT
               GROUP  BY PRODUCTLINE_SK) pr ON pr.PRODUCTLINE_SK = a.PRODUCTLINE_SK
    LEFT JOIN PDTD_DTM.REF_SLA_NLTT fs ON fs.SYSTEMNAME = 'CLOS'
                                      AND fs.NEW_CHANGE_REQUEST = a.CHANGE_REQUEST
                                      AND fs.PRODUCT_LINE = pr.PRODUCTLINE_NAME
                                      AND fs.SUB_PRODUCT = da.SUB_PRODUCT
    LEFT JOIN PDTD_DTM.REF_SLA_NLTT fd ON fd.SYSTEMNAME = 'CLOS'
                                      AND fd.NEW_CHANGE_REQUEST = a.CHANGE_REQUEST
                                      AND fd.PRODUCT_LINE = pr.PRODUCTLINE_NAME
                                      AND fd.SUB_PRODUCT IS NULL
),
-- ===== RLOS =====
rlos_app AS (
    SELECT a.*
    FROM   PDTD_DTM.FCT_RLOS_APPLICATION a
    JOIN   p ON a.DAYID = p.d_to
            AND a.PROCESSED_DATE >= p.d_from
            AND a.PROCESSED_DATE <  p.d_to + 1
),
-- Su kien cac buoc tinh TAT (phien ban moi nhat cua tung su kien, den :p_date_to)
rlos_ev AS (
    SELECT e.WI_NAME, e.WORKSTEP_CODE, e.DECISION_CODE, e.ENTRYDATE, e.EXITDATE,
           e.TAT_CALENDAR_HOUR, e.TAT_WORKING_HOUR, e.TAT_CPC_HOUR
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   rlos_app a ON a.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  e.WORKSTEP_CODE IN ('BranchSupport','DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee')
      AND  (a.MIN_APP_EXITDATE IS NULL OR NVL(e.EXITDATE, e.ENTRYDATE) > a.MIN_APP_EXITDATE)   -- da duyet lan 1: chi event SAU lan duyet dau
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
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
           -- PDTD_EVT_CNT: co event buoc PDTD sau lan duyet dau -> ho so da duyet moi co dong 'From Second Approval'; INFLIGHT_CNT: event buoc PDTD tu lan phe duyet gan nhat tro di (dang xu ly)
           COUNT(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') THEN 1 END)                                        AS PDTD_EVT_CNT,
           COUNT(CASE WHEN e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') AND e.ENTRYDATE >= a.PROCESSED_DATE THEN 1 END)    AS INFLIGHT_CNT,
           MIN(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.ENTRYDATE END)                   AS ENTRYDATE_DDE,
           MAX(CASE WHEN e.WORKSTEP_CODE = 'DetailDataEntry' THEN e.EXITDATE  END)                   AS EXITDATE_DDE
    FROM   rlos_app a
    LEFT JOIN rlos_ev e ON e.WI_NAME = a.WI_NAME
    GROUP  BY a.WI_NAME
)
-- ===== Phan 1: lan phe duyet dau da tinh san (PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL), loc PROCESSED_DATE, KHONG loc DAYID =====
SELECT
    t.SYSTEMNAME,
    t.PROCESSED_DATE,
    t.WI_NAME AS WINAME,
    t.BI_APPSTATUS,
    t.STEP01_BRANCH_CL_TAT,
    t.STEP01_BRANCH_WK_TAT,
    t.STEP01_BRANCH_TAT_CPC,
    t.STEP02_DDE_CL_TAT,
    t.STEP02_DDE_WK_TAT,
    t.STEP02_DDE_TAT_CPC,
    t.STEP03_QUALITY_CHECKER_CL_TAT,
    t.STEP03_QUALITY_CHECKER_WK_TAT,
    t.STEP03_QUALITY_CHECKER_TAT_CPC,
    t.STEP04_UNDMAKER_CL_TAT,
    t.STEP04_UNDMAKER_WK_TAT,
    t.STEP04_UNDMAKER_TAT_CPC,
    t.STEP04_UNDCHECKER_CL_TAT,
    t.STEP04_UNDCHECKER_WK_TAT,
    t.STEP04_UNDCHECKER_TAT_CPC,
    t.STEP04_UND_TAT_CPC,
    t.STEP07_APPROVER_CL_TAT,
    t.STEP07_APPROVER_WK_TAT,
    t.STEP07_APPROVER_TAT_CPC,
    t.STEP07_COMMITTEE_CL_TAT,
    t.STEP07_COMMITTEE_WK_TAT,
    t.REF_PRODUCT,
    t.SLA_CREDIT_OFFICER,
    t.SLA_CREDIT_APPROVER,
    t.SLA_MARKER,
    t.SLA_CHECKER,
    t.SLA_MARKER_RESUTL,
    t.SLA_CHECKER_RESUTL,
    t.SLA_CO_RESUTL,
    t.SLA_APPROVER_RESULT,
    t.SLA_CO_APPROVER_RESULT,
    t.TAT_PHONG_CL_TAT,
    t.TAT_PHONG_WK_TAT,
    t.TAT_KHOI_PDTD_CL_TAT,
    t.TAT_KHOI_PDTD_WK_TAT,
    'First Approval' AS BI_FLAG_APPROVAL,
    t.ENTRYDATE_DDE,
    t.EXITDATE_DDE,
    t.SLA_DE,
    t.SLA_QC,
    t.SLA_DE_RESULT,
    t.SLA_QC_RESULT,
    t.SLA_DE_TOTAL_RESULT,
    t.QD_DDE,
    t.QD_QC
FROM       PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL t
JOIN       p ON t.PROCESSED_DATE >= p.d_from AND t.PROCESSED_DATE < p.d_to + 1
UNION ALL
-- ===== Phan 2: tinh truc tiep, nhanh CLOS (ho so chua duyet + dong 'From Second Approval') =====
SELECT
    'CLOS'                                                  AS SYSTEMNAME,
    a.PROCESSED_DATE,
    a.WI_NAME                                               AS WINAME,
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN a.APPLICATION_STATUS
         WHEN a.LAST_WORKSTEP IN ('CancelRevoke','CancelPermanent') AND a.PRE_WORKSTEP_CODE IN ('DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') THEN 'Cancelled'
         WHEN g.INFLIGHT_CNT > 0 THEN 'Processing'
         ELSE a.APPLICATION_STATUS END                       AS BI_APPSTATUS,
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
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN 'First Approval' ELSE 'From Second Approval' END   AS BI_FLAG_APPROVAL,
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
LEFT JOIN  clos_ref f ON f.WI_NAME = a.WI_NAME
WHERE      (a.MIN_APP_EXITDATE IS NULL OR g.PDTD_EVT_CNT > 0)   -- chua duyet: dong First; da duyet: chi khi quay lai PDTD (dong Second)
UNION ALL
-- ===== Phan 2: tinh truc tiep, nhanh RLOS (ho so chua duyet + dong 'From Second Approval') =====
SELECT
    'RLOS'                                                  AS SYSTEMNAME,
    a.PROCESSED_DATE,
    a.WI_NAME                                               AS WINAME,
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN a.APPLICATION_STATUS
         WHEN a.LAST_WORKSTEP IN ('CancelRevoke','CancelPermanent') AND a.PRE_WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee') THEN 'Cancelled'
         WHEN g.INFLIGHT_CNT > 0 THEN 'Processing'
         ELSE a.APPLICATION_STATUS END                       AS BI_APPSTATUS,
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
    CASE WHEN a.MIN_APP_EXITDATE IS NULL THEN 'First Approval' ELSE 'From Second Approval' END   AS BI_FLAG_APPROVAL,
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
WHERE      (a.MIN_APP_EXITDATE IS NULL OR g.PDTD_EVT_CNT > 0)
ORDER BY   SYSTEMNAME, WINAME, BI_FLAG_APPROVAL;
