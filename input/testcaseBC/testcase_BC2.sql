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