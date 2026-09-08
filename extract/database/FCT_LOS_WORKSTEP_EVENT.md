# FCT_LOS_WORKSTEP_EVENT

Nguồn: docx section "4.2.2 Bảng FCT_LOS_WORKSTEP_EVENT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | WORKSTEP_CODE | VARCHAR2 | Y | 200 | PK | Mã bước xử lý trên workflow |
| 4 | ENTRYDATE | TIMESTAMP | Y | 18 | PK | Thời điểm hồ sơ vào bước xử lý |
| 5 | WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_WORKSTEP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_DECISION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 8 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 9 | DATASOURCE | VARCHAR2 | Y | 10 |  | Gán theo tuyến bảng nguồn/STG_LOS ('RLOS' hoặc 'CLOS'); hậu tố WI_NAME chỉ là kiểm tra chất lượng |
| 10 | EXITDATE | TIMESTAMP | N |  |  | Thời điểm hồ sơ ra khỏi bước xử lý |
| 11 | DECISION_CODE | VARCHAR2 | N | 200 |  | Mã quyết định tại bước xử lý |
| 12 | USERNAME | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý hồ sơ |
| 13 | REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại bước xử lý |
| 14 | REASON_CODE | VARCHAR2 | N | 50 |  | Mã lý do hủy hồ sơ |
| 15 | REASON_DESC | VARCHAR2 | N | 500 |  | Diễn giải lý do hủy hồ sơ |
| 16 | TAT_SOURCE_SEC | NUMBER | N | 12 |  | Thời gian xử lý do hệ nguồn ghi, đơn vị giây |
| 17 | TAT_CALENDAR_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo lịch tự nhiên, đơn vị giờ |
| 18 | TAT_WORKING_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo giờ làm việc, đơn vị giờ |
| 19 | TAT_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo giờ cam kết SLA, đơn vị giờ |
| 20 | EVENT_SEQ_ASC | NUMBER | N | 5 |  | Thứ tự sự kiện theo chiều từ cũ đến mới |
| 21 | EVENT_SEQ_DESC | NUMBER | N | 5 |  | Thứ tự sự kiện theo chiều từ mới đến cũ |
| 22 | BI_FLAG_APPROVAL | VARCHAR2 | N | 50 |  | Đánh dấu đây là lần phê duyệt đầu hay lần phê duyệt lại |
| 23 | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
