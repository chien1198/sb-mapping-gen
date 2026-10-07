-- ============================================================
-- SB_DWH_FCT_RLOS_CUSTOMER.sql
-- ============================================================
-- ===========================================================================
-- DROP TABLE SB_DWH.FCT_RLOS_CUSTOMER
CREATE TABLE SB_DWH.FCT_RLOS_CUSTOMER (
    DAYID                         DATE                NOT NULL,
    CUSTOMER_BK                   VARCHAR2(64)        NOT NULL,
    APPLICATION_SK                NUMBER              NOT NULL,
    T24_CUSTOMER_SK               NUMBER              NOT NULL,
    WI_NAME                       VARCHAR2(100)       ,
    ID_TYPE                       VARCHAR2(50)        ,
    ID_NUMBER                     VARCHAR2(100)       ,
    ISSUE_DATE                    DATE                ,
    EXPIRY_DATE                   DATE                ,
    ISSUE_PLACE                   VARCHAR2(200)       ,
    ISSUE_DATE_VISA               DATE                ,
    EXPIRY_DATE_VISA              DATE                ,
    CUST_CLASS                    VARCHAR2(200)       ,
    IS_FETCH                      VARCHAR2(200)       ,
    CIF                           VARCHAR2(50)        ,
    FULL_NAME                     VARCHAR2(200)       ,
    DATE_OF_BIRTH                 DATE                ,
    GENDER                        VARCHAR2(20)        ,
    NATIONALITY                   VARCHAR2(100)       ,
    TITLE                         VARCHAR2(50)        ,
    HOME_PHONE                    VARCHAR2(50)        ,
    PHONE_1                       VARCHAR2(50)        ,
    PHONE_2                       VARCHAR2(50)        ,
    MARRIAGE_STATUS               VARCHAR2(100)       ,
    EDUCATION_LEVEL               VARCHAR2(100)       ,
    VEHICLE                       VARCHAR2(100)       ,
    PERM_ADDRESS                  VARCHAR2(500)       ,
    CURR_HOUSE_NO                 VARCHAR2(200)       ,
    CURR_WARD                     VARCHAR2(100)       ,
    CITY_CODE                     VARCHAR2(50)        ,
    CITY_NAME                     VARCHAR2(200)       ,
    CITY_NAME_VN                  VARCHAR2(200)       ,
    DISTRICT_CODE                 VARCHAR2(50)        ,
    DISTRICT_NAME                 VARCHAR2(200)       ,
    DISTRICT_NAME_VN              VARCHAR2(200)       ,
    CUS_SEGMENT                   VARCHAR2(100)       ,

	CONSTRAINT FCT_RLOS_CUSTOMER_PK PRIMARY KEY (CUSTOMER_BK, DAYID) USING INDEX LOCAL
)
PARTITION BY RANGE (DAYID)
INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
(
    PARTITION FCT_RLOS_CUSTOMER_P0 VALUES LESS THAN (
        TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')
    )
);

COMMIT;
