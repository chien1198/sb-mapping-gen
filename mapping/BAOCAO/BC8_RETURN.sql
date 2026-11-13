/* =====================================================================
   BC8 - Bao cao RETURN (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC8.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE = ngay ket thuc su kien), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / su kien tra ve (FCT_*_WORKSTEP_EVENT co WORKSTEP thuoc 6 buoc va DECISION thuoc nhom
   tra ve / huy, EXITDATE trong ngay bao cao); 3 cot SL_RETURN_* la so luy ke cua ho so tai ngay bao cao.
   SL_RETURN_NHAPLIEU / THAMDINH / PHEDUYET = RETURN_CNT_DATAENTRY / UNDERWRITING / APPROVAL tren
   FCT_*_APPLICATION (cot cong don mau C, review 2026-11-13) - khong dem lai tren bang su kien.
   PROCESSED_DATE = TRUNC(EXITDATE). Loc chi nhanh qua FCT_*_APPLICATION.COMPANY_SK.
   Hai nhanh CLOS / RLOS cung bo cot, ghep bang UNION ALL.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL
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
JOIN       p ON e.DAYID = p.rpt_date
            AND e.EXITDATE >= p.rpt_date
            AND e.EXITDATE <  p.rpt_date + 1
JOIN       PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.rpt_date
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY     co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                               'UnderwriterChecker','CreditApproval','CreditCommittee')
  AND      e.DECISION_CODE IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                               'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
  AND      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
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
JOIN       p ON e.DAYID = p.rpt_date
            AND e.EXITDATE >= p.rpt_date
            AND e.EXITDATE <  p.rpt_date + 1
JOIN       PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.rpt_date
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY     co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      e.WORKSTEP_CODE IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                               'UnderwriterChecker','CreditApproval','CreditCommittee')
  AND      e.DECISION_CODE IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                               'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
  AND      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
ORDER BY   WI_NAME, EXITDATE;
