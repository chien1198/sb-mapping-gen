# FCT_LOS_APPLICATION_PARTY

Nguồn: xlsx sheet "FCT_LOS_APPLICATION_PARTY" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng quan hệ
- Mô tả: Quan hệ giữa hồ sơ và những người liên quan tới hồ sơ đó.
- Lưu gì: Lưu từng người tham gia hồ sơ kèm vai trò. BA đã xác nhận một người có thể giữ nhiều vai trò khác nhau trong cùng một bộ hồ sơ khách hàng doanh nghiệp nên vai trò là một phần của khóa. Nguồn cũng cho thấy một hồ sơ RLOS có tới bốn người đồng trả nợ nên mô hình bốn cột cố định trong báo cáo hiện tại là không đủ.
- Grain: 1 dòng = 1 người x 1 vai trò trên 1 hồ sơ x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME + APPLICATION_PARTY_BK
- Quy tắc ghi: Ghi khi người liên quan được thêm vào hồ sơ hoặc thông tin định danh thay đổi.
- Bảng nguồn CDC: NG_SB_RLOS_APPLICANT_GENERAL, NG_SB_RLOS_APPLICANT_IDGRID, NG_SB_RLOS_COREPAYER_GENERAL, NG_SB_RLOS_COREP_IDGRID, NG_SB_CLOS_CUST_INFO, NG_SB_CLOS_CUST_INFO_LEGAL
- Báo cáo sử dụng: BC1, BC2, BC3, BC4

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Mã hồ sơ. Nguồn: WI_NAME của các bảng thông tin người liên quan |
| 3 | APPLICATION_PARTY_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT — Khóa nghiệp vụ định danh một người ở một vai trò trên hồ sơ. Dự kiến ghép vai trò với loại giấy tờ và số giấy tờ. Danh sách CDC đang hỏi BA/DEV tổ hợp chính xác cho COREP_IDGRID (WI_NAME + ID_NUMBER + ID_TYPE + PIN?), cho COREPAYER_GENERAL, và hỏi phía CLOS việc bổ sung OBJ_TYPE đã đủ unique chưa. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | PARTY_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_PARTY, thông tin nhân thân của người này |
| 5 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 6 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 7 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất |
| 8 | PARTY_ROLE_CODE | VARCHAR2 | 30 | N |  | PHÁI SINH — Gán theo bảng nguồn: APPLICANT nếu đến từ APPLICANT_GENERAL/IDGRID, COREPAYER nếu đến từ COREPAYER_GENERAL/COREP_IDGRID, ORG_CUSTOMER nếu đến từ CLOS_CUST_INFO, LEGAL_REP nếu đến từ CLOS_CUST_INFO_LEGAL với OBJ_TYPE là người đại diện theo pháp luật |
| 9 | PARTY_SEQ | NUMBER | 4 | N |  | PHÁI SINH — Số thứ tự người trong cùng vai trò trên hồ sơ. Phía RLOS suy từ NG_SB_RLOS_COREP_IDGRID.PIN có giá trị Corep1 đến Corep4; các trường hợp khác do DWH đánh số |
| 10 | OBJ_TYPE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO_LEGAL.OBJ_TYPE. Giữ nguyên tên. BC2 lọc OBJ_TYPE là người đại diện theo pháp luật để lấy trường LEGAL_REPRESENTATIVE |
| 11 | REL_TO_APPLICANT | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_COREPAYER_GENERAL.REL_TO_APPLICANT. Giữ nguyên tên. Mối quan hệ người đồng trả nợ với người vay chính |
| 12 | ID_TYPE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_IDGRID.ID_TYPE / NG_SB_RLOS_COREP_IDGRID.ID_TYPE. Giữ nguyên tên. BC1 tách riêng nhóm TCC và CC với các loại còn lại |
| 13 | ID_NUMBER | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_IDGRID.ID_NUMBER / NG_SB_RLOS_COREP_IDGRID.ID_NUMBER / NG_SB_CLOS_CUST_INFO_LEGAL.ID_NUMBER. Giữ nguyên tên. Trường ADD_ID và ADD_ID_OTHER của BC1, ADD_ID_REPRESENTATIVE của BC2 |
| 14 | LEGAL_DOC | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO_LEGAL.LEGAL_DOC. Giữ nguyên tên. BC2 ghép cột này với số giấy tờ cho trường ADD_ID_REPRESENTATIVE |
| 15 | IS_PRIMARY_ID | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu ID_TYPE thuộc ('TCC','CC'), 'N' nếu khác. Thay cho việc BC1 phải tách thành hai cột riêng ADD_ID và ADD_ID_OTHER |
