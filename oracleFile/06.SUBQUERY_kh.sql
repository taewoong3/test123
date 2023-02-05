/*
    * 서브쿼리(SUBQUERY)
    - 하나의 SQL문 안에 포함된 다른 SQL문
    - 메인 SQL문을 위해 보조 역할을 하는 SQL문
*/
-- '박정보' 사원과 같은 부서에 속한 사원들의 사원명, 부서코드 조회
-- 1. 먼저 박정보의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '박정보'; -- 'D9'

SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 2개를 합치면
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '박정보');
                    
-- 전 직원의 평균 급여보다 더 많이 받는 사원들의 사번, 이름, 직급코드, 급여 조회

-- 평균 급여
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 평균 급여보다 더 많이 받는 사원
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE "직급 코드", TO_CHAR(SALARY, 'L99,999,999') 급여
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEE);
                    
--=============================================================================
/*
    * 서브쿼리의 구분
    서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라 분류
    
    - 단일행 서브쿼리          : 서브쿼리 조회 결과값이 오로지 1행일 때(한행 한열)
    - 다중행 서브쿼리          : 서브쿼리 조회 결과값이 여러행 일 때(여러행 한열)
    - 다중열 서브쿼리          : 서브쿼리 조회 결과값이 여러열 일 때(한행 여러열)
    - 다중행 다중열 서브쿼리     : 서브쿼리 조회 결과값이 여러행 여러열 일 때(여러행 여러열)
    
    >> 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/
--=============================================================================
/*
    1. 단일행 서브쿼리 : 일반 비교연산자 사용(=, !=, >, ....)
*/
-- 1) 전 직원의 평균 급여보다 더 적게 받는 직원의 이름, 직급코드, 급여를 조회

SELECT EMP_NAME, JOB_CODE, TO_CHAR(SALARY, 'L99,999,999') 급여
FROM EMPLOYEE
WHERE SALARY <= (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY DESC; -- 내림차순으로 해줄려면 끝에 DESC 붙일 것!!

-- 2) 최저 급여를 받는 사원의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

-- 3) '박정보' 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');

-- 4) '박정보' 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여, 부서명 조회
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보')
AND (DEPT_CODE = DEPT_ID);


-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');


-- 5) 부서별 급여 합계가 가장 큰 부서의 부서코드, 급여합 조회
    -- 5.1 부서별 급여 합계 중 가장 큰 값
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;     -- 17700000
    
    -- 5.2 부서별 급여합이 17700000인 부서
    SELECT DEPT_CODE
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    HAVING SUM(SALARY) = 17700000;

    -- 두 구문을 합치면
    SELECT DEPT_CODE, SUM(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                            FROM EMPLOYEE
                            GROUP BY DEPT_CODE);
                            

-- 6) '선우정보' 사원과 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회(단, 선우정보 제외)  
-->> 오라클
    -- 6.1 '선우정보' 부서 찾기
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '선우정보';    -- D1

    -- 6.2 '선우정보' 사원과 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회
SELECT DEPT_CODE, EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = 'D1' AND (DEPT_CODE = DEPT_ID);

    -- 6.3 '선우정보' 제외 (최종)
SELECT DEPT_TITLE, EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '선우정보') 
    AND (DEPT_CODE = DEPT_ID)
    AND EMP_NAME != '선우정보';
    
-- >> ANSI 구문
SELECT DEPT_TITLE, EMP_ID, EMP_NAME, PHONE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '선우정보')
    AND EMP_NAME != '선우정보';

--============================================================================
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
    쿼리 결과 여러행 한열인 것
    
    - IN 서브쿼리 : 여러개의 결과값 중에서 하나라도 일치하는 값이 있다면 가지고 와라
    
    - > ANY 서브쿼리 : 여러개의 결과값 중에서 하나라도 클 경우
    - < ANY 서브쿼리 : 여러개의 결과값 중에서 하나라도 작은 경우
    
    비교대상 > ANY(값1, 값2, 값3)  -- 비교대상이 값보다 하나라도 클 경우
    비교대상 < ANY(값1, 값2, 값3)  -- 비교대상이 값보다 하나라도 작은 경우 (== 가장 큰 값보다 작은 값이 있다면)
    
    비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3 -- 가장 작은 값보다 크면 
*/

