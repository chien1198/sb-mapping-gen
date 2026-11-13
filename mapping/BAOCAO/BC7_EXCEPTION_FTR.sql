/* =====================================================================
   BC7 - Bao cao EXCEPTION - FTR (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC7.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_report_date   DATE      Ngay bao cao (PROCESSED_DATE = ngay phat sinh exception), mac dinh T-1
     :p_branch_code   VARCHAR2  Ma chi nhanh, NULL = tat ca chi nhanh
   Grain: 1 dong / (exception x buoc) - dung grain FCT_*_EXCEPTION (DAYID, EXCEPTION_BK, WORKSTEP_CODE).
   Pham vi: FCT_*_EXCEPTION co DAYID = ngay bao cao (snapshot day du) va RAISED_DATE_TIME trong ngay bao cao.
   ACTIVITYNAME = WORKSTEP_CODE (LLD da tinh: tra DIM_*_EXCEPTION, sau lan DetailDataEntry+Submit dau tien,
   mac dinh 'DEFAULT'). CHECK_FTR / FIRST_WORKSTEP_RETURN / PHAN_LOAI_DDE da tinh san tai LLD.
   PROCESSED_DATE = TRUNC(RAISED_DATE_TIME) cho ca 2 nhanh. Loc chi nhanh qua FCT_*_APPLICATION.COMPANY_SK.
   Hai nhanh CLOS / RLOS cung bo cot, ghep bang UNION ALL.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_report_date) AS rpt_date FROM DUAL
)
-- ===== Nhanh CLOS =====
SELECT
    TRUNC(e.RAISED_DATE_TIME)                               AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS ACTIVITYNAME,
    e.EXCEPTION_CATEGORY,
    e.EXCEPTION_NAME,
    e.EXCEPTION_REMARKS,
    e.RAISED_BY,
    e.RAISED_DATE_TIME,
    CASE WHEN INSTR(e.EXCEPTION_CATEGORY, ':') > 0
         THEN REGEXP_SUBSTR(e.EXCEPTION_CATEGORY, '^[^:]+') END AS EXCEPTION_CODE,
    da.LOANCASEID,
    e.CHECK_FTR,
    e.FIRST_WORKSTEP_RETURN,
    e.PHAN_LOAI_DDE
FROM       PDTD_DTM.FCT_CLOS_EXCEPTION e
JOIN       p ON e.DAYID = p.rpt_date
          AND e.RAISED_DATE_TIME >= p.rpt_date
          AND e.RAISED_DATE_TIME <  p.rpt_date + 1
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION  da ON da.DIMENSION_KEY = e.APPLICATION_SK
LEFT JOIN  PDTD_DTM.FCT_CLOS_APPLICATION  a  ON a.WI_NAME = e.WI_NAME AND a.DAYID = e.DAYID
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY      co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    TRUNC(e.RAISED_DATE_TIME)                               AS PROCESSED_DATE,
    e.WI_NAME,
    e.WORKSTEP_CODE                                         AS ACTIVITYNAME,
    e.EXCEPTION_CATEGORY,
    e.EXCEPTION_NAME,
    e.EXCEPTION_REMARKS,
    e.RAISED_BY,
    e.RAISED_DATE_TIME,
    CASE WHEN INSTR(e.EXCEPTION_CATEGORY, ':') > 0
         THEN REGEXP_SUBSTR(e.EXCEPTION_CATEGORY, '^[^:]+') END AS EXCEPTION_CODE,
    da.LOANCASEID,
    e.CHECK_FTR,
    e.FIRST_WORKSTEP_RETURN,
    e.PHAN_LOAI_DDE
FROM       PDTD_DTM.FCT_RLOS_EXCEPTION e
JOIN       p ON e.DAYID = p.rpt_date
          AND e.RAISED_DATE_TIME >= p.rpt_date
          AND e.RAISED_DATE_TIME <  p.rpt_date + 1
LEFT JOIN  PDTD_DTM.DIM_RLOS_APPLICATION  da ON da.DIMENSION_KEY = e.APPLICATION_SK
LEFT JOIN  PDTD_DTM.FCT_RLOS_APPLICATION  a  ON a.WI_NAME = e.WI_NAME AND a.DAYID = e.DAYID
LEFT JOIN  PDTD_DTM.DIM_LOS_COMPANY      co ON co.DIMENSION_KEY = a.COMPANY_SK
WHERE      (:p_branch_code IS NULL OR co.BRANCH_CODE = :p_branch_code)
ORDER BY   WI_NAME, RAISED_DATE_TIME, ACTIVITYNAME;
