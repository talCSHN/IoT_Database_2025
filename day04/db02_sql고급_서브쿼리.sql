-- 서브쿼리 고급
-- Orders 테이블 평균 주문금액 이하의 주문에 대해 주문번호, 금액 출력
-- 집계함수는 GROUP BY가 없어도 테이블 전체를 집계할 수 있음 
SELECT orderid
	 , saleprice
  FROM Orders
 WHERE saleprice <= (SELECT AVG(saleprice)
					   FROM Orders
					 );
                     
-- 대한민국에 거주하는 고객에게 판매한 도서의 총판매액 출력
SELECT SUM(saleprice) AS '총 판매액'
  FROM Orders
 WHERE custid IN (SELECT custid
				    FROM Customer
				   WHERE address LIKE '%대한민국%'
				  );
                  
-- 3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 주문번호, 판매금액 출력
-- ALL|SOME|ANY를 쓰면 서브쿼리의 값이 단일값이 아니어도 비교할 수 있음
-- ALL - 서브쿼리 내 결과의 모든 값에 비교연산이 일치하는 값을 찾는 것
-- SOME|ANY - 서브쿼리 내 결과의 각각의 값과 비교연산이 일치하는 값을 찾는 것
SELECT *
  FROM Orders
 WHERE saleprice > ALL (SELECT saleprice
					  FROM Orders
					 WHERE custid = 3
					 );

-- 비교연산자만 쓰면 서브쿼리의 값이 단일값이 되어야함(제약사항)
SELECT *
  FROM Orders
 WHERE saleprice > (SELECT MAX(saleprice)
					  FROM Orders
					 WHERE custid = 3
										 );

-- EXISTS 연산자 사용하여 대한민국에 거주하는 고객에게 판매한 도서의 총 판매액 출력
-- EXISTS는 유일하게 서브쿼리에 *을 쓸 수 있음
SELECT SUM(saleprice) AS '총 판매액'
  FROM Orders AS o
 WHERE EXISTS (SELECT *
			     FROM Customer
			    WHERE address LIKE '%대한민국%'
				  AND custid = o.custid);

-- 최신 방법(서브쿼리에서 두 가지 컬럼을 비교하는 방법) - 튜플(파이썬과 동일)
SELECT *
  FROM Orders
 WHERE (custid, orderid) IN (SELECT custid, orderid
							   FROM Orders
							  WHERE custid = 2);
                              
-- SELECT 서브쿼리. 스칼라값(단일행, 단일열) -> 한 컬럼에 데이터 1개
-- 고객별 판매액을 출력. 고객이름과 고객별 판매액을 출력
SELECT o.custid
	 , (SELECT name FROM Customer WHERE custid = o.custid) AS 고객명
	 , SUM(saleprice) AS '판매액'
  FROM Orders AS o
 GROUP BY custid;
 
-- FROM절 서브쿼리, 인라인 뷰
-- 고객번호가 2이하인 고객의 판매액을 출력. 고객이름, 고객별 판매액 출력

-- 1. 이 테이블이 하나의 가상의 테이블이 됨
SELECT custid
	 , name
  FROM Customer
 WHERE custid <= 2;

-- 2. 위 가상테이블을 cs라고 이름 짓고, FROM절에 넣어줌
SELECT cs.*
  FROM (SELECT custid
			 , name
		  FROM Customer
		 WHERE custid <= 2) AS cs;

-- 3. 가상테이블 cs와 Orders테이블을 JOIN
SELECT cs.name, SUM(o.saleprice) AS '구매액'
  FROM (SELECT custid
			 , name
		  FROM Customer
		 WHERE custid <= 2) AS cs, Orders As o
 WHERE cs.custid = o.custid
 GROUP BY cs.name;