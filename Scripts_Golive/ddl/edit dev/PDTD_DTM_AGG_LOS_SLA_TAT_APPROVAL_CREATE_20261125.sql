-- ============================================================
-- PDTD_DTM_AGG_LOS_SLA_TAT_APPROVAL_CREATE_20261125.sql
-- CREATE bang moi tren DEV: PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL (25/11/2026) - luu ket qua BC5 cua lan phe duyet dau (append-only).
--   Nguon: FCT_CLOS_APPLICATION / FCT_RLOS_APPLICATION (APPLICATION_STATUS IN ('Approved','Rejected'), chua co dong) + FCT_*_WORKSTEP_EVENT + REF_SLA_NLTT (xem LLD PDTD_DTM_AGG_LOS_SLA_TAT_APPROVAL.csv).
--   Lan chay dau (D0) tu ghi toan bo ho so da duyet tu lich su nen khong can script init rieng.
-- ============================================================

-- ===========================================================================
-- NOTE: bang append-only luu ket qua BC5 (SLA - TAT) cua LAN PHE DUYET DAU tung ho so (Approved/Rejected).
--       1 dong = 1 ho so x 1 he thong (CLOS/RLOS); chi INSERT, khong UPDATE/MERGE; ho so chua duyet va dong lan 2 KHONG luu o day.
-- Partition   : RANGE (PROCESSED_DATE) INTERVAL 1 DAY (cung kieu cac bang AGG khac); BC5 loc khoang PROCESSED_DATE nen partition pruning
--               thay chi muc rieng. DAYID chi la cot doi soat (ngay batch ghi dong), khong nam trong PK va BC5 khong loc theo DAYID.
-- PK          : (SYSTEMNAME, WI_NAME) dung index GLOBAL (USING INDEX, khong LOCAL): Oracle khong cho unique index LOCAL thieu cot partition key
--               (ORA-14039), va ETL kiem tra NOT EXISTS theo (SYSTEMNAME, WI_NAME) nen can 1 lan tra index thay vi quet tung partition.
--               Neu sau nay DROP/TRUNCATE partition cu thi phai kem UPDATE GLOBAL INDEXES.
-- ===========================================================================
-- DROP TABLE PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL
CREATE TABLE PDTD_DTM.AGG_LOS_SLA_TAT_APPROVAL (
    SYSTEMNAME                    VARCHAR2(10)        NOT NULL,
    WI_NAME                       VARCHAR2(100)       NOT NULL,
    DAYID                         DATE                NOT NULL,
    PROCESSED_DATE                DATE                NOT NULL,
    BI_APPSTATUS                  VARCHAR2(50)        NOT NULL,
    STEP01_BRANCH_CL_TAT          NUMBER(18,2)        NOT NULL,
    STEP01_BRANCH_WK_TAT          NUMBER(18,2)        NOT NULL,
    STEP01_BRANCH_TAT_CPC         NUMBER(18,2)        NOT NULL,
    STEP02_DDE_CL_TAT             NUMBER(18,2)        NOT NULL,
    STEP02_DDE_WK_TAT             NUMBER(18,2)        NOT NULL,
    STEP02_DDE_TAT_CPC            NUMBER(18,2)        NOT NULL,
    STEP03_QUALITY_CHECKER_CL_TAT NUMBER(18,2)        NOT NULL,
    STEP03_QUALITY_CHECKER_WK_TAT NUMBER(18,2)        NOT NULL,
    STEP03_QUALITY_CHECKER_TAT_CPC NUMBER(18,2)        NOT NULL,
    STEP04_UNDMAKER_CL_TAT        NUMBER(18,2)        NOT NULL,
    STEP04_UNDMAKER_WK_TAT        NUMBER(18,2)        NOT NULL,
    STEP04_UNDMAKER_TAT_CPC       NUMBER(18,2)        NOT NULL,
    STEP04_UNDCHECKER_CL_TAT      NUMBER(18,2)        NOT NULL,
    STEP04_UNDCHECKER_WK_TAT      NUMBER(18,2)        NOT NULL,
    STEP04_UNDCHECKER_TAT_CPC     NUMBER(18,2)        NOT NULL,
    STEP04_UND_TAT_CPC            NUMBER(18,2)        NOT NULL,
    STEP07_APPROVER_CL_TAT        NUMBER(18,2)        NOT NULL,
    STEP07_APPROVER_WK_TAT        NUMBER(18,2)        NOT NULL,
    STEP07_APPROVER_TAT_CPC       NUMBER(18,2)        NOT NULL,
    STEP07_COMMITTEE_CL_TAT       NUMBER(18,2)        NOT NULL,
    STEP07_COMMITTEE_WK_TAT       NUMBER(18,2)        NOT NULL,
    TAT_PHONG_CL_TAT              NUMBER(18,2)        NOT NULL,
    TAT_PHONG_WK_TAT              NUMBER(18,2)        NOT NULL,
    TAT_KHOI_PDTD_CL_TAT          NUMBER(18,2)        NOT NULL,
    TAT_KHOI_PDTD_WK_TAT          NUMBER(18,2)        NOT NULL,
    ENTRYDATE_DDE                 TIMESTAMP,
    EXITDATE_DDE                  TIMESTAMP,
    REF_PRODUCT                   VARCHAR2(200),
    SLA_CREDIT_OFFICER            NUMBER(10,2),
    SLA_CREDIT_APPROVER           NUMBER(10,2),
    SLA_MARKER                    NUMBER(10,2),
    SLA_CHECKER                   NUMBER(10,2),
    SLA_MARKER_RESUTL             VARCHAR2(10),
    SLA_CHECKER_RESUTL            VARCHAR2(10),
    SLA_CO_RESUTL                 VARCHAR2(10),
    SLA_APPROVER_RESULT           VARCHAR2(10),
    SLA_CO_APPROVER_RESULT        VARCHAR2(10),
    SLA_DE                        NUMBER(10,2),
    SLA_QC                        NUMBER(10,2),
    SLA_DE_RESULT                 VARCHAR2(10),
    SLA_QC_RESULT                 VARCHAR2(10),
    SLA_DE_TOTAL_RESULT           VARCHAR2(10),
    QD_DDE                        NUMBER(10,2),
    QD_QC                         NUMBER(10,2),
    TIME_UPDATE                   TIMESTAMP,

	CONSTRAINT AGG_LOS_SLA_TAT_APPROVAL_PK PRIMARY KEY (SYSTEMNAME, WI_NAME) USING INDEX
)
PARTITION BY RANGE (PROCESSED_DATE)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION AGG_LOS_SLA_TAT_APPROVAL_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
