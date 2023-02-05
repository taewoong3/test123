/*
    <GROUP BY>
    그룹기준을 제시할 수 있는 구문(해당 그룹별로 여러 그룹으로 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
        ※※ 중복을 제거할 수 있다.
*/
SELECT DEPT_CODE, SALARY
FROM EMPLOYEE;

-- 각 부서별 총 급여 합계
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원의 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원의 수와 급여 합계를 구하고 부서별 오름차순으로 조회하시오
SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 각 직급별 사원 수, 보너스를 받는 사원 수, 급여 합, 급여 평균, 최저급여, 최고 급여 조회
-- 직급별 오름차순 정렬로 조회
SELECT JOB_CODE, COUNT(*),
        COUNT(BONUS) AS "보너스 받는 사원", 
        SUM(SALARY) AS "급여 합계", 
        ROUND(AVG(SALARY), -2) AS "급여 평균", 
        MIN(SALARY) AS "최저 급여", 
        MAX(SALARY) AS "최고 급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- GROUP BY절에 함수식 기술가능
SELECT SUBSTR(EMP_NO, 8, 1) "성별", COUNT(*) 인원
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자') AS "성별", COUNT(*) 인원
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- GROUP BY절에는 여러 컬럼 사용 가능
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE    -- 두 데이터가 모두 동일해야 같은 데이터로 취급해서 중복을 제거 할 수 있음
ORDER BY DEPT_CODE, JOB_CODE;

---------------------------------------------------------------------------
/*
    <HAVING 절>
    그룹에 대한 조건을 제시할 때 사용
*/
-- 각 부서별 평균 급여
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 사원 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
WHERE ROUND(AVG(SALARY)) >= 3000000 -- ★ 오류발생 : GROUP BY 절에서 조건 제시 시 WHERE절 사용 못함
GROUP BY DEPT_CODE  
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, EMP_NAME, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, EMP_NAME
HAVING ROUND(AVG(SALARY)) >= 3000000 -- GROUP BY절에서 조건 제시 시 반드시 HAVING 절 사용
ORDER BY DEPT_CODE;

/*
    <SELECT 순서>
    SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY
*/

-------------------------실습 문제---------------------------------
/*
1. 직급별 총 급여 합, 조건은 직급별 급여 합이 1000만원 이상인 직급만 조회

2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회
*/
-- 1. 직급별 총 급여 합, 조건은 직급별 급여 합이 1000만원 이상인 직급만 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY SUM(SALARY);

-- 2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--------------------------------------------------------------------------
/*
    <집계함수>
    그룹별 산출된 결과값에 중간집계를 계산해 주는 함수
    
    ROLLUP, CUBE
    => GROUP BY절에 기술
*/

-- 각 직급별 급여 합
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별 급여 합과 전체 총 급여 합 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;

-- CUBE와 ROLLUP은 그룹 기준의 컬럼이 하나일 때는 차이점이 없음.
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;

-- ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;

-- CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고 중간집계를 내는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;

--============================================================================
/*
    <집합연산자>
    여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
    
    - UNION : 합집합 | OR          => 두 쿼리문을 수행한 결과값을 더한 후, 중복되는 값은 제거하고 반환
    - INTERSECT : 교집합 | AND     => 두 쿼리문을 수행한 결과값에 중복된 결과값만 반환
    - UNION ALL : 합집합 + 교집합   => 두 쿼리문의 모든 결과값 반환(중복값도 포함)
    - MINUS : 차집합               => 앞 쿼리문의 결과에서 뒤의 쿼리문의 결과를 뺀 나머지
*/

--==========================================================================
-- 1. UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회
-- 부서코드가 D5인 사원의 ID, 이름, 부서코드
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 급여가 300만원 초과인 사원
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- OR
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;


--==========================================================================
-- 2. INTERSECT & AND
-- 부서코드가 D5인 사원이고 급여가 300만원 초과인 사원들 조회
-- INTERSECT
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- AND
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

--==========================================================================
-- 3. UNION ALL
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--==========================================================================
-- 4. MINUS
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 4. MINUS - 2
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
MINUS
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 다음처럼 사용 가능
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;

--
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
MINUS
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';