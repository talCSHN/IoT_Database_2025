-- 기존 테이블 삭제
DROP TABLE IF EXISTS NewBook;

-- 테이블 생성
CREATE TABLE NewBook (
	bookid		INTEGER AUTO_INCREMENT PRIMARY KEY,
    bookname 	VARCHAR(100),
    publisher	VARCHAR(100),
    price		INTEGER
);

-- 500만건 더미데이터 생성 설정
SET SESSION cte_max_recursion_depth = 5000000;

-- 더미데이터 생성
INSERT INTO NewBook (bookname, publisher, price)
WITH RECURSIVE cte (n) AS
(
	SELECT 1
    UNION ALL
    SELECT n+1 FROM cte WHERE n < 5000000
)
SELECT CONCAT('Book', lpad(n, 7, '0')) 	-- ex) Book0002104
	 , CONCAT('Comp', lpad(n, 7, '0'))	-- ex) Book0002104
     , FLOOR(3000 + rand() * 30000) AS price	-- 책 가격 3000 ~ 33000
  FROM cte;
  
-- 데이터 확인
SELECT count(*) FROM NewBook;

SELECT * FROM NewBook
 WHERE price BETWEEN 20000 AND 25000;
 
-- 가격을 7개 정도 검색할 수 있는 쿼리 작성
SELECT * FROM NewBook
 WHERE price in (8377, 14567, 24500, 33000, 5600, 6700, 15000);
 
-- 인덱스 생성
CREATE INDEX idx_book ON NewBook(price);