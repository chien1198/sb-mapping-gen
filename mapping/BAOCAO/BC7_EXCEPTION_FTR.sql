/* =====================================================================
   BC7 - Bao cao EXCEPTION - FTR (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC7.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (PROCESSED_DATE = ngay phat sinh exception), mac dinh T-1
     :p_date_to       DATE      Den ngay (PROCESSED_DATE = ngay phat sinh exception), mac dinh T-1; ngay du lieu (DAYID) = :p_date_to
   Grain: 1 dong / (exception x buoc) - dung grain FCT_*_EXCEPTION (DAYID, EXCEPTION_BK, WORKSTEP_CODE).
   Pham vi: FCT_*_EXCEPTION co DAYID = :p_date_to (snapshot day du lich su) va RAISED_DATE_TIME trong
   [:p_date_from, :p_date_to].
   ACTIVITYNAME = WORKSTEP_CODE (LLD da tinh: tra DIM_*_EXCEPTION, sau lan DetailDataEntry+Submit dau tien,
   mac dinh 'DEFAULT'). CHECK_FTR / FIRST_WORKSTEP_RETURN / PHAN_LOAI_DDE da tinh san tai LLD.
   PROCESSED_DATE = TRUNC(RAISED_DATE_TIME) cho ca 2 nhanh.
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
JOIN       p ON e.DAYID = p.d_to
          AND e.RAISED_DATE_TIME >= p.d_from
          AND e.RAISED_DATE_TIME <  p.d_to + 1
LEFT JOIN  PDTD_DTM.DIM_CLOS_APPLICATION  da ON da.DIMENSION_KEY = e.APPLICATION_SK
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
JOIN       p ON e.DAYID = p.d_to
          AND e.RAISED_DATE_TIME >= p.d_from
          AND e.RAISED_DATE_TIME <  p.d_to + 1
LEFT JOIN  PDTD_DTM.DIM_RLOS_APPLICATION  da ON da.DIMENSION_KEY = e.APPLICATION_SK
ORDER BY   WI_NAME, RAISED_DATE_TIME, ACTIVITYNAME;
