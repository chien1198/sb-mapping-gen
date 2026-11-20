/* =====================================================================
   BC8 - Bao cao RETURN (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC8.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (PROCESSED_DATE = ngay ket thuc su kien), mac dinh T-1
     :p_date_to       DATE      Den ngay (PROCESSED_DATE = ngay ket thuc su kien), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = :p_date_to
   Grain: 1 dong / su kien tra ve (FCT_*_WORKSTEP_EVENT co WORKSTEP thuoc 6 buoc va DECISION thuoc nhom
   tra ve / huy, EXITDATE trong [:p_date_from, :p_date_to]); 3 cot SL_RETURN_* la so luy ke cua ho so tai :p_date_to.
   FCT_*_WORKSTEP_EVENT (lat cat ngay phat sinh): loc DAYID trong [:p_date_from, :p_date_to]; ghi nhieu phien ban /
   su kien (moi DAYID 1 dong) -> chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK den :p_date_to.
   SL_RETURN_NHAPLIEU / THAMDINH / PHEDUYET = RETURN_CNT_DATAENTRY / UNDERWRITING / APPROVAL tren
   FCT_*_APPLICATION (cot cong don mau C, review 2026-11-13; snapshot loc DAYID = :p_date_to) - khong dem lai tren bang su kien.
   PROCESSED_DATE = TRUNC(EXITDATE).
   Hai nhanh CLOS / RLOS cung bo cot, ghep bang UNION ALL.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_date_from) AS d_from,
           TRUNC(:p_date_to)   AS d_to
    FROM   DUAL
)
-- ===== Nhanh CLOS =====
SELECT
    TRUNC(e.EXITDATE)                                       AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS WORKSTEP,
    e.DECISION_CODE                                         AS DECISION,
    e.EXITDATE,
    a.RETURN_CNT_DATAENTRY                                  AS SL_RETURN_NHAPLIEU,
    a.RETURN_CNT_UNDERWRITING                               AS SL_RETURN_THAMDINH,
    a.RETURN_CNT_APPROVAL                                   AS SL_RETURN_PHEDUYET
FROM       PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
JOIN       p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
WHERE      e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                               'UnderwriterChecker','CreditApproval','CreditCommittee')
  AND      e.DECISION_CODE IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                               'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
  AND      NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    TRUNC(e.EXITDATE)                                       AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS WORKSTEP,
    e.DECISION_CODE                                         AS DECISION,
    e.EXITDATE,
    a.RETURN_CNT_DATAENTRY                                  AS SL_RETURN_NHAPLIEU,
    a.RETURN_CNT_UNDERWRITING                               AS SL_RETURN_THAMDINH,
    a.RETURN_CNT_APPROVAL                                   AS SL_RETURN_PHEDUYET
FROM       PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
JOIN       p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.EXITDATE >= p.d_from
            AND e.EXITDATE <  p.d_to + 1
JOIN       PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to
WHERE      e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                               'UnderwriterChecker','CreditApproval','CreditCommittee')
  AND      e.DECISION_CODE IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                               'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
  AND      NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
ORDER BY   WI_NAME, EXITDATE;
