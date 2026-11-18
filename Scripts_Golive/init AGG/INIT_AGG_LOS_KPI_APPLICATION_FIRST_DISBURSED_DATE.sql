-- INIT_AGG_LOS_KPI_APPLICATION_FIRST_DISBURSED_DATE.sql - khoi tao FIRST_DISBURSED_DATE cho ho so co tu truoc go-live
--
-- MUC DICH: o D0 bang PREV rong nen cong thuc hang ngay gan FIRST_DISBURSED_DATE = D0 cho MOI ho so da co hop dong (ke ca ho so giai ngan tu nhieu nam truoc).
--   Script dat lai cot nay cho snapshot D0 cua PDTD_DTM.AGG_LOS_KPI_APPLICATION bang MIN(VALUE_DATE) cua cac hop dong thuoc ho so
--   (VALUE_DATE o STG_DTM.STG_DIM_LOAN). Chi dung o D0. Cong thuc hang ngay cua cot KHONG doi (xem LLD AGG_LOS_KPI_APPLICATION).
--   Cung dieu kien noi hop dong nhu LLD: RLOS: STG_FCT_LOAN.SEAB_LOS_ID = WI_NAME; CLOS: nhanh LD (STG_FCT_LOAN, SEAB_LOS_ID = WI_NAME va
--   CUSTOMER_CODE = FCT_CLOS_APPLICATION.T24_CUSTOMER_CODE) hoac nhanh MD (STG_FCT_MD, SEAB_LOS_ID = WI_NAME va CUSTOMER = T24_CUSTOMER_CODE).
--   Ho so nhieu hop dong lay ngay giai ngan som nhat. Khong co VALUE_DATE thi giu nguyen gia tri hien co (D0).
--
-- CACH CHAY (1 lan, ngay D0):
--   1. Sua DEFINE v_batch_date ben duoi thanh ngay D0 (YYYY-MM-DD). De nguyen gia tri mac dinh thi TO_DATE bao loi (co chu y).
--   2. Chay SAU job AGG_LOS_KPI_APPLICATION cua D0; TRUOC AGG_LOS_KPI_YTD_DAILY (D0), TRUOC INIT_AGG_LOS_KPI_YTD_DAILY.sql va TRUOC khi dung
--      AGG_LOS_KPI_APPLICATION_PREV cho batch D1 (PREV lay tu snapshot D0 nen phai mang ngay giai ngan that).
--   3. Chay lai nhieu lan van cho cung ket qua. KHONG chay sau khi PREV cua D1 da duoc dung.
--   4. VALUE_DATE o tuong lai (> D0): ho so duoc dem vao ngay do khi ngay do toi (gia tri duoc carry-forward qua PREV).

DEFINE v_batch_date = 'YYYY-MM-DD'

MERGE INTO PDTD_DTM.AGG_LOS_KPI_APPLICATION a
USING (
    SELECT t.APPLICATION_BK, t.DAYID, MIN(TRUNC(t.VALUE_DATE)) AS FIRST_VALUE_DATE
    FROM (
        -- RLOS: hop dong tren STG_FCT_LOAN theo SEAB_LOS_ID = WI_NAME
        SELECT g.APPLICATION_BK, g.DAYID, d.VALUE_DATE
        FROM   PDTD_DTM.AGG_LOS_KPI_APPLICATION g
        JOIN   STG_DTM.STG_FCT_LOAN f ON f.SEAB_LOS_ID = g.WI_NAME
        JOIN   STG_DTM.STG_DIM_LOAN d ON d.DIMENSION_KEY = f.CONTRACT_SK
        WHERE  g.DAYID = TO_DATE('&v_batch_date', 'YYYY-MM-DD') AND g.DATASOURCE = 'RLOS'
        UNION ALL
        -- CLOS nhanh LD: STG_FCT_LOAN theo SEAB_LOS_ID = WI_NAME va ma khach hang T24
        SELECT g.APPLICATION_BK, g.DAYID, d.VALUE_DATE
        FROM   PDTD_DTM.AGG_LOS_KPI_APPLICATION g
        JOIN   PDTD_DTM.FCT_CLOS_APPLICATION c ON c.WI_NAME = g.WI_NAME AND c.DAYID = g.DAYID
        JOIN   STG_DTM.STG_FCT_LOAN f ON f.SEAB_LOS_ID = g.WI_NAME AND f.CUSTOMER_CODE = c.T24_CUSTOMER_CODE
        JOIN   STG_DTM.STG_DIM_LOAN d ON d.DIMENSION_KEY = f.CONTRACT_SK
        WHERE  g.DAYID = TO_DATE('&v_batch_date', 'YYYY-MM-DD') AND g.DATASOURCE = 'CLOS'
        UNION ALL
        -- CLOS nhanh MD: STG_FCT_MD theo SEAB_LOS_ID = WI_NAME va ma khach hang T24
        SELECT g.APPLICATION_BK, g.DAYID, d.VALUE_DATE
        FROM   PDTD_DTM.AGG_LOS_KPI_APPLICATION g
        JOIN   PDTD_DTM.FCT_CLOS_APPLICATION c ON c.WI_NAME = g.WI_NAME AND c.DAYID = g.DAYID
        JOIN   STG_DTM.STG_FCT_MD m ON m.SEAB_LOS_ID = g.WI_NAME AND m.CUSTOMER = c.T24_CUSTOMER_CODE
        JOIN   STG_DTM.STG_DIM_LOAN d ON d.DIMENSION_KEY = m.CONTRACT_SK
        WHERE  g.DAYID = TO_DATE('&v_batch_date', 'YYYY-MM-DD') AND g.DATASOURCE = 'CLOS'
    ) t
    GROUP  BY t.APPLICATION_BK, t.DAYID
) s
ON (a.APPLICATION_BK = s.APPLICATION_BK AND a.DAYID = s.DAYID)
WHEN MATCHED THEN UPDATE SET
    a.FIRST_DISBURSED_DATE = NVL(s.FIRST_VALUE_DATE, a.FIRST_DISBURSED_DATE)
;

COMMIT;

-- Phan bo ngay giai ngan lan dau sau khoi tao: phan lon ho so phai o "tu_truoc_D0"; "dung_D0" la ho so giai ngan dung ngay D0
SELECT COUNT(*) AS so_ho_so_co_hop_dong,
       COUNT(CASE WHEN FIRST_DISBURSED_DATE = TO_DATE('&v_batch_date', 'YYYY-MM-DD') THEN 1 END) AS dung_D0,
       COUNT(CASE WHEN FIRST_DISBURSED_DATE <  TO_DATE('&v_batch_date', 'YYYY-MM-DD') THEN 1 END) AS tu_truoc_D0,
       COUNT(CASE WHEN FIRST_DISBURSED_DATE >  TO_DATE('&v_batch_date', 'YYYY-MM-DD') THEN 1 END) AS tuong_lai
FROM   PDTD_DTM.AGG_LOS_KPI_APPLICATION
WHERE  DAYID = TO_DATE('&v_batch_date', 'YYYY-MM-DD')
AND    FIRST_DISBURSED_DATE IS NOT NULL;
