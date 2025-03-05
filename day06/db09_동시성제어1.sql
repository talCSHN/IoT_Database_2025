-- 동시성 제어
-- 자동 커밋 해제
SET AUTOCOMMIT=0;

START TRANSACTION;

SELECT * FROM Book;

INSERT INTO Book VALUES (98, '데이터베이스', '한빛', 25000);	-- 트랜잭션이 걸린 상태

UPDATE Book SET
	price = 30000
 WHERE bookid = 98;
 
COMMIT;