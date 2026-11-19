

-- =====================================================================================
-- PHẦN 2: PACKAGE TẠI PDTD_DTM (y hệt bản SB_DWH, chỉ đổi nguồn sang PDTD_DTM.MV_DIM_TIME)
-- =====================================================================================
BEGIN
  EXECUTE IMMEDIATE q'~
CREATE OR REPLACE PACKAGE PDTD_DTM.PKG_BUSINESS_MINUTE AS
  FUNCTION get_minute    (p_from_ts IN TIMESTAMP, p_to_ts IN TIMESTAMP) RETURN NUMBER;
  FUNCTION get_minute_cpc(p_from_ts IN TIMESTAMP, p_to_ts IN TIMESTAMP) RETURN NUMBER;
END PKG_BUSINESS_MINUTE;
~';
END;
/


BEGIN
  EXECUTE IMMEDIATE q'~
CREATE OR REPLACE PACKAGE BODY PDTD_DTM.PKG_BUSINESS_MINUTE AS

  TYPE t_num IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

  -- Khung giờ (đơn vị: phần của ngày)
  c_wh_m1  CONSTANT NUMBER := 8/24;     c_wh_m2  CONSTANT NUMBER := 12/24;    -- WH sáng  08:00-12:00
  c_wh_a1  CONSTANT NUMBER := 13/24;    c_wh_a2  CONSTANT NUMBER := 17/24;    -- WH chiều 13:00-17:00
  c_cpc_m1 CONSTANT NUMBER := 8/24;     c_cpc_m2 CONSTANT NUMBER := 11.5/24;  -- CPC sáng  08:00-11:30
  c_cpc_a1 CONSTANT NUMBER := 13.5/24;  c_cpc_a2 CONSTANT NUMBER := 16.5/24;  -- CPC chiều 13:30-16:30

  -- Phút của 1 ngày trọn vẹn
  c_wh_full_sat  CONSTANT NUMBER := 240;   c_wh_full_wk  CONSTANT NUMBER := 480;
  c_cpc_full_sat CONSTANT NUMBER := 210;   c_cpc_full_wk CONSTANT NUMBER := 390;

  g_sat     t_num;          -- số dòng thứ Bảy được tính của ngày j (j = số ngày Julian)
  g_wk      t_num;          -- số dòng thứ 2-6 làm việc của ngày j
  g_cum_wh  t_num;          -- phút WH trọn ngày lũy kế đến hết ngày j
  g_cum_cpc t_num;          -- phút CPC trọn ngày lũy kế đến hết ngày j
  g_min     PLS_INTEGER;
  g_max     PLS_INTEGER;
  g_loaded  BOOLEAN := FALSE;

  FUNCTION sat_cnt(j PLS_INTEGER) RETURN NUMBER IS
  BEGIN
    IF g_sat.EXISTS(j) THEN RETURN g_sat(j); ELSE RETURN 0; END IF;
  END;

  FUNCTION wk_cnt(j PLS_INTEGER) RETURN NUMBER IS
  BEGIN
    IF g_wk.EXISTS(j) THEN RETURN g_wk(j); ELSE RETURN 0; END IF;
  END;

  PROCEDURE load_cache IS
    v_run_wh  NUMBER := 0;
    v_run_cpc NUMBER := 0;
  BEGIN
    FOR r IN (SELECT TO_NUMBER(TO_CHAR(T.DAY_DATE, 'J')) AS j,
                     T.DAY_OF_CAL_WEEK                    AS dow
              FROM STG_DTM.STG_DIM_TIME T
              WHERE T.DAY_OF_CAL_WEEK = 7
                 OR (T.DAY_OF_CAL_WEEK BETWEEN 2 AND 6 AND T.IS_WORKING_DAY = 1))
    LOOP
      IF r.dow = 7 THEN g_sat(r.j) := sat_cnt(r.j) + 1;
      ELSE              g_wk(r.j)  := wk_cnt(r.j)  + 1;
      END IF;
      IF g_min IS NULL OR r.j < g_min THEN g_min := r.j; END IF;
      IF g_max IS NULL OR r.j > g_max THEN g_max := r.j; END IF;
    END LOOP;

    IF g_min IS NOT NULL THEN
      FOR j IN g_min .. g_max LOOP
        v_run_wh     := v_run_wh  + c_wh_full_sat  * sat_cnt(j) + c_wh_full_wk  * wk_cnt(j);
        v_run_cpc    := v_run_cpc + c_cpc_full_sat * sat_cnt(j) + c_cpc_full_wk * wk_cnt(j);
        g_cum_wh(j)  := v_run_wh;
        g_cum_cpc(j) := v_run_cpc;
      END LOOP;
    END IF;
    g_loaded := TRUE;
  END load_cache;

  FUNCTION cum_at(j PLS_INTEGER, p_cpc BOOLEAN) RETURN NUMBER IS
    k PLS_INTEGER;
  BEGIN
    IF g_min IS NULL OR j < g_min THEN RETURN 0; END IF;
    k := LEAST(j, g_max);
    IF p_cpc THEN RETURN g_cum_cpc(k); ELSE RETURN g_cum_wh(k); END IF;
  END;

  -- Lõi tính chung: p_cpc = FALSE -> WH, TRUE -> CPC
  FUNCTION calc(p_from_ts IN TIMESTAMP, p_to_ts IN TIMESTAMP, p_cpc BOOLEAN) RETURN NUMBER IS
    v_from  DATE;
    v_to    DATE;
    jf      PLS_INTEGER;
    jl      PLS_INTEGER;
    v_total NUMBER := 0;
    m1 NUMBER; m2 NUMBER; a1 NUMBER; a2 NUMBER;

    FUNCTION overlap_min(p_start DATE, p_end DATE) RETURN NUMBER IS
    BEGIN
      RETURN GREATEST(0, LEAST(v_to, p_end) - GREATEST(v_from, p_start)) * 1440;
    END;

    FUNCTION phut_le(j PLS_INTEGER) RETURN NUMBER IS
      d DATE := TO_DATE(TO_CHAR(j), 'J');
    BEGIN
      RETURN sat_cnt(j) *  overlap_min(d + m1, d + m2)
           + wk_cnt(j)  * (overlap_min(d + m1, d + m2) + overlap_min(d + a1, d + a2));
    END;
  BEGIN
    IF NOT g_loaded THEN load_cache; END IF;

    IF p_from_ts IS NULL OR p_to_ts IS NULL THEN RETURN NULL; END IF;
    IF p_from_ts >= p_to_ts THEN RETURN 0; END IF;

    IF p_cpc THEN m1 := c_cpc_m1; m2 := c_cpc_m2; a1 := c_cpc_a1; a2 := c_cpc_a2;
    ELSE          m1 := c_wh_m1;  m2 := c_wh_m2;  a1 := c_wh_a1;  a2 := c_wh_a2;
    END IF;

    v_from := CAST(p_from_ts AS DATE);
    v_to   := CAST(p_to_ts   AS DATE);
    jf     := TO_NUMBER(TO_CHAR(v_from, 'J'));
    jl     := TO_NUMBER(TO_CHAR(v_to,   'J'));

    v_total := phut_le(jf);
    IF jl > jf     THEN v_total := v_total + phut_le(jl); END IF;
    IF jl > jf + 1 THEN v_total := v_total + cum_at(jl - 1, p_cpc) - cum_at(jf, p_cpc); END IF;

    RETURN ROUND(v_total, 2);
  END calc;

  FUNCTION get_minute(p_from_ts IN TIMESTAMP, p_to_ts IN TIMESTAMP) RETURN NUMBER IS
  BEGIN
    RETURN calc(p_from_ts, p_to_ts, FALSE);
  END;

  FUNCTION get_minute_cpc(p_from_ts IN TIMESTAMP, p_to_ts IN TIMESTAMP) RETURN NUMBER IS
  BEGIN
    RETURN calc(p_from_ts, p_to_ts, TRUE);
  END;

