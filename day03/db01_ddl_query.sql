-- 데이터베이스 생성
CREATE DATABASE sample;

-- 데이터베이스 생성(CharSet, Collation 지정)
CREATE DATABASE sample2
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 변경
ALTER DATABASE sample
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 삭제
-- 운영DB에서 실행하면 퇴사각
DROP DATABASE sample2;
DROP DATABASE sample;

-- 테이블 생성
-- NewBook 테이블 생성. 정수형은 Integer 사용, 문자형은 가변형인 Varchar 사용
-- 기본키 설정
-- 기본키가 하나면 컬럼 하나에 작성 가능
-- 기본키가 두 개 이상일 경우는 컬럼에 PRIMARY KEY 두 군데 이상 작성 불가
-- 기본키가 두 개 이상일 경우 PRIMARY KEY (bookid) 이런식으로 작성

CREATE TABLE NewBook(
	bookId 		INTEGER AUTO_INCREMENT PRIMARY KEY,
    bookName 	VARCHAR(255),
    publisher 	VARCHAR(50),
    price 		INTEGER
);

DROP TABLE NewBook;

CREATE TABLE NewBook(
	bookId 		INTEGER,
    bookName 	VARCHAR(255),
    publisher 	VARCHAR(50),
    price 		INTEGER,
    PRIMARY KEY (bookid)
);

-- 테이블 생성시, 제약조건 추가 가능
-- bookName은 NULL을 가질 수 없고, publisher는 같은 값이 있으면 안됨.
-- price는 값이 입력되지 않은 경우 기본값인 10000을 넣음.
-- 최소가격은 1000원 이상으로 함.
CREATE TABLE NewBook (
	bookId		INTEGER,
    bookName 	VARCHAR(255) NOT NULL,
    publisher 	VARCHAR(50)	 UNIQUE,
    price 		INTEGER		 DEFAULT 10000 CHECK (price >= 1000),
    PRIMARY KEY (bookId)
);

-- 아래 속성의 NewCustomer 테이블을 생성.
-- custId(INTEGER, PK)
-- name(VARCHAR(100), NOT NULL)
-- address(VARCHAR(255), NOT NULL)
-- phone(VARCHAR(30), NOT NULL)
DROP TABLE NewCustomer;

CREATE TABLE NewCustomer(
	custId 		INTEGER PRIMARY KEY,
    name 		VARCHAR(100) NOT NULL,
    address		VARCHAR(255) NOT NULL,
    phone		VARCHAR(30) NOT NULL
);

-- 다음과 같은 속성의 NewOrders를 생성.
-- orderId(INTEGER, PK)
-- bookId(INTEGER, NOT NULL, FK(NewBook))
-- custId(INTEGER, NOT NULL, FK(NewCustomer))
-- salePrice(INTEGER)
-- orderDate(DATE)
CREATE TABLE NewOrders(
	orderId 	INTEGER,
    bookId 		INTEGER NOT NULL,
    custId 		INTEGER NOT NULL,
    salePrice 	INTEGER,
    orderDate 	DATE,
    PRIMARY KEY (orderId),
    FOREIGN KEY (bookId) REFERENCES NewBook(bookId) ON DELETE CASCADE,
    FOREIGN KEY (custId) REFERENCES NewCustomer(custId) ON DELETE CASCADE
);

-- ALTER
-- NewBook 테이블에 isbn(VARCHAR(13)) 속성 추가
ALTER TABLE NewBook ADD isbn VARCHAR(13);

-- NewBook 테이블 isbn(VARCHAR(13)) 속성의 테이터타입 INTEGER로 변경
ALTER TABLE NewBook MODIFY isbn INTEGER;

-- NewBook publisher의 제약사항을 NOT NULL로 변경
ALTER TABLE NewBook MODIFY publisher VARCHAR(100) NOT NULL;

-- DROP(조심)
-- NewBook 테이블 삭제
-- 관계에서 부모 테이블은 자식 테이블을 지우기전에 삭제할 수 없음
DROP TABLE NewBook;

DROP TABLE NewOrders;