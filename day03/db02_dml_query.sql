-- INSERT
-- Book 테이블에 '스포츠 의학' 도서 추가. 한솔의학서적에서 출판. 책가격 90000
INSERT INTO Book (bookid, bookname, publisher, price)
VALUES (11, '스포츠 의학', '한솔의학서적', 90000);

SELECT * FROM Book;

-- 컬럼명 생략
INSERT INTO Book VALUES (12, '스타워즈 아트북', '디즈니', 150000);

INSERT INTO Book VALUES (12, '어벤져스 스토리', '디즈니', 150000);

-- 다중 데이터 입력
INSERT INTO Book (bookid, bookname, publisher, price)
VALUES (13, '기타교본 1', '지미 핸드릭스', 12000),
	   (14, '기타교본 2', '지미 핸드릭스', 12000),
       (15, '기타교본 3', '지미 핸드릭스', 15000);
       
-- Imported_Book에 있는 데이터를 Book 테이블에 모두 삽입.
INSERT INTO Book (bookid, bookname, publisher, price)
SELECT bookid, bookname, publisher, price
  FROM Imported_Book;
  
-- 테이블의 숫자형 타입으로 된 PK값이 자동으로 증가하도록 만들기.
CREATE TABLE NewBook (
	bookid 		INTEGER PRIMARY KEY AUTO_INCREMENT,
    bookname 	VARCHAR(50) NOT NULL,
    publisher 	VARCHAR(50) NOT NULL,
    price		INT			NULL	-- null은 생략가능
);

-- 자동증가에는 PK 컬럼을 사용하지 않음
INSERT INTO NewBook (bookname, publisher, price)
VALUES ('알라딘 아트북 4', '디즈니', 100000);

-- PK 자동증가는 편리함. 단, 지워진 PK를 다시 쓸 수 없음. RDB의 규칙 때문
-- INSERT시 자동증가 컬럼은 코드에 기입하지 않음

-- UPDATE
-- Customer 테이블에서 고객번호가 5인 고객의 주소를 '대한민국 부산'으로 변경
SELECT * FROM Customer;

drop table Imported_Book;
CREATE table Imported_Book(
	bookid integer,
    bookname varchar(255),
    publisher varchar(255),
    price integer);   
    
INSERT INTO Imported_Book (bookid, bookname, publisher, price)
VALUES (21, 'Zen Golf', 'Pearson', 12000),
		(22, 'Soccer Skills', 'Human Kinetics', 15000);

-- Book 테이블의 14번 '스포츠 의학'의 출판사를 Imported_Book 테이블에 있는 21번 책의 출판사와 동일하게 만들기.

UPDATE Customer
   SET 
	   address = '대한민국 부산'
 WHERE custid = 5;

-- Book 테이블 14번의 기존 데이터 확인
SELECT *
  FROM book
 WHERE bookid = 14;

-- 2. 바꿀 데이터 출판사 확인
SELECT *
  FROM Imported_Book
 WHERE bookid = 21;

-- 3. update문 작성
UPDATE Book
   SET bookname = '스포츠 의학',
	   publisher = (SELECT publisher
					FROM Imported_Book
					WHERE bookid = 21)
WHERE bookid = 14;

-- 데이터 수정시 조심할 것
SELECT *
  FROM NewBook;
  
-- WHERE절 없이 UPDATE 하지 말 것.
UPDATE NewBook
   SET price = 100000
 WHERE bookid = 3;
 
-- DELETE. 데이터 삭제
-- Book 테이블에서 도서번호가 15번인 도서를 삭제.
DELETE FROM Book
 WHERE bookid = 15;

-- 지우고나서 확인 필요
SELECT * FROM Book;

-- NewBook의 모든 데이터 삭제
-- 하지 말 것. WHERE절로 필요한 데이터만 삭제할 것.
DELETE FROM NewBook;