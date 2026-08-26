# DIM_LOS_CARD_PROMOTION

Nguồn: docx section "4.1.14 Bảng DIM_LOS_CARD_PROMOTION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_CARD_PROMOTION, sinh bằng Oracle sequence |
| 2 | PROMOTION_CODE | VARCHAR2 | Y | 100 |  | Mã chương trình ưu đãi phí thẻ |
| 3 | PROMOTION_DESC | VARCHAR2 | N | 500 |  | Tên chương trình ưu đãi phí thẻ |
| 4 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 5 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
