WITH
-- Ho so: PROCESSED_DATE/ BI_APPSTATUS/ BI_FLAG_APPROVAL
HS AS (
    SELECT x.WINAME,
           -- PROCESSED_DATE: UT1 phe duyet cuoi > UT2 CancelRevoke > UT3 Max(EXITDATE)
           COALESCE(MAX(CASE WHEN x.WORKSTEP IN ('CreditApproval','CreditCommittee') AND x.DECISION IN
                                  ('Submit','Send To HOSupport','Send To PostSanction','Reject','Submit To DisbursementMaker')
                             THEN x.EXITDATE END),
                    MAX(CASE WHEN x.WORKSTEP = 'CancelRevoke' THEN NVL(x.EXITDATE, x.ENTRYDATE) END),
                    MAX(x.EXITDATE))                                                   AS PROCESSED_DATE,
           CASE WHEN MAX(CASE WHEN x.WORKSTEP IN ('CreditApproval','CreditCommittee') AND x.DECISION IN
                                   ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')
                              THEN 1 ELSE 0 END) = 1                                  THEN 'Approved'
                WHEN MAX(CASE WHEN x.WORKSTEP IN ('CreditApproval','CreditCommittee') AND x.DECISION = 'Reject'
                              THEN 1 ELSE 0 END) = 1                                  THEN 'Rejected'
                WHEN MAX(CASE WHEN x.WORKSTEP IN ('CancelRevoke','CancelPermanent')
                              THEN 1 ELSE 0 END) = 1                                  THEN 'Cancelled'
                ELSE 'Processing'
           END                                                                         AS BI_APPSTATUS,
           -- Rule: First Approval: Thoi gian xu ly tat ca cac buoc cho đen phe duyet lan đau
				--	From Second Approval: Thoi gian sau phe duyet lan đau 
           	-- So sanh theo EXITDATE, EXITDATE null --> lay 23:59:59 cuoi ngay
           CASE WHEN MAX(x.EXITDATE_EFF)
                   > MIN(CASE WHEN x.WORKSTEP IN ('CreditApproval','CreditCommittee') AND x.DECISION IN
                                   ('Submit','Send To HOSupport','Send To PostSanction','Reject','Submit To DisbursementMaker')
                              THEN x.EXITDATE END)
                THEN 'From Second Approval' ELSE 'First Approval'
           END                                                                         AS BI_FLAG_APPROVAL,                                                                  
           -- TAT theo buoc (gio, ROUND 2)
           -- Chi nhanh
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'BranchSupport' THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP01_BRANCH_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'BranchSupport' THEN x.WK_H END), 0), 2)                       AS STEP01_BRANCH_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'BranchSupport' THEN x.CPC_H END), 0), 2)                      AS STEP01_BRANCH_TAT_CPC,
           -- Nhap lieu (DDE)
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP02_DDE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN x.WK_H END), 0), 2)                       AS STEP02_DDE_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN x.CPC_H END), 0), 2)                      AS STEP02_DDE_TAT_CPC,
           -- Kiem soat nhap lieu (QC)
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP03_QUALITY_CHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN x.WK_H END), 0), 2)                       AS STEP03_QUALITY_CHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN x.CPC_H END), 0), 2)                      AS STEP03_QUALITY_CHECKER_TAT_CPC,
           -- CV tham dinh
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'UnderwriterMaker' THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP04_UNDMAKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'UnderwriterMaker' THEN x.WK_H END), 0), 2)                       AS STEP04_UNDMAKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'UnderwriterMaker' THEN x.CPC_H END), 0), 2)                      AS STEP04_UNDMAKER_TAT_CPC,
           -- Kiem soat tham dinh
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'UnderwriterChecker' THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP04_UNDCHECKER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'UnderwriterChecker' THEN x.WK_H END), 0), 2)                       AS STEP04_UNDCHECKER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'UnderwriterChecker' THEN x.CPC_H END), 0), 2)                      AS STEP04_UNDCHECKER_TAT_CPC,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker') THEN x.CPC_H END), 0), 2) AS STEP04_UND_TAT_CPC,
           -- CG phe duyet
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'CreditApproval' THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP07_APPROVER_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'CreditApproval' THEN x.WK_H END), 0), 2)                       AS STEP07_APPROVER_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'CreditApproval' THEN x.CPC_H END), 0), 2)                      AS STEP07_APPROVER_TAT_CPC,
           -- Hoi dong tin dung
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'CreditCommittee' THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS STEP07_COMMITTEE_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP = 'CreditCommittee' THEN x.WK_H END), 0), 2)                       AS STEP07_COMMITTEE_WK_TAT,
           -- TAT gop
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker') THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS TAT_PHONG_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker') THEN x.WK_H END), 0), 2)                       AS TAT_PHONG_WK_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN NVL(x.TAT, x.TAT_EOD) / 3600 END), 0), 2) AS TAT_KHOI_PDTD_CL_TAT,
           ROUND(NVL(SUM(CASE WHEN x.WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN x.WK_H END), 0), 2)                       AS TAT_KHOI_PDTD_WK_TAT,
           -- DDE
           MIN(CASE WHEN x.WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN x.ENTRYDATE END) AS ENTRYDATE_DDE,
           MAX(CASE WHEN x.WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN x.EXITDATE END)  AS EXITDATE_DDE
    FROM  (-- Dong ENTRY_EXIT
           -- Buoc chua thoat (EXITDATE NULL) -> tinh den 23:59:59 ngay vao buoc = CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND
           SELECT e.WINAME, e.WORKSTEP, e.DECISION, e.ENTRYDATE, e.EXITDATE, e.TAT,
                  -- EXITDATE_EFF: EXITDATE; NULL -> 23:59:59 ngay vao buoc
                  CASE WHEN e.WORKSTEP IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry',
                                           'DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker',
                                           'UnderwriterChecker','CreditApproval','CreditCommittee')
                       THEN NVL(e.EXITDATE, CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND) END                     AS EXITDATE_EFF,
                  -- TAT_EOD: so giay tu ENTRYDATE den 23:59:59 ngay vao buoc (quy ra giay giong TAT)
                  CASE WHEN e.WORKSTEP IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry',
                                           'DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker',
                                           'UnderwriterChecker','CreditApproval','CreditCommittee')
                       THEN (CAST(CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND AS DATE) - CAST(e.ENTRYDATE AS DATE)) * 86400 END AS TAT_EOD,
                  -- WK_H: gio lam viec 8-12, 13-17
                  CASE WHEN e.WORKSTEP IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry',
                                           'DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker',
                                           'UnderwriterChecker','CreditApproval','CreditCommittee')
                       THEN get_business_minute    (CAST(e.ENTRYDATE AS DATE),
                                                    CAST(NVL(e.EXITDATE, CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND) AS DATE)) / 60 END AS WK_H,
                  -- CPC_H: gio cam ket SLA 8-11:30, 13:30-16:30
                  CASE WHEN e.WORKSTEP IN ('BranchSupport','DetailDataEntry','CLOS_DetailDataEntry',
                                           'DataInputerChecker','CLOS_DataInputerChecker','UnderwriterMaker',
                                           'UnderwriterChecker','CreditApproval')
                       THEN get_business_minute_cpc(CAST(e.ENTRYDATE AS DATE),
                                                    CAST(NVL(e.EXITDATE, CAST(TRUNC(e.ENTRYDATE) + 1 AS TIMESTAMP) - INTERVAL '1' SECOND) AS DATE)) / 60 END AS CPC_H
           FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT e
          ) x
    GROUP  BY x.WINAME
),
-- (2) Nguon ------------------------------------------
SRC AS (
    SELECT s.SYSTEMNAME, s.PROCESSED_DATE, s.WINAME, s.BI_APPSTATUS,
           s.STEP01_BRANCH_CL_TAT,          s.STEP01_BRANCH_WK_TAT,          s.STEP01_BRANCH_TAT_CPC,
           s.STEP02_DDE_CL_TAT,             s.STEP02_DDE_WK_TAT,             s.STEP02_DDE_TAT_CPC,
           s.STEP03_QUALITY_CHECKER_CL_TAT, s.STEP03_QUALITY_CHECKER_WK_TAT, s.STEP03_QUALITY_CHECKER_TAT_CPC,
           s.STEP04_UNDMAKER_CL_TAT,        s.STEP04_UNDMAKER_WK_TAT,        s.STEP04_UNDMAKER_TAT_CPC,
           s.STEP04_UNDCHECKER_CL_TAT,      s.STEP04_UNDCHECKER_WK_TAT,      s.STEP04_UNDCHECKER_TAT_CPC,
           s.STEP04_UND_TAT_CPC,
           s.STEP07_APPROVER_CL_TAT,        s.STEP07_APPROVER_WK_TAT,        s.STEP07_APPROVER_TAT_CPC,
           s.STEP07_COMMITTEE_CL_TAT,       s.STEP07_COMMITTEE_WK_TAT,
           s.REF_PRODUCT, s.SLA_CREDIT_OFFICER, s.SLA_CREDIT_APPROVER, s.SLA_MARKER, s.SLA_CHECKER,
           -- Ket qua SLA
           CASE WHEN s.STEP04_UNDMAKER_TAT_CPC   >  s.SLA_MARKER         THEN 'KHONG DAT'
                WHEN s.STEP04_UNDMAKER_TAT_CPC   <= s.SLA_MARKER         THEN 'DAT' END   AS SLA_MARKER_RESUTL,
           CASE WHEN s.STEP04_UNDCHECKER_TAT_CPC >  s.SLA_CHECKER        THEN 'KHONG DAT'
                WHEN s.STEP04_UNDCHECKER_TAT_CPC <= s.SLA_CHECKER        THEN 'DAT' END   AS SLA_CHECKER_RESUTL,
           CASE WHEN s.STEP04_UND_TAT_CPC        >  s.SLA_CREDIT_OFFICER THEN 'KHONG DAT'
                WHEN s.STEP04_UND_TAT_CPC        <= s.SLA_CREDIT_OFFICER THEN 'DAT' END   AS SLA_CO_RESUTL,
           CASE WHEN s.STEP07_APPROVER_TAT_CPC   >  s.SLA_CREDIT_APPROVER THEN 'KHONG DAT'
                WHEN s.STEP07_APPROVER_TAT_CPC   <= s.SLA_CREDIT_APPROVER THEN 'DAT' END  AS SLA_APPROVER_RESULT,
           CASE WHEN s.STEP04_UND_TAT_CPC + s.STEP07_APPROVER_TAT_CPC
                   >  s.SLA_CREDIT_OFFICER + s.SLA_CREDIT_APPROVER                       THEN 'KHONG DAT'
                WHEN s.STEP04_UND_TAT_CPC + s.STEP07_APPROVER_TAT_CPC
                   <= s.SLA_CREDIT_OFFICER + s.SLA_CREDIT_APPROVER                       THEN 'DAT' END AS SLA_CO_APPROVER_RESULT,
           s.TAT_PHONG_CL_TAT, s.TAT_PHONG_WK_TAT, s.TAT_KHOI_PDTD_CL_TAT, s.TAT_KHOI_PDTD_WK_TAT,
           s.BI_FLAG_APPROVAL, s.ENTRYDATE_DDE, s.EXITDATE_DDE, s.SLA_DE, s.SLA_QC,
           CASE WHEN s.STEP02_DDE_TAT_CPC             >  s.SLA_DE THEN 'KHONG DAT'
                WHEN s.STEP02_DDE_TAT_CPC             <= s.SLA_DE THEN 'DAT' END          AS SLA_DE_RESULT,
           CASE WHEN s.STEP03_QUALITY_CHECKER_TAT_CPC >  s.SLA_QC THEN 'KHONG DAT'
                WHEN s.STEP03_QUALITY_CHECKER_TAT_CPC <= s.SLA_QC THEN 'DAT' END          AS SLA_QC_RESULT,
           CASE WHEN s.STEP02_DDE_TAT_CPC + s.STEP03_QUALITY_CHECKER_TAT_CPC >  s.SLA_DE + s.SLA_QC THEN 'KHONG DAT'
                WHEN s.STEP02_DDE_TAT_CPC + s.STEP03_QUALITY_CHECKER_TAT_CPC <= s.SLA_DE + s.SLA_QC THEN 'DAT' END AS SLA_DE_TOTAL_RESULT,
           s.QD_DDE, s.QD_QC
    FROM (
        SELECT 'CLOS' AS SYSTEMNAME, h.*,
               NVL(f1.REF_PRODUCT  , f3.REF_PRODUCT)                          AS REF_PRODUCT,
               NVL(f2.SLA_CREDIT_OFFICER, f3.SLA_CREDIT_OFFICER)                       AS SLA_CREDIT_OFFICER,
               CASE WHEN d.APP_GRP = 'C1' THEN 4
                    ELSE NVL(f2.SLA_CREDIT_APPROVER, f3.SLA_CREDIT_APPROVER) END       AS SLA_CREDIT_APPROVER,
               NVL(f2.SLA_MARKER,  f3.SLA_MARKER)                                      AS SLA_MARKER,
               NVL(f2.SLA_CHECKER, f3.SLA_CHECKER)                                     AS SLA_CHECKER,
               f4.SLA_DE_RESULT AS SLA_DE, f4.SLA_QC_RESULT AS SLA_QC, f4.QD_DDE, f4.QD_QC
        FROM   HS h -- Thong tin ho so
        LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO       b ON b.WI_NAME = h.WINAME
        LEFT JOIN SBLOS2.NG_SB_CLOS_MAS_PRO_LINE    c ON c.PRODUCT_LINE_CODE = b.PRODUCT_LINE
        LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL        d ON d.WI_NAME = h.WINAME
        LEFT JOIN SBLOS2.NG_SB_CLOS_CREDITINFO_COMM e ON e.WI_NAME = h.WINAME
        LEFT JOIN SBLOS2.NG_SB_CLOS_CHANGEREQ       f ON f.WI_NAME = h.WINAME
        -- file1: REF_PRODUCT (TDKHDN luong 2, DISTINCT)
        LEFT JOIN (SELECT DISTINCT PRODUCT_LINE, SUB_PRODUCT, REF_PRODUCT
                   FROM   PDTD_DTM.CLOS_REF_SLA_TDKHDN_2) f1
               ON  b.CUST_GROUP IN ('MSME','SME','USME')
               -- Product Line: Change Request -> dong 'Truong Change Request'; con lai -> Product Line
               AND f1.PRODUCT_LINE = CASE WHEN f.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request'
                                          ELSE c.PRODUCT_LINE_NAME END
               AND (f1.SUB_PRODUCT IS NULL OR f1.SUB_PRODUCT = b.SUB_PRODUCT)
        -- file2: SLA TDKHDN luong 2
        LEFT JOIN PDTD_DTM.CLOS_REF_SLA_TDKHDN_2 f2
               ON  b.CUST_GROUP IN ('MSME','SME','USME')
               AND f2.FLAG_APP_GRP = CASE WHEN d.APP_GRP IN ('A1','A2','B1','B2')     THEN 'CGPD'
                                          WHEN d.APP_GRP IN ('BOD','CC','SCC','RCC') THEN 'HDTD' END
               AND f2.HAVE_ANY_DEVIATION = e.HAVE_ANY_DEVIATION
               AND f2.PRODUCT_LINE = CASE WHEN f.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request'
                                          ELSE c.PRODUCT_LINE_NAME END
               AND (f2.SUB_PRODUCT IS NULL OR f2.SUB_PRODUCT = b.SUB_PRODUCT)
        -- file3: SLA TDKHDNL
        LEFT JOIN PDTD_DTM.CLOS_REF_SLA_TDKHDNL f3
               ON  b.CUST_GROUP IN ('NBFI','JSC','FDI','BANK','STR','SOC')
               AND f3.FLAG_APP_GRP = CASE WHEN d.APP_GRP IN ('A1','A2','B1','B2')     THEN 'CGPD'
                                          WHEN d.APP_GRP IN ('BOD','CC','SCC','RCC') THEN 'HDTD' END
               AND f3.HAVE_ANY_DEVIATION = e.HAVE_ANY_DEVIATION
               AND f3.PRODUCT_LINE = CASE WHEN f.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request'
                                          ELSE c.PRODUCT_LINE_NAME END
               AND (f3.SUB_PRODUCT IS NULL OR f3.SUB_PRODUCT = b.SUB_PRODUCT)
        -- file4: NLTT CLOS 
        LEFT JOIN PDTD_DTM.REF_SLA_NLTT f4
               ON  f4.SYSTEMNAME         = 'CLOS'
               AND f4.NEW_CHANGE_REQUEST = f.CHANGE_REQUEST
               AND f4.PRODUCT_LINE       = c.PRODUCT_LINE_NAME
               AND (f4.SUB_PRODUCT IS NULL OR f4.SUB_PRODUCT = b.SUB_PRODUCT)
    ) s
),
-- (3) Dich -----------------------------------------------------------------------------
TGT AS (
    SELECT SYSTEMNAME, PROCESSED_DATE, WINAME, BI_APPSTATUS,
           STEP01_BRANCH_CL_TAT,          STEP01_BRANCH_WK_TAT,          STEP01_BRANCH_TAT_CPC,
           STEP02_DDE_CL_TAT,             STEP02_DDE_WK_TAT,             STEP02_DDE_TAT_CPC,
           STEP03_QUALITY_CHECKER_CL_TAT, STEP03_QUALITY_CHECKER_WK_TAT, STEP03_QUALITY_CHECKER_TAT_CPC,
           STEP04_UNDMAKER_CL_TAT,        STEP04_UNDMAKER_WK_TAT,        STEP04_UNDMAKER_TAT_CPC,
           STEP04_UNDCHECKER_CL_TAT,      STEP04_UNDCHECKER_WK_TAT,      STEP04_UNDCHECKER_TAT_CPC,
           STEP04_UND_TAT_CPC,
           STEP07_APPROVER_CL_TAT,        STEP07_APPROVER_WK_TAT,        STEP07_APPROVER_TAT_CPC,
           STEP07_COMMITTEE_CL_TAT,       STEP07_COMMITTEE_WK_TAT,
           REF_PRODUCT, SLA_CREDIT_OFFICER, SLA_CREDIT_APPROVER, SLA_MARKER, SLA_CHECKER,
           SLA_MARKER_RESUTL, SLA_CHECKER_RESUTL, SLA_CO_RESUTL, SLA_APPROVER_RESULT, SLA_CO_APPROVER_RESULT,
           TAT_PHONG_CL_TAT, TAT_PHONG_WK_TAT, TAT_KHOI_PDTD_CL_TAT, TAT_KHOI_PDTD_WK_TAT,
           BI_FLAG_APPROVAL, ENTRYDATE_DDE, EXITDATE_DDE, SLA_DE, SLA_QC,
           SLA_DE_RESULT, SLA_QC_RESULT, SLA_DE_TOTAL_RESULT, QD_DDE, QD_QC
    FROM   PDTD_DTM.RPT_SLA_TAT
    WHERE  SYSTEMNAME = 'CLOS'
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM TGT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM TGT MINUS SELECT * FROM SRC) y;