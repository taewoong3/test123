-- 테이블의 컬럼 조회
/*
(')외따옴표 : 문자열을 감싸는 기호
(")쌍따옴표 : 컬럼명등을 감싸는 기호
*/

-----------------------------------------------------------
/*    
    <SELECT>
    데이터를 조회할 때 사용
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물 저장(행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는 컬럼명, 컬럼명 .... FROM 테이블명;
*/
-- EMPLOYEE테이블의 모든 컬럼(*) 조회  
SELECT * 
FROM employee;
    
--EMPLOYEE테이블에서 이름, 이메일, 급여 조회
SELECT EMP_NAME, EMAIL, SALARY
FROM EMPLOYEE;

-- LOCATION 테이블에서 모든 컬럼 조회
SELECT *
FROM LOCATION;

-- LOCATION 테이블에서 LOCAL_CODE와 LOCAL_NAME컬럼 조회
SELECT LOCAL_CODE, LOCAL_NAME
FROM LOCATION;
----------------------실습 문제----------------------------
-- 1. JOB 테이블에 직급만 조회

-- 2. DEPARTMENT 테이블의 모든 컬럼 조회

-- 3. DEPARTMENT 테이블의 부서코드, 부서명만 조회

-- 4. EMPLOYEE테이블에서 사원명, 이메일, 전화번호, 입사일, 급여 조회

------------------------------------------------------------
/*
    <컬럼값을 통한 산술연산>
    SELECT절 컬럼명 작성부분에 산술연산 가능
*/
-- EMPLOYEE테이블에서 사원명, 연봉(급여*12)조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 보너스가포함된연봉((급여*보너스+급여)*12)
SELECT EMP_NAME, SALARY, BONUS, (SALARY*BONUS + SALARY)*12
FROM EMPLOYEE;
--> 산술연산에서 NULL이 있으면 모두 NULL로 표시됨

-- EMPLOYEE테이블에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
-- DATE형식끼리도 연산 가능 : 결과값은 '일'단위
-- * 오늘날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
FROM EMPLOYEE;
-- 소수점이하로 나오는 이유는 분, 초의 시간정보까지 관리하기 때문

------------------------------------------------------------------
/*
    <컬럼명에 별칭 추가하기>
    산술연산시 컬럼명은 산술에 들어간 수식 그대로 컬럼명이 됨 이때, 별칭 부여
    
    [표현법]
    컬럼명 별칭 | 컬럼명 AS 별칭 | 컬럼명 "별칭" | 컬럼명 AS "별칭"
    
    * 별칭에 반드시 쌍따옴표가 들어가야 될 때
        - 띄어쓰기가 있던지, 특수문자가 들어가 있을 때
*/
SELECT EMP_NAME 이름, 
    SALARY AS 급여, 
    BONUS, 
    SALARY*12 "연봉(원)", 
    (SALARY*BONUS + SALARY)*12 "총 소득"
FROM EMPLOYEE;

-- NATIONAL테이블에서 NATIONAL_CODE(지역), NATIONAL_NAME(나라이름) 별칭부여

------------------------------------------------------------------------
/*
    <리터럴>
    임의로 지정한 문자열(' ')
    
    SELECT절에 리터럴을 제시하면 마치 테이블에 존재하는 데이터처럼 조회 가능
    모든 행에 반복적으로 출력됨
*/
-- EMPLOYEE테이블에서 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM EMPLOYEE;

-- SAL_GRADE테이블에서 MIN_SALARY컬럼 조회, MIN_SALARY컬럼 앞에 $붙이기
SELECT '$' AS 단위, MIN_SAL
FROM SAL_GRADE;

----------------------------------------------------------------------
/*
    <연결연산자>
|| : 여러 컬럼을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결 할 수 있다
    
*/
-- EMPLOYEE테이블에서 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- 컬럼값과 리터럴 연결
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '원'
FROM EMPLOYEE;

-------------------------------------------------------------------
/*
    <DISTINCT>
    컬럼에 중복된 값들을 한번씩만 표시하고자 할 때
*/
-- EMPLOYEE테이블에서 직급코드
SELECT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- 주의 사항 : DISTINCT는 SELECT절에서 딱 한번만 기술 가능
SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE;

------------------------------------------------------------
/*
    <WHERE 절>
    조회하고자 하는 테이블에서 특정 조건에 맞는 데이터만 조회할 때
    WHERE 절에 조건식을 제시(연산자 사용가능)
    
    [표현법]
    SELECT 컬럼명, 컬럼명, 산술연산 , ....
    FROM 테이블명
    WHERE 조건식;
    
    >> 비교 연산자
    >, <, >=, <=    -> 대소비교
    =               -> 같다
    !=, ^=, <>      -> 같지않다
*/
-- EMPLOYEE테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE테이블에서 부서코드가 'D1'인 사원들의 이름, 이메일, 부서코드 조회
SELECT EMP_NAME, EMAIL, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE테이블에서 부서코드가 'D1'이 아닌 사원들의 이름, 이메일, 부서코드 조회
SELECT EMP_NAME, EMAIL, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE ^= 'D1'; 
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE테이블에서 급여가 300만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- EMPLOYEE테이블에서 재직중인(ENT_YN 컬럼값이 'N')사원의 이름, 입사일
SELECT EMP_NAME, HIRE_DATE, ENT_YN
FROM EMPLOYEE
WHERE ENT_YN = 'N';

