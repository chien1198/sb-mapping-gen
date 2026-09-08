# FCT_PDTD_DEVIATION

Nguồn: xlsx sheet "FCT_PDTD_DEVIATION" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: FCT - bảng chi tiết (nhân dòng)
- Mô tả: Điều kiện chính sách bị lệch. Là bảng gốc của BC6.
- Lưu gì: Lưu từng ngoại lệ chính sách của hồ sơ kèm tiêu chí kiểm tra, kết quả và nội dung đề xuất chấp thuận. BC6 cần danh sách chi tiết, còn BC5 và BC9 chỉ cần số đếm theo ngưỡng 2 và 3 - số đếm đó đã cộng sẵn lên bảng hồ sơ. Đây là bảng có rủi ro khóa cao nhất trong model.
- Grain: 1 dòng = 1 ngoại lệ chính sách trong ảnh chụp của ngày DAYID
- Khóa: PK = DAYID + WI_NAME + DEVIATION_BK
- Nguồn: DWH.FCT_LOS_DEVIATION
- Báo cáo sử dụng: BC6, BC9
- Quy tắc load: Bê 1-1 từ DWH.FCT_LOS_DEVIATION theo ngày, giữ nguyên grain và tính chất ẢNH CHỤP ĐẦY ĐỦ THEO NGÀY. Mỗi ngày ghi TOÀN BỘ ảnh của DWH vào phân vùng DAYID = :P_DATE, không so với hôm trước. Đọc trạng thái ngày D chỉ cần WHERE DAYID = D. DTM CHỈ ĐỌC DWH, không đọc STG_LOS: việc dựng ảnh đầy đủ từ CDC delta đã xong ở tầng DWH — xem 00_Doc_STG_LOS ở file model DWH. Sau khi bê thì LEFT JOIN bảng map để bổ sung cột chuẩn hóa; join phải là 1:1 hoặc 1:0. Phạm vi ghi: cùng tập hồ sơ với FCT_PDTD_APPLICATION_DAILY.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | Ngày dữ liệu của dòng, là khóa phân vùng của bảng | DATE |  | Y | PK | KỸ THUẬT | 1:1 từ DWH.FCT_LOS_DEVIATION.DAYID | (phân vùng theo ngày dữ liệu) | DA_CHOT | Ngày dữ liệu, kiểu DATE đã TRUNC về 00:00:00. Đây là ngày ảnh chụp số liệu, KHÔNG phải ngày nghiệp vụ. Ở bảng này DAYID là NGÀY GHI PHIÊN BẢN, không phải ngày ảnh chụp toàn bộ; xem Quy tắc ghi để biết cách lấy trạng thái tại một ngày. |
| 2 | WI_NAME | Mã hồ sơ tín dụng của RLOS hoặc CLOS | VARCHAR2 | 100 | Y | PK | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.WI_NAME | BC6.WI_NAME | DA_CHOT | Mã hồ sơ. Trường WI_NAME của BC6 |
| 3 | DEVIATION_BK | Khóa nghiệp vụ của dòng chi tiết, sinh bằng hash vì nguồn không có khóa dùng chung được | VARCHAR2 | 64 | Y | PK | BÊ 1-1 | 1:1 từ DWH.FCT_LOS_DEVIATION.DEVIATION_BK | (khóa dòng ngoại lệ) | DA_CHOT | KỸ THUẬT — Khóa nghiệp vụ của một dòng ngoại lệ chính sách. GIỮ HASH vì cả hai bảng nguồn đều thuộc LOẠI 2. STANDARD_HASH(..., 'SHA256') trên TOÀN BỘ cột không phải CLOB, cộng DATASOURCE và tên bảng nguồn: NG_SB_CLOS_CONDITON_CDGRID loại trừ AS_REGULAR và DEV_PROPOSAL; NG_SB_RLOS_MANUAL_DEVIATION loại trừ REASON. HỆ QUẢ CẦN BIẾT: hai dòng ngoại lệ trên cùng hồ sơ chỉ khác nhau ở nội dung CLOB sẽ ra cùng hash và bị gộp làm một. Chuẩn hóa trước khi hash: TRIM chuỗi, NULL quy về '<NULL>', DATE và NUMBER dùng format cố định không phụ thuộc NLS, nối bằng ký tự phân cách không xuất hiện trong dữ liệu. |
| 4 | APPLICATION_SK | Khóa tham chiếu đến chiều hồ sơ tín dụng | NUMBER | 18 | Y |  | KỸ THUẬT | 1:1 từ DWH.FCT_LOS_DEVIATION.APPLICATION_SK |  | DA_CHOT | Khóa tới DIM_PDTD_APPLICATION theo phiên bản hiệu lực tại DAYID. Không khớp thì -1 |
| 5 | DATASOURCE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.DATASOURCE |  | DA_CHOT | RLOS hoặc CLOS. Trường SYSTEMNAME của BC3, BC4, BC5 |
| 6 | PROCESSED_DATE | Ngày xử lý của hồ sơ | DATE |  | N |  | 1:1 | Tính ở DTM | BC1.PROCESSED_DATE; BC2.PROCESSED_DATE; BC5.PROCESSED_DATE; BC6.PROCESSED_DATE; BC7.PROCESSED_DATE; BC8.PROCESSED_DATE; BC9.PROCESSED_DATE | DA_CHOT | Trường PROCESSED_DATE của BC6 |
| 7 | DEVIATION_TYPE_CODE | Mã loại lệch chính sách | VARCHAR2 | 300 | N |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.DEVIATION_TYPE_CODE | BC6.DEVIATION_TYPE | DA_CHOT | Loại ngoại lệ phía CLOS. Trường DEVIATION_TYPE của BC6 |
| 8 | DEV_PROPOSAL | Đề xuất xử lý lệch chính sách | VARCHAR2 | 4000 | N |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.DEV_PROPOSAL | BC6.DEV_PROPOSAL; BC2.DEV_PROPOSAL | DA_CHOT | Đề xuất xử lý phía CLOS. Trường DEV_PROPOSAL của BC6 |
| 9 | CHECKING_CONDITION | Điều kiện kiểm tra chính sách | VARCHAR2 | 1000 | N |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.CHECKING_CONDITION | BC6.CHECKING_CONDITION | DA_CHOT | Tiêu chí bị lệch phía RLOS. Trường CHECKING_CONDITION của BC6 |
| 10 | CHECKING_RESULT | Kết quả kiểm tra chính sách | VARCHAR2 | 200 | N |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.CHECKING_RESULT | BC6.CHECKING_RESULT | DA_CHOT | Kết quả xét phía RLOS. Trường CHECKING_RESULT của BC6 |
| 11 | DEVIATION_REASON | Lý do lệch chính sách | VARCHAR2 | 4000 | N |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.DEVIATION_REASON | BC6.REASON | DA_CHOT | Nội dung ngoại lệ. Trường REASON của BC6 |
| 12 | AS_REGULAR | Quy định chuẩn liên quan tới lệch chính sách | VARCHAR2 | 4000 | N |  | 1:1 | 1:1 từ DWH.FCT_LOS_DEVIATION.AS_REGULAR | (ứng viên khóa nghiệp vụ) | DA_CHOT | Nguồn: NG_SB_CLOS_CONDITON_CDGRID.AS_REGULAR. Giữ nguyên tên. Quy định chuẩn liên quan, thường trích số quyết định nội bộ. Không báo cáo nào hiển thị nhưng phải nạp vì BA đề xuất đưa cột này vào khóa nghiệp vụ của bảng |
