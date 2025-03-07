-- 실무 실습

-- 서브쿼리
/* 문제 1 - 사원의 급여 정보 중 업무별(job) 최소 급여를 받는 사원의 이름, 성을 name으로 별칭,
			업무, 급여, 입사일로 출력(21행)
*/
DESC jobs;

SELECT CONCAT(e1.first_name, ' ', e1.last_name) AS 'name'
	 , e1.job_id
     , e1.salary
     , e1.hire_date
  FROM employees AS e1
 WHERE (e1.job_id, e1.salary) IN (SELECT e.job_id
									   , MIN(e.salary) AS 'salary'
								    FROM employees AS e
								   GROUP BY e.job_id);
                                   
-- 조건부 논리 표현식 제어 : CASE -> IF문과 동일
/* 샘플 1 - 프로젝트 성공으로 급여인상이 결정됨.
			사원은 현재 107명, 19개 업무에 소속되어 근무중.
            회사 업무중에서 Distinct job_id 5개 업무에서 일하는 사원.
            HR_REP(10%), MK_REP(12%), PR_REP(15%), SA_REP(18%), IT_PROG(20%)
            나머지는 동결.
            (107행)
*/
SELECT employee_id
	 , CONCAT(first_name, ' ', last_name) AS 'name'
     , job_id
     , salary
     , CASE job_id WHEN 'HR_REP' THEN salary*1.10
				   WHEN 'MK_REP' THEN salary*1.12
                   WHEN 'PR_REP' THEN salary*1.15
                   WHEN 'SA_REP' THEN salary*1.18
                   WHEN 'IT_PROG' THEN salary*1.20
                   ELSE salary
	   END AS 'NewSalary'
  FROM employees;
  
/* 문제 3 - 월별로 입사한 사원수가 아래와 같이 행별로 출력. (12행)
*/
-- 형변환 함수. CAST(), CONVERT()
-- SIGNED(음수포함) / UNSIGNED(양수만 지정)
SELECT CAST('09' AS UNSIGNED);
SELECT CONVERT('09', SIGNED);
SELECT CONVERT('09', CHAR);
SELECT CONVERT('2025-03-07', DATE);

-- 커럼을 입사일 중 월만 추출해서 숫자로 변경
SELECT CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 1 THEN COUNT(*) ELSE 0 END '1월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 2 THEN COUNT(*) ELSE 0 END '2월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 3 THEN COUNT(*) ELSE 0 END '3월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 4 THEN COUNT(*) ELSE 0 END '4월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 5 THEN COUNT(*) ELSE 0 END '5월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 6 THEN COUNT(*) ELSE 0 END '6월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 7 THEN COUNT(*) ELSE 0 END '7월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 8 THEN COUNT(*) ELSE 0 END '8월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 9 THEN COUNT(*) ELSE 0 END '9월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 10 THEN COUNT(*) ELSE 0 END '10월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 11 THEN COUNT(*) ELSE 0 END '11월'
     , CASE CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) WHEN 12 THEN COUNT(*) ELSE 0 END '12월'
  FROM employees
 GROUP BY CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED)
 ORDER BY CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED);

-- CASE문 사용 -> 1월부터 12월까지 EXPAND
SELECT CASE WHEN CONVERT(DATE_FORMAT(hire_date, '%m'), SIGNED) = 1 THEN count(*) END AS '1월'
  FROM employees;

-- GROUP BY 설정문제 해결
SELECT @@sql_mode;
SET SESSION sql_mode = 'only_full_group_by,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ROLLUP
/* 샘플 - 부서와 업무별 급여합계를 구하고 신년도 급여수준 레벨을 지정.
		  부서 번호와 업무를 기본으로 정해 행을 그룹별로 나눠 급여합계와 인원수 출력.(20행)
*/
SELECT department_id, job_id
	 , CONCAT('$',FORMAT(SUM(salary), 0)) AS 'Salary SUM'
     , COUNT(employee_id) AS 'COUNT EMPs'
  FROM employees
 GROUP BY department_id, job_id
 ORDER BY department_id ASC;

-- 각 총계
SELECT department_id, job_id
	 , CONCAT('$',FORMAT(SUM(salary), 0)) AS 'Salary SUM'
     , COUNT(employee_id) AS 'COUNT EMPs'
  FROM employees
 GROUP BY department_id, job_id
 WITH ROLLUP;	-- GROUP BY의 컬럼이 하나면 총계는 하나, 컬럼이 두 개면 컬럼별로 소계, 두 컬럼의 합산이 총계로 출력
 
/* 문제 1 - 이전 문제 활용. 집계결과가 아니면 (ALL-DEPTs)라고 출력, 업무에 대한 집계결과가 아니면 (ALL-JOBs) 출력
			ROLLUP으로 만들어진 소계면 ALL-JOBs, 총계면 ALL-DEPTs
*/
SELECT CASE GROUPING(department_id) WHEN 1 THEN '(ALL DEPs)' ELSE IFNULL(department_id, '부서없음') END AS 'Dept#'
	 , CASE GROUPING(job_id) WHEN 1 THEN '(ALL-JOBs)' ELSE job_id END AS 'Jobs'
	 , CONCAT('$',FORMAT(SUM(salary), 0)) AS 'Salary SUM'
     , COUNT(employee_id) AS 'COUNT EMPs'
     -- , GROUPING(department_id)	-- GROUP BY와 WITH ROLLUP을 사용할 때 그룹핑이 어떻게 되는지 확인하는 함수
     -- , GROUPING(job_id)
     , FORMAT(AVG(salary) * 12, 0) AS 'Avg Ann sal'
  FROM employees
 GROUP BY department_id, job_id
 WITH ROLLUP;
 
-- RANK
/* 샘플 - 분석함수 NTILE() 사용. 부서별 급여 합계 출력. 
		  급여가 가장 큰 것이 1, 가장 작은 것이 4가 되도록 등급 나눔(12행)
*/
SELECT department_id
	 , SUM(salary) AS 'SUM Salary'
     , NTILE(4) OVER (ORDER BY SUM(salary) DESC) AS 'Bucket#' -- 범위별로 등급 매기는 키워드
  FROM employees
 GROUP BY department_id;

/* 문제 1 - 부서별 급여를 기준으로 내림차순 정렬. 이 때 다음 세 가지 함수를 이용하여 순위 출력.(107행)
*/
SELECT employee_id
	 , last_name
     , salary
     , department_id
     , RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS 'Rank' -- RANK : 1, 1, 3 식으로 순위매김
	 , DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS 'Dense Rank'
     , ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS 'Row Number' -- 그냥 행번호 매기기
  FROM employees
 ORDER BY department_id ASC, salary DESC;