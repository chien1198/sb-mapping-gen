/* =====================================================================
   BC4 - Bao cao Tuan Chuyen vien Tham dinh (CLOS + RLOS, PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC4.md + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_from     DATE      Tu ngay (REPORT_DATE = PROCESSED_DATE), mac dinh T-1
     :p_date_to       DATE      Den ngay (REPORT_DATE = PROCESSED_DATE), mac dinh T-1; ngay du lieu cua bang snapshot (DAYID) = :p_date_to
   Grain: 1 dong / ho so (moi nhanh CLOS, RLOS), ke ca ho so co PROCESSED_DATE o nhieu ngay trong khoang.
     - Pham vi: ho so da co buoc tham dinh (FCT_*_APPLICATION.HAS_UWM_FLAG = 'Y' tai DAYID = :p_date_to), co dong
       su kien DAYID trong [:p_date_from, :p_date_to] va PROCESSED_DATE trong [:p_date_from, :p_date_to].
     - REPORT_DATE = ngay PROCESSED_DATE moi nhat cua ho so trong khoang; MAX(PROCESSED_DATE) gop cac phien ban
       su kien trong khoang ve 1 dong / ho so nen o buoc xac dinh pham vi khong loc phien ban moi nhat.
     - WORKSTEP / UND_MAKER / REMARKS: dong su kien UnderwriterMaker moi nhat.
     - ENTRYDATE / EXITDATE: MIN / MAX tai UnderwriterMaker + UnderwriterChecker.
     - FLAG cap ho so (thu tu uu tien 5 nhanh cua SRS): nhanh theo quyet dinh (da phe duyet / CVTD chot / chuyen-tra lai)
       lay tu moi dong su kien; nhanh theo trang thai workflow (chua PD / dang-phai xu ly) chi lay tu dong moi nhat
       cua ho so, vi dong cu giu WF_ACTIVITYNAME luc ghi.
   REPORT_WEEK tinh truc tiep tu REPORT_DATE (khong dung DIM_DATE): Thu 2 - Chu nhat, dinh dang YYYYMMDD-YYYYMMDD.
   FCT_*_WORKSTEP_EVENT (lat cat ngay phat sinh): CTE *_scope loc DAYID trong [:p_date_from, :p_date_to];
   CTE *_hist doc toan bo lich su cua ho so nen CHI chan tren DAYID <= :p_date_to (khong chan duoi, vi cac buoc
   cua ho so co the phat sinh truoc :p_date_from) va chi lay phien ban moi nhat cua tung WORKSTEP_EVENT_BK.
   Bang snapshot (FCT_*_APPLICATION, FCT_RLOS_CUSTOMER): loc DAYID = :p_date_to.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_date_from) AS d_from,
           TRUNC(:p_date_to)   AS d_to
    FROM   DUAL
),
-- ===== CLOS =====
-- Ho so trong pham vi khoang bao cao
clos_scope AS (
    SELECT e.WI_NAME,
           a.CUSTOMER_SK,
           TRUNC(MAX(e.PROCESSED_DATE)) AS REPORT_DATE
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.PROCESSED_DATE >= p.d_from
            AND e.PROCESSED_DATE <  p.d_to + 1
    JOIN   PDTD_DTM.FCT_CLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to AND a.HAS_UWM_FLAG = 'Y'
    GROUP  BY e.WI_NAME, a.CUSTOMER_SK
),
-- Lich su su kien cua ho so (phien ban moi nhat cua tung su kien, den :p_date_to)
clos_hist AS (
    SELECT e.*
    FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT e
    JOIN   clos_scope s ON s.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
-- Dong su kien UnderwriterMaker moi nhat / ho so
clos_uw AS (
    SELECT h.WI_NAME,
           MAX(h.WORKSTEP_CODE) KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS WORKSTEP,
           MAX(h.USERNAME)      KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS UND_MAKER,
           MAX(h.REMARKS)       KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS REMARKS
    FROM   clos_hist h
    WHERE  h.WORKSTEP_CODE = 'UnderwriterMaker'
    GROUP  BY h.WI_NAME
),
-- Moc thoi gian tham dinh + hang (rank) trang thai cap ho so
clos_agg AS (
    SELECT h.WI_NAME,
           MIN(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.ENTRYDATE END) AS ENTRYDATE,
           MAX(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.EXITDATE  END) AS EXITDATE,
           -- Co trang thai cap ho so: nhanh theo QUYET DINH (1,3,5) lay tu moi dong; nhanh theo TRANG THAI workflow (2,4)
           -- chi lay tu dong moi nhat (DAYID, ENTRYDATE lon nhat) vi dong cu giu WF_ACTIVITYNAME luc ghi
           LEAST(
               NVL(MIN(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt' THEN 1
                            WHEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ' THEN 3
                            WHEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ' THEN 5 END), 9),
               NVL(MAX(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD' THEN 2
                            WHEN 'Hồ sơ CVTĐ đang/phải xử lý' THEN 4 END)
                       KEEP (DENSE_RANK LAST ORDER BY h.DAYID, h.ENTRYDATE), 9)
           ) AS FLAG_RANK
    FROM   clos_hist h
    GROUP  BY h.WI_NAME
),
-- ===== RLOS =====
rlos_scope AS (
    SELECT e.WI_NAME,
           TRUNC(MAX(e.PROCESSED_DATE)) AS REPORT_DATE
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   p ON e.DAYID BETWEEN p.d_from AND p.d_to
            AND e.PROCESSED_DATE >= p.d_from
            AND e.PROCESSED_DATE <  p.d_to + 1
    JOIN   PDTD_DTM.FCT_RLOS_APPLICATION a ON a.WI_NAME = e.WI_NAME AND a.DAYID = p.d_to AND a.HAS_UWM_FLAG = 'Y'
    GROUP  BY e.WI_NAME
),
rlos_hist AS (
    SELECT e.*
    FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT e
    JOIN   rlos_scope s ON s.WI_NAME = e.WI_NAME
    JOIN   p ON e.DAYID <= p.d_to
    WHERE  NOT EXISTS (SELECT 1
                       FROM   PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT nv
                       WHERE  nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK
                         AND  nv.DAYID > e.DAYID
                         AND  nv.DAYID <= p.d_to)
),
rlos_uw AS (
    SELECT h.WI_NAME,
           MAX(h.WORKSTEP_CODE) KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS WORKSTEP,
           MAX(h.USERNAME)      KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS UND_MAKER,
           MAX(h.REMARKS)       KEEP (DENSE_RANK FIRST ORDER BY h.ENTRYDATE DESC, h.EXITDATE DESC NULLS FIRST) AS REMARKS
    FROM   rlos_hist h
    WHERE  h.WORKSTEP_CODE = 'UnderwriterMaker'
    GROUP  BY h.WI_NAME
),
rlos_agg AS (
    SELECT h.WI_NAME,
           MIN(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.ENTRYDATE END) AS ENTRYDATE,
           MAX(CASE WHEN h.WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker') THEN h.EXITDATE  END) AS EXITDATE,
           -- Co trang thai cap ho so: nhanh theo QUYET DINH (1,3,5) lay tu moi dong; nhanh theo TRANG THAI workflow (2,4)
           -- chi lay tu dong moi nhat (DAYID, ENTRYDATE lon nhat) vi dong cu giu WF_ACTIVITYNAME luc ghi
           LEAST(
               NVL(MIN(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt' THEN 1
                            WHEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ' THEN 3
                            WHEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ' THEN 5 END), 9),
               NVL(MAX(CASE h.WORKSTEP_FLAG
                            WHEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD' THEN 2
                            WHEN 'Hồ sơ CVTĐ đang/phải xử lý' THEN 4 END)
                       KEEP (DENSE_RANK LAST ORDER BY h.DAYID, h.ENTRYDATE), 9)
           ) AS FLAG_RANK
    FROM   rlos_hist h
    GROUP  BY h.WI_NAME
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
        JOIN   rlos_scope s ON s.WI_NAME = cu.WI_NAME
    )
    WHERE RN = 1
)
-- ===== Nhanh CLOS =====
SELECT
    TO_CHAR(TRUNC(s.REPORT_DATE, 'IW'), 'YYYYMMDD') || '-' || TO_CHAR(TRUNC(s.REPORT_DATE, 'IW') + 6, 'YYYYMMDD') AS REPORT_WEEK,
    s.REPORT_DATE,
    'CLOS'                                                  AS SYSTEMNAME,
    s.WI_NAME                                               AS WINAME,
    dc.CUSTOMER_NAME,
    u.WORKSTEP,
    u.UND_MAKER,
    g.ENTRYDATE,
    g.EXITDATE,
    CASE g.FLAG_RANK
         WHEN 1 THEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt'
         WHEN 2 THEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD'
         WHEN 3 THEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ'
         WHEN 4 THEN 'Hồ sơ CVTĐ đang/phải xử lý'
         WHEN 5 THEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ'
    END                                                     AS FLAG,
    u.REMARKS
FROM       clos_scope s
JOIN       clos_uw  u  ON u.WI_NAME = s.WI_NAME
LEFT JOIN  clos_agg g  ON g.WI_NAME = s.WI_NAME
LEFT JOIN  PDTD_DTM.DIM_CLOS_CUSTOMER dc ON dc.DIMENSION_KEY = s.CUSTOMER_SK
UNION ALL
-- ===== Nhanh RLOS =====
SELECT
    TO_CHAR(TRUNC(s.REPORT_DATE, 'IW'), 'YYYYMMDD') || '-' || TO_CHAR(TRUNC(s.REPORT_DATE, 'IW') + 6, 'YYYYMMDD') AS REPORT_WEEK,
    s.REPORT_DATE,
    'RLOS'                                                  AS SYSTEMNAME,
    s.WI_NAME                                               AS WINAME,
    cu.FULL_NAME                                            AS CUSTOMER_NAME,
    u.WORKSTEP,
    u.UND_MAKER,
    g.ENTRYDATE,
    g.EXITDATE,
    CASE g.FLAG_RANK
         WHEN 1 THEN 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt'
         WHEN 2 THEN 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD'
         WHEN 3 THEN 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ'
         WHEN 4 THEN 'Hồ sơ CVTĐ đang/phải xử lý'
         WHEN 5 THEN 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ'
    END                                                     AS FLAG,
    u.REMARKS
FROM       rlos_scope s
JOIN       rlos_uw  u  ON u.WI_NAME = s.WI_NAME
LEFT JOIN  rlos_agg g  ON g.WI_NAME = s.WI_NAME
LEFT JOIN  rlos_cust cu ON cu.WI_NAME = s.WI_NAME
ORDER BY   SYSTEMNAME, WINAME;
