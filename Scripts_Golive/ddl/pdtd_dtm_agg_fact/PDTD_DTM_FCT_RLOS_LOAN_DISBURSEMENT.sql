-- ============================================================
-- PDTD_DTM_FCT_RLOS_LOAN_DISBURSEMENT.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK khong co cot _BK
--
-- PK hien tai : (CONTRACT, DAYID)
-- Mau chuan   : (<bang>_BK, DAYID)
-- Thuc te     : LLD danh key=PK vao CONTRACT thay vi mot cot _BK.
--
-- Can xac nhan: CONTRACT dang dong vai tro business key.
--               Co can bo sung cot <bang>_BK cho nhat quan voi cac bang
--               FCT_ khac hay giu nguyen?
-- ===========================================================================
-- DROP TABLE PDTD_DTM.FCT_RLOS_LOAN_DISBURSEMENT
CREATE TABLE PDTD_DTM.FCT_RLOS_LOAN_DISBURSEMENT (
    DAYID                         DATE                NOT NULL,
    CONTRACT                      VARCHAR2(100)       NOT NULL,
    CUSTOMER_SK                   NUMBER              NOT NULL,
    T24_COMPANY_SK                NUMBER              NOT NULL,
    CONTRACT_SK                   NUMBER              NOT NULL,
    SEAB_PRODUCTS_DE_SK           NUMBER              NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    SEAB_LOS_ID                   VARCHAR2(100)       ,
    ZONE                          VARCHAR2(50)        ,
    DISBURSEMENT_AMT              NUMBER(20,2)        ,
    CUR_BALANCE                   NUMBER(20,2)        ,
    NO_DAYS_OVERDUE               NUMBER(6)           ,
    CUR_BUCKET                    NUMBER(2)           ,
    APPROVAL_DATE                 DATE                ,

	CONSTRAINT FCT_RLOS_LOAN_DISBURSEMENT_PK PRIMARY KEY (CONTRACT, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_LOAN_DISBURSEMENT_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
