-- 저장 프로시저
-- Book 테이블에 하나의 row를 추가하는 프로시저
delimiter //
CREATE PROCEDURE InsertBook(
	IN myBookId		INTEGER,
    IN myBookname	VARCHAR(40),
    IN myPublisher 	VARCHAR(40),
    IN myPrice		INTEGER
)
BEGIN
	INSERT INTO Book (bookid, bookname, publisher, price)
    VALUES (myBookId, myBookname, myPublisher, myPrice);
END;
//

-- 프로시저 호출
CALL InsertBook(31, '호날두 자서전', '알나스르', 300000);
SELECT * FROM Book;

-- 프로시저 삭제
DROP PROCEDURE InsertBook;