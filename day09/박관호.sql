-- 1번
SELECT Email AS 'email'
	 , Mobile AS 'mobile'
     , Names AS 'names'
     , Addr AS 'addr'
  FROM membertbl;


-- 2번
SELECT Names AS '도서명'
	 , Author AS '저자'
     , ISBN
     , Price AS '정가'
  FROM bookstbl
 ORDER BY ISBN;
 
-- 3번
SELECT m.Idx
	 , m.Names AS '비대여자명'
	 , m.Levels AS '등급'
     , m.Addr AS '주소'
     , r.rentalDate AS '대여일'
 FROM membertbl AS m LEFT OUTER JOIN rentaltbl AS r
   ON m.Idx = r.memberIdx
  WHERE r.memberIdx IS NULL
  ORDER BY m.Levels, m.Names;
 
-- 4번
SELECT IFNULL(d.Names, '--합계--') AS '장르'
	 , SUM(b.Price) AS '총합계금액' 
  FROM divtbl d JOIN bookstbl AS b ON d.Division = b.Division
 GROUP BY d.Names WITH ROLLUP;

