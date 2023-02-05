/*
    <JOIN>
    두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용
    조회한 결과는 RESULT SET에 담겨서 조회
    
    관계형 데이터베이스는 최소한의 데이터를 각각 테이블에 담고 있다.
    (중복을 최소화하기 위해 최대한 나누어서 관리)
    
    => SQL문을 이용하여 테이블간의 관계를 맺는 방법
                            [JOIN 용어 정리]
            오라클 전용 구만         |         ANSI 구문
    -------------------------------------------------------------------------
        등가조인                    |        내부조인(INNER JOIN) => JOIN USING/ON
        (EQUAL JOIN)              |        자연조인(NATURAL JOIN) => JOIN USING
    -------------------------------------------------------------------------
        포괄조인                    |       왼쪽 외부 조인(LEFT OUTER JOING)
        (LEFT JOIN)                |       오른쪽 외부 조인(RIGHT OUTER JOIN)
        (RIGHT JOIN)               |        전체 외부 조인(FULL OUTER JOING)
    -------------------------------------------------------------------------
        자체조인                    |        JOIN ON
        비등가조인(NON EQUL JOIN)    |        
*/

/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIL)
        연결시키는 컬럼의 값이 일치하는 행들만 조인되어 조회
*/
-- 오라클 전용 구문
--  FROM절에 조회하고자 하는 테이블을 나열(,를 구분자로)
--  WHERE절에 매칭하고자 하는 컬럼에 대한 조건을 제시

-- 1) 연결할 컬럼명이 서로 다른 경우
-- 사번, 이름, 부서코드, 부서명을 조회 // ★ 부서명은 DEPARTMENT에 속해있다.
-- 연결고리(EMPLOYY : DEPT_CODE / DEPARTMENT : DEPT_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 일치하는 값이 없으면 조회에서 제외

-- 2) 연결할 컬럼명이 서로 같은 경우
-- 사번, 이름, 직급코드, 직급명을 조회 
-- 연결고리(EMPLOYY : JOB_CODE / JOB : JOB_CDE)
SELECT EMP_ID, EMP_NAME , JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;

-- 해결 방법1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결 방법2) 테이블에 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME , E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J  -- ★ 제일먼저 실행되기 때문에 별칭 사용 가능
WHERE E.JOB_CODE = J.JOB_CODE;

-- ======================================================================== --

-- >> ANSI 구문
-- FROM절에는 기준이 되는 테이블 1개를 기술
-- JOIN절에 조회하고자하는 테이블을 기술 + 매칭시킬 컬럼에 대한 조건 기술
-- JOIN USGIN | JOIN ON

-- 1) 연결할 컬럼명이 서로 다른 경우
-- 사번, 이름, 부서코드, 부서명을 조회 // ★ 부서명은 DEPARTMENT에 속해있다.
-- 연결고리(EMPLOYY : DEPT_CODE / DEPARTMENT : DEPT_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE   -- 기준이 되는 테이블
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 기준 테이블과 연결 할 테이블

-- 2) 연결할 컬럼명이 서로 같은 경우
-- 사번, 이름, 직급코드, 직급명을 조회 
-- 연결고리(EMPLOYY : JOB_CODE / JOB : JOB_CDE)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB ON (JOB_CODE = JOB_CODE);

-- 해결방법1) 테이블에 별칭 부여
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 해결방법2) JOIN USING을 이용하는 방법(두 컬럼명이 같을때만 사용)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

----------------------------------------------------------------------------
                                -- [참고] --
                                -- > 잘 사용 안해서
/*
    자연 조인 : 각 테이블마다 동일한 컬럼이 한개만 존재할 경우
*/
-- 매칭되는 컬럼이 JOB_CODE 하나이기 때문에
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;


-- 추가적인 조건 제시도 가능
-- 직급이 대리인 사원의 사번, 이름, 직급명, 급여를 조회
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
        AND JOB_NAME = '대리';
        
-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)    -- 테이블에 조인 되는 것(컬럼)만 가능
WHERE JOB_NAME = '대리';     -- 조건은 WHERE절을 별도로 사용해야 한다.

------------------------------ 실습 문제 ---------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회
-- >> 오라클 전용 구문 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE = '인사관리부';


-- >> ANSI 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';



-- 2. DEPARTMENT과 LOCATION을 참조하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-- >> 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- >> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);




-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;



-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여 조회
-->> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') "급여"
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_ID != 'D9';

-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') "급여"
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_ID != 'D9';

--===========================================================================
/*
    2. 포괄조인 / 외부조인
    두 테이블 사이를 JOIN할 때 일치하지 않는 행도 포함시켜 조회
    <단, 반드시 LEFT / RIGHT를 지정해야 함 (기준점이 되는 테이블을 반드시 넣어줘야 한다)>
*/

