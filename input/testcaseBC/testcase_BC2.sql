WITH PD AS (   
    SELECT e0.WINAME,
           TRUNC(
             CASE
               WHEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN e0.EXITDATE END)
               WHEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke' THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                             THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)
               ELSE MAX(e0.EXITDATE)
             END) AS PROCESSED_DATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e0
    GROUP BY e0.WINAME
),
SRC AS (
    SELECT pd.WINAME,
           pd.PROCESSED_DATE,
           c.CHANGE_REQUEST             AS CHANGE_REQUEST,  
           c.CHANGE_TYPE                AS CHANGE_TYPE,   
           b.INDUSTRY_CODE_LEVEL_1      AS INDUSTRY_GROUP,  
           b.INDUSTRY_CODE_LEVEL_2      AS INDUSTRY_CLASS,  
           b.INDUSTRY_CODE_LEVEL_3      AS INDUSTRY,         
           i.CREDIT_PROFILE             AS CAP_TIN_DUNG,    
           b.CUSTOMER_NAME              AS CUSTOMER_NAME,    
           b.CUST_GROUP                 AS CUST_GROUP,      
           b.EMP_CODE                   AS EMPLOYEE_CODE,   
           b.EMP_NAME                   AS EMPLOYEE_NAME,   
           b.ZONEE                      AS ZONE,           
           b.BRANCH_CODE                AS BRANCH_CODE,      
           b.BRANCH_NAME                AS BRANCH_NAME,     
           b.COMPANY_CODE               AS COMPANY_CODE,    
           b.COMPANY_NAME               AS COMPANY_NAME,   
           e.APP_GRP                    AS APP_GRP,       
           b.PRODUCT_LINE               AS PRODUCT_LINE,  
           b.SUB_PRODUCT                AS SUB_PRODUCT,     
           f.PRECREDITLIMIT             AS ST_YEUCAU,     
           h.CREDIT_LIMIT               AS ST_PHEDUYET,   
           f.CURRENCY                   AS CURRENCY,      
           f.CREDIT_TERM                AS CREDIT_TERM,     
           f.INTEREST_RATE              AS INTEREST_RATE,  
           j.DEV_PROPOSAL               AS DEV_PROPOSAL    
    FROM PD pd
    LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO        b ON pd.WINAME = b.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CHANGEREQ        c ON pd.WINAME = c.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL         e ON pd.WINAME = e.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CREDITINFO_COMM  f ON pd.WINAME = f.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CREDITINFO_CD    h ON pd.WINAME = h.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_EXTTABLE         i ON pd.WINAME = i.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CONDITON_CDGRID  j ON pd.WINAME = j.WI_NAME
),
RPT AS (
    SELECT WINAME, PROCESSED_DATE,
           CHANGE_REQUEST, CHANGE_TYPE, INDUSTRY_GROUP, INDUSTRY_CLASS, INDUSTRY,
           CAP_TIN_DUNG, CUSTOMER_NAME, CUST_GROUP, EMPLOYEE_CODE, EMPLOYEE_NAME,
           ZONE, BRANCH_CODE, BRANCH_NAME, COMPANY_CODE, COMPANY_NAME, APP_GRP,
           PRODUCT_LINE, SUB_PRODUCT, ST_YEUCAU, ST_PHEDUYET, CURRENCY,
           CREDIT_TERM, INTEREST_RATE, DEV_PROPOSAL
    FROM PDTD_DTM.BC2
)
SELECT 'NGUON - DICH' AS SRC_FLAG, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC_FLAG, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;


