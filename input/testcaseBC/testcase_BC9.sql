--RLOS 
WITH PD AS(
SELECT B.WINAME AS WI_NAME,
	COALESCE(
		MAX(CASE WHEN B.WORKSTEP IN ('CreditCommittee', 'CreditApproval')
		          AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject')
		         THEN B.EXITDATE END),
		MIN(CASE WHEN B.WORKSTEP = 'CancelRevoke' THEN NVL(B.EXITDATE, B.ENTRYDATE) END),
		MAX(B.EXITDATE)
	) AS PROCESSED_DATE
FROM SBLOS2.NG_SB_RLOS_EXTTABLE A
INNER JOIN SBLOS2.NG_SB_RLOS_ENTRY_EXIT B ON A.WI_NAME = B.WINAME
	AND ((B.WORKSTEP IN ('CreditCommittee', 'CreditApproval')
		AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject'))
	OR B.WORKSTEP IN ('CancelRevoke','CancelPermanent'))
GROUP BY B.WINAME
),
BASE AS(
SELECT A.WI_NAME AS WI_NAME,
A.PRODUCT_NAME AS PRODUCT_NAME,
A.CHANGE_TYPE AS CHANGE_TYPE,
MAX(CASE
	WHEN B.WORKSTEP IN ('CreditCommittee', 'CreditApproval') AND B.DECISION IN ('Submit', 'Send To PostSanction', 'Submit To DisbursementMaker', 'Send To HOSupport', 'Reject') THEN 1.0
	WHEN B.WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN
		CASE
			WHEN EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT BE WHERE BE.WINAME = A.WI_NAME AND BE.WORKSTEP = 'CreditApproval')     THEN 0.8
			WHEN EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT BE WHERE BE.WINAME = A.WI_NAME AND BE.WORKSTEP = 'UnderwriterChecker') THEN 0.6
			WHEN EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT BE WHERE BE.WINAME = A.WI_NAME AND BE.WORKSTEP = 'UnderwriterMaker')   THEN 0.5
			WHEN EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT BE WHERE BE.WINAME = A.WI_NAME AND BE.WORKSTEP = 'DetailDataEntry')    THEN 0.2
			ELSE NULL
		END
	ELSE NULL
END) AS VOLUME
FROM SBLOS2.NG_SB_RLOS_EXTTABLE A
INNER JOIN SBLOS2.NG_SB_RLOS_ENTRY_EXIT B ON A.WI_NAME = B.WINAME
	AND ((B.WORKSTEP IN ('CreditCommittee', 'CreditApproval')
		AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject'))
	OR B.WORKSTEP IN ('CancelRevoke','CancelPermanent'))
GROUP BY A.WI_NAME, A.PRODUCT_NAME, A.CHANGE_TYPE
),
TSDB_FLAG AS(
SELECT WI_NAME, COUNT(1) AS COUNT_TSDB
FROM(
	SELECT WI_NAME FROM SBLOS2.NG_SB_RLOS_COL_OTHER
	UNION ALL
	SELECT WI_NAME FROM SBLOS2.NG_SB_RLOS_COL_REALESTATE
	UNION ALL
	SELECT WI_NAME FROM SBLOS2.NG_SB_RLOS_COL_TRANSPORT
	UNION ALL
	SELECT WI_NAME FROM SBLOS2.NG_SB_RLOS_COL_VALPAPER
	)
GROUP BY WI_NAME
),
DEVIATION_CNT AS(
SELECT WI_NAME, COUNT(1) AS SL_CONDITION
FROM SBLOS2.NG_SB_RLOS_MANUAL_DEVIATION
GROUP BY WI_NAME
),
SRC AS(
SELECT BASE.WI_NAME AS WI_NAME,
	TRUNC(PD.PROCESSED_DATE) AS PROCESSED_DATE,
	BASE.VOLUME AS VOLUME,
	-- POINT = file2.SLA_DE_TOTAL_RESULT + file1.SLA_CREDIT_OFFICER + file1.SLA_CREDIT_APPROVER
	ROUND(FILE2.SLA_DE_TOTAL_RESULT + FILE1.SLA_CREDIT_OFFICER + FILE1.SLA_CREDIT_APPROVER, 2) AS POINT,
	-- QUY_DOI = POINT/(8*VOLUME) (VOLUME NULL -> NULL)
	ROUND(CASE WHEN BASE.VOLUME IS NOT NULL
		THEN (FILE2.SLA_DE_TOTAL_RESULT + FILE1.SLA_CREDIT_OFFICER + FILE1.SLA_CREDIT_APPROVER) / (BASE.VOLUME*8) END, 2) AS QUY_DOI,
	CASE WHEN NVL(TS.COUNT_TSDB, 0) >= 2 THEN 'YES' ELSE 'NO' END AS TSBD_G2,   
	CASE WHEN(
		(CASE WHEN UPPER(G.SALARYFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.CARFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.HOUSEFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.ENTERPRISSEFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.DIVINGFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.FAIMILYFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.NONLICFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.WAGESFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.PENSIONFLAG) = 'YES' THEN 1 ELSE 0 END) +
		(CASE WHEN UPPER(G.OTHERFLAG) = 'YES' THEN 1 ELSE 0 END)
	   ) >= 3 THEN 'YES' ELSE 'NO' END AS INCOM_3,
	CASE WHEN (UPPER(BASE.PRODUCT_NAME) NOT LIKE '%SEAPRO%'
				AND UPPER(BASE.PRODUCT_NAME) NOT LIKE '%SEALAND%'
				AND (UPPER(NVL(G.FAIMILYFLAG, 'NO')) = 'YES'
				  OR UPPER(NVL(G.ENTERPRISSEFLAG, 'NO')) = 'YES'
				  OR UPPER(NVL(G.NONLICFLAG, 'NO')) = 'YES')
	   ) THEN 'YES' ELSE 'NO' END AS BUSINESS_INCOM,
	CASE WHEN NVL(DV.SL_CONDITION,0) = 2 THEN 'YES' ELSE 'NO' END AS DEVIATION_G2,
	CASE WHEN NVL(DV.SL_CONDITION,0) >= 3 THEN 'YES' ELSE 'NO' END AS DEVIATION_G3
FROM BASE
INNER JOIN PD ON BASE.WI_NAME = PD.WI_NAME
LEFT JOIN SBLOS2.NG_SB_RLOS_REPAYFLAGS G ON BASE.WI_NAME = G.WI_NAME
LEFT JOIN TSDB_FLAG TS ON BASE.WI_NAME = TS.WI_NAME
LEFT JOIN DEVIATION_CNT DV ON BASE.WI_NAME = DV.WI_NAME
LEFT JOIN SBLOS2.NG_SB_RLOS_APPROVAL I ON BASE.WI_NAME = I.WI_NAME
LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL J ON BASE.WI_NAME = J.WI_NAME
-- BC5TAT - sheet cam ket SLA TDKHCN (file1)
LEFT JOIN PDTD_DTM.RLOS_REF_SLA_TDKHCN FILE1
	-- 1. APP_GRP: file luu theo nhom -> gan nhan tu I.APP_GRP (giong BC5)
	ON FILE1.APP_GRP = CASE WHEN I.APP_GRP IN ('B1', 'B2', 'C1', 'C2', 'C3') THEN N'CGPD cấp B,C (B1, B2, C1, C2, C3)'
						WHEN I.APP_GRP IN ('A1', 'A2') THEN N'CGPD cấp A (A1, A2)'
						WHEN I.APP_GRP IN ('BOD', 'CC', 'SCC', 'RCC') THEN N'BOD/ CC/ SCC/ RCC' END
	-- 2. Product Line: 'Truong Change Request' -> xet CHANGE_TYPE, nguoc lai xet PRODUCT_LINE
	AND ((FILE1.PRODUCT_LINE = N'Trường Change Request' AND FILE1.CHANGE_TYPE = BASE.CHANGE_TYPE)
		OR (FILE1.PRODUCT_LINE <> N'Trường Change Request' AND FILE1.PRODUCT_LINE = J.PRODUCT_LINE))
	-- 3. DEVIATION_G3 (NULL tren file -> khong xet)
	AND (FILE1.DEVIATION_G3 IS NULL
		OR FILE1.DEVIATION_G3 = CASE WHEN NVL(DV.SL_CONDITION, 0) >= 3 THEN 'YES' ELSE 'NO' END)
	-- 4. SECONDARY_PRODUCTLINE (NULL tren file -> khong xet)
	AND (FILE1.SECONDARY_PRODUCTLINE IS NULL
		OR FILE1.SECONDARY_PRODUCTLINE = CASE J.IS_SEC_PRODUCT WHEN N'Không' THEN 'NO' WHEN N'Có' THEN 'YES' END)
-- BC5TAT - sheet cam ket SLA NLTT - RLOS (file2)
LEFT JOIN PDTD_DTM.REF_SLA_NLTT FILE2
	ON FILE2.SYSTEMNAME = 'RLOS'
	AND FILE2.PRODUCT_LINE = J.PRODUCT_LINE
),
TBL AS(
	SELECT WI_NAME, PROCESSED_DATE, VOLUME, POINT, QUY_DOI, TSBD_G2, INCOM_3, BUSINESS_INCOM, DEVIATION_G2, DEVIATION_G3
	FROM PDTD_DTM.BC9 where WI_NAME like '%RLOS%'
)
SELECT * FROM SRC MINUS SELECT * FROM TBL

