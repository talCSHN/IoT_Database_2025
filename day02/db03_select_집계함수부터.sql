-- 고객이 주문한 도서의 총 판매액을 구하시오.
SELECT SUM(saleprice) AS totalAmount
  FROM Orders;
  
-- MySQL 문자열은 ''(홑따옴표) 사용. ""(쌍따옴표) 사용 불가

-- 김연아 고객이 주문한 도서의 총 판매액을 구하시오.
SELECT SUM(saleprice) AS totalAmount
  FROM Orders
  WHERE custid = 2;
  
-- 마당서점의 도서 판매 건수를 구하시오.
SELECT COUNT(*) AS totalCount
  FROM Orders;
  
-- 고객이 주문한 도서의 총 판매액, 평균값, 최저, 최고가를 구하시오.
SELECT SUM(saleprice) AS totalMount	-- 합계
	 , AVG(saleprice) AS Average	-- 평균
     , MIN(saleprice) AS MinPrice	-- 최소
     , MAX(saleprice) AS MaxPrice	-- 최대
     , STD(saleprice) AS StandardV	-- 표준편차
  FROM Orders;
  
-- 그룹화 GROUP BY 키워드 사용
-- 고객별로 주문한 도서의 총 수량과 총 판매액을 구하시오.
-- GROUP BY를 사용하려면 반드시 집계함수 및 GROUP BY에 포함된 컬럼이 SELECT 안에 들어가 있어야 함
SELECT custid
	 , count(*) AS 구매도서수량	-- 함수 매개변수로 *, custid 가능
     , SUM(saleprice) AS 고객별구매총액
  FROM Orders
 GROUP BY custid;

-- 고객별 총액을 내림차순으로 출력하시오.
SELECT custid
	 , count(*) AS 구매도서수량	-- 함수 매개변수로 *, custid 가능
     , SUM(saleprice) AS 고객별구매총액
  FROM Orders
 GROUP BY custid
 ORDER BY 고객별구매총액 DESC;
 
SELECT custid
	 , count(*) AS 구매도서수량	-- 함수 매개변수로 *, custid 가능
     , SUM(saleprice) AS 고객별구매총액
  FROM Orders
 GROUP BY custid
 ORDER BY 3 DESC;
 
-- 가격이 8000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 단, 2권 이상 구매한 고객에 대해서만 구하시오.
--  COUNT(0) 등  쪼 WHERE에 넣을 수 없음
-- GROUP BY에 있는 컬럼만 SELECT 안에 사용 가능. 그 외에는 사용 불가
SELECT custid
	 , COUNT(*) AS 총수량
  FROM Orders
 WHERE saleprice >= 8000
 GROUP BY custid
 HAVING 총수량  >= 2; -- COUNT(*)와 별명 사용 가능
 
-- 추가 : 고객별 구매수량과 구매총액을 출력하고, 전체를 합산하여 통계를 표시하시오.
SELECT custid
	 , count(*) AS 구매도서수량	-- 함수 매개변수로 *, custid 가능
     , SUM(saleprice) AS 고객별구매총액
  FROM Orders
 GROUP BY custid
 WITH ROLLUP;
 
-- JOIN : 두 개 이상의 테이블을 합쳐서 출력
-- 고객과 고객의 주문에 관한 데이터를 모두 나타내시오.
SELECT *
  FROM Customer
  INNER JOIN Orders
  ON Customer.custid = Orders.custid;

-- 생략형 쿼리
SELECT *
  FROM Customer, Orders
 WHERE Customer.custid = Orders.custid;

-- 중복되거나 필요없는 컬럼은 제거하고 출력
SELECT Customer.custid
	 , Customer.name
     , Customer.address
     , Orders.orderid
     , Orders.saleprice
     , Orders.orderdate
  FROM Customer, Orders
 WHERE Customer.custid = Orders.custid;
 
-- 테이블명을 줄여서 별칭으로 사용
SELECT c.custid
	 , c.name
     , c.address
     , o.orderid
     , o.saleprice
     , o.orderdate
  FROM Customer AS c, Orders AS o
 WHERE c.custid = o.custid;
 
-- 필요하면 테이블 조인하면 됨
SELECT c.custid
	 , c.name
     , c.address
     , o.orderid
     , o.saleprice
     , o.orderdate
     , b.bookname
     , b.publisher
     , b.price
  FROM Customer AS c, Orders AS o, Book AS b
 WHERE c.custid = o.custid AND b.bookid = o.bookid;
 
