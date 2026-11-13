/* =====================================================================
   BC3 - Bao cao Thong tin phe duyet (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC3.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (EXITDATE cua buoc phe duyet), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / (su kien phe duyet x tai san bao dam). Ho so khong co tai san van ra 1 dong.
   Su kien phe duyet: WORKSTEP IN (CreditApproval, CreditCommittee) va DECISION thuoc nhom ket thuc
   phe duyet (so sanh khong phan biet hoa thuong), EXITDATE nam trong ngay bao cao.
   FCT_*_WORKSTEP_EVENT ghi nhieu phien ban / su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat
   cua tung WORKSTEP_EVENT_BK den ngay bao cao.
   Hai nhanh CLOS / RLOS ghep bang UNION ALL; cot khac kieu ep ve NVARCHAR2.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL
),
-- CLOS: su kien phe duyet ket thuc trong ngay bao cao (+ so tien/ky han tu snapshot ho so, loc chi nhanh)
clos_ev AS (
    SELECT e.*,
           a.APPROVED_AMT_FINAL,
           a.CURRENCY_CODE,
           a.APPROVED_TERM
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID <= p.rpt_date
            AND e.EXITDATE >= p.rpt_date
            AND e.EXITDATE <  p.rpt_date + 1
    LEFT JOIN PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.rpt_date
    LEFT JOIN PDTD_DTM.DIM_LOS_COMPANY      c ON c.DIMENSION_KEY = a.COMPANY_SK
    WHERE  e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
      AND  UPPER(e.DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')
      AND  (:p_branch_code IS NULL OR c.BRANCH_CODE = :p_branch_code)
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.rpt_date)
),
-- RLOS: tuong tu
rlos_ev AS (
    SELECT e.*,
           a.APPROVED_AMT_FINAL,
           a.CURRENCY_CODE,
           a.APPROVED_TERM
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID <= p.rpt_date
            AND e.EXITDATE >= p.rpt_date
            AND e.EXITDATE <  p.rpt_date + 1
    LEFT JOIN PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.rpt_date
    LEFT JOIN PDTD_DTM.DIM_LOS_COMPANY      c ON c.DIMENSION_KEY = a.COMPANY_SK
    WHERE  e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
      AND  UPPER(e.DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')
      AND  (:p_branch_code IS NULL OR c.BRANCH_CODE = :p_branch_code)
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.rpt_date)
),
-- RLOS: ten khach hang theo SRS (APPLICANT_GENERAL.FULL_NAME) -> FCT_RLOS_CUSTOMER, 1 dong dai dien / ho so (uu tien giay to TCC/CC)
rlos_cust AS (
    SELECT WI_NAME, FULL_NAME
    FROM (
        SELECT cu.WI_NAME, cu.FULL_NAME,
               ROW_NUMBER() OVER (
                   PARTITION BY cu.WI_NAME
                   ORDER BY CASE WHEN cu.ID_TYPE IN ('TCC','CC') THEN 0 ELSE 1 END, cu.ID_TYPE
               ) AS RN
        FROM   PDTD_DTM.FCT_RLOS_CUSTOMER cu
        JOIN   p ON cu.DAYID = p.rpt_date
        JOIN   rlos_ev ev ON ev.WI_NAME = cu.WI_NAME
    )
    WHERE RN = 1
)
-- ===== Nhanh CLOS =====
SELECT
    'CLOS'                                                  AS SYSTEMNAME,
    da.STREAM,
    ev.WI_NAME                                              AS WINAME,
    dc.CUSTOMER_NAME,
    ev.WORKSTEP_CODE                                        AS WORKSTEP,
    ev.DECISION_CODE                                        AS DECISION,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditApproval'  THEN ev.USERNAME END AS BI_APPROVER,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditCommittee' THEN ev.USERNAME END AS BI_COMMITTEE,
    ev.ENTRYDATE,
    ev.EXITDATE,
    ev.REMARKS,
    ev.APPROVED_AMT_FINAL                                   AS CREDIT_LIMIT,
    ev.CURRENCY_CODE                                        AS CURRENCY,
    ev.APPROVED_TERM                                        AS CREDIT_TERM,
    cl.COLLATERAL_TYPE_CODE                                 AS TYPES_OF_COLLATERALS,
    cl.APPRAISED_VALUE,
    cl.DESCRIPTION,
    cl.OWNER_NAME                                           AS OWNER,
    cl.LOAN_RATE_LTV                                        AS LTV,
    cl.COLL_MGMT_METHOD                                     AS COLLATERA_MANAGEMENT
FROM       clos_ev ev
CROSS JOIN p
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION  da ON da.DIMENSION_KEY = ev.APPLICATION_SK
LEFT JOIN  PDTD_DTM.DIM_CLOS_CUSTOMER     dc ON dc.DIMENSION_KEY = ev.CUSTOMER_SK
LEFT JOIN  PDTD_DTM.FCT_CLOS_COLLATERAL   cl ON cl.WI_NAME = ev.WI_NAME AND cl.DAYID = p.rpt_date
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    'RLOS'                                                  AS SYSTEMNAME,
    da.STREAM,
    ev.WI_NAME                                              AS WINAME,
    cu.FULL_NAME                                            AS CUSTOMER_NAME,
    ev.WORKSTEP_CODE                                        AS WORKSTEP,
    ev.DECISION_CODE                                        AS DECISION,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditApproval'  THEN ev.USERNAME END AS BI_APPROVER,
    CASE WHEN ev.WORKSTEP_CODE = 'CreditCommittee' THEN ev.USERNAME END AS BI_COMMITTEE,
    ev.ENTRYDATE,
    ev.EXITDATE,
    ev.REMARKS,
    ev.APPROVED_AMT_FINAL                                   AS CREDIT_LIMIT,
    TO_NCHAR(ev.CURRENCY_CODE)                              AS CURRENCY,
    TO_NCHAR(ev.APPROVED_TERM)                              AS CREDIT_TERM,
    cl.TYPES_OF_COLLATERALS,
    TO_NCHAR(cl.APPRAISED_VALUE)                            AS APPRAISED_VALUE,
    cl.DESCRIPTION,
    cl.OWNER_NAME                                           AS OWNER,
    TO_NCHAR(cl.LOAN_RATE_LTV)                              AS LTV,
    CAST(NULL AS VARCHAR2(4000))                            AS COLLATERA_MANAGEMENT
FROM       rlos_ev ev
CROSS JOIN p
LEFT JOIN  PDTD_DTM.DIM_RLOS_APPLICATION  da ON da.DIMENSION_KEY = ev.APPLICATION_SK
LEFT JOIN  rlos_cust                      cu ON cu.WI_NAME = ev.WI_NAME
LEFT JOIN  PDTD_DTM.FCT_RLOS_COLLATERAL   cl ON cl.WI_NAME = ev.WI_NAME AND cl.DAYID = p.rpt_date
ORDER BY   SYSTEMNAME, WINAME, ENTRYDATE, DESCRIPTION;
