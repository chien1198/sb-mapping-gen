# FCT_LOS_EXCEPTION

Nguồn: xlsx sheet "FCT_LOS_EXCEPTION" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng sự kiện
- Mô tả: Từng lần ghi nhận lý do khi hồ sơ chuyển bước, bị trả về hoặc yêu cầu bổ sung.
- Lưu gì: Lưu mỗi lần một lý do được nêu ra. BA giải thích cơ chế: bước trả về chọn Raise để đưa ra lý do, bước nhận chọn Clear khi đã làm rõ hoặc bổ sung và đẩy lại. Một hồ sơ có thể phát sinh cùng một loại lý do nhiều lần, bởi nhiều người, ở nhiều thời điểm, nên khóa phải đủ để phân biệt từng lần.
- Grain: 1 dòng = 1 lần ghi nhận lý do trên 1 hồ sơ x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME + EXCEPTION_BK
- Quy tắc ghi: Ghi khi lý do được nêu ra hoặc khi nội dung lý do được cập nhật.
- Bảng nguồn CDC: NG_SB_CLOS_EXCEPTION, NG_SB_RLOS_EXCEPTION
- Báo cáo sử dụng: BC7, BC8

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.WI_NAME / NG_SB_RLOS_EXCEPTION.WI_NAME. Giữ nguyên tên cột nguồn. Trường WI_NAME của BC7 |
| 3 | EXCEPTION_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT — Khóa nghiệp vụ định danh một lần ghi nhận lý do. Metadata đề xuất ghép EXCEPTION_CATEGORY + EXCEPTION_NAME + RAISED_BY + RAISED_DATE_TIME; database môi trường dev lại đang sinh cột RECID. Danh sách CDC đang hỏi BA/DEV chọn phương án nào. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 5 | EXCEPTION_REASON_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_EXCEPTION_REASON, lấy tên bước phát sinh và cờ vi phạm First Time Right |
| 6 | RAISED_BY_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lookup theo RAISED_BY |
| 7 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 8 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất |
| 9 | EXCEPTION_CATEGORY | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.EXCEPTION_CATEGORY / NG_SB_RLOS_EXCEPTION.EXCEPTION_CATEGORY. Giữ nguyên tên. Trường EXCEPTION_CATEGORY của BC7 |
| 10 | EXCEPTION_NAME | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.EXCEPTION_NAME / NG_SB_RLOS_EXCEPTION.EXCEPTION_NAME. Giữ nguyên tên. Trường EXCEPTION_NAME của BC7 |
| 11 | EXCEPTION_CODE | VARCHAR2 | 50 | N |  | PHÁI SINH — REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có. Trường EXCEPTION_CODE của BC7 |
| 12 | EXCEPTION_REMARKS | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.EXCEPTION_REMARKS / NG_SB_RLOS_EXCEPTION.EXCEPTION_REMARKS. Giữ nguyên tên. Trường EXCEPTION_REMARKS của BC7 |
| 13 | RAISED_BY | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.RAISED_BY / NG_SB_RLOS_EXCEPTION.RAISED_BY. Giữ nguyên tên. Trường RAISED_BY của BC7 |
| 14 | RAISED_DATE_TIME | TIMESTAMP |  | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.RAISED_DATE_TIME / NG_SB_RLOS_EXCEPTION.RAISED_DATE_TIME. Giữ nguyên tên. BC7 lọc dữ liệu theo cột này |
| 15 | RCTYPE | VARCHAR2 | 20 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.RCTYPE / NG_SB_RLOS_EXCEPTION.RCTYPE. Giữ nguyên tên. BA giải thích Raise là lúc nêu lý do khi trả về, Clear là lúc bước nhận đã bổ sung và đẩy lại |
| 16 | IS_FTR_BREAK | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu RCTYPE='Raise' và lý do thuộc danh mục vi phạm First Time Right (DIM_LOS_EXCEPTION_REASON.IS_FTR_VIOLATION='Y'). Gộp quy tắc mà CLOS và RLOS đang viết khác nhau về một định nghĩa; là căn cứ cho trường CHECK_FTR của BC7 |
| 17 | IS_DRAFT_SEND | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu EXCEPTION_NAME hoặc EXCEPTION_CATEGORY thuộc nhóm gửi dự thảo ('Gửi dự thảo đề xuất cho chi nhánh', 'UW-BR-FTR: Gửi dự thảo phê duyệt TD', 'CK-BR: Gửi dự thảo về ĐVKD'). BC8 phải trừ các lần này khỏi số lần return tại chốt thẩm định |
