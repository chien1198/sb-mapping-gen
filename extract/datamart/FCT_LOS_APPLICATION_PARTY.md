# FCT_LOS_APPLICATION_PARTY

Nguồn: xlsx sheet "FCT_LOS_APPLICATION_PARTY" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: FCT - bảng quan hệ
- Mô tả: Quan hệ giữa hồ sơ và những người liên quan tới hồ sơ đó.
- Lưu gì: Lưu từng người tham gia hồ sơ kèm vai trò. Giấy tờ tùy thân KHÔNG nằm ở đây mà ở FCT_LOS_PARTY_DOCUMENT vì một người có nhiều giấy tờ. BA đã xác nhận một người có thể giữ nhiều vai trò khác nhau trong cùng một bộ hồ sơ khách hàng doanh nghiệp nên vai trò là một phần của khóa. Nguồn cũng cho thấy một hồ sơ RLOS có tới bốn người đồng trả nợ nên mô hình bốn cột cố định trong báo cáo hiện tại là không đủ.
- Grain: 1 dòng = 1 PHIÊN BẢN của 1 người liên quan. DAYID là ngày phiên bản đó được ghi, KHÔNG phải ảnh chụp lại toàn bộ mỗi ngày
- Khóa: PK = DAYID + WI_NAME + APPLICATION_PARTY_BK
- Quy tắc load: Ghi khi người liên quan được thêm vào hồ sơ hoặc thông tin định danh thay đổi. Bảng này GHI KHI CÓ THAY ĐỔI, không chép lại toàn bộ mỗi ngày, nên KHÔNG được lọc WHERE DAYID = :ngay — làm vậy sẽ mất hết các dòng không đổi trong ngày đó. CÁCH ĐỌC ĐÚNG để lấy trạng thái tại ngày D: ROW_NUMBER() OVER (PARTITION BY WI_NAME, APPLICATION_PARTY_BK ORDER BY DAYID DESC) với điều kiện DAYID <= :ngay, rồi lấy dòng thứ nhất. Cách này cho lại đúng trạng thái của mọi ngày trong quá khứ.
- Nguồn: NG_SB_RLOS_APPLICANT_GENERAL, NG_SB_RLOS_COREPAYER_GENERAL, NG_SB_CLOS_CUST_INFO, NG_SB_CLOS_CUST_INFO_LEGAL
- Báo cáo sử dụng: BC1, BC2, BC3, BC4

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE |  | Y | PK | KỸ THUẬT |  |  | (phân vùng theo ngày dữ liệu) | DA_CHOT | KỸ THUẬT — Ngày dữ liệu, kiểu DATE đã TRUNC về 00:00:00. Đây là ngày ảnh chụp số liệu, KHÔNG phải ngày nghiệp vụ. Ở bảng này DAYID là NGÀY GHI PHIÊN BẢN, không phải ngày ảnh chụp toàn bộ; xem Quy tắc ghi để biết cách lấy trạng thái tại một ngày. |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 |  | WI_NAME của các bảng thông tin người liên quan | (khóa nối về hồ sơ) | DA_CHOT | 1:1 — Mã hồ sơ. Nguồn: WI_NAME của các bảng thông tin người liên quan |
| 3 | APPLICATION_PARTY_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT |  |  | (khóa dòng người liên quan) | CHO_RULE_BA | CHƯA CHỐT — Khóa nghiệp vụ định danh một người ở một vai trò trên hồ sơ. Bằng PARTY_ROLE_CODE || '|' || PARTY_SEQ, tức trùng phần định danh người của PARTY_NK trên DIM_LOS_PARTY. KHÔNG dùng số giấy tờ làm khóa vì một người có nhiều giấy tờ - đó là lý do giấy tờ đã tách sang FCT_LOS_PARTY_DOCUMENT. FSS đã đính chính metadata: NG_SB_RLOS_COREPAYER_GENERAL KHÔNG phải chỉ lưu người đồng trả nợ đầu tiên mà lưu hết, khóa database dev là WI_NAME + REL_TO_APPLICANT + ID_NO_CO, trong đó ID_NO_CO tương đương PIN của COREP_IDGRID. Phía CLOS còn phải hỏi việc bổ sung OBJ_TYPE đã đủ unique chưa. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | PARTY_SK | NUMBER | 18 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_PARTY, thông tin nhân thân của người này |
| 5 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 6 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Gán theo tuyến bảng nguồn/STG_LOS; hậu tố WI_NAME chỉ dùng kiểm tra. |
| 7 | PARTY_ROLE_CODE | VARCHAR2 | 30 | N |  | PHÁI SINH |  |  | (tách BC1.CUSTOMER_NAME với BC1.CO_REPAYER; BC2.CUSTOMER_NAME với BC2.LEGAL_REPRESENTATIVE) | DA_CHOT | PHÁI SINH — Gán theo bảng nguồn: APPLICANT nếu đến từ APPLICANT_GENERAL/IDGRID, COREPAYER nếu đến từ COREPAYER_GENERAL/COREP_IDGRID, ORG_CUSTOMER nếu đến từ CLOS_CUST_INFO, LEGAL_REP nếu đến từ CLOS_CUST_INFO_LEGAL với OBJ_TYPE là người đại diện theo pháp luật |
| 8 | PARTY_SEQ | NUMBER | 4 | N |  | PHÁI SINH |  |  | (phân biệt tối đa 4 người đồng trả nợ của BC1) | DA_CHOT | PHÁI SINH — PARTY_SEQ phải bằng đúng giá trị của DIM_LOS_PARTY. RLOS ưu tiên PIN/Corep có sẵn; CLOS ánh xạ từ key/RECID ổn định. Không đánh lại theo thứ tự hiện tại. |
| 9 | OBJ_TYPE | VARCHAR2 | 100 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO_LEGAL | OBJ_TYPE | (điều kiện lọc BC2.LEGAL_REPRESENTATIVE) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO_LEGAL.OBJ_TYPE. Giữ nguyên tên. BC2 lọc OBJ_TYPE là người đại diện theo pháp luật để lấy trường LEGAL_REPRESENTATIVE |
| 10 | REL_TO_APPLICANT | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_RLOS_COREPAYER_GENERAL | REL_TO_APPLICANT | (quan hệ người đồng trả nợ với người vay) | DA_CHOT | 1:1 — Nguồn: NG_SB_RLOS_COREPAYER_GENERAL.REL_TO_APPLICANT. Giữ nguyên tên. Mối quan hệ người đồng trả nợ với người vay chính |
