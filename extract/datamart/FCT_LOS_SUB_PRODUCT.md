# FCT_LOS_SUB_PRODUCT

Nguồn: xlsx sheet "FCT_LOS_SUB_PRODUCT" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng chi tiết
- Mô tả: Sản phẩm phụ đăng ký kèm sản phẩm chính của hồ sơ, bao gồm cả thẻ tín dụng.
- Lưu gì: Lưu từng sản phẩm phụ mà hồ sơ đăng ký kèm cùng giá trị và thời hạn của sản phẩm phụ đó. FSS đã xác nhận một hồ sơ có thể có nhiều sản phẩm phụ nên mã hồ sơ không đủ làm khóa. Thẻ tín dụng không có bảng riêng vì nó là một trong các loại sản phẩm phụ và dùng chung bộ cột hạn mức, kỳ hạn; các cột riêng của thẻ chỉ có giá trị ở dòng loại thẻ.
- Grain: 1 dòng = 1 sản phẩm phụ trên 1 hồ sơ x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME + SUB_PRODUCT_BK
- Quy tắc ghi: Ghi khi hồ sơ thêm sản phẩm phụ hoặc thay đổi hạn mức, kỳ hạn của sản phẩm phụ.
- Bảng nguồn CDC: NG_SB_RLOS_SUB_PRODUCT, NG_SB_RLOS_CREDIT_CARD, NG_SB_RLOS_CBS, NG_SB_RLOS_SENT_CBS_LOG
- Báo cáo sử dụng: BC1, BC5

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Nguồn: NG_SB_RLOS_SUB_PRODUCT.WI_NAME. Giữ nguyên tên cột nguồn |
| 3 | SUB_PRODUCT_BK | VARCHAR2 | 200 | Y | PK | CHƯA CHỐT — Khóa nghiệp vụ định danh một sản phẩm phụ trên hồ sơ. Dự kiến là loại sản phẩm phụ, hoặc loại sản phẩm phụ kết hợp loại nghiệp vụ thẻ. Danh sách CDC đang hỏi BA/DEV khóa của NG_SB_RLOS_SUB_PRODUCT và NG_SB_RLOS_CREDIT_CARD. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 5 | PRODUCT_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_PRODUCT với PRODUCT_ROLE='SUB' |
| 6 | CARD_PROMOTION_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_CARD_PROMOTION, lookup theo NG_SB_RLOS_CBS.PROMOTION_ID. Chỉ có giá trị ở dòng sản phẩm phụ là thẻ tín dụng |
| 7 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ mã hồ sơ. Hiện chỉ có RLOS ghi nhận sản phẩm phụ |
| 8 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất |
| 9 | SUB_PRODUCT_LINE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_SUB_PRODUCT.SUB_PRODUCT_LINE. Giữ nguyên tên. Trường SAN_PHAM_PHU của BC1 |
| 10 | CARD_TYPE_CODE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_CARD.CARD_TYPE (đổi tên thêm hậu tố CODE). Chỉ có ở dòng thẻ tín dụng. Tên đầy đủ loại thẻ (trường K_TYPE của BC1) tra ở tầng datamart qua bảng thẻ của T24 vì bảng danh mục loại thẻ của LOS không nằm trong phạm vi CDC |
| 11 | RELEASE_TYPE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_CARD.RELEASE (đổi tên cho rõ nghĩa). Loại nghiệp vụ thẻ: Phát hành mới, Tăng giảm hạn mức, Khác |
| 12 | SPP_AMOUNT | NUMBER | 20,2 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_CARD.LIMIT_NO (đổi tên theo cách BC1 gọi), ép kiểu số từ text. Trường SPP_Amount của BC1 |
| 13 | SPP_AMOUNT_RAW | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_CARD.LIMIT_NO giữ nguyên văn dạng text. Cần giữ vì metadata ghi nhận cột nguồn lưu hạn mức dạng chuỗi không chuẩn hóa |
| 14 | SPP_TERM | NUMBER | 5 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_CARD.TERM (đổi tên theo cách BC1 gọi), đơn vị tháng. Trường SPP_Term của BC1 |
| 15 | RESULT_MAIN_CARD_ID | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_SENT_CBS_LOG.RESULT_SEAB_MAIN_CARD_ID (đổi tên cho ngắn). Mã thẻ chính do T24 trả về; BC1 dùng để nối sang bảng thẻ T24 lấy trường K_TYPE |
