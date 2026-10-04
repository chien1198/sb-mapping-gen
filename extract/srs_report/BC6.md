# BC6 — SRS extract (nguồn: input/srs_report/BC6_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo ngoại lệ
- **Mô tả**: Báo cáo cung cấp thông tin ngoại lệ của hồ sơ trình qua Khối PDTD
- **Tác nhân**: Hệ thống BI
- **Trigger**: 
- **Điều kiện trước**: 
- **Điều kiện sau**: User chọn được tham số và xuất báo cáo hiển thị theo đúng yêu cầu

## Business Rules

- **Hoạt động**: Mã BR | Mô tả
- ****: BR 1.1 | Đầu vào: Ngày báo cáo: PROCESSED_DATE, cho phép chọn Ngày báo cáo. Mặc định hiển thị là ngày dữ liệu hiện tại (T-1) Chi nhánh: Cho phép chọn mã chi nhánh (Không bắt buộc). Mặc định hiển thị là Tất cả chi nhánh
- ****: BR 1.2 | Các bảng sử dụng:
- ****: BR 1.3 | Đầu ra: Báo cáo hiển thị các trường thông tin sau:

## Bảng nguồn sử dụng & điều kiện Join (alias map)

> **Lưu ý quan trọng**: nếu có nhiều mục (section) dưới đây (vd. "Nguồn CLOS" / "Nguồn RLOS" / "KPI Khối (RLOS)" / "KPI Khối (CLOS)"), alias (a, b, c...) được TÁI SỬ DỤNG với Ý NGHĨA KHÁC NHAU ở mỗi section — không được tra alias xuyên section.

### Nguồn CLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_CLOS_CONDITON_CDGRID |  |
| b | SBLOS2.NG_SB_RLOS_ENTRY_EXIT | JOIN với điều kiện a.WI_NAME = b.WINAME |

### Nguồn RLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_RLOS_MANUAL_DEVIATION |  |
| b | SBLOS2.NG_SB_RLOS_ENTRY_EXIT | JOIN với điều kiện a.WI_NAME = b.WINAME |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
| Nguồn CLOS | Nguồn CLOS | Nguồn CLOS | Nguồn CLOS |
|  | WI_NAME | Mã hồ sơ | NG_SB_CLOS_CONDITON_CDGRID> WI_NAME |
|  | DEVIATION_TYPE | Loại ngoại lệ | NG_SB_CLOS_CONDITON_CDGRID> DEVIATION_TYPE |
|  | DEV_PROPOSAL | Nội dung ngoại lệ | NG_SB_CLOS_CONDITON_CDGRID> DEV_PROPOSAL |
|  | PROCESSED_DATE | Ngày dữ liệu báo cáo | NG_SB_CLOS_ENTRY_EXIT> Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel: Lấy NVL( EXITDATE, ENTRYDATE) với điều kiện WORKSTEP = 'CancelRevoke' Ngày thoát bước cuối cùng của các hồ sơ chưa đến bước Phê duyệt và không ở CancelRevoke: Lấy giá trị Max(EXITDATE) |
| Nguồn RLOS | Nguồn RLOS | Nguồn RLOS | Nguồn RLOS |
|  | WI_NAME | Mã hồ sơ | NG_SB_RLOS_MANUAL_DEVIATION> WI_NAME |
|  | CHECKING_RESULT | Loại ngoại lệ | NG_SB_RLOS_MANUAL_DEVIATION> CHECKING_RESULT |
|  | CHECKING_CONDITION | Tiêu chí ngoại lệ | NG_SB_RLOS_MANUAL_DEVIATION> CHECKING_CONDITION |
|  | REASON | Nội dung ngoại lệ | NG_SB_RLOS_MANUAL_DEVIATION> REASON |
|  | PROCESSED_DATE | Ngày dữ liệu báo cáo | NG_SB_RLOS_ENTRY_EXIT Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel: Lấy NVL( EXITDATE, ENTRYDATE) với điều kiện WORKSTEP = 'CancelRevoke' Ngày thoát bước cuối cùng của các hồ sơ chưa đến bước Phê duyệt và không ở CancelRevoke: Lấy giá trị Max(EXITDATE) |
