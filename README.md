# IoT_Database_2025
IoT 개발자 DB 저장소

## 1일차
- 데이터베이스 시스템
    - 통합된 데이터를 저장해서 운영하면서, 동시에 여러 사람이 사용할 수 있도록 하는 시스템
    - 실시간 접근, 계속 변경, 동시 공유 가능, 내용으로 참조(물리적으로 떨어져 있어도 사용가능)

    - DBMS - SQL Server, Oracle, MySQL, MariaDB, MongoDB, ...

- 데이터베이스 언어
    - SQL - Structured Query Language. 구조화 된 질의 언어(프로그래밍 언어와 동일)
        - DDL : DB나 테이블 생성, 수정, 삭제 언어
        - DML : 데이터를 검색, 삽입, 수정, 삭제 언어
        - DCL : 권한 부여, 해제 제어 언어

- MySQL 설치(Docker)
    1. powershell 오픈, 도커 확인
        ```shell
        > docker -v
        Docker version 27.5.1, build 9f9e405
        ```
    
    2. MySQL Docker 이미지 다운로드
        ```shell
        > docker pull mysql
        Using default tag: latest
        latest: Pulling from library/mysql
        43759093d4f6: Download complete
        f56a22f949f9: Download complete
        893b018337e2: Download complete
        df1ba1ac457a: Download complete
        23d22e42ea50: Download complete
        277ab5f6ddde: Download complete
        431b106548a3: Download complete
        d255dceb9ed5: Download complete
        2be0d473cadf: Download complete
        cc9646b08259: Download complete
        Digest: sha256:146682692a3aa409eae7b7dc6a30f637c6cb49b6ca901c2cd160becc81127d3b
        Status: Downloaded newer image for mysql:latest
        docker.io/library/mysql:latest
        ```
    
    3. MySQL Image 확인
        ```shell
        > docker images
        REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
        mysql        latest    146682692a3a   4 weeks ago   1.09GB
        ```
    
    4. Docker 컨테이너 생성
        - MySQL Port 번호는 3306이 기본
        - Oracle Port 번호 : 1521
        - SQL Server Port 번호 : 1433
        ```shell
        > docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=12345 -d -p 3306:3306 mysql:latest
        ```
    
    5. 컨테이너 확인
        ```shell
        > docker ps -a
        CONTAINER ID   IMAGE          COMMAND                   CREATED          STATUS          PORTS
        NAMES
        6c1a82438531   mysql:latest   "docker-entrypoint.s…"   23 seconds ago   Up 23 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql-container
        ```
    
    6. Docker 컨테이너 시작, 중지, 재시작
        ```shell
        > docker stop mysql-container # 중지
        > docker start mysql-container # 시작
        > docker restart mysql-container # 재시작
        ```
    
    7. MySQL Docker 컨테이너 접속
        ```shell
        > docker exec -it mysql-container bash # bash : 리눅스의 shell
        
        > mysql -u root -p
        > Enter password: 12345
        Welcome to the MySQL monitor.  Commands end with ; or \g.
        Your MySQL connection id is 11
        Server version: 9.2.0 MySQL Community Server - GPL

        Copyright (c) 2000, 2025, Oracle and/or its affiliates.

        Oracle is a registered trademark of Oracle Corporation and/or its
        affiliates. Other names may be trademarks of their respective
        owners.

        Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
        > show databases;
        show' at line 1
        mysql> show databases;
        +--------------------+
        | Database           |
        +--------------------+
        | information_schema |
        | mysql              |
        | performance_schema |
        | sys                |
        +--------------------+
        4 rows in set (0.01 sec)
        ```

- Workbench 설치
    - https://dev.mysql.com/downloads/workbench/    MySQL Installer 8.0.41 설치
    - MySQL Installer에서 Workbench, Sample만 설치

    - Workbench 실행 후
        1. MySQL Connections + 클릭


- 관계 데이터 모델
    - 3단계 DB 구조 : 외부 스키마(실제 세계와 매핑) -> 개념 스키마(DB 논리적 설계) -> 내부 스키마(물리적 설계) -> DB
    - 모델에 쓰이는 용어
        - 릴레이션 - 테이블과 매핑
        - 속성 - 테이블 column
        - 튜플 - 테이블 row
        - 관계 - 릴레이션 간의 부모, 자식 연관

    - 무결성 제약 조건
        - 키 - **기본키**, **외래키**, 슈퍼키, 후보키, 대리키, 대체키
        - 개체 무결성 제약 조건, 참조 무결성 제약 조건, 도메인 무결성 제약 조건 

- SQL 기초
    - SQL 개요

    ```sql
    -- DML SELECT문
    SELECT publisher, price
      FROM Book
     WHERE bookname = '축구의 역사';	 -- 주석입니다
    ```

## 2일차
- SQL 기초
    - 개요
        - 데이터베이스에 있는 데이터를 추출 및 처리작업을 위해 사용되는 프로그래밍언어
        - 일반 프로그래밍 언어와의 차이점
            - DB에서만 문제 해결 가능
            - 입출력 모두 DB에서 테이블로 처리
            - 컴파일 및 실행은 DBMS가 수행
        - DML(데이터 조작어) - 검색, 삽입, 수정, 삭제
            - SELECT, INSERT, UPDATE, DELETE
        - DDL(데이터 정의어)
            - CREATE, ALTER, DROP
        - DCL(데이터 제어어)
            - GRANT, REVOKE

    - DML 중 SELECT
        ```sql
        -- SELECT문 기본 문법
        SELECT [ALL|DISTINCT] 컬럼명(들)
          FROM 테이블명(들)
         [WHERE 검색조건(들)]
         [GROUP BY 속성이름(들)]
         [HAVING 집계함수검색조건(들)]
         [ORDER BY 정렬할 속성(들) [ASC|DESC]]
         [WITH ROLLUP]
        ```

        - 쿼리 연습(정렬까지) : [SQL](./day02/db02_select_query_practice.sql)
        - 쿼리 연습(집계함수부터) : [SQL](./day02/db03_select_집계함수부터.sql)

## 3일차
- SQL 기초
    - DDL
    - DML 중 INSERT, UPDATE, DELETE