--phan2
WITH PD AS (  
    SELECT e0.WINAME,
           TRUNC(
             CASE
               WHEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN e0.EXITDATE END)
               WHEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke' THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                             THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)
               ELSE MAX(e0.EXITDATE)
             END) AS PROCESSED_DATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e0
    GROUP BY e0.WINAME
),
SRC AS (
    SELECT pd.WINAME,
           pd.PROCESSED_DATE,
           d.ID_NUMBER   AS ID_NUMBER,             
           d1.NAMEE      AS LEGAL_REPRESENTATIVE,  
           d1.ID_NUMBER  AS ADD_ID_REPRESENTATIVE, 
           e.STREAM      AS APPROVAL_TYPE          
    FROM PD pd
    LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO_LEGAL d
           ON d.WI_NAME = pd.WINAME
          AND d.OBJ_TYPE = 'Khách hàng'
    LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO_LEGAL d1
           ON d1.WI_NAME = pd.WINAME
          AND d1.OBJ_TYPE = 'Người đại diện theo pháp luật'
    LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL e
           ON e.WI_NAME = pd.WINAME
          AND e.STREAM IN ('Phê duyệt tín dụng', 'Sent to Disbursement Request')
),
RPT AS (
    SELECT WINAME,
           PROCESSED_DATE,
           ID_NUMBER,
           LEGAL_REPRESENTATIVE,
           ADD_ID_REPRESENTATIVE,
           APPROVAL_TYPE
    FROM PDTD_DTM.BC2
)
SELECT 'NGUON - DICH' AS SRC_FLAG, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC_FLAG, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;

