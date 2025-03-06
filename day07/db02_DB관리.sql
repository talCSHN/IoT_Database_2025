-- 데이터베이스 관리
SHOW DATABASES;

-- information_schema, performance_schema, mysql 등은 시스템 DB라서 개발자, DBA가 사용하는게 아님
USE madang;

-- 하나의 DB내에 존재하는 테이블들 확인
SHOW TABLES;

-- 테이블의 구조
DESC madang.NewBook;

SELECT * FROM v_orders;

-- 사용자 추가
-- madang 데이터베이스만 접근할 수 있는 사용자 madang 생성
-- 내부 접속용
CREATE USER madang@localhost IDENTIFIED BY 'madang';
-- 외부 접속용
CREATE USER madang@'%' IDENTIFIED BY 'madang';

-- DCL : GRANT, REVOKE
-- 데이터 조회, 삽입, 수정 권한만 부여
GRANT SELECT, INSERT, UPDATE ON madang.* TO 'madang'@localhost WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON madang.* TO 'madang'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- 사용자 madang에게 madang DB를 사용할 수 있는 모든 권한 부여
GRANT ALL PRIVILEGES ON madang.* TO 'madang'@localhost WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON madang.* TO 'madang'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- 권한 해제
-- madang 사용자의 권한 중 SELECT 권한만 제거
REVOKE SELECT ON madang.* FROM 'madang'@localhost;

-- 모든 권한 해제
-- REVOKE ALL PRIVILEGES ON madang.* FROM 'madang'@localhost;
-- REVOKE ALL PRIVILEGES ON madang.* FROM 'madang'@'%';
-- FLUSH PRIVILEGES;