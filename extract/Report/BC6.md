# BC6 — TRUY VẾT TỪNG TRƯỜNG BÁO CÁO VỀ DWH VÀ DTM

Nguồn: xlsx sheet "BC6" (Reports_20260907.xlsx)

Trường đích lấy từ SRS bản 25/08, giữ đúng thứ tự. Cột Luồng dữ liệu cho biết trường đó đã có sẵn ở DWH rồi kéo lên, hay phải lên DTM mới tính được.

| STT | Tên cột trên báo cáo | Ý nghĩa cột trên báo cáo | Có ở DWH | Tên cột ở DWH | Tên bảng ở DWH | Có ở DTM | Tên cột ở DTM | Tên bảng ở DTM | Luồng dữ liệu |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | WI_NAME | Mã hồ sơ | Có | WI_NAME | DIM_LOS_APPLICATION / FCT_LOS_APPLICATION_DAILY / FCT_LOS_DEVIATION | Có | WI_NAME | DIM_PDTD_APPLICATION / FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_APPLICATION_MILESTONE | Có ở DWH, kéo lên DTM |
| 2 | DEVIATION_TYPE | Loại ngoại lệ | Có | DEVIATION_TYPE_CODE | FCT_LOS_DEVIATION | Có | DEVIATION_TYPE_CODE | FCT_PDTD_DEVIATION | Có ở DWH, kéo lên DTM |
| 3 | DEV_PROPOSAL | Nội dung ngoại lệ | Có | DEV_PROPOSAL | FCT_LOS_DEVIATION | Có | DEV_PROPOSAL | FCT_PDTD_DEVIATION | Có ở DWH, kéo lên DTM |
| 4 | PROCESSED_DATE | Ngày dữ liệu báo cáo | Có | PROCESSED_DATE | FCT_LOS_APPLICATION_DAILY | Có | PROCESSED_DATE | FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_DEVIATION / FCT_PDTD_EXCEPTION | Có ở DWH, kéo lên DTM |
| 5 | CHECKING_RESULT | Loại ngoại lệ | Có | CHECKING_RESULT | FCT_LOS_DEVIATION | Có | CHECKING_RESULT | FCT_PDTD_DEVIATION | Có ở DWH, kéo lên DTM |
| 6 | CHECKING_CONDITION | Tiêu chí ngoại lệ | Có | CHECKING_CONDITION | FCT_LOS_DEVIATION | Có | CHECKING_CONDITION | FCT_PDTD_DEVIATION | Có ở DWH, kéo lên DTM |
| 7 | REASON | Nội dung ngoại lệ | Có | DEVIATION_REASON | FCT_LOS_DEVIATION | Có | DEVIATION_REASON | FCT_PDTD_DEVIATION | Có ở DWH, kéo lên DTM |