--phan3
WITH PD AS ( 
    SELECT e0.WINAME,
           TRUNC(
             CASE
               WHEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN e0.EXITDATE END)
               WHEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke' THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                             THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)
               ELSE MAX(e0.EXITDATE)
             END) AS PROCESSED_DATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e0
    GROUP BY e0.WINAME
),
COLL AS (   
    SELECT g.WI_NAME,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE IS NOT NULL THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_NHOM_0,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'PHUONGTIEN VTAI'              THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_PTVT,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'BAT DONG SAN'                 THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_BDS,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'TAI SAN KHAC - MMTB,DCSX'     THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_MMTB,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'TAI SAN KHAC - QUYEN DOI NO'  THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_KPT,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE IN ('HH LA LINHKIEN','HH LA NLSX','HH TM THANHPHAM')
                              THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_HTK,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'KHÔNG CÓ TÀI SẢN'             THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_TIN_CHAP,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'TIN CHAP THEO QUY DINH'       THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TIN_CHAP_TQD,
           CASE WHEN MAX(CASE WHEN g.COLLTYPE = 'TR.PHIEU TIN PH'              THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSDB_CP_TP
    FROM SBLOS2.NG_SB_CLOS_COLL_CD g
    GROUP BY g.WI_NAME
),
SRC AS (
    SELECT pd.WINAME,
           pd.PROCESSED_DATE,
           NVL(c.TSDB_NHOM_0,   'NO') AS TSDB_NHOM_0,
           NVL(c.TSDB_PTVT,     'NO') AS TSDB_PTVT,
           NVL(c.TSDB_BDS,      'NO') AS TSDB_BDS,
           NVL(c.TSDB_MMTB,     'NO') AS TSDB_MMTB,
           NVL(c.TSDB_KPT,      'NO') AS TSDB_KPT,
           NVL(c.TSDB_HTK,      'NO') AS TSDB_HTK,
           NVL(c.TSDB_TIN_CHAP, 'NO') AS TSDB_TIN_CHAP,
           NVL(c.TIN_CHAP_TQD,  'NO') AS TIN_CHAP_TQD,
           NVL(c.TSDB_CP_TP,    'NO') AS TSDB_CP_TP
    FROM PD pd
    LEFT JOIN COLL c ON pd.WINAME = c.WI_NAME
),
RPT AS (
    SELECT WINAME, PROCESSED_DATE,
           TSDB_NHOM_0, TSDB_PTVT, TSDB_BDS, TSDB_MMTB, TSDB_KPT,
           TSDB_HTK, TSDB_TIN_CHAP, TIN_CHAP_TQD, TSDB_CP_TP
    FROM PDTD_DTM.BC2
)
SELECT 'NGUON - DICH' AS SRC_FLAG, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC_FLAG, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;

--phan4
WITH PD AS (   
    SELECT e0.WINAME,
           TRUNC(
             CASE
               WHEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN e0.EXITDATE END)
               WHEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke' THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                             THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)
               ELSE MAX(e0.EXITDATE)
             END) AS PROCESSED_DATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e0
    GROUP BY e0.WINAME
),
EE_DET AS (
    SELECT e.WINAME, e.WORKSTEP, e.ENTRYDATE, e.EXITDATE, e.REMARK, e.DECISION, e.USERNAME,
           ROW_NUMBER() OVER (PARTITION BY e.WINAME ORDER BY e.ENTRYDATE DESC) AS RN
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e
),
EE_LAST AS (
    SELECT d.WINAME,
        MIN(d.ENTRYDATE)                                   AS CREATION_DATE,
        MAX(CASE WHEN d.RN = 1 THEN d.WORKSTEP  END)       AS LAST_WORKSTEP,
        MAX(CASE WHEN d.RN = 2 THEN d.WORKSTEP  END)       AS PRE_WORKSTEP,
        MAX(CASE WHEN d.RN = 1 THEN d.ENTRYDATE END)       AS LAST_ENTRYDATE,
        MAX(CASE WHEN d.RN = 1 THEN d.EXITDATE  END)       AS LAST_EXITDATE,
        MAX(CASE WHEN d.RN = 1 THEN d.REMARK    END)       AS LAST_REMARKS,
        MAX(CASE WHEN d.RN = 1 THEN d.DECISION  END)       AS LAST_DECISION,
        MIN(CASE WHEN d.WORKSTEP = 'UnderwriterMaker' THEN d.ENTRYDATE END)                    AS MIN_UWM,
        MIN(CASE WHEN d.WORKSTEP IN ('CreditApproval','CreditCommittee') THEN d.ENTRYDATE END) AS MIN_APP,
        MAX(CASE WHEN d.WORKSTEP IN ('CreditApproval','CreditCommittee') THEN d.EXITDATE END)  AS LAST_APPROVAL_DATE,
        MAX(CASE WHEN d.WORKSTEP = 'CancelRevoke' THEN d.ENTRYDATE END)                        AS BI_CAN_DATE,
        MAX(CASE WHEN d.WORKSTEP = 'RequestInitiate' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'RequestInitiate' THEN d.EXITDATE END NULLS FIRST)     AS RI_USER,
        MAX(CASE WHEN d.WORKSTEP = 'BranchSupport' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'BranchSupport' THEN d.EXITDATE END NULLS FIRST)       AS BRANCH_USER,
        MAX(CASE WHEN d.WORKSTEP = 'DetailDataEntry' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'DetailDataEntry' THEN d.EXITDATE END NULLS FIRST)     AS DDE_USER,
        MAX(CASE WHEN d.WORKSTEP = 'DataInputerChecker' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'DataInputerChecker' THEN d.EXITDATE END NULLS FIRST)  AS QUALITY_CHECKER,
        MAX(CASE WHEN d.WORKSTEP = 'PhoneVerification' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'PhoneVerification' THEN d.EXITDATE END NULLS FIRST)   AS PHV_USER,
        MAX(CASE WHEN d.WORKSTEP = 'FieldAssessment' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'FieldAssessment' THEN d.EXITDATE END NULLS FIRST)     AS FA_USER,
        MAX(CASE WHEN d.WORKSTEP = 'UnderwriterMaker' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'UnderwriterMaker' THEN d.EXITDATE END NULLS FIRST)    AS UND_MAKER,
        MAX(CASE WHEN d.WORKSTEP = 'UnderwriterChecker' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'UnderwriterChecker' THEN d.EXITDATE END NULLS FIRST)  AS UND_CHECKER,
        MAX(CASE WHEN d.WORKSTEP = 'CreditApproval' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'CreditApproval' THEN d.EXITDATE END NULLS FIRST)      AS BI_APPROVER,
        MAX(CASE WHEN d.WORKSTEP = 'CreditCommittee' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'CreditCommittee' THEN d.EXITDATE END NULLS FIRST)     AS BI_COMMITTEE,
        MAX(CASE WHEN d.WORKSTEP = 'HOSupport' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'HOSupport' THEN d.EXITDATE END NULLS FIRST)           AS BI_HOS_USER
    FROM EE_DET d
    GROUP BY d.WINAME
),
SRC AS (
    SELECT pd.WINAME,
           pd.PROCESSED_DATE,
           l.CREATION_DATE, l.LAST_WORKSTEP, l.PRE_WORKSTEP, l.LAST_ENTRYDATE, l.LAST_EXITDATE,
           l.LAST_REMARKS, l.LAST_DECISION, l.MIN_UWM, l.MIN_APP, l.LAST_APPROVAL_DATE, l.BI_CAN_DATE,
           l.RI_USER, l.BRANCH_USER, l.DDE_USER, l.QUALITY_CHECKER, l.PHV_USER, l.FA_USER,
           l.UND_MAKER, l.UND_CHECKER, l.BI_APPROVER, l.BI_COMMITTEE, l.BI_HOS_USER
    FROM PD pd
    LEFT JOIN EE_LAST l ON pd.WINAME = l.WINAME
),
RPT AS (
    SELECT WINAME, PROCESSED_DATE,
           CREATION_DATE, LAST_WORKSTEP, PRE_WORKSTEP, LAST_ENTRYDATE, LAST_EXITDATE,
           LAST_REMARKS, LAST_DECISION, MIN_UWM, MIN_APP, LAST_APPROVAL_DATE, BI_CAN_DATE,
           RI_USER, BRANCH_USER, DDE_USER, QUALITY_CHECKER, PHV_USER, FA_USER,
           UND_MAKER, UND_CHECKER, BI_APPROVER, BI_COMMITTEE, BI_HOS_USER
    FROM PDTD_DTM.BC2
)
SELECT 'NGUON - DICH' AS SRC_FLAG, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC_FLAG, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;