-- 고객과 고객 주문에 관한 데이터를 고객별로 정렬하여 나타내시오.
-- 고객명으로 정렬
SELECT c.*
     , o.*
  FROM Customer AS c, Orders AS o
 WHERE c.custid = o.custid
 ORDER BY c.name ASC;
 
-- 고객 이름과 고객이 주문한 도서의 판매가격을 검색하시오.
SELECT c.name
	 , o.saleprice
  FROM Customer AS c, Orders AS o
 WHERE c.custid = o.custid;
 
-- 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오.
SELECT c.name
	 , SUM(o.saleprice) AS totalAmount
  FROM Customer AS c, Orders AS o
 WHERE c.custid = o.custid
 GROUP BY c.name
 ORDER BY c.name ASC;

-- 고객의 이름과 고객이 주문한 도서의 이름을 구하시오.
SELECT c.name
	 , b.bookname
  FROM Customer AS c, Orders AS o, Book AS b
 WHERE c.custid = o.custid AND o.bookid = b.bookid;
 
-- 가격이 20000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오.
SELECT c.name, b.bookname
  FROM Customer AS c, Orders AS o, Book AS b
 WHERE c.custid = o.custid AND o.bookid = b.bookid -- JOIN을 위한 조건
 AND b.price = 20000;
 
-- 외부조인 : 조건을 만족하지 않는(일치하지 않는) 데이터도 출력이 필요할 때 사용하는 JOIN
-- 도서를 구매하지 않은 고객을 포함해 고객의 이름과 고객이 주문한 도서의 판매가격을 구하시오.
-- LEFT OUTER JOIN, RIGHT OUTER JOIN - LEFT, RIGHT는 기준이 되는 테이블 위치 의미
SELECT c.name, o.saleprice
  FROM Customer AS c LEFT OUTER JOIN Orders AS o
  ON c.custid = o.custid;
  
SELECT c.name, o.saleprice
  FROM Customer AS c RIGHT OUTER JOIN Orders AS o
  ON c.custid = o.custid;
  
-- 서브 쿼리(부속 질의)
SELECT MAX(price) 
  FROM Book;
  
-- 가장 비싼 도서의 이름을 나타내시오
SELECT bookname
  FROM Book
  WHERE price = (SELECT MAX(price) FROM Book);
  
-- 도서를 구매한 적이 있는 고객의 이름을 검색하시오.
SELECT c.name
  FROM Customer AS c
 WHERE c.custid IN (SELECT DISTINCT custid FROM Orders);
  
-- 대한미디어에서 출판한 도서를 구매한 고객의 이름을 나타내시오.
SELECT c.name
  FROM Customer AS c
  WHERE c.custid IN (SELECT o.custid
					   FROM Orders AS o
					  WHERE o.bookid IN (SELECT b.bookid
										   FROM Book As b
										  WHERE b.publisher = '대한미디어'
                                          )
					);

-- JOIN 으로 변경 가능(SubQuery <-> JOIN)
SELECT c.name
  FROM Customer As c, Book AS b, Orders AS o
  WHERE c.custid = o.custid AND o.bookid = b.bookid AND b.publisher = '대한미디어';
  
-- 출판사별로 출판사의 평균 도서가격보다 비싼 도서를 구하시오.(조인으로 변경 불가능)
-- 상관 서브쿼리
SELECT *
  FROM Book AS b1
 WHERE b1.price > (SELECT AVG(b2.price) AS AvgPrice
					 FROM Book AS b2
					 WHERE b2.publisher = b1.publisher);
 
SELECT AVG(b2.price), b2.publisher
  FROM Book AS b2
  GROUP BY b2.publisher;

-- 집합 연산(타입에 제약이 없음)
SELECT name
  FROM Customer
UNION  
SELECT bookname
  FROM Book;
  
SELECT name
  FROM Customer
UNION  
SELECT orderdate
  FROM Orders;
  
-- EXISTS : 상관서브쿼리에서 사용하는 키워드(상관서브쿼리가 아니라도 사용가능)
-- 주문이 있는 고객의 이름과 주소를 나타내시오.
SELECT *
  FROM Customer AS c
 WHERE EXISTS (SELECT *						-- o.custid도 가능
				 FROM Orders AS o
				WHERE o.custid = c.custid	-- 메인쿼리의 컬럼이 서브쿼리에 사용되고 있음
			  );