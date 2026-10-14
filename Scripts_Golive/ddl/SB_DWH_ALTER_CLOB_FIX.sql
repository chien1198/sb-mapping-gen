-- ============================================================
-- SB_DWH_ALTER_CLOB_FIX.sql
-- Sửa kiểu dữ liệu đích khớp với nguồn STG_LOS (CLOB) cho các cột
-- hiện đang khai báo VARCHAR2(4000) tại SB_DWH, nguy cơ truncate dữ liệu.
-- Áp dụng cho bảng chưa có dữ liệu (chưa go-live).
-- ============================================================

ALTER TABLE SB_DWH.FCT_CLOS_COLLATERAL MODIFY (
    DESCRIPTION        CLOB,
    COLL_MGMT_METHOD   CLOB
);

COMMIT;

ALTER TABLE SB_DWH.FCT_CLOS_DEVIATION MODIFY (
    DEV_PROPOSAL       CLOB,
    AS_REGULAR         CLOB
);

COMMIT;

ALTER TABLE SB_DWH.FCT_RLOS_DEVIATION MODIFY (
    DEVIATION_REASON   CLOB
);

COMMIT;
