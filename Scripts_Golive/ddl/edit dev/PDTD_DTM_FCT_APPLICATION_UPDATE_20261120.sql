-- ============================================================
-- PDTD_DTM_FCT_APPLICATION_UPDATE_20261120.sql
-- UPDATE DDL tren DEV cho PDTD_DTM.FCT_CLOS_APPLICATION va FCT_RLOS_APPLICATION (20/11/2026):
--   them cot LAST_DECISION (VARCHAR2(200), NULL) - DECISION_CODE cua cung dong event co ENTRYDATE
--   lon nhat voi LAST_WORKSTEP / LAST_ENTRYDATE / LAST_EXITDATE (xem LLD). NULL khi buoc cuoi dang
--   mo (chua co quyet dinh). Khac DECISION_CODE / WORKSTEP_DECISION_SK dau bang (quyet dinh cua su
--   kien HOAN TAT gan nhat, giu lam chieu khai thac).
--   FCT_CLOS_APPLICATION.FLAG_AUTO_CANCEL doi sang dua tren LAST_DECISION (chi doi ETL, khong doi DDL).
--   Ho so da co truoc khi them cot: NULL, ETL tinh lai khi co event moi (giong LAST_GROUP_CNT).
--   Luu y: bang FCT_xLOS_APPLICATION_PREV (snapshot DAYID=v_batch_date-1 cua chinh bang nay) phai co
--   cot LAST_DECISION - neu la bang cau truc co dinh thi ALTER tuong tu.
-- ============================================================

ALTER TABLE PDTD_DTM.FCT_CLOS_APPLICATION ADD (
    LAST_DECISION                 VARCHAR2(200)
);

ALTER TABLE PDTD_DTM.FCT_RLOS_APPLICATION ADD (
    LAST_DECISION                 VARCHAR2(200)
);
