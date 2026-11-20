/* =====================================================================
   BC9 - Bao cao KPI, phan KPI Khoi (1 dong; PDTD_DTM, Oracle 19c)
   Nguon thiet ke: extract/srs_report/BC9.md (muc "KPI Khoi") + lld/pdtd_dtm/* (skill gen-report)
   Tham so:
     :p_date_to   DATE   Ngay du lieu (DAYID), mac dinh T-1 (TRUNC(SYSDATE) - 1)
   Bang AGG_LOS_KPI_YTD_DAILY luy ke tu 1/1 den DAYID nen chi can :p_date_to (khong co :p_date_from).
   Doc cac cot luy ke nam (_YTD) cua AGG_LOS_KPI_YTD_DAILY tai DAYID = :p_date_to; bang tong hop khong co chieu
   chi nhanh nen KHONG ap dung loc chi nhanh o phan nay (da chap nhan). Cac chi tieu da loai tai khoan test,
   3 don vi VN0010401 / VN0010101 / VN0010002 va chi tinh luong BL / KHCN_HO ngay tai bang tong hop.
   TAT_RLOS = trung binh cong cua TAT trung binh nhom UNSEC va nhom SEC; TY_LE_GN = SLGN * 100 / SLHS.
   ===================================================================== */
WITH
p AS (
    SELECT TRUNC(:p_date_to) AS data_day FROM DUAL
),
y AS (
    SELECT p.data_day,
           d.SLHS_RLOS_YTD, d.SLGN_RLOS_YTD, d.SLHS_CLOS_YTD, d.SLGN_CLOS_YTD,
           d.QUY_DOI_RLOS_YTD, d.QUY_DOI_CLOS_YTD, d.USER_CNT_YTD,
           d.TAT_RLOS_UNSEC_SUM_HOUR_YTD / NULLIF(d.TAT_RLOS_UNSEC_CASE_CNT_YTD, 0) AS AVG_TAT_UNSEC,
           d.TAT_RLOS_SEC_SUM_HOUR_YTD   / NULLIF(d.TAT_RLOS_SEC_CASE_CNT_YTD, 0)   AS AVG_TAT_SEC,
           d.TAT_CLOS_SUM_HOUR_YTD       / NULLIF(d.TAT_CLOS_CASE_CNT_YTD, 0)       AS AVG_TAT_CLOS
    FROM   p
    JOIN   PDTD_DTM.AGG_LOS_KPI_YTD_DAILY d ON d.DAYID = p.data_day
)
SELECT
    'Ngày ' || TO_CHAR(y.data_day, 'DD') || ' tháng ' || TO_CHAR(y.data_day, 'MM')   AS YEAR_MONTH,
    (y.AVG_TAT_UNSEC + y.AVG_TAT_SEC) / 2                                           AS TAT_RLOS,
    y.AVG_TAT_CLOS                                                                  AS TAT_CLOS,
    ((y.AVG_TAT_UNSEC + y.AVG_TAT_SEC) / 2 + y.AVG_TAT_CLOS) / 2                    AS TAT_TB,
    y.QUY_DOI_RLOS_YTD                                                              AS QUY_DOI_RLOS,
    y.QUY_DOI_CLOS_YTD                                                              AS QUY_DOI_CLOS,
    y.USER_CNT_YTD                                                                  AS NHAN_SU,
    (y.QUY_DOI_RLOS_YTD + y.QUY_DOI_CLOS_YTD) / NULLIF(y.USER_CNT_YTD, 0)           AS NSLD,
    y.SLHS_RLOS_YTD                                                                 AS SLHS_RLOS,
    y.SLGN_RLOS_YTD                                                                 AS SLGN_RLOS,
    y.SLGN_RLOS_YTD * 100 / NULLIF(y.SLHS_RLOS_YTD, 0)                              AS TY_LE_GN_RLOS,
    y.SLHS_CLOS_YTD                                                                 AS SLHS_CLOS,
    y.SLGN_CLOS_YTD                                                                 AS SLGN_CLOS,
    y.SLGN_CLOS_YTD * 100 / NULLIF(y.SLHS_CLOS_YTD, 0)                              AS TY_LE_GN_CLOS,
    y.SLHS_RLOS_YTD + y.SLHS_CLOS_YTD                                               AS SLHS_TONG,
    y.SLGN_RLOS_YTD + y.SLGN_CLOS_YTD                                               AS SLGN_TONG,
    (y.SLGN_RLOS_YTD + y.SLGN_CLOS_YTD) * 100
        / NULLIF(y.SLHS_RLOS_YTD + y.SLHS_CLOS_YTD, 0)                              AS TY_LE_GN_TONG
FROM   y;