--phan5
WITH PD AS (
    SELECT e0.WINAME,
           TRUNC(
             CASE
               WHEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN e0.EXITDATE END)
               WHEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke' THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                             THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)
               ELSE MAX(e0.EXITDATE)
             END) AS PROCESSED_DATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e0
    GROUP BY e0.WINAME
),
EE_DET AS (
    SELECT e.WINAME, e.WORKSTEP, e.DECISION, e.ENTRYDATE,
           ROW_NUMBER() OVER (PARTITION BY e.WINAME ORDER BY e.ENTRYDATE DESC) AS RN
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e
),
EE_LAST AS (
    SELECT d.WINAME,
           MAX(CASE WHEN d.RN = 1 THEN d.DECISION END) AS LAST_DECISION,
           MAX(CASE WHEN d.WORKSTEP = 'CancelRevoke' THEN d.ENTRYDATE END) AS BI_CAN_DATE,
           CASE
             WHEN MAX(CASE WHEN d.WORKSTEP IN ('CreditCommittee','CreditApproval')
                            AND d.DECISION IN ('Submit','Send To PostSanction',
                                               'Submit To DisbursementMaker','Send To HOSupport')
                           THEN 1 ELSE 0 END) = 1 THEN 'Approved'
             WHEN MAX(CASE WHEN d.WORKSTEP IN ('CreditCommittee','CreditApproval')
                            AND d.DECISION = 'Reject'
                           THEN 1 ELSE 0 END) = 1 THEN 'Rejected'
             WHEN MAX(CASE WHEN d.WORKSTEP IN ('CancelRevoke','CancelPermanent')
                           THEN 1 ELSE 0 END) = 1 THEN 'Cancelled'
             ELSE 'Processing'
           END AS BI_APPSTATUS
    FROM EE_DET d
    GROUP BY d.WINAME
),
SRC AS (
    SELECT pd.WINAME,
           pd.PROCESSED_DATE,
           CASE WHEN b.CUST_GROUP IN ('MSME','SME','USME') THEN 'PDTD_KHDN'
                WHEN b.CUST_GROUP IN ('NBFI','JSC','FDI','BANK','STR','SOC') THEN 'PDTD_KHDNL'
                ELSE NULL
           END AS BI_FLOW,
           l.BI_APPSTATUS,
           CASE WHEN l.BI_CAN_DATE IS NOT NULL
                 AND l.LAST_DECISION = 'Auto-Cancel'
                THEN 'YES' ELSE 'NO'
           END AS FLAG_AUTO_CAN
    FROM PD pd
    LEFT JOIN EE_LAST l                      ON pd.WINAME = l.WINAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO b  ON pd.WINAME = b.WI_NAME
),
RPT AS (
    SELECT WINAME,
           PROCESSED_DATE,
           BI_FLOW,
           BI_APPSTATUS,
           FLAG_AUTO_CAN
    FROM PDTD_DTM.BC2
)
SELECT 'NGUON - DICH' AS SRC_FLAG, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC_FLAG, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;


