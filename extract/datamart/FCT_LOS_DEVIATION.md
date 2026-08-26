# FCT_LOS_DEVIATION

Nguồn: xlsx sheet "FCT_LOS_DEVIATION" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng chi tiết
- Mô tả: Các điều kiện chính sách bị lệch được ghi nhận trên hồ sơ.
- Lưu gì: Lưu từng ngoại lệ chính sách của hồ sơ kèm tiêu chí kiểm tra, kết quả và nội dung đề xuất chấp thuận. BC6 cần danh sách chi tiết, còn BC5 và BC9 chỉ cần số đếm theo ngưỡng 2 và 3 - số đếm đó đã cộng sẵn lên bảng hồ sơ. Đây là bảng có rủi ro khóa cao nhất trong model.
- Grain: 1 dòng = 1 ngoại lệ chính sách trên 1 hồ sơ x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME + DEVIATION_BK
- Quy tắc ghi: Ghi khi ngoại lệ mới được ghi nhận hoặc nội dung ngoại lệ thay đổi.
- Bảng nguồn CDC: NG_SB_CLOS_CONDITON_CDGRID, NG_SB_RLOS_MANUAL_DEVIATION
- Báo cáo sử dụng: BC5, BC6, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.WI_NAME / NG_SB_RLOS_MANUAL_DEVIATION.WI_NAME. Giữ nguyên tên cột nguồn. Trường WI_NAME của BC6 |
| 3 | DEVIATION_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT — Khóa nghiệp vụ định danh một dòng ngoại lệ. Đây là điểm rủi ro cao nhất: BA xác nhận một hồ sơ có thể có nhiều ngoại lệ cùng loại, bảng CLOS chỉ có 4 cột và không cột nào định danh được dòng, RLOS đã kiểm tra trên database thấy tổ hợp WI_NAME + CHECKING_CONDITION không duy nhất. Phương án dự phòng: CDC theo toàn bộ cột và bắt buộc mang ROWID nguồn về STG_LOS. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 5 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 6 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất |
| 7 | DEVIATION_TYPE_CODE | VARCHAR2 | 300 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.DEVIATION_TYPE (đổi tên thêm hậu tố CODE). Trường DEVIATION_TYPE của BC6 phía CLOS |
| 8 | CHECKING_CONDITION | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_RLOS_MANUAL_DEVIATION.CHECKING_CONDITION. Giữ nguyên tên. Trường CHECKING_CONDITION của BC6 |
| 9 | CHECKING_RESULT | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_MANUAL_DEVIATION.CHECKING_RESULT. Giữ nguyên tên. Trường CHECKING_RESULT của BC6 |
| 10 | DEVIATION_REASON | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_RLOS_MANUAL_DEVIATION.REASON (đổi tên cho rõ nghĩa vì tên gốc quá chung). Trường REASON của BC6 |
| 11 | DEV_PROPOSAL | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.DEV_PROPOSAL. Giữ nguyên tên. Trường DEV_PROPOSAL của BC6 và BC2 |
| 12 | AS_REGULAR | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.AS_REGULAR. Giữ nguyên tên. Quy định chuẩn liên quan, thường trích số quyết định nội bộ. Không báo cáo nào hiển thị nhưng phải nạp vì BA đề xuất đưa cột này vào khóa nghiệp vụ của bảng |
