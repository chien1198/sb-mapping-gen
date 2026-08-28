
with N2 AS (
	SELECT  
		.....
	FROM SOURCE_TABLE
	WHERE Date = :pdate
)
, N1 AS (
	SELECT
		.......
	FROM SOURCE_TABLE
	WHERE DATE = :pdate - 1
)
--ban ghi them moi: flag = 'I' chi co tai ngay 2
SELECT 
	.....
FROM N2
LEFT JOIN N1 ON key2= key1
WHERE key1 is null

UNION ALL

--ban ghi khong thay doi thay doi: flag = U
SELECT 
	.....
FROM N2
JOIN N1 ON key2 = key 1
WHERE n2.col1 = n1.col1
	and n2.col2 = n1.col2
	......
	and n2.coln = n1.coln
	
UNION ALL

--ban ghi thay doi:flag = U
SELECT 
	.....
FROM N2
JOIN N1 ON key2 = key 1
WHERE n2.col1 <> n1.col1
	and n2.col2 <> n1.col2
	......
	and n2.coln <> n1.coln
	
UNION ALL


--ban ghi bi xoa: flag = D
SELECT 

FROM N1
LEFT JOIN N2 ON key1 = key2
WHERE n2.key is null
