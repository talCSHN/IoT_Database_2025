-- 내장 함수
-- -78과 78의 절대값 구하기
SELECT ABS(-78), ABS(78);

-- 4.875를 소수점 첫번째 자리까지 반올림
SELECT ROUND(4.875, 1) AS 결과;

-- 고객별 평균 주문 금액을 100원 단위로 반올림한 값.
SELECT custid, ROUND(SUM(saleprice) / COUNT(*), -2) AS 평균금액
  FROM Orders
 GROUP BY custid;
 
-- 문자열 내장 함수
-- 도서 제목에서 야구가 포함된 도서명을 농구로 변경한 후 출력하시오
SELECT bookid
	 , REPLACE(bookname, '야구', '농구') AS bookname	-- 출력 결과만 바꿔주는거지 데이터가 바뀐건 아님
     , publisher
     , price
  FROM Book;
  
-- 추가
SELECT 'Hello' 'MySQL';

SELECT CONCAT('Hello', 'MySQL', 'WoW');

-- 굿스포츠에서 출판한 도서의 제목과 제목의 문자수, 바이트수 구하기
SELECT bookname AS '제목'
	 , CHAR_LENGTH(bookname) AS '제목 문자수'	-- 글자 길이를 구할 때
     , LENGTH(bookname) AS '제목 바이트수'		-- utf8에서 한글 한 글자의 바이트 수는 3byte
  FROM Book
 WHERE publisher = '굿스포츠';
 
-- 고객 중 성이 같은 사람이 몇 명이나 되는지 성(姓)별 인원수를 구하기
-- SUBSTR(자를 원본 문자열, 시작인덱스, 길이)
-- DB는 인덱스를 1부터 시작(프로그래밍언어와 차이점)
SELECT SUBSTR('성박', 1, 2);

SELECT SUBSTR(name, 1, 1) AS 성씨
	 , count(*) AS 인원수
  FROM Customer
 GROUP BY SUBSTR(name, 1, 1);
 
-- TRIM, Python의 strip()과 동일
SELECT CONCAT('--', TRIM('     Hello     '), '--');
SELECT CONCAT('--', LTRIM('     Hello     '), '--');
SELECT CONCAT('--', RTRIM('     Hello     '), '--');

-- 새롭게 추가된 trim() 함수
SELECT TRIM('=' FROM '=== -Hello- ===');

-- 날짜시간 함수
SELECT SYSDATE(); -- Docker 서버시간을 따라서 GMT(그리니치 표준시)를 따름 +9hour

SELECT ADDDATE(SYSDATE(), INTERVAL 9 HOUR) AS '한국시간';

-- 마당서점은 주문일부터 10일 후에 매출을 확정. 각 주문의 확정일자 구하기.
SELECT orderid AS '주문번호'
	 , orderdate AS '주문일자'
     , ADDDATE(orderdate, INTERVAL 10 DAY) AS '확정일자'
  FROM Orders;
  
-- 나라별 날짜, 시간을 표현하는 포맷이 다름.
SELECT SYSDATE() AS '기본 날짜/시간'
	 , DATE_FORMAT(SYSDATE(), '%M/%d/%Y %H:%i:%s') ;
     
-- 2014년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 나타내기.
-- 단, 주문일은 %Y/%m/%d 형태로 표시.
-- %Y = 연도 전체, %y = 연도 뒤2자리, %M = 영문 월 ex) July, %m = 숫자 월, %b = 영문 월 약자 ex) Jul, %d = 일
-- %H = 16, %h = 04(오후도 동일), %W = Monday, %w = 1(요일은 일요일부터 0)
-- %p = AM/PM
SELECT orderid AS '주문번호'
	 , DATE_FORMAT(orderdate, '%Y/%m/%d') AS '주문일'
     , custid AS '고객번호'
     , bookid AS '도서번호'
  FROM Orders;
  
-- DATEDIFF : D-day 계산.
SELECT DATEDIFF(SYSDATE(), '2025-02-03');

-- Formatting, 1000 단위마다 , 넣기
SELECT bookid
	 , FORMAT(price, 0) AS price
  FROM MyBook;

-- NULL -> Python의 None과 동일. 모든 다른 프로그래밍 언어에서는 전부 NULL
-- 금액이 NULL일때 발생되는 현상
SELECT price - 5000
  FROM MyBook
 WHERE bookId = 3;

-- 핵심. 집계함수가 다 꼬임.
SELECT SUM(price) AS '합산은 그닥 문제없음'
	 , AVG(price) AS '평균은 NULL이 빠져서 꼬임'
     , COUNT(*)	  AS '모든 행의 갯수는 일치'
     , COUNT(price) AS 'NULL 값은 갯수에서 빠짐'
  FROM MyBook;

-- NULL값 확인. NULL은 비교연산자(=, >, <, <>, ...) 사용 불가.
-- IS 키워드 사용
SELECT *
  FROM MyBook
 WHERE price IS NOT NULL;
 
SELECT *
  FROM MyBook
 WHERE bookname IS NULL; -- 반대는 IS NOT NULL
 
-- IFNULL 함수
SELECT bookid
	 , bookname
     , IFNULL(price, 0)
  FROM MyBook;