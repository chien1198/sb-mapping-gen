# FCT_PDTD_WORKSTEP_EVENT

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
|  | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
|  | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
|  | WORKSTEP_CODE | VARCHAR2 | Y | 200 | PK | Mã bước xử lý trên workflow |
|  | ENTRYDATE | TIMESTAMP | Y |  | PK | Thời điểm hồ sơ vào bước xử lý |
|  | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_WORKSTEP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_DECISION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | DATASOURCE | VARCHAR2 | Y | 10 |  | RLOS hoặc CLOS |
|  | EXITDATE | TIMESTAMP | N | 100 |  | Thời điểm hồ sơ ra khỏi bước xử lý |
|  | DECISION_CODE | VARCHAR2 | N | 200 |  | Mã quyết định tại bước xử lý |
|  | USERNAME | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý hồ sơ |
|  | REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại bước xử lý |
|  | CREDIT_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
|  | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
|  | REASON_CODE | VARCHAR2 | N | 50 |  | Mã lý do hủy hồ sơ |
|  | REASON_DESC | VARCHAR2 | N | 500 |  | Diễn giải lý do hủy hồ sơ |
|  | TAT_SOURCE_SEC | NUMBER | N | 12 |  | Thời gian xử lý do hệ nguồn ghi, đơn vị giây |
|  | TAT_CALENDAR_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo lịch tự nhiên, đơn vị giờ |
|  | TAT_WORKING_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo giờ làm việc, đơn vị giờ |
|  | TAT_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian xử lý theo giờ cam kết SLA, đơn vị giờ |
|  | EVENT_SEQ_ASC | NUMBER | N | 5 |  | Thứ tự sự kiện theo chiều từ cũ đến mới |
|  | EVENT_SEQ_DESC | NUMBER | N | 5 |  | Thứ tự sự kiện theo chiều từ mới đến cũ |
|  | BI_FLAG_APPROVAL | VARCHAR2 | N | 50 |  | Đánh dấu đây là lần phê duyệt đầu hay lần phê duyệt lại |
|  | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
|  | BI_WORKSTEP | VARCHAR2 | N | 50 |  | Tên bước chuẩn hóa để hiển thị trên báo cáo |
