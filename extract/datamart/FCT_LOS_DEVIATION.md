# FCT_LOS_DEVIATION

Nguồn: xlsx sheet "FCT_LOS_DEVIATION" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: FCT - bảng chi tiết
- Mô tả: Các điều kiện chính sách bị lệch được ghi nhận trên hồ sơ.
- Lưu gì: Lưu từng ngoại lệ chính sách của hồ sơ kèm tiêu chí kiểm tra, kết quả và nội dung đề xuất chấp thuận. BC6 cần danh sách chi tiết, còn BC5 và BC9 chỉ cần số đếm theo ngưỡng 2 và 3 - số đếm đó đã cộng sẵn lên bảng hồ sơ. Đây là bảng có rủi ro khóa cao nhất trong model.
- Grain: 1 dòng = 1 PHIÊN BẢN của 1 ngoại lệ chính sách. DAYID là ngày phiên bản đó được ghi, KHÔNG phải ảnh chụp lại toàn bộ mỗi ngày
- Khóa: PK = DAYID + WI_NAME + DEVIATION_BK
- Quy tắc load: Ghi khi ngoại lệ mới được ghi nhận hoặc nội dung ngoại lệ thay đổi. Bảng này GHI KHI CÓ THAY ĐỔI, không chép lại toàn bộ mỗi ngày, nên KHÔNG được lọc WHERE DAYID = :ngay — làm vậy sẽ mất hết các dòng không đổi trong ngày đó. CÁCH ĐỌC ĐÚNG để lấy trạng thái tại ngày D: ROW_NUMBER() OVER (PARTITION BY WI_NAME, DEVIATION_BK ORDER BY DAYID DESC) với điều kiện DAYID <= :ngay, rồi lấy dòng thứ nhất. Cách này cho lại đúng trạng thái của mọi ngày trong quá khứ.
- Nguồn: NG_SB_CLOS_CONDITON_CDGRID, NG_SB_RLOS_MANUAL_DEVIATION
- Báo cáo sử dụng: BC5, BC6, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE |  | Y | PK | KỸ THUẬT |  |  | (phân vùng theo ngày dữ liệu) | DA_CHOT | KỸ THUẬT — Ngày dữ liệu, kiểu DATE đã TRUNC về 00:00:00. Đây là ngày ảnh chụp số liệu, KHÔNG phải ngày nghiệp vụ. Ở bảng này DAYID là NGÀY GHI PHIÊN BẢN, không phải ngày ảnh chụp toàn bộ; xem Quy tắc ghi để biết cách lấy trạng thái tại một ngày. |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 | NG_SB_CLOS_CONDITON_CDGRID / NG_SB_RLOS_MANUAL_DEVIATION | WI_NAME | BC6.WI_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.WI_NAME / NG_SB_RLOS_MANUAL_DEVIATION.WI_NAME. Giữ nguyên tên cột nguồn. Trường WI_NAME của BC6 |
| 3 | DEVIATION_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT |  |  | (khóa dòng ngoại lệ) | CHO_RULE_BA | CHƯA CHỐT — Khóa nghiệp vụ định danh một dòng ngoại lệ. Đây là điểm rủi ro cao nhất: BA xác nhận một hồ sơ có thể có nhiều ngoại lệ cùng loại, bảng CLOS chỉ có 4 cột và không cột nào định danh được dòng, RLOS đã kiểm tra trên database thấy tổ hợp WI_NAME + CHECKING_CONDITION không duy nhất. Phương án dự phòng: CDC theo toàn bộ cột và bắt buộc bật ảnh trước của bản ghi UPDATE để nối được về dòng khai sinh. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 5 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Gán theo tuyến bảng deviation nguồn/STG_LOS; hậu tố WI_NAME chỉ dùng kiểm tra. |
| 6 | DEVIATION_TYPE_CODE | VARCHAR2 | 300 | N |  | 1:1 | NG_SB_CLOS_CONDITON_CDGRID | DEVIATION_TYPE | BC6.DEVIATION_TYPE | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.DEVIATION_TYPE (đổi tên thêm hậu tố CODE). Trường DEVIATION_TYPE của BC6 phía CLOS |
| 7 | CHECKING_CONDITION | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_RLOS_MANUAL_DEVIATION | CHECKING_CONDITION | BC6.CHECKING_CONDITION | DA_CHOT | 1:1 — Nguồn: NG_SB_RLOS_MANUAL_DEVIATION.CHECKING_CONDITION. Giữ nguyên tên. Trường CHECKING_CONDITION của BC6 |
| 8 | CHECKING_RESULT | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_RLOS_MANUAL_DEVIATION | CHECKING_RESULT | BC6.CHECKING_RESULT | DA_CHOT | 1:1 — Nguồn: NG_SB_RLOS_MANUAL_DEVIATION.CHECKING_RESULT. Giữ nguyên tên. Trường CHECKING_RESULT của BC6 |
| 9 | DEVIATION_REASON | VARCHAR2 | 4000 | N |  | 1:1 | NG_SB_RLOS_MANUAL_DEVIATION | REASON | BC6.REASON | DA_CHOT | 1:1 — Nguồn: NG_SB_RLOS_MANUAL_DEVIATION.REASON (đổi tên cho rõ nghĩa vì tên gốc quá chung). Trường REASON của BC6 |
| 10 | DEV_PROPOSAL | VARCHAR2 | 4000 | N |  | 1:1 | NG_SB_CLOS_CONDITON_CDGRID | DEV_PROPOSAL | BC6.DEV_PROPOSAL; BC2.DEV_PROPOSAL | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.DEV_PROPOSAL. Giữ nguyên tên. Trường DEV_PROPOSAL của BC6 và BC2 |
| 11 | AS_REGULAR | VARCHAR2 | 4000 | N |  | 1:1 | NG_SB_CLOS_CONDITON_CDGRID | AS_REGULAR | (ứng viên khóa nghiệp vụ) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CONDITON_CDGRID.AS_REGULAR. Giữ nguyên tên. Quy định chuẩn liên quan, thường trích số quyết định nội bộ. Không báo cáo nào hiển thị nhưng phải nạp vì BA đề xuất đưa cột này vào khóa nghiệp vụ của bảng |
