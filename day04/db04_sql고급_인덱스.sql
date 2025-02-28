-- 인덱스
-- DDL로 인덱스 생성
-- Book테이블의 bookname에 인덱스 ix_Book 생성.
CREATE INDEX ix_Book ON Book(bookname);

-- Book 테이블에 publisher, price를 인덱스 ix_Book2 생성
CREATE INDEX ix_Book2 ON Book(publisher, price);

-- 인덱스 출력
SHOW INDEX FROM Book;

-- 인덱스가 제대로 동작하는지 확인
-- 실행계획(Explain Current Statement) - 인덱스나 조인등에서 쿼리중 어디에서 가장 처리비용이 많이 발생하는지.
SELECT *
  FROM Book
 WHERE publisher = '대한미디어'
   AND price >= 30000;
   
-- Book 테이블 인덱스 최적화
ANALYZE TABLE BOok;

-- 쓸모없는 인덱스는 삭제.
DROP INDEX ix_Book2 ON Book;


-- 구구단
SELECT
	  CONCAT(b.b, '*', a.a, '=', a.a*b.b) AS 2단
    , CONCAT(c.c, '*', a.a, '=', a.a*c.c) AS 3단
    , CONCAT(d.d, '*', a.a, '=', a.a*d.d) AS 4단
    , CONCAT(e.e, '*', a.a, '=', a.a*e.e) AS 5단
    , CONCAT(f.f, '*', a.a, '=', a.a*f.f) AS 6단
	, CONCAT(g.g, '*', a.a, '=', a.a*g.g) AS 7단
	, CONCAT(h.h, '*', a.a, '=', a.a*h.h) AS 8단
    , CONCAT(i.i, '*', a.a, '=', a.a*i.i) AS 9단
  FROM (
		SELECT 1 a UNION ALL
        SELECT 2 a UNION ALL
        SELECT 3 a UNION ALL
        SELECT 4 a UNION ALL
        SELECT 5 a UNION ALL
        SELECT 6 a UNION ALL
        SELECT 7 a UNION ALL
        SELECT 8 a UNION ALL
        SELECT 9 a
        ) AS a
CROSS JOIN
	(SELECT 2 b) b,
    (SELECT 3 c) c,
    (SELECT 4 d) d,
    (SELECT 5 e) e,
    (SELECT 6 f) f,
    (SELECT 7 g) g,
    (SELECT 8 h) h,
    (SELECT 9 i) i;