-- 1) '강정보' OR '전지연' 사원과 같은 직급인 직원들의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE
FROM EMPLOYEE;

    -- 1.1) '강정보' OR '전지연' 사원의 직급
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('강정보', '전지연');   -- J3, J7

    -- 1.2) J3, J7 직급인 사원들의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3','J7');

    -- 최종본
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN ('강정보', '전지연'));
                    
                    
-- 2) 대리 직급임에도 과장들의 급여 중 최소급여보다 많이 받는 사원의 사번, 이름, 직급, 급여 조회
    -- 2.1 과장 직급의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'; -- 2200000 / 2500000 / 3760000

    -- 2.2 직급이 대리 이면서 급여가 위의 목록 값들 중 하나라도 큰 사원의 사번, 이름, 직급, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY(2200000, 2500000, 3760000); -- 세 가지 값 중 어느 것 하나라도 크면 된다. (즉, 가장 최소값 보다 크면 된다.)
    
    -- 2.3 최종
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY(SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');
    
-- 단일행 쿼리
    -- 대리 직급임에도 과장들의 급여 중 최소급여보다 많이 받는 사원의 사번, 이름, 직급, 급여 조회

    -- 단일행
    
SELECT MIN(SALARY)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

    -- 최종

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > (SELECT MIN(SALARY)
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');
    
    
-- 3) 차장 직급임에도 과장 직급의 급여보다 적게 받는 사원의 사번, 이름, 직급, 급여 조회
    -- 3.1 과장 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';  -- 2200000

    -- 3.2 차장 직급, 급여 조회
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';  -- 2800000, 1550000, 2490000, 2480000

    -- 3.3 차장 직급임에도 과장 직급의 급여보다 적게 받는 사원의 사번, 이름, 직급, 급여
    
    -- 과장의 가장 큰 금액보다 적게 받는 차장
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장' 
                        AND SALARY < ANY(SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME = '과장');


-- 4) 과장 직급임에도 차장 직급의 급여보다 많이 받는 사원의 사번, 이름, 직급, 급여 조회
    -- 4.1) 급여 조회 (차장의 가장 적게 받는 급여)
    -- ANY
    -- 비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' 
        AND SALARY > ANY(SELECT SALARY
                         FROM EMPLOYEE
                         JOIN JOB USING(JOB_CODE)
                        WHERE JOB_NAME = '차장');

-- ALL : 차장의 가장 많이받는 급여보다 많이 받는 과장
-- 비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' 
        AND SALARY > ALL(SELECT SALARY
                         FROM EMPLOYEE
                         JOIN JOB USING(JOB_CODE)
                         WHERE JOB_NAME = '차장');
--============================================================================
/*
    3. 다중열 서브쿼리
    한행에 여러열인 결과값 일 때
*/
-- 1) '장정보' 사원과 같은 부서코드, 직급코드에 해당하는 사원들의 이름, 부서코드, 직급코드, 입사일 조회

    -- 단일행 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보')
    AND JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '장정보'); 

    -- 한행 다중열로
    -- 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '장정보');
                                

-- 2) '지정보' 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사원명, 직급코드, 사수코드 조회
    -- 2.1) '지정보' 사원의 직급코드, 사수 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '지정보';

    -- 2.2) '지정보' 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사원명, 직급코드, 사수코드 조회
SELECT EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID = (SELECT MANAGER_ID
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '지정보') 
    AND JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '지정보');
                        
    -- 2.3) 최종
SELECT EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (MANAGER_ID, JOB_CODE) = (SELECT MANAGER_ID, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '지정보');
                        
                        
--============================================================================
/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회결과 여러행, 여러열이 나올 때
*/
-- 1.) 각 직급별 최소 금액의 급여 받는 사원의 사번, 이름 직급코드, 급여 조회

    -- 1.1) 각 직급(JOB_CODE)별 최소 금액 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

    -- 1.2) JOB_CODE와 SALARY가 일치해야한다.
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J1' AND SALARY = 8000000
                OR 'J2' AND SALARY = 3700000;

    -- 1.3) 최종
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE(JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);


