-- 행번호
-- 고객 목록에서 고객번호, 이름, 전화번호를 앞의 2명만 출력.
SET @seq := 0;	-- 변수선언. SET으로 시작. 변수명 앞에 @붙임. 값 할당은 ':='

SELECT (@seq := @seq + 1) AS '행번호'
	 , custid
	 , name
     , phone
  FROM Customer
 WHERE @seq < 2;
 
SELECT (@seq := @seq + 1) AS '행번호'
	 , custid
	 , name
     , phone
  FROM Customer LIMIT 2;	-- 순차적인 일부 데이터 추출에 탁월
  
-- 특정 범위 추출
SELECT custid
	 , name
     , phone
  FROM Customer LIMIT 2 OFFSET 3; -- 3번째 다음행부터 2개 추출