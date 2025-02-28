-- 뷰
-- DDL CREATE로 뷰 생성
CREATE OR REPLACE VIEW v_orders	-- 생성, 수정을 동시에 하는게 좋음
	AS
SELECT o.orderid
	 , c.custid
     , c.name
     , b.bookid
     , b.bookname
     , b.price
     , o.saleprice
     , o.orderdate
  FROM Customer AS c, Book AS b, Orders AS o
 WHERE c.custid = o.custid
   AND b.bookid = o.bookid;

-- 뷰 실행
-- 위의 조인쿼리 실행
-- SQL 테이블로 할 수 있는 쿼리는 다 실행 가능
SELECT *
  FROM v_orders
 WHERE name = '장미란';
 
-- 주소에 '대한민국'을 포함하는 고객들로 구성된 뷰를 만들고 조회.
-- 뷰 이름 : vw_Customer
CREATE OR REPLACE VIEW vw_Customer
	AS
SELECT *
  FROM Customer
 WHERE address LIKE '%대한민국%';
 
SELECT *
  FROM vw_Customer;
  
-- 뷰로 INSERT 하면 기존 테이블에 INSERT됨. UPDATE, DELETE도 가능
-- 단, 뷰의 테이블이 하나여야 함. 관계에서 자식테이블의 뷰는 INSERT 불가.
INSERT INTO vw_Customer 
VALUES (7, '호날두', '영국 런던', '010-9999-0099');

-- vw_Customer 삭제
DROP VIEW vw_Customer;