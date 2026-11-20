/* =====================================================================
   BC3 - Bao cao Thong tin phe duyet (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC3.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (EXITDATE cua buoc phe duyet), mac dinh T-1
     :p_date_to       DATE      Den ngay (EXITDATE cua buoc phe duyet), mac dinh T-1; ngay du lieu cua cac bang snapshot (DAYID) = :p_date_to
   Grain: 1 dong / (su kien phe duyet x tai san bao dam). Ho so khong co tai san van ra 1 dong.
   Su kien phe duyet: WORKSTEP IN (CreditApproval, CreditCommittee) va DECISION thuoc nhom ket thuc
   phe duyet (so sanh khong phan biet hoa thuong), EXITDATE nam trong [:p_date_from, :p_date_to].
   FCT_*_WORKSTEP_EVENT (lat cat ngay phat sinh): loc DAYID trong [:p_date_from, :p_date_to]; ghi nhieu
   phien ban / su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK den :p_date_to.
   Cac bang snapshot (FCT_*_APPLICATION, FCT_*_COLLATERAL, FCT_RLOS_CUSTOMER): loc DAYID = :p_date_to.
   Hai nhanh CLOS / RLOS ghep bang UNION ALL; cot khac kieu ep ve NVARCHAR2.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_date_from) AS d_from,
           TRUNC(:p_date_to)   AS d_to
    FROM   DUAL
),
-- CLOS: su kien phe duyet ket thuc trong khoang bao cao (+ so tien/ky han tu snapshot ho so tai :p_date_to)
clos_ev AS (
    SELECT e.*,
           a.APPROVED_AMT_FINAL,
           a.CURRENCY_CODE,
           a.APPROVED_TERM
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
    LEFT JOIN PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
    WHERE  e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
      AND  UPPER(e.DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
-- RLOS: tuong tu
rlos_ev AS (
    SELECT e.*,
           a.APPROVED_AMT_FINAL,
           a.CURRENCY_CODE,
           a.APPROVED_TERM
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
    LEFT JOIN PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
    WHERE  e.WORKSTEP_CODE IN ('CreditApproval','CreditCommittee')
      AND  UPPER(e.DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')
      AND  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
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
        JOIN   p ON cu.DAYID = p.d_to
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
LEFT JOIN  PDTD_DTM.FCT_CLOS_COLLATERAL   cl ON cl.WI_NAME = ev.WI_NAME AND cl.DAYID = p.d_to
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
LEFT JOIN  PDTD_DTM.FCT_RLOS_COLLATERAL   cl ON cl.WI_NAME = ev.WI_NAME AND cl.DAYID = p.d_to
ORDER BY   SYSTEMNAME, WINAME, ENTRYDATE, DESCRIPTION;
