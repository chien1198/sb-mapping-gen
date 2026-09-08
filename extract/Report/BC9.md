# BC9 — TRUY VẾT TỪNG TRƯỜNG BÁO CÁO VỀ DWH VÀ DTM

Nguồn: xlsx sheet "BC9" (Reports_20260907.xlsx)

Trường đích lấy từ SRS bản 25/08, giữ đúng thứ tự. Cột Luồng dữ liệu cho biết trường đó đã có sẵn ở DWH rồi kéo lên, hay phải lên DTM mới tính được.

| STT | Tên cột trên báo cáo | Ý nghĩa cột trên báo cáo | Có ở DWH | Tên cột ở DWH | Tên bảng ở DWH | Có ở DTM | Tên cột ở DTM | Tên bảng ở DTM | Luồng dữ liệu |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | PROCESSED_DATE | Ngày dữ liệu - Ngày mới nhất của dữ liệu | Có | PROCESSED_DATE | FCT_LOS_APPLICATION_DAILY | Có | PROCESSED_DATE | FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_DEVIATION / FCT_PDTD_EXCEPTION | Có ở DWH, kéo lên DTM |
| 2 | WI_NAME | Mã hồ sơ | Có | WI_NAME | DIM_LOS_APPLICATION / FCT_LOS_APPLICATION_DAILY / FCT_LOS_APPLICATION_PARTY | Có | WI_NAME | FCT_PDTD_KPI_APPLICATION | Có ở DWH, kéo lên DTM |
| 3 | VOLUME | Tỷ lệ KPI | Có | HAS_REACHED_QC / KPI_VOLUME | FCT_LOS_APPLICATION_DAILY | Có | HAS_REACHED_QC / KPI_VOLUME | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 4 | POINT | Điểm KPI | Có | APP_GRP_CODE / PRODUCT_NAME | DIM_LOS_APPROVAL_GROUP / DIM_LOS_PRODUCT | Có | APP_GRP_CODE / POINT / PRODUCT_NAME | DIM_PDTD_APPROVAL_GROUP / DIM_PDTD_PRODUCT / FCT_PDTD_KPI_APPLICATION | Có ở DWH, kéo lên DTM |
| 5 | QUY_DOI | Điểm KPI quy đổi | Có | KPI_VOLUME | FCT_LOS_APPLICATION_DAILY | Có | KPI_VOLUME | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 6 | TSBD_G2 | HS có từ 02 TSBĐ trở lên (YES/NO) | Có | COLLATERAL_CNT / COLL_GROUP | DIM_LOS_COLLATERAL_TYPE / FCT_LOS_APPLICATION_DAILY | Có | COLLATERAL_CNT / COLL_GROUP | DIM_PDTD_COLLATERAL_TYPE / FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 7 | INCOM_3 | HS có từ 03 nguồn thu trở lên (YES/NO) | Có | CARFLAG / DIVINGFLAG / ENTERPRISSEFLAG | FCT_LOS_APPLICATION_DAILY | Có | CARFLAG / DIVINGFLAG / ENTERPRISSEFLAG | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 8 | BUSINESS_INCOM | HS có nguồn thu từ kinh doanh (không áp dụng với SeAPro và SeALand) (YES/NO) | Có | ENTERPRISSEFLAG / FAIMILYFLAG / FLAG_BUSINESS_INCOME | DIM_LOS_PRODUCT / FCT_LOS_APPLICATION_DAILY | Có | ENTERPRISSEFLAG / FAIMILYFLAG / FLAG_BUSINESS_INCOME | DIM_PDTD_PRODUCT / FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 9 | DEVIATION_G2 | HS có 2 ngoại lệ (YES/NO) | Có | DEVIATION_CNT | FCT_LOS_APPLICATION_DAILY | Có | DEVIATION_CNT | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 10 | DEVIATION_G3 | HS có 3 ngoại lệ trở lên (YES/NO) | Có | DEVIATION_CNT | FCT_LOS_APPLICATION_DAILY | Có | DEVIATION_CNT | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 11 | YEAR_MONTH | Năm báo cáo | Không |  |  | Có | YEAR_MONTH | DIM_DATE | Lên DTM mới tính được |
| 12 | TAT_RLOS | TAT RLOS | Có | PRODUCT_NAME / STEP07_APPROVER_WK_HOUR / TAT_WORKING_HOUR | DIM_LOS_PRODUCT / FCT_LOS_SLA_DAILY / FCT_LOS_WORKSTEP_EVENT | Có | BI_FLAG_APPROVAL / PRODUCT_NAME / TAT_WORKING_HOUR | DIM_PDTD_PRODUCT / FCT_PDTD_SLA_DAILY / FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 13 | TAT_CLOS | TAT CLOS | Không |  |  | Có | TAT_APPLICATION_HOUR | FCT_PDTD_KPI_APPLICATION | Lên DTM mới tính được |
| 14 | TAT_TB | TAT trung bình | Có | TAT_KHOI_PDTD_WK_HOUR | FCT_LOS_SLA_DAILY | Có | TAT_TB | FCT_PDTD_KPI_YTD_DAILY | Có ở DWH, kéo lên DTM |
| 15 | QUY_DOI_RLOS | Điểm KPI RLOS quy đổi | Không |  |  | Có | QUY_DOI_RLOS | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 16 | QUY_DOI_CLOS | Điểm KPI CLOS quy đổi | Không |  |  | Có | QUY_DOI_CLOS | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 17 | NHAN_SU | Nhân sự Khối PDTD | Không |  |  | Có | FIRST_ELIGIBLE_TS / NHAN_SU | FCT_PDTD_KPI_USER_YEAR / FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 18 | NSLD | NSLĐ Khối PDTD | Không |  |  | Có | IS_PDTD_STEP / NSLD | DIM_PDTD_WORKSTEP / FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 19 | SLHS_RLOS | Số lượng hồ sơ phê duyệt RLOS | Có | PRODUCT_NAME | DIM_LOS_PRODUCT | Có | MILESTONE_TS / PRODUCT_NAME / SLHS_RLOS | DIM_PDTD_PRODUCT / FCT_PDTD_APPLICATION_MILESTONE / FCT_PDTD_KPI_YTD_DAILY | Có ở DWH, kéo lên DTM |
| 20 | SLGN_RLOS | Số lượng hồ sơ giải ngân RLOS | Không |  |  | Có | MILESTONE_TS / SLGN_RLOS | FCT_PDTD_APPLICATION_MILESTONE / FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 21 | TY_LE_GN_RLOS | Tỷ lệ giải ngân RLOS | Không |  |  | Có | TY_LE_GN_RLOS | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 22 | SLHS_CLOS | Số lượng hồ sơ phê duyệt CLOS | Không |  |  | Có | MILESTONE_TS / SLHS_CLOS | FCT_PDTD_APPLICATION_MILESTONE / FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 23 | SLGN_CLOS | Số lượng hồ sơ giải ngân CLOS | Không |  |  | Có | SLGN_CLOS | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 24 | TY_LE_GN_CLOS | Tỷ lệ giải ngân CLOS | Không |  |  | Có | TY_LE_GN_CLOS | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 25 | SLHS_TONG | Tổng số lượng hồ sơ phê duyệt | Không |  |  | Có | SLHS_TONG | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 26 | SLGN_TONG | Tổng số lượng hồ sơ giải ngân | Không |  |  | Có | SLGN_TONG | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được |
| 27 | TY_LE_GN_TONG | Tỷ lệ giải ngân tổng | Không |  |  | Có | TY_LE_GN_TONG | FCT_PDTD_KPI_YTD_DAILY | Lên DTM mới tính được (chờ chốt rule) |
