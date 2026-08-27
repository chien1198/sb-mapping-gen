# FCT_LOS_EXCEPTION

Nguồn: xlsx sheet "FCT_LOS_EXCEPTION" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: FCT - bảng sự kiện
- Mô tả: Từng lần ghi nhận lý do khi hồ sơ chuyển bước, bị trả về hoặc yêu cầu bổ sung.
- Lưu gì: Lưu mỗi lần một lý do được nêu ra. BA giải thích cơ chế: bước trả về chọn Raise để đưa ra lý do, bước nhận chọn Clear khi đã làm rõ hoặc bổ sung và đẩy lại. Một hồ sơ có thể phát sinh cùng một loại lý do nhiều lần, bởi nhiều người, ở nhiều thời điểm, nên khóa phải đủ để phân biệt từng lần.
- Grain: 1 dòng = 1 PHIÊN BẢN của 1 lần ghi nhận lý do. DAYID là ngày phiên bản đó được ghi, KHÔNG phải ảnh chụp lại toàn bộ mỗi ngày
- Khóa: PK = DAYID + WI_NAME + EXCEPTION_BK
- Quy tắc load: Ghi khi lý do được nêu ra hoặc khi nội dung lý do được cập nhật. Bảng này GHI KHI CÓ THAY ĐỔI, không chép lại toàn bộ mỗi ngày, nên KHÔNG được lọc WHERE DAYID = :ngay — làm vậy sẽ mất hết các dòng không đổi trong ngày đó. CÁCH ĐỌC ĐÚNG để lấy trạng thái tại ngày D: ROW_NUMBER() OVER (PARTITION BY WI_NAME, EXCEPTION_BK ORDER BY DAYID DESC) với điều kiện DAYID <= :ngay, rồi lấy dòng thứ nhất. Cách này cho lại đúng trạng thái của mọi ngày trong quá khứ.
- Nguồn: NG_SB_CLOS_EXCEPTION, NG_SB_RLOS_EXCEPTION
- Báo cáo sử dụng: BC7, BC8

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE |  | Y | PK | KỸ THUẬT |  |  | (phân vùng theo ngày dữ liệu) | DA_CHOT | KỸ THUẬT — Ngày dữ liệu, kiểu DATE đã TRUNC về 00:00:00. Đây là ngày ảnh chụp số liệu, KHÔNG phải ngày nghiệp vụ. Ở bảng này DAYID là NGÀY GHI PHIÊN BẢN, không phải ngày ảnh chụp toàn bộ; xem Quy tắc ghi để biết cách lấy trạng thái tại một ngày. |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | WI_NAME | BC7.WI_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.WI_NAME / NG_SB_RLOS_EXCEPTION.WI_NAME. Giữ nguyên tên cột nguồn. Trường WI_NAME của BC7 |
| 3 | EXCEPTION_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT |  |  | (khóa dòng lý do) | CHO_RULE_BA | CHƯA CHỐT — Khóa nghiệp vụ định danh một lần ghi nhận lý do. Metadata đề xuất ghép EXCEPTION_CATEGORY + EXCEPTION_NAME + RAISED_BY + RAISED_DATE_TIME; database môi trường dev lại đang sinh cột RECID. Danh sách CDC đang hỏi BA/DEV chọn phương án nào. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 5 | EXCEPTION_REASON_SK | NUMBER | 18 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_EXCEPTION_REASON, lấy tên bước phát sinh và cờ vi phạm First Time Right |
| 6 | RAISED_BY_USER_SK | NUMBER | 18 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_USER, lookup theo RAISED_BY |
| 7 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | EXCEPTION_CATEGORY | BC7.EXCEPTION_CATEGORY | DA_CHOT | PHÁI SINH — Gán theo tuyến bảng EXCEPTION nguồn/STG_LOS; hậu tố WI_NAME chỉ dùng kiểm tra. |
| 8 | EXCEPTION_CATEGORY | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | EXCEPTION_CATEGORY | BC7.EXCEPTION_CATEGORY | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.EXCEPTION_CATEGORY / NG_SB_RLOS_EXCEPTION.EXCEPTION_CATEGORY. Giữ nguyên tên. Trường EXCEPTION_CATEGORY của BC7 |
| 9 | EXCEPTION_NAME | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | EXCEPTION_NAME | BC7.EXCEPTION_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.EXCEPTION_NAME / NG_SB_RLOS_EXCEPTION.EXCEPTION_NAME. Giữ nguyên tên. Trường EXCEPTION_NAME của BC7 |
| 10 | EXCEPTION_REMARKS | VARCHAR2 | 4000 | N |  | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | EXCEPTION_REMARKS | BC7.EXCEPTION_REMARKS | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.EXCEPTION_REMARKS / NG_SB_RLOS_EXCEPTION.EXCEPTION_REMARKS. Giữ nguyên tên. Trường EXCEPTION_REMARKS của BC7 |
| 11 | RAISED_BY | VARCHAR2 | 100 | N |  | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | RAISED_BY | BC7.RAISED_BY | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.RAISED_BY / NG_SB_RLOS_EXCEPTION.RAISED_BY. Giữ nguyên tên. Trường RAISED_BY của BC7 |
| 12 | RAISED_DATE_TIME | TIMESTAMP |  | N |  | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | RAISED_DATE_TIME | BC7.RAISED_DATE_TIME; BC7.PROCESSED_DATE | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.RAISED_DATE_TIME / NG_SB_RLOS_EXCEPTION.RAISED_DATE_TIME. Giữ nguyên tên. BC7 lọc dữ liệu theo cột này |
| 13 | RCTYPE | VARCHAR2 | 20 | N |  | 1:1 | NG_SB_CLOS_EXCEPTION / NG_SB_RLOS_EXCEPTION | RCTYPE | (điều kiện lọc BC7.CHECK_FTR) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXCEPTION.RCTYPE / NG_SB_RLOS_EXCEPTION.RCTYPE. Giữ nguyên tên. BA giải thích Raise là lúc nêu lý do khi trả về, Clear là lúc bước nhận đã bổ sung và đẩy lại |
