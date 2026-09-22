"""Generate slide PDTD Datamart PPTX from template_slide.pptx.

Reuses the 3 existing slides (Title, "Nội dung chính", "Cảm ơn") as style
templates. Content slides are built with the "Title and Content" layout,
which only carries footer/page-number placeholders — title box and body
(text or table) are drawn manually to match the template's font/color.
"""

import copy
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR

TEMPLATE = "input/template_slide.pptx"
OUTPUT = "output/Slide_PDTD_Datamart.pptx"

FONT = "Palatino Linotype"
TITLE_COLOR = RGBColor(0x58, 0x91, 0x1F)
BODY_COLOR = RGBColor(0x33, 0x33, 0x33)
HEADER_FILL = RGBColor(0x58, 0x91, 0x1F)
HEADER_TEXT = RGBColor(0xFF, 0xFF, 0xFF)
ROW_ALT_FILL = RGBColor(0xF2, 0xF6, 0xEC)

TITLE_TOP = Inches(0.25)
TITLE_HEIGHT = Inches(0.6)
TITLE_LEFT = Inches(0.5)
TITLE_WIDTH = Inches(12.19)

BODY_TOP = Inches(1.05)
BODY_LEFT = Inches(0.5)
BODY_WIDTH = Inches(12.19)
BODY_HEIGHT = Inches(5.7)

CONTENT_LAYOUT_IDX = 1  # "Title and Content"


def add_title(slide, text, subtitle=None):
    box = slide.shapes.add_textbox(TITLE_LEFT, TITLE_TOP, TITLE_WIDTH, TITLE_HEIGHT)
    tf = box.text_frame
    tf.word_wrap = True
    p = tf.paragraphs[0]
    run = p.add_run()
    run.text = text
    run.font.name = FONT
    run.font.size = Pt(24)
    run.font.bold = True
    run.font.color.rgb = TITLE_COLOR
    if subtitle:
        p2 = tf.add_paragraph()
        r2 = p2.add_run()
        r2.text = subtitle
        r2.font.name = FONT
        r2.font.size = Pt(13)
        r2.font.bold = False
        r2.font.color.rgb = RGBColor(0x66, 0x66, 0x66)
    return box


def add_bullets(slide, items, top=BODY_TOP, height=BODY_HEIGHT, font_size=14):
    box = slide.shapes.add_textbox(BODY_LEFT, top, BODY_WIDTH, height)
    tf = box.text_frame
    tf.word_wrap = True
    for i, item in enumerate(items):
        p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
        level = item.get("level", 0) if isinstance(item, dict) else 0
        text = item["text"] if isinstance(item, dict) else item
        bold = item.get("bold", False) if isinstance(item, dict) else False
        p.level = level
        prefix = "•  " if level == 0 else "-  "
        run = p.add_run()
        run.text = (prefix + text) if text.strip() else text
        run.font.name = FONT
        run.font.size = Pt(font_size - level * 1)
        run.font.bold = bold
        run.font.color.rgb = BODY_COLOR
        p.space_after = Pt(6)
    return box


def add_table(slide, headers, rows, top=BODY_TOP, height=BODY_HEIGHT, col_widths=None, font_size=11):
    n_rows = len(rows) + 1
    n_cols = len(headers)
    tbl_shape = slide.shapes.add_table(n_rows, n_cols, BODY_LEFT, top, BODY_WIDTH, height)
    table = tbl_shape.table

    if col_widths:
        total = sum(col_widths)
        for c, w in enumerate(col_widths):
            table.columns[c].width = Emu(int(BODY_WIDTH * w / total))

    for c, h in enumerate(headers):
        cell = table.cell(0, c)
        cell.text = h
        cell.fill.solid()
        cell.fill.fore_color.rgb = HEADER_FILL
        for p in cell.text_frame.paragraphs:
            p.alignment = PP_ALIGN.LEFT
            for r in p.runs:
                r.font.name = FONT
                r.font.size = Pt(font_size)
                r.font.bold = True
                r.font.color.rgb = HEADER_TEXT
        cell.vertical_anchor = MSO_ANCHOR.MIDDLE

    for ri, row in enumerate(rows, start=1):
        for ci, val in enumerate(row):
            cell = table.cell(ri, ci)
            cell.text = str(val)
            if ri % 2 == 0:
                cell.fill.solid()
                cell.fill.fore_color.rgb = ROW_ALT_FILL
            else:
                cell.fill.solid()
                cell.fill.fore_color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
            for p in cell.text_frame.paragraphs:
                for r in p.runs:
                    r.font.name = FONT
                    r.font.size = Pt(font_size)
                    r.font.color.rgb = BODY_COLOR
            cell.vertical_anchor = MSO_ANCHOR.TOP
            cell.margin_top = Pt(4)
            cell.margin_bottom = Pt(4)
    return tbl_shape


