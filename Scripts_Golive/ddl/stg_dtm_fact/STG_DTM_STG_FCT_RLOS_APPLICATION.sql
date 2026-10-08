-- ============================================================
-- STG_DTM_STG_FCT_RLOS_APPLICATION.sql
-- ============================================================
-- ===========================================================================
-- NOTE - CAN CHECK LAI: PK khong co cot _BK
--
-- PK hien tai : (WI_NAME, DAYID)
-- Mau chuan   : (<bang>_BK, DAYID)
-- Thuc te     : LLD danh key=PK vao WI_NAME thay vi mot cot _BK.
--
-- Can xac nhan: WI_NAME dang dong vai tro business key.
--               Co can bo sung cot <bang>_BK cho nhat quan voi cac bang
--               STG_FCT_ khac hay giu nguyen?
--
-- TANG STG (vung chia): bang chi giu lat cat 1 ngay roi day sang PDTD_DTM.
-- Da giu nguyen partition INTERVAL 1 DAY + PK LOCAL cho dong bo 2 tang kia,
-- nhung neu job la truncate-load moi ngay thi can danh gia lai: partition tren
-- bang chi chua 1 ngay gan nhu khong co tac dung, va PK constraint lam cham load.
-- ===========================================================================
-- DROP TABLE STG_DTM.STG_FCT_RLOS_APPLICATION
CREATE TABLE STG_DTM.STG_FCT_RLOS_APPLICATION (
    DAYID                         DATE                NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    WORKSTEP_DECISION_SK          NUMBER              NOT NULL,
    PRODUCT_SK                    NUMBER              NOT NULL,
    COMPANY_SK                    NUMBER              NOT NULL,
    CHANGE_TYPE_SK                NUMBER              NOT NULL,
    CARD_PROMOTION_SK             NUMBER              NOT NULL,
    WI_NAME                       NVARCHAR2(70)       NOT NULL,
    PROCESSED_DATE                DATE                ,
    CREATION_DATE                 DATE                ,
    APPROVED_AMT_FINAL            NUMBER(20,2)        ,
    APPROVED_TERM                 NUMBER(5)           ,
    CURRENCY_CODE                 NVARCHAR2(100)        ,
    UNDERWRITERMAKER_USERMAKE     VARCHAR2(100)       ,
    UNDERWRITERCHECKER_USERMAKE   VARCHAR2(100)       ,
    APPROVAL_USERMAKE             VARCHAR2(100)       ,
    CHANGE_REQUEST                NVARCHAR2(50)       ,
    CHANGE_TYPE                   NVARCHAR2(255)       ,

  CONSTRAINT STG_FCT_RLOS_APPLICATION_PK PRIMARY KEY (WI_NAME, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION STG_FCT_RLOS_APPLICATION_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