-------------------------  실습 문제   ---------------------------------
-- 1. 급여가 400만원 이하인 사원들의 이름, 급여, 입사일, 연봉 조회
SELECT EMP_NAME, SALARY, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY <= 4000000;

-- 2. 연봉이 5000만원 이상인 사원들의 이름, 급여, 연봉, 부서코드(DEPT_CODE) 조회
SELECT EMP_NAME, SALARY, SALARY*12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;

-- 3. 직급코드가 'J3'이 아닌 사원들의 사번(EMP_ID), 이름, 
--                              직급코드(JOB_CODE), 퇴사여부 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

-------------------------------------------------------------------
/*
    <논리연산자>
    AND : ~이면서, 그리고
    OR : ~이거나, 또는
*/
-- 부서코드가 'D9'이면서 급여가 500이상인 사원의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300이상인 사원의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- 급여가 350만원 이상 600만원 이하인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE 350000 <= SALARY <= 6000000; -- 오류
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

-----------------------------------------------------------------------
/*
    <BETWEEN AND>
    ~이상 ~이하인 범위에 대한 조건을 제시할 때 사용
    
    [표현법]
    비교대상컬럼 BETWEEN 하한값 AND 상한값
*/
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 입사일이 90/01/01 ~ 01/01/01 인 사원의 이름, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01';
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

---------------------------------------------------------------------
/*
    <LIKE>
    비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 것만 조회
    
    [표현법]
    비교대상컬럼 LIKE '특정패턴'
    : 특정 패턴 => '%','_' 와일드카드 사용
    
    >>
     - % : 0글자 이상
     EX) 비교대상컬럼 LIKE '문자%' => 비교대상의 컬럼값이 '문자'로 시작하는 컬럼 조회
         비교대상컬럼 LIKE '%문자' => 비교대상의 컬럼값이 '문자'로 끝나는 컬럼 조회
         비교대상컬럼 LIKE '%문자%' => 비교대상의 컬럼값이 '문자'가 포함되어 있는 컬럼 조회
     
     - _ : 1글자
     EX) 비교대상컬럼 LIKE '_문자' => 비교대상의 컬럼값이 '문자'앞에 무조건 한글자가 있는 컬럼 조회
         비교대상컬럼 LIKE '_ _문자' => 비교대상의 컬럼값이 4글자 '문자'로 끝나는 컬럼 조회
         비교대상컬럼 LIKE '_문자_' => 비교대상의 컬럼값이 4글자 '문자'앞에 한글자,
                                    '문자'뒤에 한글자가 있는 컬럼 조회
*/
-- 성이 전씨인 사원의 이름, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- 사원들 중 이름에 '하'자가 포함되어 있는 사원들의 이름, 주민번호, 전화번호 조회
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 사원들 중 이름 가운데에 '하'자가 있는 사원들의 이름, 주민번호, 전화번호 조회
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

-- 전화번호 중에서 3번째 자리가 1인 사원들의 이름, 전화번호, 이메일 조회
SELECT EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- 이메일 중 _(언더바) 앞의 글자가 3글자인 사원들의 이름, 이메일 조회
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%';

-- 와일드 카드로 사용되고 있는 문자와 컬럼값에 들어있는 문자가 동일하기 때문에 조회 안됨
-- _는 모두 와일드 카드로 인식
--> 어떤것이 와일드카드이고 데이터값인지 구분
--> 데이터값으로 취급하고자하는 값 앞에 나만의 와일드카드(아무거나 문자, 숫자,특수문자등)
--      제시하고 나만의 와일드카드를 ESCAPE OPTION으로 등록
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___#_%' ESCAPE '#';

-- 위의 조회결과 사원이 아닌 사원들의 이름, 이메일 조회
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE NOT EMAIL LIKE '___E_%' ESCAPE 'E';
-- NOT은 컬럼명 앞에 또는 LIKE앞에 기입 가능

----------------------  실습 문제 --------------------------------
--1. EMPLOYEE테이블에서 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

--2. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

--3. EMPLOYEE테이블에서 이름에 '하'자가 포함되어 있고, 급여가 240만원 이상인 사원들의
--          사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2400000;

--4. DEPARTMENT테이블에서 해외영업부인 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