-- 2.) 각 부서별 최고급여 금액을 받는 사원의 사번, 이름, 부서코드, 급여 조회
    -- 2.1) 각 부서별 최고급여 조회
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

    -- 최종
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE(DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                            FROM EMPLOYEE
                            GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE DESC;

--========================================================================
/*
    5. 인라인 뷰(INLINE VIEW)
    FROM절에 서브쿼리 작성
    
    서브쿼리 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 이름, 보너스를 포함한 연봉(별칭부여), 부서코드 조회
SELECT EMP_ID, EMP_NAME, (SALARY*(1+BONUS))*12 "연봉", DEPT_CODE
FROM EMPLOYEE;

    -- 조건1. 보너스 포함 연봉이 NULL이 나오지 않게
SELECT EMP_ID, EMP_NAME, (SALARY*NVL(1+BONUS, 1))*12 "연봉", DEPT_CODE
FROM EMPLOYEE;
    
    
    -- 조건2. 보너스를 연봉이 3000만원 이상인 사원들만 조회
SELECT EMP_ID, EMP_NAME, (SALARY*NVL(1+BONUS, 1))*12 "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY*NVL(1+BONUS, 1))*12 >= 30000000;


-- ★ WHERE절에 별칭을 사용하고 싶다면 INLINE VIEW를 사용하면 됨 
    -- 기존 EMPLOYEE이 아닌 "내가 정의한 테이블을 사용하겠다" 라는 의미
SELECT EMP_ID, EMP_NAME, 연봉, DEPT_CODE
FROM (SELECT EMP_ID, EMP_NAME, (SALARY*NVL(1+BONUS, 1))*12 "연봉", DEPT_CODE
      FROM EMPLOYEE)
WHERE 연봉 >= 30000000;


--  >> 인라인 뷰를 주로 사용하는 예 => TOP-N 분석(상위 몇위만 가져오기)

-- 사원들 중 급여를 많이 받는 상위 5명만 조회
-- * ROWNUM : 오라클에서 제공하는 컬럼. 조회된 순서대로 1부터 순번 부여 (ORDER BY랑 같이 사용함)
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;

        -- 실행 순서
        -- FROM -> SELECT -> ORDER BY(무엇을 하든 무조건 제일 마지막에 실행)
SELECT ROWNUM, EMP_NAME, SALARY -- ②
FROM EMPLOYEE   -- ①
ORDER BY SALARY DESC; -- ③

-- ORDER BY절이 수행된 이후 ROWNUM을 부여한 후 5명을 조회
SELECT ROWNUM, A.*  -- *을 넣어주고 싶다면, 위치를 특정할 수 있는 별칭을 부여해야한다. "A(별칭)에 모든 컬럼"
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
        FROM EMPLOYEE   
        ORDER BY SALARY DESC) A
WHERE ROWNUM <= 5;

-------------------------[문제풀이]-------------------------------------------

-- Q) 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
SELECT ROWNUM, A.*  -- SELECT * : 이렇게 표현해도 괜찮다. ROWNUM을 굳이 작성 할 필요없음!
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC) A
WHERE ROWNUM <= 5;


-- Q) 각 부서별 평균 급여가 높은 3개의 부서의 부서코드, 평균 급여 조회
    -- ★ 별칭 사용 법(이렇게 사용해도 가능)
    /*
        SELECT DEPT_CODE, ROUNG(평균급여)
        AVG(SALARY) 평균급여
    */
SELECT ROWNUM, A.*  -- SELECT DEPT_CODE, ROUNG(평균급여)
FROM (SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여 -- AVG(SALARY) 평균급여
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY 평균급여 DESC) A     -- ★ ORDER BY 2 DESC : DEPT_CODE(1번), ROUND(AVG(SALARY))(2번), 번호로도 부여 가능
WHERE ROWNUM <= 3;


--=============================================================================
/*
    순위를 매기는 함수(WINDOW FUNCTION)
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
    
         - RANK() OVER(정렬기준) : 동등한 순위가 나왔을 때 동등한 수위 수 만큼 건너뛰고, 순위를 계산한다.
                                    EX) 1, 2, 3, 3, 5
                                    
         - DENSE_RANK() OVER(정렬기준) : 동등한 순위가 나왔을 때, 바로 그 다음 순위가 나온다.
                                    EX) 1, 2, 3, 3, 4
                                    
    >> RANK()는 반드시 SELECT 절에서만 사용가능
        -- 인라인 뷰 밖에 쓸 수 없다
*/
-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;



-- 급여가 상위 5위인 사원들의 이름, 급여, 순위 조회
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
        FROM EMPLOYEE)
WHERE 순위 <= 5;













                        
                        