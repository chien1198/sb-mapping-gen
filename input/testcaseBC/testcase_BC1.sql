-- MINUS
-- ===== CUM 1 | THOI GIAN / WORKFLOW =====
WITH
PD AS (
    SELECT
        u.WINAME,
        u.PD_UT1_APPROVED,
        u.PD_UT2_CANCEL,
        u.PD_UT3_LAST_EXIT,
        COALESCE(u.PD_UT1_APPROVED, u.PD_UT2_CANCEL, u.PD_UT3_LAST_EXIT) AS PROCESSED_DATE
    FROM (
        SELECT
            e0.WINAME,
            MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                      AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                          'Send To PostSanction','Submit To DisbursementMaker')
                     THEN e0.EXITDATE END)                                 AS PD_UT1_APPROVED,
            MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                     THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)              AS PD_UT2_CANCEL,
            MAX(e0.EXITDATE)                                               AS PD_UT3_LAST_EXIT
        FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e0
        GROUP BY e0.WINAME
    ) u
),
EE_DET AS (
    SELECT
        r.WINAME, r.WORKSTEP, r.ENTRYDATE, r.EXITDATE, r.REMARKS, r.DECISION, r.USERNAME, r.RN,
        x.BI_WORKSTEP, x.SYSTEM,
        ak.WORK_STEP AS AK_WORK_STEP, ak.USER_MAKE
    FROM (
        SELECT
            e.WINAME, e.WORKSTEP, e.ENTRYDATE, e.EXITDATE, e.REMARKS, e.DECISION, e.USERNAME,
            ROW_NUMBER() OVER (PARTITION BY e.WINAME ORDER BY e.ENTRYDATE DESC) AS RN
        FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e
    ) r
    LEFT JOIN SBLOS2.Q_RLOS_REF_WORKSTEP_2SYSTEMS   x  ON r.WORKSTEP = x.WORKSTEP
    LEFT JOIN SBLOS2.NG_SB_RLOS_USER_MAKE_WORK_STEP ak ON r.WINAME   = ak.WI_NAME AND r.WORKSTEP = ak.WORK_STEP
),
EE_LAST AS (
    SELECT
        d.WINAME,
        MAX(CASE WHEN d.RN = 1 THEN d.WORKSTEP  END) AS LAST_WORKSTEP,
        MAX(CASE WHEN d.RN = 2 THEN d.WORKSTEP  END) AS PRE_WORKSTEP,
        MAX(CASE WHEN d.RN = 1 THEN d.ENTRYDATE END) AS LAST_ENTRYDATE,
        MAX(CASE WHEN d.RN = 1 THEN d.EXITDATE  END) AS LAST_EXITDATE,
        MAX(CASE WHEN d.RN = 1 THEN d.REMARKS    END) AS LAST_REMARKS,
        MAX(CASE WHEN d.RN = 1 THEN d.DECISION  END) AS LAST_DECISION,
        MIN(d.ENTRYDATE)                                                                         AS CREATION_DATE,
        MIN(CASE WHEN d.WORKSTEP = 'UnderwriterMaker' THEN d.ENTRYDATE END)                      AS MIN_UWM,
        MIN(CASE WHEN d.WORKSTEP IN ('CreditApproval','CreditCommittee') THEN d.ENTRYDATE END)   AS MIN_APP,
        MAX(CASE WHEN d.WORKSTEP IN ('CreditApproval','CreditCommittee') THEN d.EXITDATE END)    AS LAST_APPROVAL_DATE,
        CASE
            WHEN MAX(CASE WHEN d.WORKSTEP IN ('CreditCommittee','CreditApproval')
                           AND d.DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')
                          THEN 1 ELSE 0 END) = 1                                           THEN 'Approved'
            WHEN MAX(CASE WHEN d.WORKSTEP IN ('CreditCommittee','CreditApproval')
                           AND d.DECISION = 'Reject'
                          THEN 1 ELSE 0 END) = 1                                           THEN 'Rejected'
            WHEN MAX(CASE WHEN d.WORKSTEP IN ('CancelRevoke','CancelPermanent')
                          THEN 1 ELSE 0 END) = 1                                           THEN 'Cancelled'
            ELSE 'Processing'
        END                                                                                      AS BI_APPSTATUS,
        MAX(CASE WHEN d.DECISION = 'Cancel' AND d.USERNAME IS NOT NULL THEN d.EXITDATE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.DECISION = 'Cancel' THEN d.EXITDATE END NULLS FIRST) AS CAN_USER_DATE,
        MAX(CASE WHEN d.DECISION = 'Cancel' THEN d.REMARKS END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.DECISION = 'Cancel' THEN d.EXITDATE END NULLS FIRST) AS LAST_CAN_REMARKS,
        MAX(CASE WHEN d.WORKSTEP = 'DetailDataEntry' AND d.EXITDATE IS NOT NULL THEN d.REMARKS END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'DetailDataEntry' THEN d.EXITDATE END NULLS FIRST)   AS LAST_REMARK_DDE,
        MAX(CASE WHEN d.WORKSTEP = 'UnderwriterMaker' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'UnderwriterMaker' THEN d.EXITDATE END NULLS FIRST)  AS UND_MAKER,
        MAX(CASE WHEN d.WORKSTEP = 'UnderwriterChecker' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'UnderwriterChecker' THEN d.EXITDATE END NULLS FIRST) AS UND_CHECKER,
        MAX(CASE WHEN d.WORKSTEP = 'PhoneVerification' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP = 'PhoneVerification' THEN d.EXITDATE END NULLS FIRST) AS PHV_USER,
        MAX(CASE WHEN d.WORKSTEP IN ('CreditCommittee','CreditApproval') AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.WORKSTEP IN ('CreditCommittee','CreditApproval')
                                               THEN d.EXITDATE END NULLS FIRST)                                     AS BI_APPROVER,
        MAX(CASE WHEN d.BI_WORKSTEP = '01.Branch' AND d.SYSTEM = 'OF' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.BI_WORKSTEP = '01.Branch' AND d.SYSTEM = 'OF'
                                               THEN d.EXITDATE END NULLS FIRST)                                     AS BRANCH_USER,
        MAX(CASE WHEN d.BI_WORKSTEP = '02.DDE' AND d.SYSTEM = 'OF' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.BI_WORKSTEP = '02.DDE' AND d.SYSTEM = 'OF'
                                               THEN d.EXITDATE END NULLS FIRST)                                     AS DDE_USER,
        MAX(CASE WHEN d.BI_WORKSTEP = '03.Data Quality check' AND d.SYSTEM = 'OF' AND d.EXITDATE IS NOT NULL THEN d.USERNAME END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.BI_WORKSTEP = '03.Data Quality check' AND d.SYSTEM = 'OF'
                                               THEN d.EXITDATE END NULLS FIRST)                                     AS QUALITY_CHECKER,
        MAX(CASE WHEN d.AK_WORK_STEP = 'UnderwriterMaker' AND d.EXITDATE IS NOT NULL THEN d.USER_MAKE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.AK_WORK_STEP = 'UnderwriterMaker' THEN d.EXITDATE END NULLS FIRST)   AS AK_UWMAKER,
        MAX(CASE WHEN d.AK_WORK_STEP = 'UnderwriterChecker' AND d.EXITDATE IS NOT NULL THEN d.USER_MAKE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.AK_WORK_STEP = 'UnderwriterChecker' THEN d.EXITDATE END NULLS FIRST) AS AK_UWCHECKER,
        MAX(CASE WHEN d.AK_WORK_STEP IN ('CreditCommittee','CreditApproval') AND d.EXITDATE IS NOT NULL THEN d.USER_MAKE END)
            KEEP (DENSE_RANK LAST ORDER BY CASE WHEN d.AK_WORK_STEP IN ('CreditCommittee','CreditApproval')
                                               THEN d.EXITDATE END NULLS FIRST)                                     AS AK_APPROVAL
    FROM EE_DET d
    GROUP BY d.WINAME
),
AUTO_CAN_ROW AS (
    SELECT
        e1.WINAME,
        MIN(CAST(e1.ENTRYDATE AS DATE)) AS AUTO_CAN_DATE
    FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e1
    WHERE e1.WORKSTEP = 'CancelRevoke'
      AND e1.USERNAME IS NULL
      AND e1.EXITDATE IS NULL
      AND e1.DECISION IS NULL
      AND EXISTS (
          SELECT 1
          FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e2
          WHERE e2.WINAME    = e1.WINAME
            AND e2.WORKSTEP  = 'BranchSupport'
            AND e2.ENTRYDATE < e1.ENTRYDATE
            AND e2.EXITDATE  IS NULL
            AND e2.DECISION  IS NULL
            AND get_business_minute(CAST(e2.ENTRYDATE AS DATE), CAST(e1.ENTRYDATE AS DATE)) >= 2400
      )
      AND NOT EXISTS (
          SELECT 1
          FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e3
          WHERE e3.WINAME    = e1.WINAME
            AND e3.DECISION  = 'Cancel'
            AND e3.ENTRYDATE <= e1.ENTRYDATE
      )
	  GROUP BY e1.WINAME
),
APP_BASE AS (
    SELECT
        l.*,
        ac_.AUTO_CAN_DATE                                                    AS AUTO_CAN_DATE
    FROM EE_LAST l
    LEFT JOIN AUTO_CAN_ROW ac_ ON l.WINAME = ac_.WINAME
),
SRC AS (
    SELECT
        a.WINAME,
        a.PROCESSED_DATE,
        a.CREATION_DATE AS CREATION_DATE,
        a.BI_APPSTATUS AS BI_APPSTATUS,
        a.LAST_WORKSTEP AS LAST_WORKSTEP,
        a.PRE_WORKSTEP AS PRE_WORKSTEP,
        a.LAST_ENTRYDATE AS LAST_ENTRYDATE,
        a.LAST_EXITDATE AS LAST_EXITDATE,
        a.LAST_REMARKS AS LAST_REMARKS,
        a.LAST_REMARK_DDE AS LAST_REMARK_DDE,
        a.LAST_DECISION AS LAST_DECISION,
        COALESCE(a.AK_UWMAKER, g.UWMAKERUSER) AS UNDERWRITERMAKER_TAKERESPON,
        COALESCE(a.AK_UWCHECKER, g.UWCHKRUSER) AS UNDERWRITERCHECKER_TAKERESPON,
        COALESCE(a.AK_APPROVAL, g.CREDAPPRUSER, g.CCOMMITUSER) AS APPROVAL_TAKERESPON,
        a.MIN_UWM AS MIN_UWM,
        a.MIN_APP AS MIN_APP,
        a.LAST_APPROVAL_DATE AS LAST_APPROVAL_DATE,
        a.CAN_USER_DATE AS CAN_USER_DATE,
        a.AUTO_CAN_DATE AS AUTO_CAN_DATE,
        CASE WHEN a.AUTO_CAN_DATE IS NOT NULL THEN 'YES' ELSE 'NO' END AS FLAG_AUTO_CAN,
        a.LAST_CAN_REMARKS AS LAST_CAN_REMARKS,
        a.BRANCH_USER AS BRANCH_USER,
        a.DDE_USER AS DDE_USER,
        a.QUALITY_CHECKER AS QUALITY_CHECKER,
        a.UND_MAKER AS UND_MAKER,
        a.UND_CHECKER AS UND_CHECKER,
        a.PHV_USER AS PHV_USER,
        a.BI_APPROVER AS BI_APPROVER
    FROM PD pd
    JOIN APP_BASE a ON a.WINAME = pd.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_EXTTABLE           g   ON a.WINAME = g.WI_NAME
),
RPT AS (
    SELECT
        WINAME,
        PROCESSED_DATE,
        CREATION_DATE,
        BI_APPSTATUS,
        LAST_WORKSTEP,
        PRE_WORKSTEP,
        LAST_ENTRYDATE,
        LAST_EXITDATE,
        LAST_REMARKS,
        LAST_REMARK_DDE,
        LAST_DECISION,
        UNDERWRITERMAKER_TAKERESPON,
        UNDERWRITERCHECKER_TAKERESPON,
        APPROVAL_TAKERESPON,
        MIN_UWM,
        MIN_APP,
        LAST_APPROVAL_DATE,
        CAN_USER_DATE,
        AUTO_CAN_DATE,
        FLAG_AUTO_CAN,
        LAST_CAN_REMARKS,
        BRANCH_USER,
        DDE_USER,
        QUALITY_CHECKER,
        UND_MAKER,
        UND_CHECKER,
        PHV_USER,
        BI_APPROVER
    FROM PDTD_DTM.RPT_RLOS_APPLICATION
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;

-- ===== CUM 2 | THONG TIN TINH  =====
WITH
PD AS (
    SELECT
        u.WINAME,
        u.PD_UT1_APPROVED,
        u.PD_UT2_CANCEL,
        u.PD_UT3_LAST_EXIT,
        COALESCE(u.PD_UT1_APPROVED, u.PD_UT2_CANCEL, u.PD_UT3_LAST_EXIT) AS PROCESSED_DATE
    FROM (
        SELECT
            e0.WINAME,
            MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                      AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                          'Send To PostSanction','Submit To DisbursementMaker')
                     THEN e0.EXITDATE END)                                 AS PD_UT1_APPROVED,
            MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                     THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)              AS PD_UT2_CANCEL,
            MAX(e0.EXITDATE)                                               AS PD_UT3_LAST_EXIT
        FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e0
        GROUP BY e0.WINAME
    ) u
),
SRC AS (
    SELECT
        a.WINAME,
        a.PROCESSED_DATE,
        o.BI_FLOW AS BI_FLOW,
        l.STREAM AS STREAM,
        g.REQ_TYPE AS CHANGE_REQUEST,
        g.CHANGE_TYPE AS CHANGE_TYPE,
        y.DETAIL_CHANGE_TYPE_NAME AS CHANGE_TYPE_DETAIL,
        CASE WHEN UPPER(c.CUS_SEGMENT) LIKE '%XANH' THEN 'XANH'
                      WHEN c.CUS_SEGMENT = 'CBNV'            THEN 'CBNV'
                      ELSE 'THUONG' END AS BI_CUS_SEGMENT,
        b.FULL_NAME AS CUSTOMER_NAME,
        (SELECT LISTAGG(u.ID_NUMBER, ';') WITHIN GROUP (ORDER BY u.ID_NUMBER)
                   FROM SBLOS2.NG_SB_RLOS_APPLICANT_IDGRID u
                  WHERE u.WI_NAME = a.WINAME AND u.ID_TYPE IN ('TCC','CC')) AS ADD_ID,
        (SELECT LISTAGG(u.ID_NUMBER, ';') WITHIN GROUP (ORDER BY u.ID_NUMBER)
                   FROM SBLOS2.NG_SB_RLOS_APPLICANT_IDGRID u
                  WHERE u.WI_NAME = a.WINAME AND u.ID_TYPE NOT IN ('TCC','CC')) AS ADD_ID_OTHER,
        ac.CUSTOMER AS CUSTOMER_ID,
        ac.DATE_OF_BIRTH AS DATE_OF_BIRTH,
        ac.GENDER AS GENDER,
        c.PERM_ADD AS PERMANENT_RESIDENCE_ADDRESS,
        s.CITY_NAME AS CURRENT_RESIDENTIAL_CITY,
        t.DISTRICT_NAME AS CURRENT_RESIDENTIAL_DISTRICT,
        c.WARD_CURR_RES AS CURRENT_RESIDENTIAL_WARD,
        c.HOUSNO_CURR_RES || ', ' || c.WARD_CURR_RES || ', ' || t.DISTRICT_NAME || ', ' || s.CITY_NAME AS CURRENT_RESIDENTIAL_ADDRESS,
        c.MARR_STATUS AS MARRIAGE_STATUS,
        c.EDU_LEVEL AS EDUCATION_LEVEL,
        c.VEHICLE AS VEHICLES,
        b.EMPLOYEE_CODE AS EMPLOYEE_CODE,
        b.EMPLOYEE_NAME AS EMPLOYEE_NAME,
        b.ZONE AS ZONE,
        b.BRACH_CODE AS BRANCH_CODE,
        b.BRANCH_NAME AS BRANCH_NAME,
        b.COMPANY_CODE AS COMPANY_CODE,
        b.COMPANY_NAME AS COMPANY_NAME,
        l.APP_GRP AS APP_GRP,
        b.PRODUCT_LINE AS PRODUCT_LINE,
        b.SUB_PRODUCT AS SUB_PRODUCT,
        b.IS_SEC_PRODUCT AS SECONDARY_PRODUCTLINE,
        b.DEVIATION_FLAG AS DEVIATION,
        b.POLICY AS POLICY,
        b.CAMPAIGN AS CAMPAIGN,
        CASE UPPER(b.PROOF_OF_INCOME) WHEN 'PROOFINCOME01' THEN 'CHUNGTU_CHUNGMINH_THUNHAP'
                                          WHEN 'PROOFINCOME02' THEN 'BANGKE_THUNHAP'
                                          ELSE b.PROOF_OF_INCOME END AS PROOF_OF_INCOME,
        SUBSTR(REGEXP_REPLACE(
                       CASE WHEN m.SALARYFLAG      = 'Yes' THEN 'Lương / '                  END
                    || CASE WHEN m.CARFLAG         = 'Yes' THEN 'Cho thuê phương tiện / '     END
                    || CASE WHEN m.HOUSEFLAG       = 'Yes' THEN 'Cho thuê nhà / '             END
                    || CASE WHEN m.ENTERPRISSEFLAG = 'Yes' THEN 'Lợi nhuận doanh nghiệp / '   END
                    || CASE WHEN m.DIVINGFLAG      = 'Yes' THEN 'Cổ tức / '                   END
                    || CASE WHEN m.FAIMILYFLAG     = 'Yes' THEN 'Kinh doanh hộ gia đình / '   END
                    || CASE WHEN m.NONLICFLAG      = 'Yes' THEN 'Kinh doanh không ĐKKD / '    END
                    || CASE WHEN m.WAGESFLAG       = 'Yes' THEN 'Tiền công / '                END
                    || CASE WHEN m.PENSIONFLAG     = 'Yes' THEN 'Lương hưu/phụ cấp / '        END
                    || CASE WHEN m.OTHERFLAG       = 'Yes' THEN 'Nguồn thu khác / '           END,
                    ' / $', ''), 1, 200) AS REPAYMENT_SOURCE,
        p.TOT_INC_CALC AS TOTAL_INCOME,
        k.LOAN_TO_VALUE AS LOAN_TO_VALUE,
        ad.K_TYPE AS K_TYPE,
        aa.DESCRIPTION AS PROMOTION_ID,
        ae.HOME_ADDRESS AS HOME_ADDRESS,
        k.LOAN_AMOUNT AS LOAN_AMOUNT,
        k.LOAN_TERM AS LOAN_TERM,
        k.CURRENT_RATE AS INTEREST_RATE,
        k.LOAN_OBJECTIVE AS LOAN_OBJECTIVE
    FROM PD a
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL  b   ON a.WINAME = b.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_DETAIL   c   ON a.WINAME = c.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_EXTTABLE           g   ON a.WINAME = g.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_CREDIT_PROPOSAL    k   ON a.WINAME = k.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPROVAL           l   ON a.WINAME = l.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_REPAYFLAGS         m   ON a.WINAME = m.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_SENT_CBS_LOG       n   ON a.WINAME = n.WI_NAME
    LEFT JOIN SBLOS2.RLOS_REF_FLOW                 o   ON l.STREAM = o.STREAM
    LEFT JOIN SBLOS2.NG_SB_RLOS_REPAY_CALC         p   ON a.WINAME = p.WI_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_MAS_CITY           s   ON c.CITY_CURR_RES = s.CITY_CODE
    LEFT JOIN SBLOS2.NG_SB_RLOS_MAS_DISTRICT       t   ON c.DISTRICT_CURR_RES = t.DISTRICT_CODE
    LEFT JOIN SBLOS2.NG_SB_RLOS_CBS                w   ON a.WINAME = w.WI_NAME
    LEFT JOIN SBLOS2.SB_RLOS_MAS_CHANGE_TYPE       y   ON g.CHANGE_TYPE = y.CHANGE_TYPE_NAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_MAS_CARD_PROMOTIO  aa  ON w.PROMOTION_ID = aa.PROMOTION_CODE
    LEFT JOIN STG_DTM.STG_DIM_CUSTOMER             ac  ON EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_APPLICANT_IDGRID u2
                                                              WHERE u2.WI_NAME = a.WINAME
                                                                AND TRIM(u2.ID_NUMBER) = TRIM(ac.LEGAL_ID)
                                                                AND TRIM(u2.ID_TYPE)   = TRIM(ac.LEGAL_DOC_NAME)) AND ac.EXP_DATE is null 
    LEFT JOIN STG_DTM.STG_DIM_CARD                 ad  ON n.RESULT_SEAB_MAIN_CARD_ID = ad.MAIN_ID
    LEFT JOIN STG_DTM.STG_DIM_SEAB_MAIN_CARD       ae  ON n.RESULT_SEAB_MAIN_CARD_ID = ae.RECID
),
RPT AS (
    SELECT
        WINAME,
        PROCESSED_DATE,
        BI_FLOW,
        STREAM,
        CHANGE_REQUEST,
        CHANGE_TYPE,
        CHANGE_TYPE_DETAIL,
        BI_CUS_SEGMENT,
        CUSTOMER_NAME,
        ADD_ID,
        ADD_ID_OTHER,
        CUSTOMER_ID,
        DATE_OF_BIRTH,
        GENDER,
        PERMANENT_RESIDENCE_ADDRESS,
        CURRENT_RESIDENTIAL_CITY,
        CURRENT_RESIDENTIAL_DISTRICT,
        CURRENT_RESIDENTIAL_WARD,
        CURRENT_RESIDENTIAL_ADDRESS,
        MARRIAGE_STATUS,
        EDUCATION_LEVEL,
        VEHICLES,
        EMPLOYEE_CODE,
        EMPLOYEE_NAME,
        ZONE,
        BRANCH_CODE,
        BRANCH_NAME,
        COMPANY_CODE,
        COMPANY_NAME,
        APP_GRP,
        PRODUCT_LINE,
        SUB_PRODUCT,
        SECONDARY_PRODUCTLINE,
        DEVIATION,
        POLICY,
        CAMPAIGN,
        PROOF_OF_INCOME,
        REPAYMENT_SOURCE,
        TOTAL_INCOME,
        LOAN_TO_VALUE,
        K_TYPE,
        PROMOTION_ID,
        HOME_ADDRESS,
        LOAN_AMOUNT,
        LOAN_TERM,
        INTEREST_RATE,
        LOAN_OBJECTIVE
    FROM PDTD_DTM.RPT_RLOS_APPLICATION
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;

-- ===== CUM 3A | TSBD =====
WITH
PD AS (
    SELECT
        u.WINAME,
        u.PD_UT1_APPROVED,
        u.PD_UT2_CANCEL,
        u.PD_UT3_LAST_EXIT,
        COALESCE(u.PD_UT1_APPROVED, u.PD_UT2_CANCEL, u.PD_UT3_LAST_EXIT) AS PROCESSED_DATE
    FROM (
        SELECT
            e0.WINAME,
            MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                      AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                          'Send To PostSanction','Submit To DisbursementMaker')
                     THEN e0.EXITDATE END)                                 AS PD_UT1_APPROVED,
            MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                     THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)              AS PD_UT2_CANCEL,
            MAX(e0.EXITDATE)                                               AS PD_UT3_LAST_EXIT
        FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e0
        GROUP BY e0.WINAME
    ) u
),
TSBD AS (
    -- (1) Bat dong san
    SELECT z.WI_NAME, z.COL_TYPE,
           h.OWNER             AS OWNERSHIP,
           h.NO_CERTI          AS GCN_REAL_ESTATE,
           NULL                AS GCN_OTHER,
           h.REL_CUSTOMER      AS TSBD_RELATIONSHIP
    FROM SBLOS2.NG_SB_RLOS_DISB_COL_GRID z
    LEFT JOIN SBLOS2.NG_SB_RLOS_COL_REALESTATE h
           ON z.WI_NAME = h.WI_NAME
          AND UPPER(z.OWNER) = UPPER(h.OWNER) AND UPPER(z.RELATION) = UPPER(h.REL_CUSTOMER)
    WHERE UPPER(z.COL_TYPE) = 'REALSTATE'
    UNION ALL
    -- (2) Phuong tien van tai
    SELECT z.WI_NAME, z.COL_TYPE,
           NULL, NULL,
           j1.CERTIFICATENO,
           q.RELATION_CUSTOMER
    FROM SBLOS2.NG_SB_RLOS_DISB_COL_GRID z
    LEFT JOIN SBLOS2.NG_SB_RLOS_COL_TRANSPORT q
           ON z.WI_NAME = q.WI_NAME
          AND UPPER(z.OWNER) = UPPER(q.OWNER) AND UPPER(z.RELATION) = UPPER(q.RELATION_CUSTOMER)
    LEFT JOIN SBLOS2.NG_SB_RLOS_COLL_CERTIGRD j1
           ON q.WI_NAME = j1.WI_NAME
          AND UPPER(q.OWNER) = UPPER(j1.OWNER) AND UPPER(q.RELATION_CUSTOMER) = UPPER(j1.RELATIONSHIP)
    WHERE UPPER(z.COL_TYPE) = 'TRANSPORT'
    UNION ALL
    -- (3) Giay to co gia
    SELECT z.WI_NAME, z.COL_TYPE,
           NULL, NULL,
           COALESCE(r.NUMBERSIGN, j2.CERTIFICATENO),
           r.RELATION_CUSTOMER
    FROM SBLOS2.NG_SB_RLOS_DISB_COL_GRID z
    LEFT JOIN SBLOS2.NG_SB_RLOS_COL_VALPAPER r
           ON z.WI_NAME = r.WI_NAME
          AND UPPER(z.OWNER) = UPPER(r.OWNER) AND UPPER(z.RELATION) = UPPER(r.RELATION_CUSTOMER)
    LEFT JOIN SBLOS2.NG_SB_RLOS_COLL_CERTIGRD j2
           ON r.WI_NAME = j2.WI_NAME
          AND UPPER(r.OWNER) = UPPER(j2.OWNER) AND UPPER(r.RELATION_CUSTOMER) = UPPER(j2.RELATIONSHIP)
    WHERE UPPER(z.COL_TYPE) = 'VALPAPER'
    UNION ALL
    -- (4) Tai san khac
    SELECT z.WI_NAME, z.COL_TYPE,
           NULL, NULL, NULL,
           i.RELATION_CUSTOMER
    FROM SBLOS2.NG_SB_RLOS_DISB_COL_GRID z
    LEFT JOIN SBLOS2.NG_SB_RLOS_COL_OTHER i
           ON z.WI_NAME = i.WI_NAME
          AND UPPER(z.OWNER) = UPPER(i.OWNER) AND UPPER(z.RELATION) = UPPER(i.RELATION_CUSTOMER)
    WHERE UPPER(z.COL_TYPE) = 'OTHER'
),
TSBD_FLAG AS (      -- co TSBD theo HO SO: YES neu co it nhat 1 dong dung loai
    SELECT z.WI_NAME,
           CASE WHEN MAX(CASE WHEN UPPER(z.COL_TYPE) = 'REALSTATE' THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSBD_BDS,
           CASE WHEN MAX(CASE WHEN UPPER(z.COL_TYPE) = 'TRANSPORT' THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSBD_PTVT,
           CASE WHEN MAX(CASE WHEN UPPER(z.COL_TYPE) = 'VALPAPER'  THEN 1 END) = 1 THEN 'YES' ELSE 'NO' END AS TSBD_GTCG
    FROM SBLOS2.NG_SB_RLOS_DISB_COL_GRID z
    GROUP BY z.WI_NAME
),
SRC AS (
    SELECT
        a.WINAME,
        a.PROCESSED_DATE,
        t.OWNERSHIP,
        NVL(fl.TSBD_BDS,  'NO') AS TSBD_BDS,     -- co theo HO SO
        NVL(fl.TSBD_PTVT, 'NO') AS TSBD_PTVT,
        NVL(fl.TSBD_GTCG, 'NO') AS TSBD_GTCG,
        t.GCN_REAL_ESTATE,
        t.GCN_OTHER,
        t.TSBD_RELATIONSHIP
    FROM PD a
    LEFT JOIN TSBD      t  ON a.WINAME = t.WI_NAME
    LEFT JOIN TSBD_FLAG fl ON a.WINAME = fl.WI_NAME
),
RPT AS (
    SELECT
        WINAME,
        PROCESSED_DATE,
        OWNERSHIP,
        TSBD_BDS,
        TSBD_PTVT,
        TSBD_GTCG,
        GCN_REAL_ESTATE,
        GCN_OTHER,
        TSBD_RELATIONSHIP
    FROM PDTD_DTM.RPT_RLOS_APPLICATION
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;

-- ===== CUM 3B | NGUOI DONG TRA NO =====
WITH
PD AS (
    SELECT
        u.WINAME,
        u.PD_UT1_APPROVED,
        u.PD_UT2_CANCEL,
        u.PD_UT3_LAST_EXIT,
        COALESCE(u.PD_UT1_APPROVED, u.PD_UT2_CANCEL, u.PD_UT3_LAST_EXIT) AS PROCESSED_DATE
    FROM (
        SELECT
            e0.WINAME,
            MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                      AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                          'Send To PostSanction','Submit To DisbursementMaker')
                     THEN e0.EXITDATE END)                                 AS PD_UT1_APPROVED,
            MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                     THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)              AS PD_UT2_CANCEL,
            MAX(e0.EXITDATE)                                               AS PD_UT3_LAST_EXIT
        FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e0
        GROUP BY e0.WINAME
    ) u
),
SRC AS (
    SELECT
        a.WINAME,
        a.PROCESSED_DATE,
        d.FULL_NAME AS CO_REPAYER,
        (SELECT LISTAGG(e.ID_NUMBER, ';') WITHIN GROUP (ORDER BY e.ID_NUMBER)
                   FROM SBLOS2.NG_SB_RLOS_COREP_IDGRID e
                  WHERE e.WI_NAME = d.WI_NAME AND e.PIN = d.ID_NO_CO
                    AND e.ID_TYPE IN ('TCC','CC')) AS ADD_ID_COREPAYER,
        (SELECT LISTAGG(e.ID_NUMBER, ';') WITHIN GROUP (ORDER BY e.ID_NUMBER)
                   FROM SBLOS2.NG_SB_RLOS_COREP_IDGRID e
                  WHERE e.WI_NAME = d.WI_NAME AND e.PIN = d.ID_NO_CO
                    AND e.ID_TYPE NOT IN ('TCC','CC')) AS ADD_ID_OTHER_COREPAYER
    FROM PD a
    LEFT JOIN SBLOS2.NG_SB_RLOS_COREPAYER_GENERAL  d   ON a.WINAME = d.WI_NAME
),
RPT AS (
    SELECT
        WINAME,
        PROCESSED_DATE,
        CO_REPAYER,
        ADD_ID_COREPAYER,
        ADD_ID_OTHER_COREPAYER
    FROM PDTD_DTM.RPT_RLOS_APPLICATION
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;

-- ===== CUM 3C | SAN PHAM PHU =====
WITH
PD AS (
    SELECT
        u.WINAME,
        u.PD_UT1_APPROVED,
        u.PD_UT2_CANCEL,
        u.PD_UT3_LAST_EXIT,
        COALESCE(u.PD_UT1_APPROVED, u.PD_UT2_CANCEL, u.PD_UT3_LAST_EXIT) AS PROCESSED_DATE
    FROM (
        SELECT
            e0.WINAME,
            MAX(CASE WHEN e0.WORKSTEP IN ('CreditCommittee','CreditApproval')
                      AND e0.DECISION IN ('Send To HOSupport','Reject','Submit',
                                          'Send To PostSanction','Submit To DisbursementMaker')
                     THEN e0.EXITDATE END)                                 AS PD_UT1_APPROVED,
            MAX(CASE WHEN e0.WORKSTEP = 'CancelRevoke'
                     THEN NVL(e0.EXITDATE, e0.ENTRYDATE) END)              AS PD_UT2_CANCEL,
            MAX(e0.EXITDATE)                                               AS PD_UT3_LAST_EXIT
        FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT e0
        GROUP BY e0.WINAME
    ) u
),
SRC AS (
    SELECT
        a.WINAME,
        a.PROCESSED_DATE,
        f.SUB_PRODUCT_LINE AS SAN_PHAM_PHU,
        (SELECT VAL FROM (
                     SELECT af.LIMIT_NO AS VAL FROM SBLOS2.NG_SB_RLOS_CREDIT_CARD_APP af WHERE af.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = N'Thẻ tín dụng'
                     UNION ALL
                     SELECT ag.LIMIT_NO FROM SBLOS2.NG_SB_RLOS_SEABUY_APP  ag WHERE ag.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeABuy'
                     UNION ALL
                     SELECT ah.LIMIT_NO FROM SBLOS2.NG_SB_RLOS_CIVIL_APP   ah WHERE ah.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeACivil'
                     UNION ALL
                     SELECT ai.LIMIT_NO FROM SBLOS2.NG_SB_RLOS_TEACHER_APP ai WHERE ai.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeATeacher'
                     UNION ALL
                     SELECT aj.LIMIT_NO FROM SBLOS2.NG_SB_RLOS_WOMAN_APP   aj WHERE aj.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeAWoman'
                 ) WHERE ROWNUM = 1) AS SPP_AMOUNT,
        (SELECT VAL FROM (
                     SELECT af.TERM AS VAL FROM SBLOS2.NG_SB_RLOS_CREDIT_CARD_APP af WHERE af.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = N'Thẻ tín dụng'
                     UNION ALL
                     SELECT ag.TIME_VALID FROM SBLOS2.NG_SB_RLOS_SEABUY_APP  ag WHERE ag.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeABuy'
                     UNION ALL
                     SELECT ah.TIME_VALID FROM SBLOS2.NG_SB_RLOS_CIVIL_APP   ah WHERE ah.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeACivil'
                     UNION ALL
                     SELECT ai.TIME_VALID FROM SBLOS2.NG_SB_RLOS_TEACHER_APP ai WHERE ai.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeATeacher'
                     UNION ALL
                     SELECT aj.TIME_VALID FROM SBLOS2.NG_SB_RLOS_WOMAN_APP   aj WHERE aj.WI_NAME = f.WI_NAME AND f.SUB_PRODUCT_LINE = 'SeAWoman'
                 ) WHERE ROWNUM = 1) AS SPP_TERM
    FROM PD a
    LEFT JOIN SBLOS2.NG_SB_RLOS_SUB_PRODUCT        f   ON a.WINAME = f.WI_NAME
),
RPT AS (
    SELECT
        WINAME,
        PROCESSED_DATE,
        SAN_PHAM_PHU,
        SPP_AMOUNT,
        SPP_TERM
    FROM PDTD_DTM.RPT_RLOS_APPLICATION
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM RPT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM RPT MINUS SELECT * FROM SRC) y;