END PKG_BUSINESS_MINUTE;
~';
END;
/


-- =====================================================================================
-- PHẦN 3: 2 HÀM TẠI PDTD_DTM (cùng tên, cùng tham số với bản SB_DWH)
-- =====================================================================================
BEGIN
  EXECUTE IMMEDIATE q'~
CREATE OR REPLACE FUNCTION PDTD_DTM.FNC_GET_BUSINESS_MINUTE (
  p_from_ts IN TIMESTAMP,
  p_to_ts   IN TIMESTAMP
) RETURN NUMBER PARALLEL_ENABLE
IS
BEGIN
  RETURN PDTD_DTM.PKG_BUSINESS_MINUTE.get_minute(p_from_ts, p_to_ts);
END FNC_GET_BUSINESS_MINUTE;
~';
  EXECUTE IMMEDIATE q'~
CREATE OR REPLACE FUNCTION PDTD_DTM.FNC_GET_BUSINESS_MINUTE_CPC (
  p_from_ts IN TIMESTAMP,
  p_to_ts   IN TIMESTAMP
) RETURN NUMBER PARALLEL_ENABLE
IS
BEGIN
  RETURN PDTD_DTM.PKG_BUSINESS_MINUTE.get_minute_cpc(p_from_ts, p_to_ts);
END FNC_GET_BUSINESS_MINUTE_CPC;
~';
END;
/



