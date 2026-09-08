# FCT_PDTD_KPI_YTD_DAILY

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | QUY_DOI_RLOS_DAY | NUMBER | N | 14,4 |  | Tổng điểm KPI quy đổi của hồ sơ RLOS, phần PHÁT SINH TRONG NGÀY |
| 3 | QUY_DOI_CLOS_DAY | NUMBER | N | 14,4 |  | Tổng điểm KPI quy đổi của hồ sơ CLOS, phần PHÁT SINH TRONG NGÀY |
| 4 | NEW_USER_CNT_DAY | NUMBER | N | 8 |  | Số người xử lý mới được tính vào nhân sự, phần PHÁT SINH TRONG NGÀY |
| 5 | SLHS_RLOS_DAY | NUMBER | N | 12 |  | Số hồ sơ RLOS được phê duyệt, phần PHÁT SINH TRONG NGÀY |
| 6 | SLHS_CLOS_DAY | NUMBER | N | 12 |  | Số hồ sơ CLOS được phê duyệt, phần PHÁT SINH TRONG NGÀY |
| 7 | SLGN_RLOS_DAY | NUMBER | N | 12 |  | Số hồ sơ RLOS đã giải ngân, phần PHÁT SINH TRONG NGÀY |
| 8 | SLGN_CLOS_DAY | NUMBER | N | 12 |  | Số hồ sơ CLOS đã giải ngân, phần PHÁT SINH TRONG NGÀY |
| 9 | TAT_RLOS_SEC_SUM_HOUR_DAY | NUMBER | N | 18,6 |  | Tổng thời gian xử lý của hồ sơ RLOS CÓ tài sản bảo đảm, đơn vị giờ, phần PHÁT SINH TRONG NGÀY |
| 10 | TAT_RLOS_SEC_CASE_CNT_DAY | NUMBER | N | 12 |  | Số hồ sơ RLOS có tài sản bảo đảm, là mẫu số tính thời gian trung bình, phần PHÁT SINH TRONG NGÀY |
| 11 | TAT_RLOS_UNSEC_SUM_HOUR_DAY | NUMBER | N | 18,6 |  | Tổng thời gian xử lý của hồ sơ RLOS KHÔNG có tài sản bảo đảm, đơn vị giờ, phần PHÁT SINH TRONG NGÀY |
| 12 | TAT_RLOS_UNSEC_CASE_CNT_DAY | NUMBER | N | 12 |  | Số hồ sơ RLOS không có tài sản bảo đảm, là mẫu số, phần PHÁT SINH TRONG NGÀY |
| 13 | TAT_CLOS_SUM_HOUR_DAY | NUMBER | N | 18,6 |  | Tổng thời gian xử lý của hồ sơ CLOS, đơn vị giờ, phần PHÁT SINH TRONG NGÀY |
| 14 | TAT_CLOS_CASE_CNT_DAY | NUMBER | N | 12 |  | Số hồ sơ CLOS, là mẫu số tính thời gian trung bình, phần PHÁT SINH TRONG NGÀY |
| 15 | TAT_RLOS_SEC_SUM_HOUR_YTD | NUMBER | N | 20,6 |  | Tổng thời gian xử lý của hồ sơ RLOS CÓ tài sản bảo đảm, đơn vị giờ, LŨY KẾ TỪ ĐẦU NĂM |
| 16 | TAT_RLOS_SEC_CASE_CNT_YTD | NUMBER | N | 14 |  | Số hồ sơ RLOS có tài sản bảo đảm, là mẫu số tính thời gian trung bình, LŨY KẾ TỪ ĐẦU NĂM |
| 17 | TAT_RLOS_UNSEC_SUM_HOUR_YTD | NUMBER | N | 20,6 |  | Tổng thời gian xử lý của hồ sơ RLOS KHÔNG có tài sản bảo đảm, đơn vị giờ, LŨY KẾ TỪ ĐẦU NĂM |
| 18 | TAT_RLOS_UNSEC_CASE_CNT_YTD | NUMBER | N | 14 |  | Số hồ sơ RLOS không có tài sản bảo đảm, là mẫu số, LŨY KẾ TỪ ĐẦU NĂM |
| 19 | TAT_CLOS_SUM_HOUR_YTD | NUMBER | N | 20,6 |  | Tổng thời gian xử lý của hồ sơ CLOS, đơn vị giờ, LŨY KẾ TỪ ĐẦU NĂM |
| 20 | TAT_CLOS_CASE_CNT_YTD | NUMBER | N | 14 |  | Số hồ sơ CLOS, là mẫu số tính thời gian trung bình, LŨY KẾ TỪ ĐẦU NĂM |
| 21 | TAT_RLOS | NUMBER | N | 18,6 |  | Thời gian xử lý trung bình của hồ sơ RLOS, đơn vị giờ |
| 22 | TAT_CLOS | NUMBER | N | 18,6 |  | Thời gian xử lý trung bình của hồ sơ CLOS, đơn vị giờ |
| 23 | TAT_TB | NUMBER | N | 18,6 |  | Thời gian xử lý trung bình chung hai hệ, đơn vị giờ |
| 24 | QUY_DOI_RLOS | NUMBER | N | 16,4 |  | Điểm KPI RLOS quy đổi |
| 25 | QUY_DOI_CLOS | NUMBER | N | 16,4 |  | Điểm KPI CLOS quy đổi |
| 26 | NHAN_SU | NUMBER | N | 8 |  | Số nhân sự trong tháng |
| 27 | NSLD | NUMBER | N | 16,4 |  | NSLĐ Khối PDTD |
| 28 | SLHS_RLOS | NUMBER | N | 14 |  | Số lượng hồ sơ phê duyệt RLOS |
| 29 | SLGN_RLOS | NUMBER | N | 14 |  | Số lượng hồ sơ giải ngân RLOS |
| 30 | TY_LE_GN_RLOS | NUMBER | N | 9,4 |  | Tỷ lệ giải ngân RLOS |
| 31 | SLHS_CLOS | NUMBER | N | 14 |  | Số lượng hồ sơ phê duyệt CLOS |
| 32 | SLGN_CLOS | NUMBER | N | 14 |  | Số lượng hồ sơ giải ngân CLOS |
| 33 | TY_LE_GN_CLOS | NUMBER | N | 9,4 |  | Tỷ lệ giải ngân CLOS |
| 34 | SLHS_TONG | NUMBER | N | 14 |  | Tổng số lượng hồ sơ phê duyệt |
| 35 | SLGN_TONG | NUMBER | N | 14 |  | Tổng số lượng hồ sơ giải ngân |
| 36 | TY_LE_GN_TONG | NUMBER | N | 9,4 |  | Tỷ lệ giải ngân tổng |
