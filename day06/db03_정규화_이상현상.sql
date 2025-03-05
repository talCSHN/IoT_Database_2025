-- 계절학기 테이블
DROP TABLE IF EXISTS Summer; -- 기존테이블이 존재하면 삭제

-- 계절학기 테이블 생성
CREATE TABLE Summer (
	sid			INTEGER,
    class		VARCHAR(20),
    price		INTEGER
);


-- 데이터 확인
SELECT * FROM Summer;

-- 기본데이터 추가(MySQL에서는 한번에 다중데이터 INSERT 가능)
INSERT INTO Summer VALUES (100, 'Java', 20000),(150, 'Python', 15000),(200, 'C', 10000),(250, 'Java', 20000);

-- 계절학기를 듣는 학생의 학번과 수강과목
SELECT sid
	 , class
  FROM Summer;
  
-- C 강좌 수강료
SELECT price
  FROM Summer
 WHERE class LIKE '%C%';
 
-- 수강료가 가장 비싼 과목
SELECT DISTINCT(class)
  FROM Summer
 WHERE price = (SELECT MAX(price)
				  FROM Summer);
                  
-- 계절학기 학생수와 수강료 총액
SELECT COUNT(*) AS '학생수'
	 , SUM(price) AS '수강료총액'
  FROM Summer;
  
/* 이상현상(anomaly) */
-- 삭제 이상
DELETE FROM Summer WHERE sid = 200;

-- 삽입이상
INSERT INTO Summer VALUES (NULL, 'C++', 25000);

SELECT COUNT(*)
  FROM Summer;
  
SELECT COUNT(sid)
  FROM Summer;
  
-- 수정이상
UPDATE Summer SET
	price = 15000
 WHERE sid = 100;
 
DELETE FROM Summer;