-- 사원명, 부서명, 급여, 연봉
-->> 부서배치가 안된 사원 2명에 대한 정보가 안나온다.
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN
-- >> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- ★ LEFT 쪽 즉, EMPLOYEE 테이블에 있는 모든 정보를 다 나오게 하라는 의미

--  >> 오라클 전용 구문
-- (+) : 기준이 아닌 테이블의 컬럼명에 기호(+)를 넣어줌
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);


-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN

-- >> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE 
RIGHT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- ★ LEFT 쪽 즉, EMPLOYEE 테이블에 있는 모든 정보를 다 나오게 하라는 의미

--  >> 오라클 전용 구문
-- (+) : 기준이 아닌 테이블의 컬럼명에 기호(+)를 넣어줌
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행 조회
--      >> ★ 오라클 전용구문에는 없음. (반드시, ANSI구문으로만 가능)
SELECT EMP_NAME, DEPT_TITLE, TO_CHAR(SALARY, 'L99,999,999') 월급, TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


--==============================================================================
/*
    3. 비등가 조인
        매칭시킬 컬럼에 대한 조건 작성시 등호(=)를 사용하지 않는 JOIN문
        ANSI구문으로는 JOIN ON으로만 가능
*/

-- 사원명, 급여, 급여레벨 조회
-- >> 오라클 전용 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
--WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- >> ANSI 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

--==============================================================================
/*
    4. 자체조인(SELF JOIN)
    같은 테이블을 다시 JOIN하는 경우
*/

-- 전체사원의 사원번호, 사원명, 사원부서코드 => EMPLOYEE
--           사수번호, 사수명, 사수부서코드 => EMPLOYEE
-- >> 오라클 전용 구문
SELECT E.EMP_ID 사원번호, E.EMP_NAME 사원명, E.DEPT_CODE 사원부서코드, 
       M.EMP_ID 사수번호, M.EMP_NAME 사수명, M.DEPT_CODE 사수부서코드
FROM EMPLOYEE E, EMPLOYEE M
-- WHERE E.MANAGER_ID = M.EMP_ID;    >> 사수가 없는 행은 안나옴
WHERE E.MANAGER_ID = M.EMP_ID(+);


-- >> ANSI 구문
SELECT E.EMP_ID 사원번호, E.EMP_NAME 사원명, E.DEPT_CODE 사원부서코드, 
       M.EMP_ID 사수번호, M.EMP_NAME 사수명, M.DEPT_CODE 사수부서코드
FROM EMPLOYEE E
--  JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);   >> 사수가 없는 행은 안나옴
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

--=============================================================================
/*
    다중 JOIN(이런 말은 없음. 수업 진행을 위해 작명함)
    2개 이상의 테이블을 JOIN
*/
-- 사번, 사원명, 부서명, 직급명 조회
-- EMPLOYEE     : DEPT_CODE, JOB_CODE
-- DEPARTMENT   : DEPT_ID
-- JOB          :            JOB_CODE

-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID 
        AND E.JOB_CODE = J.JOB_CODE;
        
-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);


-- 사번, 사원명, 부서명, 지역명 조회
-- EMPLOYEE     : DEPT_CODE
-- DEPARTMENT   : DEPT_ID    LOCATION_ID
-- LOCATION     :            LOCAL_CODE

-- >> 오라클 전용 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCAL_CODE = LOCATION_ID;

-- >> ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID);

----------------------------- 실습 문제 -----------------------------------------
-- 1). 사번, 사원명, 부서명, 지역명, 국가명 조회(4개 테이블 조인 국가명은 NATIONAL 테이블)
-- >> 오라클 전용 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE, DEPARTMENT, LOCATION L, NATIONAL N
WHERE DEPT_CODE = DEPT_ID 
    AND LOCAL_CODE = LOCATION_ID 
    AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-- >> ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE);

-- 2). 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회 (모든 테이블 조인)
-- >> 오라클 전용 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, JOB_NAME 직급명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명, SAL_LEVEL 급여등급
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE
WHERE E.DEPT_CODE = D.DEPT_ID(+) 
        AND E.JOB_CODE = J.JOB_CODE(+)
        AND D.LOCATION_ID = L.LOCAL_CODE(+)
        AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
        AND E.SALARY BETWEEN MIN_SAL AND MAX_SAL;
        
-- >> ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, JOB_NAME 직급명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명, SAL_LEVEL 급여등급
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB USING (JOB_CODE)
LEFT JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
LEFT JOIN NATIONAL USING (NATIONAL_CODE)
LEFT JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);