--phan6
WITH PD AS (
    SELECT e0.WINAME,
           TRUNC(
             CASE
               WHEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                              AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                                  'Send To PostSanction','Submit To DisbursementMaker')
                             THEN e0.EXITDATE END)
               WHEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke' THEN 1 ELSE 0 END) = 1
               THEN MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                             THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)
               ELSE MAX(e0.EXITDATE)
             END) AS PROCESSED_DATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT e0
    GROUP BY e0.WINAME
),
CID AS (
    SELECT DISTINCT d.WI_NAME, l.CUSTOMER AS CUSTOMER_ID
    FROM SBLOS2.NG_SB_CLOS_CUST_INFO_LEGAL d
    LEFT JOIN SBLOS2.REF_CLOS_LEGAL k
           ON d.OBJ_TYPE = k.OBJ_TYPE
    LEFT JOIN STG_DTM.STG_DIM_CUSTOMER l
           ON REGEXP_REPLACE(d.ID_NUMBER, '\s') = l.LEGAL_ID
          AND d.LEGAL_DOC = REGEXP_REPLACE(l.LEGAL_DOC_NAME, '\s')
          AND l.EXP_DATE IS NULL
          AND l.LEGAL_ID <> '.'
    WHERE TRIM(k.LEGAL_TYPE) = 'CUSTOMER'
),
EE_DET AS ( 
    SELECT a.WINAME, a.EXITDATE, m.WORK_STEP AS AK_WORK_STEP, m.USER_MAKE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT a
    LEFT JOIN SBLOS2.NG_SB_CLOS_USER_MAKE_WORK_STEP m
           ON a.WINAME = m.WI_NAME AND a.WORKSTEP = m.WORK_STEP
),
EE_LAST AS (
    SELECT d.WINAME,
        MAX(CASE WHEN d.AK_WORK_STEP = 'UnderwriterMaker' AND d.EXITDATE IS NOT NULL THEN d.USER_MAKE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.AK_WORK_STEP = 'UnderwriterMaker' THEN d.EXITDATE END NULLS FIRST)
            AS AK_UWMAKER,
        MAX(CASE WHEN d.AK_WORK_STEP = 'UnderwriterChecker' AND d.EXITDATE IS NOT NULL THEN d.USER_MAKE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.AK_WORK_STEP = 'UnderwriterChecker' THEN d.EXITDATE END NULLS FIRST)
            AS AK_UWCHECKER,
        MAX(CASE WHEN d.AK_WORK_STEP IN ('CreditCommittee','CreditApproval') AND d.EXITDATE IS NOT NULL THEN d.USER_MAKE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.AK_WORK_STEP IN ('CreditCommittee','CreditApproval')
                                               THEN d.EXITDATE END NULLS FIRST)
            AS AK_APPROVAL
    FROM EE_DET d
    GROUP BY d.WINAME
),
SRC AS (
    SELECT pd.WINAME,
           pd.PROCESSED_DATE,
           cid.CUSTOMER_ID,
           COALESCE(a.AK_UWMAKER, i.UWMAKERUSER)    AS UNDERWRITERMAKER_TAKERESPON,
           COALESCE(a.AK_UWCHECKER, i.UWCHKRUSER)   AS UNDERWRITERCHECKER_TAKERESPON,
           COALESCE(a.AK_APPROVAL,
                    CASE e.APP_GRP WHEN 'A1'  THEN 'long.lq'
                                   WHEN 'CC'  THEN 'UBTD'
                                   WHEN 'BOD' THEN 'HDQT' END) AS APPROVAL_TAKERESPON
    FROM PD pd
    LEFT JOIN CID cid                      ON pd.WINAME = cid.WI_NAME
    LEFT JOIN EE_LAST a                    ON pd.WINAME = a.WINAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_EXTTABLE i ON pd.WINAME = i.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL e ON pd.WINAME = e.WI_NAME
),
RPT AS (
    SELECT WINAME,
           PROCESSED_DATE,
           CUSTOMER_ID,
           UNDERWRITERMAKER_TAKERESPON,
           UNDERWRITERCHECKER_TAKERESPON,
           APPROVAL_TAKERESPON
    FROM PDTD_DTM.BC2
)
SELECT 'NGUON - DICH' AS SRC_FLAG, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC_FLAG, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;
