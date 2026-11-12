--phan 1
WITH SRC AS (
    SELECT A.EXITDATE AS PROCESSED_DATE, A.WINAME AS WI_NAME,
           A.WORKSTEP, A.DECISION, A.EXITDATE
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT A
    WHERE A.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                         'UnderwriterChecker','CreditApproval','CreditCommittee')
      AND A.DECISION IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                         'Send Back to DataInputerChecker','Additional_Doc_Required',
                         'Cancel','Reject')
    UNION ALL
    SELECT A.EXITDATE AS PROCESSED_DATE, A.WINAME AS WINAME,
           A.WORKSTEP, A.DECISION, A.EXITDATE
    FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT A
    WHERE A.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                         'UnderwriterChecker','CreditApproval','CreditCommittee')
      AND A.DECISION IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                         'Send Back to DataInputerChecker','Additional_Doc_Required',
                         'Cancel','Reject')
),
TBL AS (
    SELECT PROCESSED_DATE, WI_NAME, WORKSTEP, DECISION, EXITDATE
    FROM PDTD_DTM.BC8
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM TGT) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM TGT MINUS SELECT * FROM SRC) y;


--phan 2
WITH SRC AS (
    SELECT
        A.WINAME AS WI_NAME,
        SUM(CASE WHEN A.WORKSTEP = 'DetailDataEntry' AND A.DECISION = 'Send_Back' THEN 1
                 WHEN A.WORKSTEP = 'DataInputerChecker' AND A.DECISION = 'Additional_Doc_Required' THEN 1
                 ELSE 0 END) AS SL_RETURN_NHAPLIEU,
        (SUM(CASE WHEN A.WORKSTEP = 'UnderwriterMaker' AND A.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END)
            - (SELECT COUNT(1) FROM SBLOS2.NG_SB_CLOS_EXCEPTION B
               WHERE B.WI_NAME = A.WINAME
                 AND B.EXCEPTION_CATEGORY = N'Gửi dự thảo đề xuất cho chi nhánh'))
        + SUM(CASE WHEN A.WORKSTEP = 'UnderwriterChecker' AND A.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END)
            AS SL_RETURN_THAMDINH,
        SUM(CASE WHEN A.WORKSTEP IN ('CreditApproval', 'CreditCommittee')
                  AND A.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END) AS SL_RETURN_PHEDUYET
    FROM SBLOS2.NG_SB_CLOS_ENTRY_EXIT A
    WHERE A.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                         'UnderwriterChecker','CreditApproval','CreditCommittee')
      AND A.DECISION IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                         'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
    GROUP BY A.WINAME
    UNION ALL
    SELECT
        A.WINAME AS WINAME,
        SUM(CASE WHEN A.WORKSTEP = 'DetailDataEntry' AND A.DECISION = 'Send_Back' THEN 1
                 WHEN A.WORKSTEP = 'DataInputerChecker' AND A.DECISION = 'Additional_Doc_Required' THEN 1
                 ELSE 0 END) AS SL_RETURN_NHAPLIEU,
        (SUM(CASE WHEN A.WORKSTEP = 'UnderwriterMaker' AND A.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END)
            - (SELECT COUNT(DISTINCT B.WI_NAME || '|' || TO_CHAR(B.RAISED_DATE_TIME, 'YYYYMMDDHH24MISS'))
               FROM SBLOS2.NG_SB_RLOS_EXCEPTION B
               WHERE B.WI_NAME = A.WINAME
                 AND B.EXCEPTION_NAME = N'UW-BR-FTR: Gửi dự thảo phê duyệt TD'))
        + (SUM(CASE WHEN A.WORKSTEP = 'UnderwriterChecker' AND A.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END)
            - (SELECT COUNT(DISTINCT B.WI_NAME || '|' || TO_CHAR(B.RAISED_DATE_TIME, 'YYYYMMDDHH24MISS'))
               FROM SBLOS2.NG_SB_RLOS_EXCEPTION B
               WHERE B.WI_NAME = A.WINAME
                 AND B.EXCEPTION_CATEGORY = N'CK-BR: Gửi dự thảo về ĐVKD'))
            AS SL_RETURN_THAMDINH,
        SUM(CASE WHEN A.WORKSTEP IN ('CreditApproval', 'CreditCommittee')
                  AND A.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END) AS SL_RETURN_PHEDUYET
    FROM SBLOS2.NG_SB_RLOS_ENTRY_EXIT A
    WHERE A.WORKSTEP IN ('DetailDataEntry','DataInputerChecker','UnderwriterMaker',
                         'UnderwriterChecker','CreditApproval','CreditCommittee')
      AND A.DECISION IN ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker',
                         'Send Back to DataInputerChecker','Additional_Doc_Required','Cancel','Reject')
    GROUP BY A.WINAME
),
TBL AS (
    SELECT DISTINCT WI_NAME, SL_RETURN_NHAPLIEU, SL_RETURN_THAMDINH, SL_RETURN_PHEDUYET
    FROM PDTD_DTM.BC8
)
SELECT 'NGUON - DICH' AS SRC, x.* FROM (SELECT * FROM SRC MINUS SELECT * FROM TBL) x
UNION ALL
SELECT 'DICH - NGUON' AS SRC, y.* FROM (SELECT * FROM TBL MINUS SELECT * FROM SRC) y;