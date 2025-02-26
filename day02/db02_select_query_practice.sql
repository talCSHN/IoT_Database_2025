-- 모든 도서의 이름과 가격을 검색하시오.
SELECT bookname, price
  FROM Book;
  
-- 워크벤치에서 쿼리 실행할 때는 편함
SELECT *
  FROM Book;

-- 모든 도서의 도서번호, 도서이름, 출판사, 가격을 검색하시오.
-- 파이썬, C# 등 프로그래밍 언어로 가져갈 때는 컬럼이름과 컬럼갯수를 모두 파악해야 하기 때문에 아래와 같이 사용
SELECT bookid, bookname, publisher, price
  FROM Book;
  
-- 도서 테이블의 모든 출판사를 검색하시오.
-- 출판사별로 한 번만 출력
-- ALL : 전부 다, DISTINCT : 중복 제거
SELECT DISTINCT publisher
  FROM Book;
  
-- 도서 중 가격이 20,000원 미만인 것을 검색하시오.
-- >:미만, <: 초과, >=: 이하, <=: 초과, <> 같지 않음, !=: 같지 않음, =: 같음(프로그래밍 언어와 다름)
SELECT *
  FROM Book
 WHERE price < 20000
   AND publisher = '굿스포츠';

-- 가격이 10,000이상 20,000이하인 도서를 검색하시오.
SELECT *
  FROM Book
 WHERE price >= 10000 AND price <= 20000;

SELECT *
  FROM Book
 WHERE price BETWEEN 10000 AND 20000;

-- 출판사가 '굿스포츠' 또는 '대한미디어'인 도서를 검색하시오.
SELECT *
  FROM Book
 WHERE publisher = '굿스포츠' OR publisher = '대한미디어';
 
SELECT *
  FROM Book
 WHERE publisher IN ('굿스포츠', '대한미디어');
 
SELECT *
  FROM Book
 WHERE publisher NOT IN ('굿스포츠', '대한미디어');

-- '축구의 역사'를 출간한 출판사를 검색하시오.
SELECT publisher
  FROM Book
 WHERE bookname = '축구의 역사';
 
SELECT publisher
  FROM Book
 WHERE bookname LIKE '축구의 역사';
 
-- 패턴
-- % 갯수와 상관없이 글자가 포함되는 것
-- [] 은 Oracle, SQL Server 등에서만 사용가능. MySQL은 지원x
-- [0-5] : 1개의 문자가 일치
-- [^] : 1개의 문자가 일치하지 않는 것
-- _특정위치의 1개의 문자가 일치할때. 
-- _구% : 첫 번째 글자는 뭐든지 상관 없고, 두 번째 글자가 구로 되고 뒤에 글이 더 있다
SELECT *
  FROM Book
 WHERE bookname LIKE '%축구%';
 
SELECT *
  FROM Book
 WHERE bookname LIKE '%_구%';
 
-- 고객중에서 전화번호가 없는 사람을 검색하시오.
SELECT *
  FROM Customer
 WHERE phone IS NULL;
 
SELECT *
  FROM Customer
 WHERE phone IS NOT NULL;
 
-- 축구에 관한 도서 중 가격이 20,000 이상인 도서를 검색하시오.
SELECT *
  FROM Book
 WHERE bookname LIKE '%축구%' AND price >= 20000;
 
-- 도서를 이름순(오름차순)으로 검색하시오.
-- ASC(오름차순), DESC(내림차순)
SELECT *
  FROM Book
-- ORDER BY bookname ASC;
 ORDER BY bookname;

SELECT *
  FROM Book
 ORDER BY bookname DESC;
 
SELECT *
  FROM Book
 ORDER BY price ASC;
 
-- 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 정렬
SELECT *
  FROM Book
 ORDER BY price, bookname ASC;
 
-- 도서 가격을 내림차순으로 검색하시오. 가격이 같다면 출판사를 오름차순으로 출력하시오.
SELECT *
  FROM Book
 ORDER BY price DESC, publisher ASC;