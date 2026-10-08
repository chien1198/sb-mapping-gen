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
    WI_NAME                       NVARCHAR2(100)       ,
    ID_TYPE                       NVARCHAR2(50)        ,
    ID_NUMBER                     NVARCHAR2(100)       ,
    ISSUE_DATE                    DATE                ,
    EXPIRY_DATE                   DATE                ,
    ISSUE_PLACE                   NVARCHAR2(100)       ,
    ISSUE_DATE_VISA               DATE                ,
    EXPIRY_DATE_VISA              DATE                ,
    CUST_CLASS                    NVARCHAR2(200)       ,
    IS_FETCH                      NVARCHAR2(200)       ,
    CIF                           NVARCHAR2(50)        ,
    FULL_NAME                     NVARCHAR2(150)       ,
    DATE_OF_BIRTH                 DATE                ,
    GENDER                        NVARCHAR2(255)        ,
    NATIONALITY                   NVARCHAR2(100)       ,
    TITLE                         NVARCHAR2(30)        ,
    HOME_PHONE                    NVARCHAR2(100)        ,
    PHONE_1                       NVARCHAR2(100)        ,
    PHONE_2                       NVARCHAR2(100)        ,
    MARRIAGE_STATUS               NVARCHAR2(50)       ,
    EDUCATION_LEVEL               NVARCHAR2(100)       ,
    VEHICLE                       NVARCHAR2(100)       ,
    PERM_ADDRESS                  NVARCHAR2(2000)       ,
    CURR_HOUSE_NO                 NVARCHAR2(200)       ,
    CURR_WARD                     NVARCHAR2(200)       ,
    CITY_CODE                     VARCHAR2(50)        ,
    CITY_NAME                     VARCHAR2(200)       ,
    CITY_NAME_VN                  VARCHAR2(200)       ,
    DISTRICT_CODE                 NVARCHAR2(20)        ,
    DISTRICT_NAME                 NVARCHAR2(255)       ,
    DISTRICT_NAME_VN              VARCHAR2(200)       ,
    CUS_SEGMENT                   NVARCHAR2(50)       ,

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
