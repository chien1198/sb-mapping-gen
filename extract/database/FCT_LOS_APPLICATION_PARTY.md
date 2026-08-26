# FCT_LOS_APPLICATION_PARTY

Nguồn: docx section "4.2.5 Bảng FCT_LOS_APPLICATION_PARTY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_PARTY_BK | VARCHAR2 | Y | 300 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | PARTY_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_PARTY. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 7 | PARTY_ROLE_CODE | VARCHAR2 | N | 30 |  | Vai trò của người trên hồ sơ |
| 8 | PARTY_SEQ | NUMBER | N | 4 |  | Số thứ tự người trong cùng vai trò của hồ sơ |
| 9 | OBJ_TYPE | VARCHAR2 | N | 100 |  | Loại đối tượng của giấy tờ pháp lý |
| 10 | REL_TO_APPLICANT | VARCHAR2 | N | 200 |  | Quan hệ với người đề nghị vay |
