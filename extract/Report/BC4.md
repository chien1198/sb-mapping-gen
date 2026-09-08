# BC4 — TRUY VẾT TỪNG TRƯỜNG BÁO CÁO VỀ DWH VÀ DTM

Nguồn: xlsx sheet "BC4" (Reports_20260907.xlsx)

Trường đích lấy từ SRS bản 25/08, giữ đúng thứ tự. Cột Luồng dữ liệu cho biết trường đó đã có sẵn ở DWH rồi kéo lên, hay phải lên DTM mới tính được.

| STT | Tên cột trên báo cáo | Ý nghĩa cột trên báo cáo | Có ở DWH | Tên cột ở DWH | Tên bảng ở DWH | Có ở DTM | Tên cột ở DTM | Tên bảng ở DTM | Luồng dữ liệu |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | REPORT_WEEK | Tuần báo cáo | Không |  |  | Có | REPORT_WEEK | DIM_DATE | Lên DTM mới tính được |
| 2 | REPORT_DATE | Ngày báo cáo | Có | DAYID / PROCESSED_DATE_UWM | FCT_LOS_APPLICATION_DAILY | Có | DAYID / PROCESSED_DATE_UWM | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 3 | SYSTEMNAME | Hệ thống (CLOS/RLOS) | Có | SYSTEM_CODE | DIM_LOS_APPLICATION / FCT_LOS_APPLICATION_DAILY | Có | SYSTEM_CODE | DIM_PDTD_APPLICATION / FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_APPLICATION_PARTY | Có ở DWH, kéo lên DTM |
| 4 | WINAME | Mã hồ sơ | Có | WI_NAME | DIM_LOS_APPLICATION / FCT_LOS_WORKSTEP_EVENT | Có | WI_NAME | DIM_PDTD_APPLICATION / FCT_PDTD_APPLICATION_MILESTONE / FCT_PDTD_KPI_APPLICATION | Có ở DWH, kéo lên DTM |
| 5 | CUSTOMER_NAME | Tên khách hàng | Có | FULL_NAME | FCT_LOS_APPLICATION_PARTY | Có | FULL_NAME | FCT_PDTD_APPLICATION_PARTY | Có ở DWH, kéo lên DTM |
| 6 | WORKSTEP | Bước hồ sơ | Có | DECISION_SK / WORKSTEP_CODE | DIM_LOS_WORKSTEP / FCT_LOS_WORKSTEP_EVENT | Có | DECISION_SK / WORKSTEP / WORKSTEP_CODE | DIM_PDTD_WORKSTEP / FCT_PDTD_WORKSTEP_EVENT / Q_RLOS_REF_WORKSTEP_2SYSTEMS | Có ở DWH, kéo lên DTM |
| 7 | UND_MAKER | User Chuyên viên thẩm định | Có | USERNAME | FCT_LOS_WORKSTEP_EVENT | Có | USERNAME | FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 8 | ENTRYDATE | Thời gian lên bước thẩm định | Có | ENTRYDATE | FCT_LOS_WORKSTEP_EVENT | Có | ENTRYDATE | FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 9 | EXITDATE | Thời gian kết thúc bước thẩm định | Có | EXITDATE | FCT_LOS_WORKSTEP_EVENT | Có | EXITDATE | FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 10 | FLAG | Trạng thái | Có | CURRENT_WORKSTEP_SK | FCT_LOS_APPLICATION_DAILY | Có | CURRENT_WORKSTEP_SK | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 11 | REMARKS | Ghi chú | Có | REMARKS | FCT_LOS_WORKSTEP_EVENT | Có | REMARKS | FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
