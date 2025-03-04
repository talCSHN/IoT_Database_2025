-- Order 테이블의 판매 도서에 대한 이익금을 계산하는 프로시저
DELIMITER //
CREATE PROCEDURE getInterest(

)
BEGIN
	-- 변수 선언
    DECLARE myInterest FLOAT DEFAULT 0.0;
    DECLARE price INTEGER;
    DECLARE endOfRow BOOLEAN DEFAULT FALSE;
    DECLARE InterestCursor CURSOR FOR
		SELECT saleprice FROM Orders;
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET endOfRow=TRUE;
        
	-- 커서 오픈
    OPEN InterestCursor;
    cursor_loop: LOOP
		FETCH InterestCursor INTO price;	-- SELECT saleprice FROM Orders의 테이블을 한 행씩 읽어서 값을 price에 집어넣는다
        IF endOfRow THEN LEAVE cursor_loop;	-- python break;
        END IF;
        IF price >= 30000 THEN	-- 판매가가 3만원 이상이면 10% 이윤을 챙기고, 그 미만이면 5% 이윤을 챙겨라
			SET myInterest = myInterest + price * 0.1;
        ELSE
			SET myInterest = myInterest + price * 0.05;
        END IF;
    END LOOP cursor_loop;
    CLOSE InterestCursor;	-- 커서 종료
    
    -- 결과 출력
    SELECT CONCAT('전체 이익 금액 = ', myInterest) AS 'Interest';
END;

-- 저장 프로시저 실행
CALL getInterest();