------------------------ 문제 1 ------------------------
/*
계정명 : SCOTT, 비밀번호 : kh1234 계정 생성
일반 사용자계정인 kh계정에 접속하여 CREATE USER SCOTT;로 실행하니 문제가 발생,
이를 조치하시오

1. 문제점
    계정 생성은 반드시 관리자계정에서만 가능
1. 조치사항
    관리자계정(SYSTEM or SYS)에서 계정 생성해야함'
    
2. 문제점
    생성 SQL구문 오류
2. 조치사항
    CREATE USER SCOTT IDENTIFIED BY kh1234;
    
3. 문제점
    권한을 설정하지 않음
3. 조치사항
    GRANT CONNECT, RESOURCE TO SCOTT;   == >> RESOURCE가 주어지면 테이블까지 만드는 것
    GRANT CONNECT TO SCOTT;             == >> 접속은 가능!!
    GRANT CREATE SESSION TO SCOTT;
    
    
    
    Q)테이블을 생성하려고 하는데 생성이 안됨
    
    문제점) 
    권한을 설정하지 않아서
    
    조치사항)
    GRANT RESOURCE TO SCOTT;                    ==>> 테이블 만들 수 있다. OR (     GRANT CREATE TABLE TO SCOTT;    )
    GRANT RESOURCE, CREATE VIEW TO SCOTT;       ==>> 테이블 및 뷰까지 만들 수 있다.
    
*/

------------------------ 문제 2 ------------------------
/*
    TABLE 생성
*/
CREATE TABLE KH123(
    KID NUMBER PRIMARY KEY,
    KNAME VARCHAR2(20) NOT NULL,
    KNO CHAR(14) UNIQUE NOT NULL,
    KAGE NUMBER CHECK(KAGE BETWEEN 1 AND 200),   -- 값은 1~200사이의 숫자만 입력
    KYN CHAR(1) CHECK(KYN IN ('Y', 'N'))        -- 수강중이면 Y, 수강하지 않았으면 N
);


------------------------ 문제 3 ------------------------
/*
DDL 개념 및 명령어
    개념
        DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
        주로 DB관리자, 설계자가 사용
        실제 데이터 값이 아닌 구조 자체를 정의하는 언어
    명령어
       오라클에서 제공하는 객체(OBJECT)를 생성(CREATE), 구조를 변경(ALTER)하고, 구조 자체를 삭제(DROP)하는 언어
DML 개념 및 명령어
    개념
        DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어
    명령어
        테이블에 값을 삽입, 삭제, 수정, 검색하는 구문
        INSERT, UPDATE, DELETE, SELECT
DCL 개념 및 명령어
    개념
        <DCL : DATA CONTROL LANGUAGE> : 데이터 제어 언어
        데이터베이스에 접근하고 객체들을 사용하도록 권한을 주고 회수하는 명령어들을 말함.
    명령어
        GRANT, REVOKE

집합연산자 개념과 명령어

    여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
    
    - UNION : 합집합 | OR          => 두 쿼리문을 수행한 결과값을 더한 후, 중복되는 값은 제거하고 반환
    - INTERSECT : 교집합 | AND     => 두 쿼리문을 수행한 결과값에 중복된 결과값만 반환
    - UNION ALL : 합집합 + 교집합   => 두 쿼리문의 모든 결과값 반환(중복값도 포함)
    - MINUS : 차집합               => 앞 쿼리문의 결과에서 뒤의 쿼리문의 결과를 뺀 나머지
*/




------------------------ 문제 4 ------------------------
-- EMPLOYEE 테이블에서 보너스를 받지 않고 부서배치는 되어 있는 사원 조회
SELECT *
FROM EMPLOYEE
WHERE BONUS IS NULL AND DEPT_CODE IS NOT NULL;

------------------------ 문제 5 ------------------------
/*
    JOB_CODE가 J7이거나 J6이면서 SALARY값이 200만원 이상이고,
    BONUS가 있고 여자이며 이메일 주소는 _앞에 3글자만 있는 사원의
    EMP_NAME, EMP_ID, JOB_CODE, DEPT_CODE, SALARY, BONUS조회
*/
SELECT EMP_NAME, EMP_ID, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE JOB_CODE IN('J7','J6') 
    AND SALARY >= 2000000
    AND BONUS IS NOT NULL
    --AND EMP_NO LIKE '_______2%'
    AND SUBSTR(EMP_NO,8,1) IN ('2','4')
    AND EMAIL LIKE '___#_%' ESCAPE '#';

------------------------ 문제 6 ------------------------
    -- ROWNUM을 활용하여 급여가 가장 높은 5명을 조회하고 싶었으나, 제대로 조회되지 않음
    -- 어떤 문제점이 있는지 해결안 SQL문 작성하시오.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--  문제점
    -- ORDER BY는 가장 마지막에 실행되기 때문에, ROWNUM이 적용된 이후에 ORDER BY가 적용되어 순서가 꼬였음

--  조치사항
    -- ORDER BY를 우선 실행 시켜줘야 하기 때문에, FROM절에 넣어주고, 후에 ROWNUM을 실행시켜줌
SELECT ROWNUM, A.*
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) A
WHERE ROWNUM <= 5;

------------------------ 문제 7 ------------------------
    -- 부서별 평균 급여가 270만원을 초과하는 부서들에 대해 부서코드, 부서별 총 급여합, 평균급여, 사원수 조회
    
-- 나의 오답
SELECT A.*
FROM (SELECT DEPT_CODE 부서코드, SUM(SALARY) "부서별 총 급여", ROUND(AVG(SALARY)) "부서별 평균급여", COUNT(EMP_NAME) "사원 수"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY ROUND(AVG(SALARY)) DESC) A
WHERE "부서별 평균급여" > 270000;


-- 선생님 정답
SELECT DEPT_CODE, SUM(SALARY) 총합, ROUND(AVG(SALARY)) 평균, COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 2700000
ORDER BY DEPT_CODE;
