def add_placeholder_box(slide, label, top=BODY_TOP, height=BODY_HEIGHT):
    box = slide.shapes.add_textbox(BODY_LEFT, top, BODY_WIDTH, height)
    box.fill.solid()
    box.fill.fore_color.rgb = RGBColor(0xF5, 0xF5, 0xF5)
    box.line.color.rgb = RGBColor(0xCC, 0xCC, 0xCC)
    box.line.width = Pt(1)
    tf = box.text_frame
    tf.word_wrap = True
    tf.vertical_anchor = MSO_ANCHOR.MIDDLE
    p = tf.paragraphs[0]
    p.alignment = PP_ALIGN.CENTER
    run = p.add_run()
    run.text = label
    run.font.name = FONT
    run.font.size = Pt(16)
    run.font.italic = True
    run.font.color.rgb = RGBColor(0x99, 0x99, 0x99)
    return box


def new_slide(prs):
    layout = prs.slide_masters[0].slide_layouts[CONTENT_LAYOUT_IDX]
    slide = prs.slides.add_slide(layout)
    # copy footer / page-number placeholder text style from existing slide 2
    return slide


def main():
    prs = Presentation(TEMPLATE)

    # ============================================================
    # Slide: Mục lục (update existing slide 2's content is title-only,
    # we add bullets under it)
    # ============================================================
    toc_slide = prs.slides[1]
    add_bullets(toc_slide, [
        "1. Mục tiêu & phạm vi buổi review",
        "2. Giới thiệu về nghiệp vụ",
        "3. Giới thiệu về dữ liệu LOS, cơ chế ghi từ app xuống Database",
        "4. Tìm hiểu về thiết kế hiện tại trên SB_DWH (bộ bảng DIM/FACT)",
        "5. Trình bày ý tưởng thiết kế",
        {"text": "Quyết định thiết kế Dimension", "level": 1},
        {"text": "Quyết định thiết kế Fact", "level": 1},
        {"text": "Bảng mô tả báo cáo sử dụng từng bảng tầng PDTD_DTM", "level": 1},
        "6. Thiết kế database chi tiết từng bảng",
    ], top=Inches(1.3), height=Inches(5.3), font_size=16)

    # ============================================================
    # 1) Mục tiêu & phạm vi buổi review
    # ============================================================
    s = new_slide(prs)
    add_title(s, "1. MỤC TIÊU & PHẠM VI BUỔI REVIEW")
    add_bullets(s, [
        "Giới thiệu thiết kế datamart PDTD hiện tại (LOS → SB_DWH → PDTD_DTM) tới các chuyên gia/đối tác review",
        "Tiếp nhận góp ý về mức độ phù hợp của thiết kế với hệ thống hiện tại và các điểm cần điều chỉnh (nếu có)",
        "Thống nhất phê duyệt để chuyển sang giai đoạn phát triển",
    ], font_size=18)

    # ============================================================
    # 2) Giới thiệu về nghiệp vụ
    # ============================================================
    s = new_slide(prs)
    add_title(s, "2. GIỚI THIỆU VỀ NGHIỆP VỤ")
    add_bullets(s, [
        {"text": "Bối cảnh", "bold": True},
        {"text": "Khối PDTD (Phê Duyệt Tín Dụng) cần báo cáo vận hành/KPI cho hồ sơ tín dụng chạy trên 2 hệ nguồn song song: CLOS (khách hàng doanh nghiệp/tổ chức) và RLOS (khách hàng cá nhân/bán lẻ)", "level": 1},
        {"text": "Hai hệ dùng chung 1 workflow engine (BPM) nhưng khác bộ trường, khác cách đặt tên bước xử lý", "level": 1},
        {"text": "Các nhóm câu hỏi nghiệp vụ cần trả lời", "bold": True},
        {"text": "Hồ sơ đang ở đâu, tồn đọng bao lâu, ai đang xử lý, thông tin khách hàng/người liên quan là gì? (BC1, BC2, BC4)", "level": 1},
        {"text": "Hồ sơ được phê duyệt (đồng ý/từ chối) với kết quả, hạn mức, tài sản bảo đảm như thế nào? (BC3)", "level": 1},
        {"text": "Có bao nhiêu ngoại lệ chính sách, hồ sơ bị trả về bao nhiêu lần? (BC6, BC7, BC8)", "level": 1},
        {"text": "SLA từng bước có đạt cam kết không? (BC5)", "level": 1},
        {"text": "Các chỉ tiêu KPI của Khối PDTD đạt được ra sao? (BC9)", "level": 1},
        {"text": "Hồ sơ sau phê duyệt có thực sự giải ngân, dư nợ ra sao? (BC10, BC11)", "level": 1},
    ], font_size=13)

    s = new_slide(prs)
    add_title(s, "2. GIỚI THIỆU VỀ NGHIỆP VỤ", "Vòng đời một hồ sơ tín dụng — 4 bước chính")
    add_bullets(s, [
        {"text": "B1 — ĐVKD / Cụm HTTD / Vận hành tỉnh", "bold": True},
        {"text": "Khởi tạo và nhập liệu hồ sơ tại đơn vị kinh doanh", "level": 1},
        {"text": "B2 — Phê duyệt tín dụng", "bold": True},
        {"text": "Thẩm định và ra quyết định phê duyệt", "level": 1},
        {"text": "B3 — Xử lý tín dụng", "bold": True},
        {"text": "Hoàn thiện hồ sơ, giải ngân", "level": 1},
        {"text": "B4 — Giám sát sau giải ngân", "bold": True},
        {"text": "Theo dõi khoản vay sau khi đã giải ngân, nối sang dữ liệu T24", "level": 1},
        {"text": ""},
        {"text": "Chi tiết từng bước, từng luồng xử lý cụ thể tham khảo sơ đồ luồng riêng."},
    ], font_size=16)

    # ============================================================
    # 3) Giới thiệu về dữ liệu LOS, cơ chế ghi từ app xuống database
    # ============================================================
    s = new_slide(prs)
    add_title(s, "3. DỮ LIỆU LOS & CƠ CHẾ GHI TỪ APP XUỐNG DATABASE")
    add_table(
        s,
        ["Thao tác", "Cơ chế"],
        [
            ["Insert", "Ghi bản ghi mới vào database khi có phát sinh"],
            ["Update", "2 bước: (1) Xoá dữ liệu liên quan tới hồ sơ được điều chỉnh trong bảng tương ứng; (2) Ghi dữ liệu mới vào bảng"],
            ["Delete", "Xoá dữ liệu khi có hành động xoá trên giao diện"],
        ],
        top=Inches(1.1), height=Inches(1.8), col_widths=[2, 8], font_size=13,
    )
    add_bullets(s, [
        "Bước từ DB LOS về STG_LOS của DWH dùng CDC qua Oracle GoldenGate, đọc trực tiếp redo log — GoldenGate bắt được cả sự kiện DELETE lẫn INSERT như 2 bản ghi log riêng biệt, theo đúng thứ tự transaction đã xảy ra ở nguồn",
        "DB nguồn LOS (transactional) chỉ giữ trạng thái hiện tại — record cũ bị xoá thật, không truy vấn lại được trực tiếp trên LOS",
        "Nhờ GoldenGate đọc redo log ở tầng CDC, cặp sự kiện (DELETE cũ + INSERT mới) vẫn được capture đầy đủ trước khi tới STG_LOS — đây chính là nguyên liệu để tầng DWH/DTM dựng lại lịch sử qua SCD Type 2 (EFF_DATE/EXP_DATE)",
    ], top=Inches(3.1), height=Inches(2.2), font_size=13)

    s = new_slide(prs)
    add_title(s, "3. DỮ LIỆU LOS & CƠ CHẾ GHI TỪ APP XUỐNG DATABASE", "Sequence: App UI → LOS DB → GoldenGate CDC → STG_LOS → SB_DWH → PDTD_DTM")
    add_placeholder_box(s, "[ Sơ đồ sequence sẽ được chèn thủ công ]")

    # ============================================================
    # 4) Tìm hiểu thiết kế hiện tại trên SB_DWH — DIM
    # ============================================================
    s = new_slide(prs)
    add_title(s, "4. THIẾT KẾ HIỆN TẠI TRÊN SB_DWH", "Bảng DIM")
    add_table(
        s,
        ["Thành phần", "Mô tả"],
        [
            ["DIMENSION_KEY", "Sequence key, số tự tăng, làm khóa chính (PK) của bảng DIM"],
            ["<object>_SK", "Cũng là sequence key tương tự DIMENSION_KEY. DIM có nhiều level đối tượng thì mỗi level có sequence key riêng"],
            ["TOTAL / TOTAL_NAME", "Giá trị cố định 'TOTAL'"],
            ["TOTAL_SK", "Giá trị mặc định cố định theo bảng: -2 (DIM_ACCOUNT) hoặc -1 (DIM_LOAN)"],
            ["EFF_DATE / EXP_DATE", "Ngày hiệu lực bản ghi — còn hiệu lực khi EXP_DATE IS NULL. Phục vụ xử lý SCD-2"],
            ["INPUTER / AUTHORISER...", "Nhóm cột maker-checker, xuất hiện ở khá nhiều DIM"],
            ["Cột thuộc tính", "Thông tin mô tả gắn với từng đối tượng của DIM"],
        ],
        top=Inches(1.1), height=Inches(3.0), col_widths=[3, 9], font_size=12,
    )
    add_bullets(s, [
        {"text": "Ví dụ: DIM_PDTD_ORG_UNIT (1 dòng = 1 đơn vị kinh doanh)", "bold": True},
        {"text": "Khóa: DIMENSION_KEY (PK, giữ nguyên từ DWH); <object>_SK: ORG_UNIT_SK — mặc định -1 nếu không có giá trị phù hợp", "level": 1},
        {"text": "Cột thuộc tính: COMPANY_CODE, COMPANY_NAME, BRANCH_CODE, BRANCH_NAME, ZONE_NAME_LOS", "level": 1},
    ], top=Inches(4.3), height=Inches(1.4), font_size=13)

    # ============================================================
    # 4) SB_DWH — FACT
    # ============================================================
    s = new_slide(prs)
    add_title(s, "4. THIẾT KẾ HIỆN TẠI TRÊN SB_DWH", "Bảng FACT")
    add_table(
        s,
        ["Thành phần", "Mô tả"],
        [
            ["DAYID", "Ngày dữ liệu — grain theo ngày (snapshot), không phải theo giao dịch"],
            ["DATASOURCE", "Nguồn dữ liệu: RLOS / CLOS"],
            ["<object>_SK", "Toàn bộ các cột dạng %_SK là FK trỏ tới các bảng DIM tương ứng"],
            ["Measure", "Các cột đo lường / số liệu tổng hợp"],
            ["Cột khai thác khác", "Phục vụ mục đích truy vấn/báo cáo bổ sung"],
        ],
        top=Inches(1.1), height=Inches(2.1), col_widths=[3, 9], font_size=12,
    )
    add_bullets(s, [
        {"text": "Ví dụ: FCT_PDTD_APPLICATION_DAILY (bảng nền, 1 dòng = 1 hồ sơ × 1 ngày dữ liệu)", "bold": True},
        {"text": "Khóa: DAYID + WI_NAME; FK tới 11 chiều (APPLICATION_SK, ORG_UNIT_SK, PRODUCT_SK...) — điển hình star-schema", "level": 1},
        {"text": "Cột khai thác: BI_APPSTATUS, BI_FLOW — trạng thái/luồng đã chuẩn hóa sẵn cho BI", "level": 1},
    ], top=Inches(3.4), height=Inches(1.2), font_size=13)

    s = new_slide(prs)
    add_title(s, "4. THIẾT KẾ HIỆN TẠI TRÊN SB_DWH", "Vì sao FCT_PDTD_APPLICATION_DAILY là daily snapshot fact")
    add_bullets(s, [
        "DB nguồn (transactional) chỉ trả lời được \"hồ sơ này đang ở đâu ngay bây giờ\". Khi hồ sơ đi tiếp bước, bản ghi ở bước cũ bị xoá thật (Update = Delete+Insert) — không còn cách nào truy vấn ngược lại quá khứ",
        "FCT_PDTD_APPLICATION_DAILY chủ động chụp và lưu 1 dòng cho mỗi hồ sơ vào cuối mỗi DAYID, theo 2 lý do sinh dòng:",
        {"text": "Có phát sinh xử lý trong ngày (HAS_ACTION_IN_DAY='Y') — điều kiện phạm vi cho BC1, BC2", "level": 1},
        {"text": "Hồ sơ đang trong chu kỳ thẩm định chưa chốt — duy trì tập tồn đọng phục vụ BC4", "level": 1},
        "Đánh đổi: dung lượng phình theo (số ngày × số hồ sơ) — cần chiến lược partition theo DAYID và archive/purge dữ liệu cũ",
    ], font_size=14)

    # ============================================================
    # 5.0) Tổng quan mô hình 3 tầng
    # ============================================================
    s = new_slide(prs)
    add_title(s, "5. Ý TƯỞNG THIẾT KẾ", "5.0 — Tổng quan mô hình 3 tầng")
    add_placeholder_box(s, "[ Sơ đồ LOS → SB_DWH → PDTD_DTM sẽ được chèn thủ công ]")

    # ============================================================
    # 5.1) Quyết định thiết kế Dimension — intro + 12 rows split
    # ============================================================
    s = new_slide(prs)
    add_title(s, "5. Ý TƯỞNG THIẾT KẾ", "5.1 — Quyết định thiết kế Dimension: cách suy luận")
    add_bullets(s, [
        "Xuất phát từ (các) bảng nguồn trên LOS cùng mô tả 1 đối tượng nghiệp vụ",
        "→ Hợp nhất thành 1 chiều duy nhất ở tầng SB_DWH (DIM_LOS_*)",
        "→ Xem thuộc tính chính có phải loại tương đối ổn định, dùng để phân loại/gắn nhãn hay không",
        "→ Nếu đúng: kết luận tạo DIM, PDTD_DTM bê nguyên 1-1 từ DIM_LOS tương ứng",
    ], font_size=18)

    dim_rows = [
        ("CLOS: NG_SB_CLOS_CUST_INFO (thông tin hồ sơ)\nRLOS: NG_SB_RLOS_APPLICANT_GENERAL, NG_SB_RLOS_SUB_PRODUCT",
         "Sản phẩm tín dụng", "DIM_LOS_PRODUCT", "DIM_PDTD_PRODUCT"),
        ("CLOS: NG_SB_CLOS_APPROVAL (cấp phê duyệt theo hạn mức)\nRLOS: NG_SB_RLOS_APPROVAL",
         "Cấp thẩm quyền phê duyệt", "DIM_LOS_APPROVAL_GROUP", "DIM_PDTD_APPROVAL_GROUP"),
        ("CLOS: NG_SB_CLOS_ENTRY_EXIT\nRLOS: NG_SB_RLOS_ENTRY_EXIT (lịch sử xử lý theo bước)",
         "Quyết định tại bước xử lý", "DIM_LOS_DECISION", "DIM_PDTD_DECISION"),
        ("CLOS: NG_SB_CLOS_CHANGEREQ (yêu cầu thay đổi hạn mức/điều kiện)",
         "Loại thay đổi điều kiện phê duyệt", "DIM_LOS_CHANGE_TYPE", "DIM_PDTD_CHANGE_TYPE"),
        ("CLOS: NG_SB_CLOS_COLL_CD\nRLOS: 4 bảng COL_REALESTATE/TRANSPORT/VALPAPER/OTHER",
         "Loại tài sản bảo đảm", "DIM_LOS_COLLATERAL_TYPE", "DIM_PDTD_COLLATERAL_TYPE"),
        ("CLOS: NG_SB_CLOS_MAS_EXCEPTION (danh mục master ngoại lệ)\nRLOS: tương đương (chưa xác nhận)",
         "Lý do ngoại lệ chính sách", "DIM_LOS_EXCEPTION_REASON", "DIM_PDTD_EXCEPTION_REASON"),
    ]
    add_table(s, ["Bảng nguồn LOS", "Đối tượng mô tả", "DIM tầng SB_DWH", "DIM tầng PDTD_DTM"],
              dim_rows, top=Inches(2.5), height=Inches(4.0), col_widths=[5, 3, 2.5, 2.5], font_size=10)

    s = new_slide(prs)
    add_title(s, "5. Ý TƯỞNG THIẾT KẾ", "5.1 — Quyết định thiết kế Dimension (tiếp)")
    dim_rows2 = [
        ("RLOS: H_NG_SB_RLOS_MAS_CITY (63 tỉnh/thành), H_NG_SB_RLOS_MAS_DISTRICT (710 quận/huyện) — dùng chung 2 hệ",
         "Địa bàn hành chính", "DIM_LOS_GEO", "DIM_PDTD_GEO"),
        ("CLOS: NG_SB_CLOS_CUST_INFO, RLOS: NG_SB_RLOS_APPLICANT_GENERAL — chỉ lấy nhóm cột COMPANY/BRANCH/ZONE",
         "Đơn vị kinh doanh", "DIM_LOS_ORG_UNIT", "DIM_PDTD_ORG_UNIT"),
        ("RLOS Online: CARD_INFOMATION (phát hành/gia hạn thẻ)",
         "Chương trình ưu đãi phí thẻ", "DIM_LOS_CARD_PROMOTION", "DIM_PDTD_CARD_PROMOTION"),
        ("CLOS/RLOS: ENTRY_EXIT (mã bước), WFINSTRUMENTTABLE (trạng thái tức thời BPM)",
         "Bước xử lý trên workflow", "DIM_LOS_WORKSTEP", "DIM_PDTD_WORKSTEP"),
        ("CLOS/RLOS: ENTRY_EXIT — username người thực hiện",
         "Tài khoản cán bộ xử lý", "DIM_LOS_USER", "DIM_PDTD_USER"),
        ("Core T24: SB_DWH.DIM_CUSTOMER — nối sang LOS qua số giấy tờ định danh",
         "Khách hàng", "DIM_CUSTOMER", "DIM_PDTD_CUSTOMER"),
        ("CLOS: CUST_INFO, APPROVAL, EXTTABLE, CHANGEREQ\nRLOS: APPLICANT_GENERAL/DETAIL, APPROVAL, EXTTABLE",
         "Hồ sơ tín dụng", "DIM_LOS_APPLICATION", "DIM_PDTD_APPLICATION"),
    ]
    add_table(s, ["Bảng nguồn LOS", "Đối tượng mô tả", "DIM tầng SB_DWH", "DIM tầng PDTD_DTM"],
              dim_rows2, top=Inches(1.1), height=Inches(5.3), col_widths=[5, 3, 2.5, 2.5], font_size=10)

    # ============================================================
    # 5.2) Quyết định thiết kế Fact
    # ============================================================
    s = new_slide(prs)
    add_title(s, "5. Ý TƯỞNG THIẾT KẾ", "5.2 — Quyết định thiết kế Fact: cách suy luận")
    add_bullets(s, [
        "Xuất phát từ (các) bảng nguồn trên LOS cùng mô tả 1 đối tượng nghiệp vụ phát sinh theo giao dịch/thời gian",
        "→ Hợp nhất thành 1 fact duy nhất ở tầng SB_DWH (FCT_LOS_*)",
        "→ Xem grain có ổn định, có chốt được rõ \"1 dòng = ?\" hay không",
        "→ Nếu đúng: kết luận tạo FACT, PDTD_DTM bê nguyên 1-1 từ FCT_LOS tương ứng",
    ], font_size=18)

    fct_rows1 = [
        ("CLOS: ENTRY_EXIT, CREDITINFO_CD/COMM\nRLOS: ENTRY_EXIT, CREDIT_PROPOSAL(_APP), REPAY_CALC, REPAYFLAGS\nChung: WFINSTRUMENTTABLE",
         "Trạng thái hồ sơ cuối mỗi ngày", "1 hồ sơ × 1 ngày", "FCT_LOS_APPLICATION_DAILY", "FCT_PDTD_APPLICATION_DAILY"),
        ("CLOS/RLOS: ENTRY_EXIT — nhật ký workflow mức nguyên tử, giữ hết mọi sự kiện",
         "Mỗi lần hồ sơ vào 1 bước", "1 logical event (hồ sơ × bước × lần vào)", "FCT_LOS_WORKSTEP_EVENT", "FCT_PDTD_WORKSTEP_EVENT"),
        ("CLOS/RLOS: ENTRY_EXIT (qua FCT_LOS_WORKSTEP_EVENT)",
         "Thời gian xử lý lũy kế", "1 hồ sơ × 1 ngày có action", "FCT_LOS_SLA_DAILY", "FCT_PDTD_SLA_DAILY"),
        ("CLOS: CUST_INFO, CUST_INFO_LEGAL\nRLOS: APPLICANT_GENERAL, COREPAYER_GENERAL",
         "Người liên quan tới hồ sơ", "1 người × 1 hồ sơ, theo DAYID", "FCT_LOS_APPLICATION_PARTY", "FCT_PDTD_APPLICATION_PARTY"),
    ]
    add_table(s, ["Bảng nguồn LOS", "Đối tượng mô tả", "Grain", "FACT tầng SB_DWH", "FACT tầng PDTD_DTM"],
              fct_rows1, top=Inches(2.5), height=Inches(4.0), col_widths=[4, 2.3, 2, 2, 2], font_size=9)

    s = new_slide(prs)
    add_title(s, "5. Ý TƯỞNG THIẾT KẾ", "5.2 — Quyết định thiết kế Fact (tiếp)")
    fct_rows2 = [
        ("RLOS: APPLICANT_IDGRID, COREP_IDGRID\nCLOS: CUST_INFO_LEGAL",
         "Giấy tờ tùy thân người liên quan", "1 giấy tờ × 1 người × 1 hồ sơ", "FCT_LOS_PARTY_DOCUMENT", "FCT_PDTD_PARTY_DOCUMENT"),
        ("CLOS: COLL_CD\nRLOS: 4 bảng COL_REALESTATE/TRANSPORT/VALPAPER/OTHER",
         "Tài sản bảo đảm của hồ sơ", "1 tài sản × 1 hồ sơ, theo DAYID", "FCT_LOS_COLLATERAL", "FCT_PDTD_COLLATERAL"),
        ("CLOS: CONDITON_CDGRID\nRLOS: MANUAL_DEVIATION",
         "Ngoại lệ chính sách trên hồ sơ", "1 ngoại lệ × 1 hồ sơ, theo DAYID", "FCT_LOS_DEVIATION", "FCT_PDTD_DEVIATION"),
        ("CLOS: EXCEPTION (log phát sinh)\nRLOS: EXCEPTION (cơ chế Raise/Clear)",
         "Lần ghi nhận lý do trả về/bổ sung", "1 lần ghi nhận × 1 hồ sơ, theo DAYID", "FCT_LOS_EXCEPTION", "FCT_PDTD_EXCEPTION"),
        ("RLOS: SUB_PRODUCT, CREDIT_CARD_APP, SEABUY/CIVIL/TEACHER/WOMAN_APP, SENT_CBS_LOG",
         "Sản phẩm phụ đăng ký kèm hồ sơ", "1 occurrence, theo DAYID", "FCT_LOS_SUB_PRODUCT", "FCT_PDTD_SUB_PRODUCT"),
    ]
    add_table(s, ["Bảng nguồn LOS", "Đối tượng mô tả", "Grain", "FACT tầng SB_DWH", "FACT tầng PDTD_DTM"],
              fct_rows2, top=Inches(1.1), height=Inches(3.6), col_widths=[4, 2.3, 2, 2, 2], font_size=9)
    add_bullets(s, [
        "Core T24: FCT_LOAN, DIM_LOAN, DIM_COMPANY, DIM_SEAB_PRODUCTS_DE + map vùng miền → FCT_PDTD_DISBURSEMENT (grain: 1 hợp đồng khoản vay × 1 ngày, khác grain hồ sơ)",
        "Tính từ FCT_PDTD_APPLICATION_DAILY + bảng SLA cam kết → FCT_PDTD_KPI_APPLICATION, KPI_USER_YEAR, KPI_YTD_DAILY (fact tổng hợp riêng ở PDTD_DTM)",
        "Tính từ FCT_PDTD_APPLICATION_DAILY + FCT_PDTD_DISBURSEMENT → FCT_PDTD_APPLICATION_MILESTONE (chỉ ghi khi đạt mốc lần đầu, tránh đếm trùng)",
    ], top=Inches(4.9), height=Inches(2.0), font_size=11)

    # ============================================================
    # 5.3) Ma trận báo cáo
    # ============================================================
    bc_map = {
        "BC1": ["FCT_APPLICATION_DAILY", "FCT_APPLICATION_PARTY", "FCT_COLLATERAL", "FCT_PARTY_DOCUMENT", "FCT_SUB_PRODUCT",
                "DIM_APPLICATION", "DIM_APPROVAL_GROUP", "DIM_CARD_PROMOTION", "DIM_CHANGE_TYPE", "DIM_COLLATERAL_TYPE",
                "DIM_CUSTOMER", "DIM_DECISION", "DIM_GEO", "DIM_ORG_UNIT", "DIM_PRODUCT", "DIM_USER", "DIM_WORKSTEP"],
        "BC2": ["FCT_APPLICATION_DAILY", "FCT_APPLICATION_PARTY", "FCT_PARTY_DOCUMENT",
                "DIM_APPLICATION", "DIM_APPROVAL_GROUP", "DIM_CHANGE_TYPE", "DIM_COLLATERAL_TYPE", "DIM_CUSTOMER",
                "DIM_DECISION", "DIM_ORG_UNIT", "DIM_PRODUCT", "DIM_USER", "DIM_WORKSTEP"],
        "BC3": ["FCT_COLLATERAL", "FCT_WORKSTEP_EVENT", "DIM_APPLICATION", "DIM_COLLATERAL_TYPE", "DIM_DECISION", "DIM_USER", "DIM_WORKSTEP"],
        "BC4": ["FCT_APPLICATION_DAILY", "FCT_WORKSTEP_EVENT", "DIM_APPLICATION", "DIM_DATE", "DIM_DECISION", "DIM_USER", "DIM_WORKSTEP"],
        "BC5": ["FCT_APPLICATION_DAILY", "FCT_SLA_DAILY", "FCT_SUB_PRODUCT", "DIM_APPLICATION", "DIM_APPROVAL_GROUP",
                "DIM_CHANGE_TYPE", "DIM_PRODUCT", "DIM_WORKSTEP"],
        "BC6": ["FCT_APPLICATION_DAILY", "FCT_DEVIATION", "DIM_APPLICATION"],
        "BC7": ["FCT_APPLICATION_DAILY", "FCT_EXCEPTION", "DIM_APPLICATION", "DIM_DECISION", "DIM_EXCEPTION_REASON", "DIM_USER", "DIM_WORKSTEP"],
        "BC8": ["FCT_APPLICATION_DAILY", "FCT_WORKSTEP_EVENT", "DIM_APPLICATION", "DIM_DECISION", "DIM_USER", "DIM_WORKSTEP"],
        "BC9": ["FCT_APPLICATION_DAILY", "FCT_APPLICATION_MILESTONE", "FCT_DEVIATION", "FCT_KPI_APPLICATION",
                "FCT_KPI_USER_YEAR", "FCT_KPI_YTD_DAILY", "FCT_SLA_DAILY", "FCT_WORKSTEP_EVENT",
                "DIM_APPLICATION", "DIM_APPROVAL_GROUP", "DIM_DATE", "DIM_DECISION", "DIM_ORG_UNIT", "DIM_PRODUCT", "DIM_USER", "DIM_WORKSTEP"],
        "BC10": ["FCT_DISBURSEMENT", "DIM_APPLICATION", "DIM_CUSTOMER", "DIM_ORG_UNIT"],
        "BC11": ["FCT_DISBURSEMENT", "DIM_APPLICATION", "DIM_CUSTOMER", "DIM_ORG_UNIT"],
    }
    bc_items = list(bc_map.items())
    for chunk_start in range(0, len(bc_items), 4):
        chunk = bc_items[chunk_start:chunk_start + 4]
        s = new_slide(prs)
        sub = f"5.3 — Báo cáo sử dụng bảng PDTD_DTM ({chunk_start+1}-{chunk_start+len(chunk)}/11)"
        add_title(s, "5. Ý TƯỞNG THIẾT KẾ", sub)
        rows = [(bc, "\n".join(tables)) for bc, tables in chunk]
        add_table(s, ["Báo cáo", "Bảng PDTD_DTM sử dụng (FCT_PDTD_* / DIM_PDTD_*)"], rows,
                  top=Inches(1.1), height=Inches(5.7), col_widths=[1.5, 10.5], font_size=10)

    # ============================================================
    # 6) Thiết kế database chi tiết
    # ============================================================
    s = new_slide(prs)
    add_title(s, "6. THIẾT KẾ DATABASE CHI TIẾT TỪNG BẢNG", "6.1 — Tổng quan mô hình")
    add_bullets(s, [
        "Diagram SB_DWH: https://dbdiagram.io/d/SB_PDTD_DWH-6a9e8e4c50ad2c46dc5c705f",
        "Diagram PDTD_DTM: https://dbdiagram.io/d/SB_PDTD_DTM-6a9e68565450bea1be086290",
    ], font_size=16)
    add_placeholder_box(s, "[ Screenshot sơ đồ dbdiagram sẽ được chèn thủ công ]", top=Inches(2.2), height=Inches(4.4))

    s = new_slide(prs)
    add_title(s, "6. THIẾT KẾ DATABASE CHI TIẾT TỪNG BẢNG", "6.2 — Thiết kế database vùng SB_DWH")
    add_bullets(s, ["Mở tài liệu thiết kế database (docx)."], font_size=18)

    s = new_slide(prs)
    add_title(s, "6. THIẾT KẾ DATABASE CHI TIẾT TỪNG BẢNG", "6.3 — Thiết kế database vùng PDTD_DTM")
    add_bullets(s, ["Mở tài liệu thiết kế database (docx)."], font_size=18)

    s = new_slide(prs)
    add_title(s, "6. THIẾT KẾ DATABASE CHI TIẾT TỪNG BẢNG", "6.4 — Thiết kế database bộ bảng MAP (REF)")
    add_bullets(s, ["Mở tài liệu thiết kế database (docx)."], font_size=18)

    # ============================================================
    # Move "Cảm ơn" slide (currently index 2, i.e. slide 3) to the end
    # ============================================================
    xml_slides = prs.slides._sldIdLst
    slides = list(xml_slides)
    thank_you = slides[2]
    xml_slides.remove(thank_you)
    xml_slides.append(thank_you)

    prs.save(OUTPUT)
    print(f"Saved {OUTPUT} with {len(prs.slides)} slides")


if __name__ == "__main__":
    main()
