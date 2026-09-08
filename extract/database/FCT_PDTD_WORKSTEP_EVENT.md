# FCT_PDTD_WORKSTEP_EVENT

Nguồn: docx section "4.4.2 Bảng FCT_PDTD_WORKSTEP_EVENT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | WORKSTEP_CODE | VARCHAR2 | Y | 200 | PK | Mã bước xử lý trên workflow |
| 4 | ENTRYDATE | TIMESTAMP | Y |  | PK | Thời điểm hồ sơ vào bước xử lý |
| 5 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_WORKSTEP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_DECISION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 8 | USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 9 | DATASOURCE | VARCHAR2 | Y | 10 |  | RLOS hoặc CLOS |
| 10 | EXITDATE | TIMESTAMP | N | 100 |  | Thời điểm hồ sơ ra khỏi bước xử lý |
| 11 | DECISION_CODE | VARCHAR2 | N | 200 |  | Mã quyết định tại bước xử lý |
| 12 | USERNAME | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý hồ sơ |
| 13 | REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại bước xử lý |
| 14 | CREDIT_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
| 15 | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
| 16 | REASON_CODE | VARCHAR2 | N | 50 |  | Mã lý do hủy hồ sơ |
| 17 | REASON_DESC | VARCHAR2 | N | 500 |  | Diễn giải lý do hủy hồ sơ |
| 18 | TAT_SOURCE_SEC | NUMBER | N | 12 |  | Thời gian xử lý do hệ nguồn ghi, đơn vị giây |
| 19 | TAT_CALENDAR_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo lịch tự nhiên, đơn vị giờ |
| 20 | TAT_WORKING_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo giờ làm việc, đơn vị giờ |
| 21 | TAT_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo giờ cam kết SLA, đơn vị giờ |
| 22 | EVENT_SEQ_ASC | NUMBER | N | 5 |  | Thứ tự sự kiện theo chiều từ cũ đến mới |
| 23 | EVENT_SEQ_DESC | NUMBER | N | 5 |  | Thứ tự sự kiện theo chiều từ mới đến cũ |
| 24 | BI_FLAG_APPROVAL | VARCHAR2 | N | 50 |  | Đánh dấu đây là lần phê duyệt đầu hay lần phê duyệt lại |
| 25 | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
| 26 | BI_WORKSTEP | VARCHAR2 | N | 50 |  | Tên bước chuẩn hóa để hiển thị trên báo cáo |
