# FCT_LOS_WORKSTEP_EVENT

Nguồn: xlsx sheet "FCT_LOS_WORKSTEP_EVENT" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng sự kiện
- Mô tả: Nhật ký xử lý hồ sơ ở mức nguyên tử: từng lần hồ sơ vào một bước.
- Lưu gì: Lưu mỗi lần hồ sơ đi vào một bước xử lý: người thực hiện, thời gian vào và ra, quyết định đưa ra, ghi chú, và ba thang đo thời gian đã tính sẵn. Một hồ sơ đi qua cùng một bước nhiều lần nếu bị trả đi trả lại, nên khóa phải có thêm mốc thời gian vào bước.
- Grain: 1 dòng = 1 lần hồ sơ vào 1 bước xử lý tại 1 mốc ENTRYDATE
- Khóa: PK = DAYID + WI_NAME + WORKSTEP_CODE + ENTRYDATE
- Quy tắc ghi: Ghi khi phát sinh sự kiện mới hoặc khi sự kiện cũ được cập nhật, ví dụ điền EXITDATE và DECISION lúc hồ sơ rời bước.
- Bảng nguồn CDC: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9, BC10, BC11

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.WINAME / NG_SB_RLOS_ENTRY_EXIT.WINAME (riêng hai bảng ENTRY_EXIT viết là WINAME, các bảng còn lại viết WI_NAME) |
| 3 | WORKSTEP_CODE | VARCHAR2 | 200 | Y | PK | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.WORKSTEP / NG_SB_RLOS_ENTRY_EXIT.WORKSTEP (đổi tên thêm hậu tố CODE), đã cắt tiền tố hệ nguồn nếu có. Trường WORKSTEP của BC3, BC4, BC8 |
| 4 | ENTRYDATE | TIMESTAMP |  | Y | PK | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.ENTRYDATE / NG_SB_RLOS_ENTRY_EXIT.ENTRYDATE. Giữ nguyên tên và giữ đủ giờ phút giây. Bắt buộc nằm trong khóa vì một hồ sơ có thể quay lại cùng một bước nhiều lần. Trường ENTRYDATE của BC3 và BC4 |
| 5 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 6 | WORKSTEP_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_WORKSTEP, lookup theo SYSTEM_CODE và WORKSTEP_CODE |
| 7 | DECISION_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_DECISION, lookup theo SYSTEM_CODE và DECISION_CODE |
| 8 | USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lookup theo USERNAME |
| 9 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 10 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên bản ghi mới nhất của cùng một sự kiện |
| 11 | EXITDATE | TIMESTAMP |  | N |  | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.EXITDATE / NG_SB_RLOS_ENTRY_EXIT.EXITDATE. Giữ nguyên tên. NULL nghĩa là hồ sơ đang nằm tại bước này. Trường EXITDATE của BC3, BC4, BC8 |
| 12 | DECISION_CODE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.DECISION / NG_SB_RLOS_ENTRY_EXIT.DECISION (đổi tên thêm hậu tố CODE). Trường DECISION của BC3 và BC8 |
| 13 | USERNAME | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.USERNAME / NG_SB_RLOS_ENTRY_EXIT.USERNAME. Giữ nguyên tên. Là giá trị của toàn bộ các trường user theo vai trò ở BC1, BC2, BC3, BC4 |
| 14 | REMARKS | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.REMARKS / NG_SB_RLOS_ENTRY_EXIT.REMARKS. Giữ nguyên tên. Trường REMARKS của BC3 và BC4 |
| 15 | REASON_CODE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: NG_SB_RLOS_ENTRY_EXIT.REASON_CODE. Giữ nguyên tên. BA cho biết dùng để chọn lý do đơn vị kinh doanh hủy hồ sơ |
| 16 | REASON_DESC | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_RLOS_ENTRY_EXIT.REASON_DESC. Giữ nguyên tên. BA cho biết là diễn giải lý do hủy, lấy từ bảng NG_SB_RLOS_MAS_REASON |
| 17 | TAT_SOURCE_SEC | NUMBER | 12 | N |  | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.TAT / NG_SB_RLOS_ENTRY_EXIT.TAT (đổi tên thêm hậu tố SEC để ghi rõ đơn vị). BA xác nhận đơn vị nguồn là GIÂY. Giữ lại để đối soát với ba cột tính lại bên dưới |
| 18 | TAT_CALENDAR_MIN | NUMBER | 12,2 | N |  | PHÁI SINH — (CAST(EXITDATE AS DATE) - CAST(ENTRYDATE AS DATE)) * 24 * 60, đơn vị PHÚT. Thời gian theo lịch tự nhiên |
| 19 | TAT_WORKING_MIN | NUMBER | 12,2 | N |  | PHÁI SINH — get_business_minute(ENTRYDATE, EXITDATE), đơn vị PHÚT. Loại trừ ngày lễ, chiều thứ Bảy và cả ngày Chủ nhật; giờ tính từ 8-12 và 13-17 |
| 20 | TAT_CPC_MIN | NUMBER | 12,2 | N |  | PHÁI SINH — get_business_minute_cpc(ENTRYDATE, EXITDATE), đơn vị PHÚT. Giờ theo cam kết SLA, tính từ 8-11:30 và 13:30-16:30 |
| 21 | EVENT_SEQ_ASC | NUMBER | 5 | N |  | PHÁI SINH — ROW_NUMBER() OVER (PARTITION BY WI_NAME ORDER BY ENTRYDATE ASC). Dùng để xác định sự kiện trả về đầu tiên cho BC7 |
| 22 | EVENT_SEQ_DESC | NUMBER | 5 | N |  | PHÁI SINH — ROW_NUMBER() OVER (PARTITION BY WI_NAME ORDER BY ENTRYDATE DESC). Bằng 1 là bản ghi cuối cùng của hồ sơ. Chính là ID_DESC mà BC1 và BC2 đang tự tính để lấy toàn bộ nhóm trường LAST_ |
| 23 | IS_LAST_EVENT | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' khi EVENT_SEQ_DESC = 1, tức bản ghi mới nhất theo ENTRYDATE của hồ sơ. Là điều kiện để lấy toàn bộ nhóm trường có tiền tố LAST_ của BC1 và BC2 |
| 24 | IS_RETURN_EVENT | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu DECISION_CODE thuộc nhóm trả về (DIM_LOS_DECISION.IS_RETURN = 'Y') |
| 25 | IS_APPROVAL_EVENT | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu WORKSTEP_CODE thuộc ('CreditApproval','CreditCommittee') và DECISION_CODE thuộc nhóm phê duyệt |
| 26 | BI_FLAG_APPROVAL | VARCHAR2 | 50 | N |  | PHÁI SINH — 'First Approval' nếu EXITDATE <= MIN(EXITDATE của các sự kiện phê duyệt trong cùng hồ sơ), ngược lại 'From Second Approval'. Trường BI_FLAG_APPROVAL của BC5 |
| 27 | PRE_WORKSTEP_CODE | VARCHAR2 | 200 | N |  | PHÁI SINH — LAG(WORKSTEP_CODE) OVER (PARTITION BY WI_NAME ORDER BY ENTRYDATE) |
