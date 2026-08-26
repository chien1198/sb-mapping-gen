# DIM_LOS_COLLATERAL

Nguồn: xlsx sheet "DIM_LOS_COLLATERAL" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - thực thể (SCD Type 2)
- Mô tả: Danh mục tài sản bảo đảm gắn với hồ sơ tín dụng.
- Lưu gì: Lưu phần mô tả của từng tài sản bảo đảm: loại tài sản, số giấy chứng nhận, chủ sở hữu, quan hệ chủ tài sản với khách hàng và đặc điểm riêng theo từng loại. Hợp nhất 4 bảng tài sản của RLOS với bảng tài sản của CLOS. Phần giá trị định giá biến động theo thời gian nằm ở FCT_LOS_COLLATERAL, nên tài sản được định giá lại không bị hiểu nhầm thành tài sản mới.
- Grain: 1 dòng = 1 phiên bản thuộc tính của 1 tài sản bảo đảm
- Khóa: DIMENSION_KEY (sequence). NK = COLLATERAL_NK - CHƯA CHỐT, xem mô tả cột
- Bảng nguồn CDC: NG_SB_RLOS_COL_REALESTATE, NG_SB_RLOS_COL_TRANSPORT, NG_SB_RLOS_COL_VALPAPER, NG_SB_RLOS_COL_OTHER, NG_SB_RLOS_COLL_CERTIGRD, NG_SB_RLOS_DISB_COL_GRID, NG_SB_CLOS_COLL_CD
- Báo cáo sử dụng: BC1, BC2, BC3, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_COLLATERAL |
| 2 | COLLATERAL_NK | VARCHAR2 | 300 | Y |  | CHƯA CHỐT — Khóa tự nhiên định danh một tài sản bảo đảm. RLOS đã chốt khóa cho 3 bảng (WI_NAME + NO_CERTI / CONTROL_POSTER / NUMBERSIGN); COL_OTHER, COLL_CERTIGRD, DISB_COL_GRID và CLOS_COLL_CD chưa có. Ràng buộc bắt buộc: KHÔNG đưa giá trị định giá hay tỷ lệ LTV vào khóa. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 3 | WI_NAME | VARCHAR2 | 100 | N |  | 1:1 — Mã hồ sơ mà tài sản được thế chấp cho. Nguồn: WI_NAME của các bảng tài sản |
| 4 | SYSTEM_CODE | VARCHAR2 | 10 | N |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 5 | COLLATERAL_TYPE_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_COLLATERAL_TYPE. Phía CLOS lookup theo COLLTYPE, phía RLOS suy theo bảng nguồn mà bản ghi đến từ đó |
| 6 | COLL_SEQ | NUMBER | 4 | N |  | PHÁI SINH — ROW_NUMBER() OVER (PARTITION BY WI_NAME, COLL_TYPE_CODE ORDER BY khóa nguồn). Do DWH sinh để phân biệt các tài sản cùng loại trong một hồ sơ khi nguồn chưa có khóa |
| 7 | CERTIFICATE_NO | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_RLOS_COL_REALESTATE.NO_CERTI cho bất động sản, NG_SB_RLOS_COLL_CERTIGRD.CERTIFICATENO cho các loại khác (đổi tên để dùng chung). Trường GCN_REAL_ESTATE và GCN_OTHER của BC1 |
| 8 | DESCRIPTION | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.DESCRIPTION cho CLOS, NG_SB_RLOS_COL_OTHER.DESCRIBE cho tài sản khác của RLOS. Giữ tên phía CLOS. Trường Description của BC3 |
| 9 | OWNER_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: OWNER của 4 bảng tài sản RLOS / NG_SB_CLOS_COLL_CD.COLL_OWNER (đổi tên để dùng chung hai hệ). Trường Owner của BC3 |
| 10 | REL_TO_CUSTOMER | VARCHAR2 | 200 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_REALESTATE.REL_CUSTOMER và RELATION_CUSTOMER của 3 bảng tài sản RLOS còn lại (đổi tên để dùng chung). Trường TSBD_RELATIONSHIP của BC1 |
| 11 | USING_PURPOSE | VARCHAR2 | 255 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_REALESTATE.USING_PURPOSE. Giữ nguyên tên. BC3 ghép cột này với số giấy chứng nhận để tạo phần mô tả tài sản bất động sản |
| 12 | VEHICLE_TYPE | VARCHAR2 | 100 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_TRANSPORT.TYPE_VEHICLE (đổi thứ tự từ cho thuận). Trường Types of Collaterals của BC3 với tài sản là phương tiện |
| 13 | BRAND | VARCHAR2 | 200 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_TRANSPORT.BRAND. Giữ nguyên tên. BC3 ghép cột này với biển số để tạo phần mô tả tài sản phương tiện |
| 14 | CONTROL_POSTER | VARCHAR2 | 100 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_TRANSPORT.CONTROL_POSTER. Giữ nguyên tên. Biển số kiểm soát của phương tiện |
| 15 | VALPAPER_TYPE | VARCHAR2 | 100 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_VALPAPER.TYPE1 (đổi tên vì tên gốc không mang nghĩa). Trường Types of Collaterals của BC3 với tài sản là giấy tờ có giá |
| 16 | NUMBERSIGN | VARCHAR2 | 200 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_VALPAPER.NUMBERSIGN. Giữ nguyên tên. Số hiệu giấy tờ có giá, cũng là căn cứ cho cờ TSBD_GTCG của BC1 |
| 17 | COLL_TYPE_CODE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.COLLTYPE giữ nguyên văn (phía RLOS gán theo bảng nguồn). Trường Types of Collaterals của BC3 và căn cứ cho 9 cờ loại tài sản của BC2 |
| 18 | IS_ASSET_FORMED | VARCHAR2 | 10 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_REALESTATE.PROPERTY / NG_SB_RLOS_COL_TRANSPORT.PROPERTY (đổi tên theo giải thích của BA). BA xác nhận cột này nghĩa là TÀI SẢN ĐÃ HÌNH THÀNH HAY CHƯA, không phải cờ có hay không có tài sản như SRS đang dùng |
| 19 | COLL_MGMT_METHOD | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.COLL_MGMT_APP (đổi tên cho rõ nghĩa). CHỈ CÓ Ở CLOS. Trường Collateral Management của BC3. Lưu ý BA cho biết người dùng thường không nhập trường này trên live nên phần lớn sẽ rỗng, nhưng BC3 vẫn liệt kê nên phải nạp |
| 20 | IS_FORMED_FROM_LOAN | VARCHAR2 | 10 | N |  | 1:1 — CHỈ CÓ Ở RLOS. Nguồn: NG_SB_RLOS_COL_REALESTATE.IS_COLLATERAL_LOAN, đối chiếu NG_SB_RLOS_DISB_COL_GRID.PROPERTY_FORMED (đổi tên theo giải thích của BA là TSBĐ hình thành từ vốn vay). Trường PROPERTY_FORMED của BC1 |
| 21 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 22 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