--------------------------------------------------------------------
/*
    <IS NULL / IS NOT NULL>
    컬럼값에 NULL이 있는 경우 NULL값 비교에 사용
*/
-- EMPLOYEE테이블에서 보너스를 받지 못하는 사원의 이름, 급여, 보너스
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
-- WHERE BONUS = NULL;  조회안됨
WHERE BONUS IS NULL;

-- EMPLOYEE테이블에서 보너스를 받는 사원의 사번, 이름, 급여, 보너스, 연봉(보너스포함) 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, (SALARY*BONUS+SALARY)*12 연봉
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- EMPLOYEE테이블에서 사수(MANAGER_ID)가 없는 사원들의 사원명, 전화번호, 
--          사수번호, 부서코드 조회
SELECT EMP_NAME, PHONE, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서배치는 받지 않았지만 보너스는 받는 사원의 이름, 보너스, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

--------------------------------------------------------------------
/*
    <IN / NOT IN>
    IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는것만 조회
    NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지만 조회
    
    [표현법]
    비교대상컬럼 IN ('값1', '값2', '값3'...)
*/
-- 부서코드가 D5이거나 D6이거나 D8인 사원의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D5' OR DEPT_CODE = 'D8';
WHERE DEPT_CODE IN('D5','D6','D8');

-- 부서코드가 'D6','D5','D8'를 제외한 사원의 이름, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN('D5','D6','D8');

--------------------------------------------------------------------------
/*
    <연산자의 우선순위>
    1. ()
    2. 산술연산자
    3. 연결연산자
    4. 비교연산자
    5. IS NULL / LIKE / IN
    6. BETWEEN AND
    7. NOT(논리연산자)
    8. AND(논리연산자)
    9. OR(논리연산자)
*/
-- ** OR보다 AND연산자가 먼저 수행됨
-- 직급코드가 J7이거나 J2인 사원들의 급여가 200만원 이상인 사원들의 이름, 직급코드, 급여조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
-- WHERE JOB_CODE = 'J7' OR JOB_CODE='J2' AND SALARY >= 2000000;
WHERE (JOB_CODE = 'J7' OR JOB_CODE='J2') AND SALARY >= 2000000;


------------------------------ 실습 문제 ------------------------------
--1. 사수가 없고 부서배치도 받지 않은 사원들의 이름, 사수번호, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

--2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않는 사원들의 사번, 이름, 
--      급여, 보너스, 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY*12 >= 30000000 AND BONUS IS NULL;

--3. 입사일이 95/01/01이상이고 부서배치를 받은 사원들의 사번, 이름, 입사일, 
--      부서코드 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL;

--4. 급여가 200만원 이상 500만원 이하이고, 입사일이 01/01/01 이상이고,
--      보너스를 받지 않는 사원들의 사번, 이름, 급여, 입사일, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000
    AND HIRE_DATE >= '01/01/01'
    AND BONUS IS NULL;
    
--5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의
--      이름, 급여, 보너스, 연봉(보너스포함) 조회
SELECT EMP_NAME, SALARY, BONUS, (SALARY*BONUS+SALARY)*12 연봉
FROM EMPLOYEE
WHERE (SALARY*BONUS+SALARY)*12 IS NOT NULL
    AND EMP_NAME LIKE '%하%';
    
------------------------------------------------------------------
/*
    <ORDER BY>
    내가 제시한 컬럼을 기준으로 정렬
    - SELECT문 마지막에 기술, 실행순서도 마지막
    
    [표현법]
    SELECT 컬럼1, 컬럼2, 컬럼3...
    FROM 테이블명
    WHERE 조건식
    ORDER BY 정렬기준의 컬럼명 | 별칭 | 컬럼순번 [ASC|DESC] [NULLS FIRST|NULLS LAST];
    
    - ASC : 오름차순 정렬(생략시 기본값)
    - DESC : 내림차순 정렬
    
    - NULLS FIRST : 정렬하고자 하는 컬럼값이 NULL이 있을 경우 데이터의 맨 앞에 배치
                    생략시 DESC의 기본값
    - NULLS LAST : 정렬하고자 하는 컬럼값이 NULL이 있을 경우 데이터의 맨 뒤에 배치
                    생략시 ASC의 기본값     
*/
SELECT *
FROM EMPLOYEE
--ORDER BY BONUS; -- ASC 기본값 NULL값은 맨 마지막
--ORDER BY BONUS ASC;   
--ORDER BY BONUS DESC NULLS LAST;    
ORDER BY BONUS DESC, SALARY;   -- 정렬기준 여러개 제시 가능
    
-- 전 사원의 사원명, 연봉(보너스포함) 조회(연봉별 내림차순 정렬로 조회)
SELECT EMP_NAME, (SALARY*(1+BONUS))*12 연봉
FROM EMPLOYEE
--ORDER BY (SALARY*(1+BONUS))*12 DESC NULLS LAST;
ORDER BY 연봉 DESC NULLS LAST;         -- 별칭 사용
--ORDER BY 2 DESC NULLS LAST;              -- 컬럼 순번