-- ============================================================
-- PDTD_DTM_FCT_APPLICATION_UPDATE_20261119.sql
-- UPDATE DDL tren DEV cho PDTD_DTM.FCT_CLOS_APPLICATION va FCT_RLOS_APPLICATION (19/11/2026):
--   them cot LAST_GROUP_CNT (NUMBER(3), NULL) - so dong event cua nhom cuoi (cac dong co
--   ENTRYDATE = LAST_ENTRYDATE) cua ho so. Dung de quyet dinh ngay hom sau co can doc lai
--   FCT_xLOS_WORKSTEP_EVENT hay khong khi tinh LAST_ENTRYDATE / LAST_EXITDATE / LAST_REMARKS /
--   LAST_WORKSTEP / PRE_WORKSTEP_CODE (xem LLD).
--   Ho so da co truoc khi them cot: NULL, ETL xu ly nhu ho so moi va tinh lai khi co event.
--
--   them index (WI_NAME, ENTRYDATE) cho 2 bang event de doc nhanh lich su event theo ho so:
--     FCT_CLOS_WORKSTEP_EVENT_IX2, FCT_RLOS_WORKSTEP_EVENT_IX2
--   (FCT_RLOS_WORKSTEP_EVENT_IX1 hien co giu nguyen, dang phuc vu AUTO_CANCEL_DATE)
-- ============================================================

ALTER TABLE PDTD_DTM.FCT_CLOS_APPLICATION ADD (
    LAST_GROUP_CNT                NUMBER(3)
);

ALTER TABLE PDTD_DTM.FCT_RLOS_APPLICATION ADD (
    LAST_GROUP_CNT                NUMBER(3)
);

CREATE INDEX PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT_IX2
    ON PDTD_DTM.FCT_CLOS_WORKSTEP_EVENT (WI_NAME, ENTRYDATE) LOCAL;

CREATE INDEX PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT_IX2
    ON PDTD_DTM.FCT_RLOS_WORKSTEP_EVENT (WI_NAME, ENTRYDATE) LOCAL;