--CLOS 
WITH PD AS(
SELECT B.WINAME AS WI_NAME,
	COALESCE(
		MAX(CASE WHEN B.WORKSTEP IN ('CreditCommittee', 'CreditApproval')
		          AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject')
		         THEN B.EXITDATE END),
		MIN(CASE WHEN B.WORKSTEP = 'CancelRevoke' THEN NVL(B.EXITDATE, B.ENTRYDATE) END),
		MAX(B.EXITDATE)
	) AS PROCESSED_DATE
FROM SBLOS2.NG_SB_CLOS_EXTTABLE A
INNER JOIN SBLOS2.NG_SB_CLOS_ENTRY_EXIT B ON A.WI_NAME = B.WINAME
	AND ((B.WORKSTEP IN ('CreditCommittee', 'CreditApproval')
		AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject'))
	OR B.WORKSTEP IN ('CancelRevoke','CancelPermanent'))
GROUP BY B.WINAME
),
BASE AS(
SELECT A.WI_NAME AS WI_NAME,
MAX(CASE 
		WHEN B.WORKSTEP IN ('CreditCommittee', 'CreditApproval') AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject') THEN 1.0
		WHEN B.WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN
			CASE 
				WHEN EXISTS(SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT BE WHERE BE.WINAME = B.WINAME AND BE.WORKSTEP =  'CreditApproval') THEN 0.8
				WHEN EXISTS(SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT BE WHERE BE.WINAME = B.WINAME AND BE.WORKSTEP = 'UnderwriterChecker') THEN 0.6
				WHEN EXISTS(SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT BE WHERE BE.WINAME = B.WINAME AND BE.WORKSTEP = 'UnderwriterMaker') THEN 0.5
				WHEN EXISTS(SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT BE WHERE BE.WINAME = B.WINAME AND BE.WORKSTEP = 'DetailDataEntry') THEN 0.2
				ELSE NULL
			END
		ELSE NULL
	END) AS VOLUME
FROM SBLOS2.NG_SB_CLOS_EXTTABLE A
INNER JOIN SBLOS2.NG_SB_CLOS_ENTRY_EXIT B ON A.WI_NAME = B.WINAME
	AND ((B.WORKSTEP IN ('CreditCommittee', 'CreditApproval')
		AND B.DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport', 'Reject'))
	OR B.WORKSTEP IN ('CancelRevoke','CancelPermanent'))
GROUP BY A.WI_NAME
),
SRC AS(
SELECT BASE.WI_NAME AS WI_NAME,
	TRUNC(PD.PROCESSED_DATE) AS PROCESSED_DATE,
	BASE.VOLUME AS VOLUME,
	ROUND(PT.POINT, 2) AS POINT,
	ROUND(CASE WHEN BASE.VOLUME IS NOT NULL THEN PT.POINT  / (BASE.VOLUME*8) END, 2) AS QUY_DOI
FROM BASE
INNER JOIN PD ON BASE.WI_NAME = PD.WI_NAME
LEFT JOIN (
	SELECT BASE.WI_NAME,
		-- APP_GRP = 'C1' -> file3 + 4.00; con lai file3 + NVL(file1, file2) CO + CA
		CASE WHEN E.APP_GRP = 'C1' THEN FILE3.SLA_DE_TOTAL_RESULT + 4.00
			ELSE FILE3.SLA_DE_TOTAL_RESULT
				+ NVL(FILE1.SLA_CREDIT_OFFICER, FILE2.SLA_CREDIT_OFFICER)
				+ NVL(FILE1.SLA_CREDIT_APPROVER, FILE2.SLA_CREDIT_APPROVER)
		END AS POINT
	FROM BASE
	LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO C ON BASE.WI_NAME = C.WI_NAME
	LEFT JOIN SBLOS2.NG_SB_CLOS_MAS_PRO_LINE D ON C.PRODUCT_LINE = D.PRODUCT_LINE_CODE
	LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL E ON BASE.WI_NAME = E.WI_NAME
	LEFT JOIN SBLOS2.NG_SB_CLOS_CREDITINFO_COMM F ON BASE.WI_NAME = F.WI_NAME
	LEFT JOIN SBLOS2.NG_SB_CLOS_CHANGEREQ G ON BASE.WI_NAME = G.WI_NAME
	-- BC5TAT - sheet cam ket SLA TDKHDN luong 2 (file1)
	LEFT JOIN PDTD_DTM.CLOS_REF_SLA_TDKHDN_2 FILE1
		ON C.CUST_GROUP IN ('MSME', 'SME', 'USME')
		AND FILE1.FLAG_APP_GRP = CASE WHEN E.APP_GRP IN ('A1', 'A2', 'B1', 'B2') THEN 'CGPD'
									WHEN E.APP_GRP IN ('BOD', 'CC', 'SCC', 'RCC') THEN 'HDTD' END
		AND FILE1.HAVE_ANY_DEVIATION = F.HAVE_ANY_DEVIATION
		AND FILE1.PRODUCT_LINE = CASE WHEN G.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request' ELSE D.PRODUCT_LINE_NAME END
		AND (FILE1.SUB_PRODUCT IS NULL OR FILE1.SUB_PRODUCT = C.SUB_PRODUCT)
	-- BC5TAT - sheet cam ket SLA TDKHDNL (file2)
	LEFT JOIN PDTD_DTM.CLOS_REF_SLA_TDKHDNL FILE2
		ON C.CUST_GROUP IN ('NBFI', 'JSC', 'FDI', 'BANK', 'STR', 'SOC')
		AND FILE2.FLAG_APP_GRP = CASE WHEN E.APP_GRP IN ('A1', 'A2', 'B1', 'B2') THEN 'CGPD'
									WHEN E.APP_GRP IN ('BOD', 'CC', 'SCC', 'RCC') THEN 'HDTD' END
		AND FILE2.HAVE_ANY_DEVIATION = F.HAVE_ANY_DEVIATION
		AND FILE2.PRODUCT_LINE = CASE WHEN G.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request' ELSE D.PRODUCT_LINE_NAME END
		AND (FILE2.SUB_PRODUCT IS NULL OR FILE2.SUB_PRODUCT = C.SUB_PRODUCT)
	-- BC5TAT - sheet cam ket SLA NLTT - CLOS (file3). CHANGE_REQUEST NULL -> khong map 
	LEFT JOIN PDTD_DTM.REF_SLA_NLTT FILE3
		ON FILE3.SYSTEMNAME = 'CLOS'
		AND FILE3.NEW_CHANGE_REQUEST = G.CHANGE_REQUEST
		AND FILE3.PRODUCT_LINE = D.PRODUCT_LINE_NAME
		AND (FILE3.SUB_PRODUCT IS NULL OR FILE3.SUB_PRODUCT = C.SUB_PRODUCT)
) PT ON BASE.WI_NAME = PT.WI_NAME
),
TBL AS(
SELECT WI_NAME, PROCESSED_DATE, VOLUME, POINT, QUY_DOI
FROM PDTD_DTM.BC9 where WI_NAME like '%CLOS%'
)
SELECT * FROM SRC MINUS SELECT * FROM TBL

--check KPI 

"WITH -- TAT | HO SO + NAM
-- [TAT_RLOS_HS] CUM RLOS - 1 dong / ho so: PROCESSED_DATE, trang thai, thong tin ho so.
TAT_RLOS_HS AS (
    SELECT x.*,
           b.PRODUCT_NAME, b.COMPANY_CODE, e.SUB_PRODUCT, e.COLLREQUIRE, f.BI_FLOW
    FROM  (SELECT WINAME,
                  -- PROCESSED_DATE: UT1 ngay phe duyet / tu choi cuoi > UT2 ngay CancelRevoke > UT3 Max(EXITDATE)
                  COALESCE(MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN EXITDATE END),
                           MIN(CASE WHEN WORKSTEP = 'CancelRevoke' THEN NVL(EXITDATE, ENTRYDATE) END),
                           MAX(EXITDATE))                                                           AS PROCESSED_DATE,
                  -- Trang thai ho so (BI_APPSTATUS)
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN 1 ELSE 0 END)   AS IS_PD_TC,     -- Approved / Rejected
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')  THEN 1 ELSE 0 END)   AS IS_APPROVED,  -- Approved
                  MAX(CASE WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 1 ELSE 0 END) AS IS_CANCEL,    -- Cancelled
                  MIN(ENTRYDATE)                                                                  AS NGAY_PHAT_SINH  -- ngay ho so phat sinh
           FROM   SBLOS2.NG_SB_RLOS_ENTRY_EXIT
           GROUP  BY WINAME
          ) x
    JOIN      SBLOS2.NG_SB_RLOS_EXTTABLE          b ON b.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL e ON e.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPROVAL          c ON c.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.RLOS_REF_FLOW                f ON f.STREAM  = c.STREAM
    WHERE  1 = 1
    AND    x.NGAY_PHAT_SINH >= DATE '2021-01-01'                                     --Ho so phat sinh tu 01/01/2021
    AND    NOT EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT t                --Loai ho so co tai khoan test
                       WHERE  t.WINAME = x.WINAME AND t.USERNAME IN ('hanh.nh2','hai.bt2'))
),
-- [TAT_CLOS_HS] CUM CLOS - 1 dong / ho so: PROCESSED_DATE, trang thai, thong tin ho so.
TAT_CLOS_HS AS (
    SELECT x.*,
           b.STREAM
    FROM  (SELECT WINAME,
                  -- PROCESSED_DATE: UT1 ngay phe duyet / tu choi cuoi > UT2 ngay CancelRevoke > UT3 Max(EXITDATE)
                  COALESCE(MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN EXITDATE END),
                           MIN(CASE WHEN WORKSTEP = 'CancelRevoke' THEN NVL(EXITDATE, ENTRYDATE) END),
                           MAX(EXITDATE))                                                           AS PROCESSED_DATE,
                  -- Trang thai ho so (BI_APPSTATUS)
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN 1 ELSE 0 END)   AS IS_PD_TC,     -- Approved / Rejected
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')  THEN 1 ELSE 0 END)   AS IS_APPROVED,  -- Approved
                  MAX(CASE WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 1 ELSE 0 END) AS IS_CANCEL,    -- Cancelled
                  MIN(ENTRYDATE)                                                                  AS NGAY_PHAT_SINH  -- ngay ho so phat sinh
           FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT
           GROUP  BY WINAME
          ) x
    LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL  b ON b.WI_NAME = x.WINAME
    WHERE  1 = 1
    AND    x.NGAY_PHAT_SINH >= DATE '2021-01-01'                                     --  Ho so phat sinh tu 01/01/2021
    AND    NOT EXISTS (SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT t                --  Loai ho so co tai khoan test
                       WHERE  t.WINAME = x.WINAME AND t.USERNAME IN ('hanh.nh2','hai.bt2'))
),
-- [TAT_DS_NAM] Danh sach nam 
TAT_DS_NAM (NAM) AS (
    SELECT 2018 FROM DUAL                                                -- [NAM_DAU]
    UNION ALL
    SELECT NAM + 1 FROM TAT_DS_NAM
    WHERE  NAM + 1 <= EXTRACT(YEAR FROM TRUNC(SYSDATE) - 1)
),
-- [TAT_NAM] Khung nam:
--   Nam qua khu : tu 01/01 den 31/12
--   Nam hien tai: tu 01/01 den ngay du lieu T-1
TAT_NAM AS (
    SELECT NAM, TU_NGAY, DEN_NGAY,
           N'Ngày ' || TO_CHAR(DEN_NGAY, 'DD') || N' tháng ' || TO_CHAR(DEN_NGAY, 'MM')   AS YEAR_MONTH
    FROM  (SELECT NAM,
                  TO_DATE(NAM || '0101', 'YYYYMMDD')                     AS TU_NGAY,
                  LEAST(TO_DATE(NAM || '1231', 'YYYYMMDD'),
                        TRUNC(SYSDATE) - 1)                              AS DEN_NGAY   -- nam qua khu 31/12, nam hien tai T-1
           FROM   TAT_DS_NAM)
),
-- =============================================================================================
-- TAT | CHI TIEU
-- =============================================================================================
-- [TAT_RLOS] TAT_RLOS / nam = (AVG TAT nhom UNSEC + AVG TAT nhom SEC) / 2
--   TAT ho so = tong gio lam viec cac buoc DDE, DataInputerChecker, UWMaker, UWChecker, CreditApproval,
--               chi tinh cac buoc den lan phe duyet / tu choi dau
--   Loc: da phe duyet / tu choi; BI_FLOW IN ('BL','KHCN_HO')
TAT_RLOS AS (
    SELECT y.NAM,
           (AVG(CASE WHEN t.FLAG = 'UNSEC' THEN t.TAT END)
          + AVG(CASE WHEN t.FLAG = 'SEC'   THEN t.TAT END)) / 2                                  AS TAT_RLOS
    FROM   TAT_NAM y
    LEFT JOIN (SELECT h.WINAME, h.PROCESSED_DATE,
                      -- Phan nhom: Nhom 1 UNSEC, Nhom 2 SEC 
                      CASE WHEN (NVL(CASE WHEN h.SUB_PRODUCT LIKE N'%Phát hành%' OR h.SUB_PRODUCT LIKE '%TTD%' THEN 'Credit Card' ELSE h.SUB_PRODUCT END, 'XX') = 'Credit Card' AND h.COLLREQUIRE = 'FALSE')
                             OR h.PRODUCT_NAME IN ('SeABuyHuutri','SeACivil','SeAHome-Buy','SeAHome-Fast',
                                                   'SeAHome-Woman','SeAHome-Teacher','SeAFast_KTSBD_KD')
                             OR (h.PRODUCT_NAME = 'SeAHome-Pro' AND h.COLLREQUIRE = 'FALSE')
                           THEN 'UNSEC' ELSE 'SEC' END                                            AS FLAG,
                      NVL(SUM(CASE WHEN a.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                                                       'UnderwriterChecker','CreditApproval')
                                   THEN get_business_minute(CAST(a.ENTRYDATE AS DATE), CAST(a.EXITDATE AS DATE)) / 60 END), 0) AS TAT
               FROM   TAT_RLOS_HS h
               JOIN   (SELECT e.*,
                          MIN(CASE WHEN e.WORKSTEP IN ('CreditApproval','CreditCommittee') AND e.DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN e.EXITDATE END)
                              OVER (PARTITION BY e.WINAME)                                AS T1      -- lan phe duyet / tu choi dau
                   FROM   SBLOS2.NG_SB_RLOS_ENTRY_EXIT e) a
                      ON a.WINAME = h.WINAME AND a.EXITDATE <= NVL(a.T1, SYSDATE)        -- chi lan phe duyet dau
               WHERE  h.IS_PD_TC = 1                                                     -- da phe duyet / tu choi
               AND    h.BI_FLOW IN ('BL','KHCN_HO')                                      -- pham vi luong
               GROUP  BY h.WINAME, h.PROCESSED_DATE, h.SUB_PRODUCT, h.COLLREQUIRE, h.PRODUCT_NAME) t
           ON TRUNC(t.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY
    GROUP  BY y.NAM
),
-- [TAT_CLOS] TAT_CLOS / nam = AVG(TAT)
--  TAT ho so = tong gio lam viec cac buoc (CLOS_)DetailDataEntry, (CLOS_)DataInputerChecker, UWMaker, UWChecker,
--   CreditApproval, CreditCommittee; chi tinh cac buoc den lan phe duyet / tu choi dau
--  Loc: da phe duyet / tu choi; STREAM = 'Phe duyet tin dung'
TAT_CLOS AS (
    SELECT y.NAM, AVG(t.TAT) AS TAT_CLOS
    FROM   TAT_NAM y
    LEFT JOIN (SELECT h.WINAME, h.PROCESSED_DATE,
                      NVL(SUM(CASE WHEN a.WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry','DataInputerChecker',
                                                       'CLOS_DataInputerChecker','UnderwriterMaker','UnderwriterChecker',
                                                       'CreditApproval','CreditCommittee')
                                   THEN get_business_minute(CAST(a.ENTRYDATE AS DATE), CAST(a.EXITDATE AS DATE)) / 60 END), 0) AS TAT
               FROM   TAT_CLOS_HS h
               JOIN   (SELECT e.*,
                          MIN(CASE WHEN e.WORKSTEP IN ('CreditApproval','CreditCommittee') AND e.DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN e.EXITDATE END)
                              OVER (PARTITION BY e.WINAME)                                AS T1      -- lan phe duyet / tu choi dau
                   FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT e) a
                      ON a.WINAME = h.WINAME AND a.EXITDATE <= NVL(a.T1, SYSDATE)        -- chi lan phe duyet dau
               WHERE  h.IS_PD_TC = 1                                                     -- da phe duyet / tu choi
               AND    h.STREAM = N'Phê duyệt tín dụng'
               GROUP  BY h.WINAME, h.PROCESSED_DATE) t
           ON TRUNC(t.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY
    GROUP  BY y.NAM
),
-- MINUS
-- [TAT_SRC] Nguon; TAT_TB = (TAT_RLOS + TAT_CLOS) / 2 
TAT_SRC AS (
    SELECT y.NAM, y.YEAR_MONTH,
           ROUND(r.TAT_RLOS, 2)                      AS TAT_RLOS,
           ROUND(c.TAT_CLOS, 2)                      AS TAT_CLOS,
           ROUND((r.TAT_RLOS + c.TAT_CLOS) / 2, 2)   AS TAT_TB
    FROM   TAT_NAM  y
    JOIN   TAT_RLOS r ON r.NAM = y.NAM
    JOIN   TAT_CLOS c ON c.NAM = y.NAM
),
-- [TAT_TGT] Dich
TAT_TGT AS (
    SELECT NAM, YEAR_MONTH,
           ROUND(TAT_RLOS, 2) AS TAT_RLOS, ROUND(TAT_CLOS, 2) AS TAT_CLOS, ROUND(TAT_TB, 2) AS TAT_TB
    FROM   PDTD_DTM.RPT_KPI_KHOI
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM TAT_SRC MINUS SELECT * FROM TAT_TGT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, z.* FROM (SELECT * FROM TAT_TGT MINUS SELECT * FROM TAT_SRC) z;"



"WITH -- QUY DOI / NSLD | HO SO + NAM
-- [QD_RLOS_HS] CUM RLOS - 1 dong / ho so: PROCESSED_DATE, trang thai, thong tin ho so.
QD_RLOS_HS AS (
    SELECT x.*,
           b.PRODUCT_NAME, b.COMPANY_CODE, e.SUB_PRODUCT, e.COLLREQUIRE, f.BI_FLOW
    FROM  (SELECT WINAME,
                  -- PROCESSED_DATE: UT1 ngay phe duyet / tu choi cuoi > UT2 ngay CancelRevoke > UT3 Max(EXITDATE)
                  COALESCE(MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN EXITDATE END),
                           MIN(CASE WHEN WORKSTEP = 'CancelRevoke' THEN NVL(EXITDATE, ENTRYDATE) END),
                           MAX(EXITDATE))                                                           AS PROCESSED_DATE,
                  -- Trang thai ho so (BI_APPSTATUS)
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN 1 ELSE 0 END)   AS IS_PD_TC,     -- Approved / Rejected
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')  THEN 1 ELSE 0 END)   AS IS_APPROVED,  -- Approved
                  MAX(CASE WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 1 ELSE 0 END) AS IS_CANCEL,    -- Cancelled
                  MIN(ENTRYDATE)                                                                  AS NGAY_PHAT_SINH  -- ngay ho so phat sinh
           FROM   SBLOS2.NG_SB_RLOS_ENTRY_EXIT
           GROUP  BY WINAME
          ) x
    JOIN      SBLOS2.NG_SB_RLOS_EXTTABLE          b ON b.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL e ON e.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPROVAL          c ON c.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.RLOS_REF_FLOW                f ON f.STREAM  = c.STREAM
    WHERE  1 = 1
    AND    x.NGAY_PHAT_SINH >= DATE '2021-01-01'                                     -- Ho so phat sinh tu 01/01/2021
    AND    NOT EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT t                -- Loai ho so co tai khoan test
                       WHERE  t.WINAME = x.WINAME AND t.USERNAME IN ('hanh.nh2','hai.bt2'))
),
-- [QD_CLOS_HS] CUM CLOS - 1 dong / ho so: PROCESSED_DATE, trang thai, thong tin ho so.
QD_CLOS_HS AS (
    SELECT x.*
    FROM  (SELECT WINAME,
                  -- PROCESSED_DATE: UT1 ngay phe duyet / tu choi cuoi > UT2 ngay CancelRevoke > UT3 Max(EXITDATE)
                  COALESCE(MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN EXITDATE END),
                           MIN(CASE WHEN WORKSTEP = 'CancelRevoke' THEN NVL(EXITDATE, ENTRYDATE) END),
                           MAX(EXITDATE))                                                           AS PROCESSED_DATE,
                  -- Trang thai ho so (BI_APPSTATUS)
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN 1 ELSE 0 END)   AS IS_PD_TC,     -- Approved / Rejected
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')  THEN 1 ELSE 0 END)   AS IS_APPROVED,  -- Approved
                  MAX(CASE WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 1 ELSE 0 END) AS IS_CANCEL,    -- Cancelled
                  MIN(ENTRYDATE)                                                                  AS NGAY_PHAT_SINH  -- ngay ho so phat sinh
           FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT
           GROUP  BY WINAME
          ) x
    WHERE  1 = 1
    AND    x.NGAY_PHAT_SINH >= DATE '2021-01-01'                                     -- Ho so phat sinh tu 01/01/2021
    AND    NOT EXISTS (SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT t                -- Loai ho so co tai khoan test
                       WHERE  t.WINAME = x.WINAME AND t.USERNAME IN ('hanh.nh2','hai.bt2'))
),
-- [QD_DS_NAM] Danh sach nam 
QD_DS_NAM (NAM) AS (
    SELECT 2018 FROM DUAL                                                -- [NAM_DAU]
    UNION ALL
    SELECT NAM + 1 FROM QD_DS_NAM
    WHERE  NAM + 1 <= EXTRACT(YEAR FROM TRUNC(SYSDATE) - 1)
),
-- [QD_NAM] Khung nam:
--   Nam qua khu : tu 01/01 den 31/12
--   Nam hien tai: tu 01/01 den ngay du lieu T-1
QD_NAM AS (
    SELECT NAM, TU_NGAY, DEN_NGAY,
           N'Ngày ' || TO_CHAR(DEN_NGAY, 'DD') || N' tháng ' || TO_CHAR(DEN_NGAY, 'MM')   AS YEAR_MONTH
    FROM  (SELECT NAM,
                  TO_DATE(NAM || '0101', 'YYYYMMDD')                     AS TU_NGAY,
                  LEAST(TO_DATE(NAM || '1231', 'YYYYMMDD'),
                        TRUNC(SYSDATE) - 1)                              AS DEN_NGAY   -- nam qua khu 31/12, nam hien tai T-1
           FROM   QD_DS_NAM)
),
-- QUY DOI | RLOS
-- [QD_RLOS_POINT] POINT / ho so - join 2 file SLA: file2 NLTT.SLA_DE_TOTAL_RESULT + file1 TDKHCN.SLA_CREDIT_OFFICER + file1 TDKHCN.SLA_CREDIT_APPROVER
QD_RLOS_POINT AS (
    SELECT h.WINAME,
           f2.SLA_DE_TOTAL_RESULT + f1.SLA_CREDIT_OFFICER + f1.SLA_CREDIT_APPROVER       AS POINT
    FROM   QD_RLOS_HS h
    JOIN      SBLOS2.NG_SB_RLOS_EXTTABLE          b ON b.WI_NAME = h.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL e ON e.WI_NAME = h.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPROVAL          c ON c.WI_NAME = h.WINAME
    LEFT JOIN (SELECT WI_NAME, COUNT(*) AS SL                                  -- so ngoai le (dieu kien DEVIATION_G3 cua file1)
               FROM   SBLOS2.NG_SB_RLOS_MANUAL_DEVIATION
               GROUP  BY WI_NAME) dv ON dv.WI_NAME = h.WINAME
    -- file1: cam ket SLA TDKHCN
    LEFT JOIN PDTD_DTM.RLOS_REF_SLA_TDKHCN f1
           ON  f1.APP_GRP = CASE WHEN c.APP_GRP IN ('B1','B2','C1','C2','C3') THEN N'CGPD cấp B,C (B1, B2, C1, C2, C3)'
                                 WHEN c.APP_GRP IN ('A1','A2')                 THEN N'CGPD cấp A (A1, A2)'
                                 WHEN c.APP_GRP IN ('BOD','CC','SCC','RCC')    THEN N'BOD/ CC/ SCC/ RCC' END
           AND (   (f1.PRODUCT_LINE =  N'Trường Change Request' AND f1.CHANGE_TYPE  = b.CHANGE_TYPE)
                OR (f1.PRODUCT_LINE <> N'Trường Change Request' AND f1.PRODUCT_LINE = e.PRODUCT_LINE))
           AND (f1.DEVIATION_G3 IS NULL
                OR f1.DEVIATION_G3 = CASE WHEN NVL(dv.SL, 0) >= 3 THEN 'YES' ELSE 'NO' END)
           AND (f1.SECONDARY_PRODUCTLINE IS NULL
                OR f1.SECONDARY_PRODUCTLINE = CASE e.IS_SEC_PRODUCT WHEN N'Không' THEN 'NO'
                                                                    WHEN N'Có'    THEN 'YES' END)
    -- file2: cam ket SLA NLTT - RLOS
    LEFT JOIN PDTD_DTM.REF_SLA_NLTT f2
           ON  f2.SYSTEMNAME   = 'RLOS'
           AND f2.PRODUCT_LINE = e.PRODUCT_LINE
),
-- [QD_RLOS] QUY_DOI_RLOS / nam = SUM(QUY_DOI) cac ho so RLOS co PROCESSED_DATE trong nam
--   QUY_DOI = POINT / (8*VOLUME) (VOLUME NULL -> NULL); ho so bao cao RLOS = Approved / Rejected / Cancelled
QD_RLOS AS (
    SELECT y.NAM, SUM(q.QUY_DOI) AS QUY_DOI_RLOS
    FROM   QD_NAM y
    LEFT JOIN (SELECT v.PROCESSED_DATE,
                      CASE WHEN v.VOLUME IS NOT NULL THEN p.POINT  / (v.VOLUME*8) END             AS QUY_DOI
               FROM  (SELECT h.WINAME, h.PROCESSED_DATE,
                             CASE WHEN h.IS_PD_TC  = 1 THEN 1.0                       -- Da phe duyet / tu choi
                                  WHEN h.IS_CANCEL = 1 THEN CASE WHEN s.HAS_CA  = 1 THEN 0.8   -- Cancel: theo buoc xa nhat da den
                                                                 WHEN s.HAS_UWC = 1 THEN 0.6
                                                                 WHEN s.HAS_UWM = 1 THEN 0.5
                                                                 WHEN s.HAS_DDE = 1 THEN 0.2 END
                             END                                               AS VOLUME
                      FROM   QD_RLOS_HS h
                      JOIN   (SELECT WINAME,
                                    MAX(CASE WHEN WORKSTEP = 'CreditApproval'     THEN 1 ELSE 0 END) AS HAS_CA,
                                    MAX(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN 1 ELSE 0 END) AS HAS_UWC,
                                    MAX(CASE WHEN WORKSTEP = 'UnderwriterMaker'   THEN 1 ELSE 0 END) AS HAS_UWM,
                                    MAX(CASE WHEN WORKSTEP = 'DetailDataEntry'    THEN 1 ELSE 0 END) AS HAS_DDE
                             FROM   SBLOS2.NG_SB_RLOS_ENTRY_EXIT
                             GROUP  BY WINAME) s ON s.WINAME = h.WINAME
                      WHERE  h.IS_PD_TC = 1 OR h.IS_CANCEL = 1) v
               LEFT JOIN QD_RLOS_POINT p ON p.WINAME = v.WINAME) q
           ON TRUNC(q.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY
    GROUP  BY y.NAM
),
-- QUY DOI | CLOS
-- [QD_CLOS_POINT] POINT / ho so - join 3 file SLA:
--   APP_GRP = 'C1': file3 NLTT.SLA_DE_TOTAL_RESULT + 4.00
--   APP_GRP <> 'C1': file3 NLTT.SLA_DE_TOTAL_RESULT + NVL(file1 luong 2, file2 TDKHDNL).SLA_CREDIT_OFFICER + NVL(file1 luong 2, file2 TDKHDNL).SLA_CREDIT_APPROVER
QD_CLOS_POINT AS (
    SELECT h.WINAME,
           CASE WHEN e.APP_GRP = 'C1'
                THEN f3.SLA_DE_TOTAL_RESULT + 4.00
                ELSE f3.SLA_DE_TOTAL_RESULT
                   + NVL(f1.SLA_CREDIT_OFFICER,  f2.SLA_CREDIT_OFFICER)
                   + NVL(f1.SLA_CREDIT_APPROVER, f2.SLA_CREDIT_APPROVER) END                      AS POINT
    FROM   QD_CLOS_HS h
    LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO       c  ON c.WI_NAME  = h.WINAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_MAS_PRO_LINE    d  ON d.PRODUCT_LINE_CODE = c.PRODUCT_LINE
    LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL        e  ON e.WI_NAME  = h.WINAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CREDITINFO_COMM cr ON cr.WI_NAME = h.WINAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CHANGEREQ       g  ON g.WI_NAME  = h.WINAME
    -- file1: cam ket SLA TDKHDN luong 2
    LEFT JOIN PDTD_DTM.CLOS_REF_SLA_TDKHDN_2 f1
           ON  c.CUST_GROUP IN ('MSME','SME','USME')
           AND f1.FLAG_APP_GRP = CASE WHEN e.APP_GRP IN ('A1','A2','B1','B2')     THEN 'CGPD'
                                      WHEN e.APP_GRP IN ('BOD','CC','SCC','RCC') THEN 'HDTD' END
           AND f1.HAVE_ANY_DEVIATION = cr.HAVE_ANY_DEVIATION
           AND f1.PRODUCT_LINE = CASE WHEN g.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request'
                                      ELSE d.PRODUCT_LINE_NAME END
           AND (f1.SUB_PRODUCT IS NULL OR f1.SUB_PRODUCT = c.SUB_PRODUCT)
    -- file2: cam ket SLA TDKHDNL
    LEFT JOIN PDTD_DTM.CLOS_REF_SLA_TDKHDNL f2
           ON  c.CUST_GROUP IN ('NBFI','JSC','FDI','BANK','STR','SOC')
           AND f2.FLAG_APP_GRP = CASE WHEN e.APP_GRP IN ('A1','A2','B1','B2')     THEN 'CGPD'
                                      WHEN e.APP_GRP IN ('BOD','CC','SCC','RCC') THEN 'HDTD' END
           AND f2.HAVE_ANY_DEVIATION = cr.HAVE_ANY_DEVIATION
           AND f2.PRODUCT_LINE = CASE WHEN g.CHANGE_REQUEST = 'Change Request' THEN N'Trường Change Request'
                                      ELSE d.PRODUCT_LINE_NAME END
           AND (f2.SUB_PRODUCT IS NULL OR f2.SUB_PRODUCT = c.SUB_PRODUCT)
    -- file3: cam ket SLA NLTT - CLOS (CHANGE_REQUEST NULL -> khong map)
    LEFT JOIN PDTD_DTM.REF_SLA_NLTT f3
           ON  f3.SYSTEMNAME         = 'CLOS'
           AND f3.NEW_CHANGE_REQUEST = g.CHANGE_REQUEST
           AND f3.PRODUCT_LINE       = d.PRODUCT_LINE_NAME
           AND (f3.SUB_PRODUCT IS NULL OR f3.SUB_PRODUCT = c.SUB_PRODUCT)
),
-- [QD_CLOS] QUY_DOI_CLOS / nam = SUM(QUY_DOI) cac ho so CLOS co PROCESSED_DATE trong nam
--   QUY_DOI = POINT  /(8* VOLUME) (VOLUME NULL -> NULL); ho so bao cao CLOS = Approved / Rejected / Cancelled
QD_CLOS AS (
    SELECT y.NAM, SUM(q.QUY_DOI) AS QUY_DOI_CLOS
    FROM   QD_NAM y
    LEFT JOIN (SELECT v.PROCESSED_DATE,
                      CASE WHEN v.VOLUME IS NOT NULL THEN p.POINT / (v.VOLUME*8) END             AS QUY_DOI
               FROM  (SELECT h.WINAME, h.PROCESSED_DATE,
                             CASE WHEN h.IS_PD_TC  = 1 THEN 1.0                       -- Da phe duyet / tu choi
                                  WHEN h.IS_CANCEL = 1 THEN CASE WHEN s.HAS_CA  = 1 THEN 0.8   -- Cancel: theo buoc xa nhat da den
                                                                 WHEN s.HAS_UWC = 1 THEN 0.6
                                                                 WHEN s.HAS_UWM = 1 THEN 0.5
                                                                 WHEN s.HAS_DDE = 1 THEN 0.2 END
                             END                                               AS VOLUME
                      FROM   QD_CLOS_HS h
                      JOIN   (SELECT WINAME,
                                    MAX(CASE WHEN WORKSTEP = 'CreditApproval'     THEN 1 ELSE 0 END) AS HAS_CA,
                                    MAX(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN 1 ELSE 0 END) AS HAS_UWC,
                                    MAX(CASE WHEN WORKSTEP = 'UnderwriterMaker'   THEN 1 ELSE 0 END) AS HAS_UWM,
                                    MAX(CASE WHEN WORKSTEP = 'DetailDataEntry'    THEN 1 ELSE 0 END) AS HAS_DDE
                             FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT
                             GROUP  BY WINAME) s ON s.WINAME = h.WINAME
                      WHERE  h.IS_PD_TC = 1 OR h.IS_CANCEL = 1) v
               LEFT JOIN QD_CLOS_POINT p ON p.WINAME = v.WINAME) q
           ON TRUNC(q.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY
    GROUP  BY y.NAM
),
-- NHAN SU (RLOS + CLOS)
-- =============================================================================================
-- [QD_NHAN_SU] NHAN_SU / nam = COUNT(DISTINCT USERNAME) tren UNION ENTRY_EXIT RLOS + CLOS
--   Buoc: DetailDataEntry, DataInputerChecker, UnderwriterChecker, UnderwriterMaker, PhoneVerification,
--         CreditApproval, CreditCommittee, HOSupport
--   Ho so: Approved / Rejected / Cancelled; RLOS them BI_FLOW IN ('BL','KHCN_HO'); EXITDATE trong nam
QD_NHAN_SU AS (
    SELECT y.NAM, COUNT(DISTINCT n.USERNAME) AS NHAN_SU
    FROM   QD_NAM y
    LEFT JOIN (-- RLOS
               SELECT a.USERNAME, a.EXITDATE
               FROM   SBLOS2.NG_SB_RLOS_ENTRY_EXIT a
               JOIN   QD_RLOS_HS h ON h.WINAME = a.WINAME
               WHERE  a.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterChecker','UnderwriterMaker',
                                     'PhoneVerification','CreditApproval','CreditCommittee','HOSupport')
               AND    (h.IS_PD_TC = 1 OR h.IS_CANCEL = 1)
               AND    h.BI_FLOW IN ('BL','KHCN_HO')
               UNION
               -- CLOS
               SELECT a.USERNAME, a.EXITDATE
               FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT a
               JOIN   QD_CLOS_HS h ON h.WINAME = a.WINAME
               WHERE  a.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterChecker','UnderwriterMaker',
                                     'PhoneVerification','CreditApproval','CreditCommittee','HOSupport')
               AND    (h.IS_PD_TC = 1 OR h.IS_CANCEL = 1)) n
           ON TRUNC(n.EXITDATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY
    GROUP  BY y.NAM
),
-- MINUS
-- [QD_SRC] Nguon; NSLD = (QUY_DOI_RLOS + QUY_DOI_CLOS) / NHAN_SU (ghep 2 nguon)
QD_SRC AS (
    SELECT y.NAM, y.YEAR_MONTH,
           ROUND(r.QUY_DOI_RLOS, 2)                                                   AS QUY_DOI_RLOS,
           ROUND(c.QUY_DOI_CLOS, 2)                                                   AS QUY_DOI_CLOS,
           n.NHAN_SU,
           ROUND((r.QUY_DOI_RLOS + c.QUY_DOI_CLOS) / NULLIF(n.NHAN_SU, 0), 2)         AS NSLD
    FROM   QD_NAM     y
    JOIN   QD_RLOS    r ON r.NAM = y.NAM
    JOIN   QD_CLOS    c ON c.NAM = y.NAM
    JOIN   QD_NHAN_SU n ON n.NAM = y.NAM
),
-- [QD_TGT] Dich
QD_TGT AS (
    SELECT NAM, YEAR_MONTH,
           ROUND(QUY_DOI_RLOS, 2) AS QUY_DOI_RLOS, ROUND(QUY_DOI_CLOS, 2) AS QUY_DOI_CLOS,
           NHAN_SU, ROUND(NSLD, 2) AS NSLD
    FROM   PDTD_DTM.RPT_KPI_KHOI
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM QD_SRC MINUS SELECT * FROM QD_TGT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, z.* FROM (SELECT * FROM QD_TGT MINUS SELECT * FROM QD_SRC) z;"



WITH -- SLHS / SLGN | HO SO + NAM
-- [SL_RLOS_HS] CUM CHINH RLOS - 1 dong / ho so: PROCESSED_DATE, trang thai, thong tin ho so.
SL_RLOS_HS AS (
    SELECT x.*,
           b.PRODUCT_NAME, b.COMPANY_CODE, e.SUB_PRODUCT, e.COLLREQUIRE, f.BI_FLOW
    FROM  (SELECT WINAME,
                  -- PROCESSED_DATE: UT1 ngay phe duyet / tu choi cuoi > UT2 ngay CancelRevoke > UT3 Max(EXITDATE)
                  COALESCE(MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN EXITDATE END),
                           MIN(CASE WHEN WORKSTEP = 'CancelRevoke' THEN NVL(EXITDATE, ENTRYDATE) END),
                           MAX(EXITDATE))                                                           AS PROCESSED_DATE,
                  -- Trang thai ho so (BI_APPSTATUS)
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN 1 ELSE 0 END)   AS IS_PD_TC,     -- Approved / Rejected
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')  THEN 1 ELSE 0 END)   AS IS_APPROVED,  -- Approved
                  MAX(CASE WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 1 ELSE 0 END) AS IS_CANCEL,    -- Cancelled
                  MIN(ENTRYDATE)                                                                  AS NGAY_PHAT_SINH  -- ngay ho so phat sinh
           FROM   SBLOS2.NG_SB_RLOS_ENTRY_EXIT
           GROUP  BY WINAME
          ) x
    JOIN      SBLOS2.NG_SB_RLOS_EXTTABLE          b ON b.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL e ON e.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_RLOS_APPROVAL          c ON c.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.RLOS_REF_FLOW                f ON f.STREAM  = c.STREAM
    WHERE  1 = 1
    AND    x.NGAY_PHAT_SINH >= DATE '2021-01-01'                                     -- Ho so phat sinh tu 01/01/2021
    AND    NOT EXISTS (SELECT 1 FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT t                -- Loai ho so co tai khoan test
                       WHERE  t.WINAME = x.WINAME AND t.USERNAME IN ('hanh.nh2','hai.bt2'))
),
-- [SL_CLOS_HS] CUM CLOS - 1 dong / ho so: PROCESSED_DATE, trang thai, thong tin ho so.
SL_CLOS_HS AS (
    SELECT x.*,
           b.STREAM, c.VAR_STR12, h.PRODUCT_LINE, h.SUB_PRODUCT
    FROM  (SELECT WINAME,
                  -- PROCESSED_DATE: UT1 ngay phe duyet / tu choi cuoi > UT2 ngay CancelRevoke > UT3 Max(EXITDATE)
                  COALESCE(MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN EXITDATE END),
                           MIN(CASE WHEN WORKSTEP = 'CancelRevoke' THEN NVL(EXITDATE, ENTRYDATE) END),
                           MAX(EXITDATE))                                                           AS PROCESSED_DATE,
                  -- Trang thai ho so (BI_APPSTATUS)
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject') THEN 1 ELSE 0 END)   AS IS_PD_TC,     -- Approved / Rejected
                  MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport')  THEN 1 ELSE 0 END)   AS IS_APPROVED,  -- Approved
                  MAX(CASE WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 1 ELSE 0 END) AS IS_CANCEL,    -- Cancelled
                  MIN(ENTRYDATE)                                                                  AS NGAY_PHAT_SINH  -- ngay ho so phat sinh
           FROM   SBLOS2.NG_SB_CLOS_ENTRY_EXIT
           GROUP  BY WINAME
          ) x
    LEFT JOIN SBLOS2.NG_SB_CLOS_APPROVAL  b ON b.WI_NAME = x.WINAME
    LEFT JOIN SBLOS2.WFINSTRUMENTTABLE    c ON c.PROCESSINSTANCEID = x.WINAME
    LEFT JOIN SBLOS2.NG_SB_CLOS_CUST_INFO h ON h.WI_NAME = x.WINAME
    WHERE  1 = 1
    AND    x.NGAY_PHAT_SINH >= DATE '2021-01-01'                                     -- Ho so phat sinh tu 01/01/2021
    AND    NOT EXISTS (SELECT 1 FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT t                -- Loai ho so co tai khoan test
                       WHERE  t.WINAME = x.WINAME AND t.USERNAME IN ('hanh.nh2','hai.bt2'))
),
-- [SL_DS_NAM] Danh sach nam 
SL_DS_NAM (NAM) AS (
    SELECT 2018 FROM DUAL                                                -- [NAM_DAU]
    UNION ALL
    SELECT NAM + 1 FROM SL_DS_NAM
    WHERE  NAM + 1 <= EXTRACT(YEAR FROM TRUNC(SYSDATE) - 1)
),
-- [SL_NAM] Khung nam:
--   Nam qua khu : tu 01/01 den 31/12
--   Nam hien tai: tu 01/01 den ngay du lieu T-1
SL_NAM AS (
    SELECT NAM, TU_NGAY, DEN_NGAY,
           N'Ngày ' || TO_CHAR(DEN_NGAY, 'DD') || N' tháng ' || TO_CHAR(DEN_NGAY, 'MM')   AS YEAR_MONTH
    FROM  (SELECT NAM,
                  TO_DATE(NAM || '0101', 'YYYYMMDD')                     AS TU_NGAY,
                  LEAST(TO_DATE(NAM || '1231', 'YYYYMMDD'),
                        TRUNC(SYSDATE) - 1)                              AS DEN_NGAY   -- nam qua khu 31/12, nam hien tai T-1
           FROM   SL_DS_NAM)
),
-- SLHS / SLGN | RLOS
-- [SL_RLOS_HS_SL] Ho so RLOS tinh SLHS / SLGN - 1 dong / ho so
--   Loc: phe duyet thanh cong; BI_FLOW IN ('BL','KHCN_HO'); loai COMPANY_CODE VN0010401/VN0010101/VN0010002;
--   Nhom 1 (vay thuong) hoac Nhom 2 (the tin dung & SP nhanh)
SL_RLOS_HS_SL AS (
    SELECT h.WINAME, h.PROCESSED_DATE
    FROM   SL_RLOS_HS h
    WHERE  h.IS_APPROVED = 1
    AND    h.BI_FLOW IN ('BL','KHCN_HO')
    AND    h.COMPANY_CODE NOT IN ('VN0010401','VN0010101','VN0010002')
    AND    (   (NVL(CASE WHEN h.SUB_PRODUCT LIKE N'%Phát hành%' OR h.SUB_PRODUCT LIKE '%TTD%' THEN 'Credit Card' ELSE h.SUB_PRODUCT END, 'XX') <> 'Credit Card'
                AND h.PRODUCT_NAME NOT IN ('SeAHome-Fast','SeAHome-FastTSDB'))          -- Nhom 1
            OR (NVL(CASE WHEN h.SUB_PRODUCT LIKE N'%Phát hành%' OR h.SUB_PRODUCT LIKE '%TTD%' THEN 'Credit Card' ELSE h.SUB_PRODUCT END, 'XX') =  'Credit Card'
                AND h.PRODUCT_NAME IN ('SeAHome-Fast','SeAHome-FastTSDB')))             -- Nhom 2
),
-- [SL_RLOS_GN] Ho so RLOS da giai ngan: SL_RLOS_HS_SL INNER JOIN STG_FCT_LOAN (chi ho so co trong STG_FCT_LOAN)
SL_RLOS_GN AS (
    SELECT DISTINCT s.WINAME, s.PROCESSED_DATE, g.SEAB_LOS_ID
    FROM   SL_RLOS_HS_SL s
    INNER JOIN STG_DTM.STG_FCT_LOAN g ON g.SEAB_LOS_ID = s.WINAME
),
-- [SL_RLOS] SLHS_RLOS, SLGN_RLOS / nam
--   SLHS = COUNT(DISTINCT WI_NAME) tren SL_RLOS_HS_SL
--   SLGN = COUNT(DISTINCT SEAB_LOS_ID) tren SL_RLOS_GN
SL_RLOS AS (
    SELECT y.NAM,
           (SELECT COUNT(DISTINCT s.WINAME)      FROM SL_RLOS_HS_SL s
            WHERE  TRUNC(s.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY)                        AS SLHS_RLOS,
           (SELECT COUNT(DISTINCT g.SEAB_LOS_ID) FROM SL_RLOS_GN g
            WHERE  TRUNC(g.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY)                        AS SLGN_RLOS
    FROM   SL_NAM y
),
-- SLHS / SLGN | CLOS
-- [SL_CLOS_HS_SL] Ho so CLOS tinh SLHS / SLGN 
--   Loc: phe duyet thanh cong; STREAM = 'Phe duyet tin dung'; VAR_STR12 NOT NULL;
--        Nhom 1 (PRO01 - han muc thau chi / the TD doanh nghiep) hoac Nhom 2 (con lai, tru PRO02 - LC theo mon)
SL_CLOS_HS_SL AS (
    SELECT h.WINAME, h.PROCESSED_DATE, h.VAR_STR12
    FROM   SL_CLOS_HS h
    WHERE  h.IS_APPROVED = 1
    AND    h.STREAM = N'Phê duyệt tín dụng'
    AND    h.VAR_STR12 IS NOT NULL
    AND    (   (h.PRODUCT_LINE = 'PRO01' AND h.SUB_PRODUCT IN (N'Hạn mức thấu chi', N'Hạn mức Thẻ tín dụng doanh nghiệp'))  -- Nhom 1
            OR (CASE WHEN h.PRODUCT_LINE = 'PRO01' AND h.SUB_PRODUCT IN (N'Hạn mức thấu chi', N'Hạn mức Thẻ tín dụng doanh nghiệp') THEN 0
                     WHEN h.PRODUCT_LINE = 'PRO02' AND h.SUB_PRODUCT = N'Phát hành LC theo món' THEN 0
                     ELSE 1 END) = 1)                                                                                    -- Nhom 2
),
-- [SL_CLOS_KH] CUSTOMER
SL_CLOS_KH AS (
    SELECT DISTINCT s.WINAME, s.PROCESSED_DATE, s.VAR_STR12, cu.CUSTOMER
    FROM   SL_CLOS_HS_SL s
    INNER JOIN SBLOS2.NG_SB_CLOS_CUST_INFO_LEGAL lg ON lg.WI_NAME = s.WINAME
    LEFT JOIN  STG_DTM.STG_DIM_CUSTOMER cu
           ON  REGEXP_REPLACE(lg.ID_NUMBER, '\s') = cu.LEGAL_ID
           AND lg.LEGAL_DOC = REGEXP_REPLACE(cu.LEGAL_DOC_NAME, '\s')
           AND cu.EXP_DATE IS NULL
           AND cu.LEGAL_ID <> '.'
),
-- [SL_CLOS_GN_LD] Giai ngan nhanh LD: SL_CLOS_KH INNER JOIN STG_FCT_LOAN (SEAB_LOS_ID + CUSTOMER_CODE),
--   gom theo VAR_STR12 -> contract_list_ld = LISTAGG(CONTRACT, ';')
SL_CLOS_GN_LD AS (
    SELECT k.VAR_STR12,
           LISTAGG(l.CONTRACT, ';') WITHIN GROUP (ORDER BY l.CONTRACT)                  AS CONTRACT_LIST_LD
    FROM   SL_CLOS_KH k
    INNER JOIN STG_DTM.STG_FCT_LOAN l ON l.SEAB_LOS_ID = k.WINAME AND l.CUSTOMER_CODE = k.CUSTOMER
    GROUP  BY k.VAR_STR12
),
-- [SL_CLOS_GN_MD] Giai ngan nhanh MD: SL_CLOS_KH INNER JOIN STG_FCT_MD (SEAB_LOS_ID + CUSTOMER),
--   gom theo SEAB_LOS_ID + CUSTOMER -> contract_list_md = LISTAGG(CONTRACT, ';')
SL_CLOS_GN_MD AS (
    SELECT k.WINAME, k.CUSTOMER,
           LISTAGG(m.CONTRACT, ';') WITHIN GROUP (ORDER BY m.CONTRACT)                  AS CONTRACT_LIST_MD
    FROM   SL_CLOS_KH k
    INNER JOIN STG_DTM.STG_FCT_MD m ON m.SEAB_LOS_ID = k.WINAME AND m.CUSTOMER = k.CUSTOMER
    GROUP  BY k.WINAME, k.CUSTOMER
),
-- [SL_CLOS_GN] Ghep 2 nhanh giai ngan: NVL(contract_list_ld, contract_list_md) 
SL_CLOS_GN AS (
    SELECT k.WINAME, k.PROCESSED_DATE,
           NVL(ld.CONTRACT_LIST_LD, md.CONTRACT_LIST_MD)                                         AS CONTRACT_GN
    FROM   SL_CLOS_KH k
    LEFT JOIN SL_CLOS_GN_LD ld ON ld.VAR_STR12 = k.VAR_STR12
    LEFT JOIN SL_CLOS_GN_MD md ON md.WINAME = k.WINAME AND md.CUSTOMER = k.CUSTOMER
),
-- [SL_CLOS] SLHS_CLOS, SLGN_CLOS / nam
--   SLHS = COUNT(DISTINCT WI_NAME) ho so SL_CLOS_HS_SL; SLGN = COUNT(NVL(contract_list_ld, contract_list_md))
SL_CLOS AS (
    SELECT y.NAM,
           (SELECT COUNT(DISTINCT s.WINAME) FROM SL_CLOS_HS_SL s
            WHERE  TRUNC(s.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY)                        AS SLHS_CLOS,
           (SELECT COUNT(g.CONTRACT_GN)     FROM SL_CLOS_GN g
            WHERE  TRUNC(g.PROCESSED_DATE) BETWEEN y.TU_NGAY AND y.DEN_NGAY)                        AS SLGN_CLOS
    FROM   SL_NAM y
),
-- MINUS
SL_SRC AS (
    SELECT y.NAM, y.YEAR_MONTH,
           r.SLHS_RLOS,
           r.SLGN_RLOS,
           ROUND(r.SLGN_RLOS * 100 / NULLIF(r.SLHS_RLOS, 0), 2)                                AS TY_LE_GN_RLOS,
           c.SLHS_CLOS,
           c.SLGN_CLOS,
           ROUND(c.SLGN_CLOS * 100 / NULLIF(c.SLHS_CLOS, 0), 2)                                AS TY_LE_GN_CLOS,
           r.SLHS_RLOS + c.SLHS_CLOS                                                           AS SLHS_TONG,
           r.SLGN_RLOS + c.SLGN_CLOS                                                           AS SLGN_TONG,
           ROUND((r.SLGN_RLOS + c.SLGN_CLOS) * 100 / NULLIF(r.SLHS_RLOS + c.SLHS_CLOS, 0), 2)   AS TY_LE_GN_TONG
    FROM   SL_NAM  y
    JOIN   SL_RLOS r ON r.NAM = y.NAM
    JOIN   SL_CLOS c ON c.NAM = y.NAM
),
-- [SL_TGT] Dich
SL_TGT AS (
    SELECT NAM, YEAR_MONTH,
           SLHS_RLOS, SLGN_RLOS, ROUND(TY_LE_GN_RLOS, 2) AS TY_LE_GN_RLOS,
           SLHS_CLOS, SLGN_CLOS, ROUND(TY_LE_GN_CLOS, 2) AS TY_LE_GN_CLOS,
           SLHS_TONG, SLGN_TONG, ROUND(TY_LE_GN_TONG, 2) AS TY_LE_GN_TONG
    FROM   PDTD_DTM.RPT_KPI_KHOI
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SL_SRC MINUS SELECT * FROM SL_TGT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, z.* FROM (SELECT * FROM SL_TGT MINUS SELECT * FROM SL_SRC) z;