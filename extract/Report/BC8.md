# BC8 — TRUY VẾT TỪNG TRƯỜNG BÁO CÁO VỀ DWH VÀ DTM

Nguồn: xlsx sheet "BC8" (Reports_20260907.xlsx)

Trường đích lấy từ SRS bản 25/08, giữ đúng thứ tự. Cột Luồng dữ liệu cho biết trường đó đã có sẵn ở DWH rồi kéo lên, hay phải lên DTM mới tính được.

| STT | Tên cột trên báo cáo | Ý nghĩa cột trên báo cáo | Có ở DWH | Tên cột ở DWH | Tên bảng ở DWH | Có ở DTM | Tên cột ở DTM | Tên bảng ở DTM | Luồng dữ liệu |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | PROCESSED_DATE | Ngày dữ liệu | Có | PROCESSED_DATE | FCT_LOS_APPLICATION_DAILY | Có | PROCESSED_DATE | FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_DEVIATION / FCT_PDTD_EXCEPTION | Có ở DWH, kéo lên DTM |
| 2 | WI_NAME | Mã hồ sơ | Có | WI_NAME | DIM_LOS_APPLICATION / FCT_LOS_APPLICATION_DAILY | Có | WI_NAME | DIM_PDTD_APPLICATION / FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_APPLICATION_MILESTONE | Có ở DWH, kéo lên DTM |
| 3 | WORKSTEP | Bước hồ sơ | Có | WORKSTEP_CODE | FCT_LOS_WORKSTEP_EVENT | Có | WORKSTEP_CODE | DIM_PDTD_WORKSTEP / FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 4 | decision | Quyết định | Có | DECISION_CODE | DIM_LOS_DECISION / FCT_LOS_WORKSTEP_EVENT | Có | DECISION_CODE | DIM_PDTD_DECISION / FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 5 | exitdate | Thời gian tạo quyết định => thời gian eu tạo quyết định tương ứng | Có | EXITDATE | FCT_LOS_WORKSTEP_EVENT | Có | EXITDATE | FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 6 | sl_return_nhaplieu | Số lần return tại Nhập liệu => đếm số lần hồ sơ có Decision = Send Back tại bước Detail Data Entry + Decision = Additional Doc Required tại bước Data Inputer Checker | Có | RETURN_CNT_DATAENTRY | FCT_LOS_APPLICATION_DAILY | Có | RETURN_CNT_DATAENTRY | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 7 | sl_return_thamdinh | Số lần return tại Thẩm định => Cộng tổng số lần return tại bước Underwriter Maker + Underwriter Checker | Có | RETURN_CNT_UNDERWRITING | FCT_LOS_APPLICATION_DAILY | Có | RETURN_CNT_UNDERWRITING | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 8 | sl_return_pheduyet | Số lần return tại Cấp Phê duyệt | Có | RETURN_CNT_APPROVAL | FCT_LOS_APPLICATION_DAILY | Có | RETURN_CNT_APPROVAL | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
