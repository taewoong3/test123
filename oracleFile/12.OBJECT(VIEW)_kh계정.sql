/*
    < VIEW >
    SELECT문을 저장해둘 수 있는 객체
    (자주 쓰이는 긴 SELECT문을 저장해두면 더 편함)
    임시테이블 같은 존재(실제 데이터가 있는거 아님 -> 가상테이블)
*/
-- '한국'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- >> 오라클 전용 방식
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L
WHERE (E.DEPT_CODE = D.DEPT_ID) 
    AND (D.LOCATION_ID = L.LOCAL_CODE) 
    AND(N.NATIONAL_CODE = L.NATIONAL_CODE) 
    AND NATIONAL_NAME = '한국';

-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';




-- '러시아'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- >> 오라클 전용 방식
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L
WHERE (E.DEPT_CODE = D.DEPT_ID) 
    AND (D.LOCATION_ID = L.LOCAL_CODE) 
    AND(N.NATIONAL_CODE = L.NATIONAL_CODE) 
    AND NATIONAL_NAME = '러시아';

-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';



    
-- '일본'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- >> 오라클 전용 방식
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L
WHERE (E.DEPT_CODE = D.DEPT_ID) 
    AND (D.LOCATION_ID = L.LOCAL_CODE) 
    AND(N.NATIONAL_CODE = L.NATIONAL_CODE) 
    AND NATIONAL_NAME = '일본';
    
-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본'; 
    
    
--------------------------------------------------------------------------------
/*
    1. VIEW 생성 방법
    
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
*/
CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
    JOIN NATIONAL USING (NATIONAL_CODE);
    
-- 관리자계정에서 권한 부여
GRANT CREATE VIEW TO KH;

SELECT * FROM VW_EMPLOYEE;

-- '한국'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT * 
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';
    
--------------------------------------------------------------------------------
/*
    * 뷰에 별칭 부여
    서브쿼리에 SELECT절에 함수식이나 산술연산식이 기술되어 있는 경우는 반드시 별칭 부여해야함
*/
-- 전 사원의 사번, 이름, 직급명, 성별(남,여), 근무년수 조회하는 뷰(VW_EMP)를 생성
SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, 
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) || '년' 근무년수
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

SELECT * FROM VW_EMP;

-- OR REPLACE = 이미 같은 이름의 VIEW가 존재하면, 덮어쓰기
CREATE OR REPLACE VIEW VW_EMP(사번, 이름, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
        FROM EMPLOYEE
        JOIN JOB USING(JOB_CODE);

SELECT 이름, 성별, 직급명
FROM VW_EMP
WHERE 성별 = '여';
    
SELECT 이름, 근무년수
FROM VW_EMP
WHERE 근무년수 >= 20;
    
    
-- 뷰 삭제
DROP VIEW VW_EMP;
    
    
--------------------------------------------------------------------------------
-- 생성된 뷰를 이용하여 DML(UPDATE, INSERT, DELETE) 사용가능
-- 실제 테이블에도 반영됨

CREATE OR REPLACE VIEW VW_JOB
AS SELECT *
    FROM JOB;
    
-- 뷰를 통해 INSERT
INSERT INTO VW_JOB VALUES('J9', '인턴');
    
-- 뷰를 통해 UPDATE
UPDATE VW_JOB 
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J9';
    
-- 뷰를 통해 DELETE
DELETE FROM VW_JOB
WHERE JOB_CODE = 'J9';
    
--------------------------------------------------------------------------------
/*
    * 뷰를 통해 DML명령어를 조작 불가능할 경우가 더 많다
    
    1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 할 경우
    2) 뷰에 정의되어있지만, 테이블에 제약조건이 NOT NULL일 경우
    3) 산술연산식이나 함수식으로 정의되어 있는 경우
    4) 그룹함수나 GROUP BY절에 포함된 경우
    5) DISTINCT 구문이 포함되어 있는 경우
    6) JOIN이용하여 여러 테이블을 연결 시켰을 경우
*/
-- 1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 할 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE
    FROM JOB;
    
INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES('J9', '인턴');

/* 오류발생
UPDATE VW_JOB
    SET JOB_NAME = '인턴'
    WHERE JOB_CODE ='J9';

*/

-- 2.) 뷰에 정의되어있지만 테이블에 제약조건이 NOT NULL일 경우
    -- JOB_NAME컬람만 있는 VIEW 생성
CREATE OR REPLACE VIEW VW_JOB2
AS SELECT JOB_NAME
    FROM JOB;

-- INSERT
/* ★ 오류 발생 : 실제 테이블에 연동이 되기 때문(JOB_CODE가 기본키라서 반드시 삽입이 이루어져야 한다.)            
INSERT INTO VW_JOB2 VALUES('알바');
*/

-- UPDATE
UPDATE VW_JOB2
    SET JOB_NAME = '알바'
    WHERE JOB_NAME = '수습사원';

-- DELETE
/*  ★ 오류발생 : EMPLOYEE에서 JOB_CODE 'J7'을 사용중이며, JOB_CODE에는 FOREIGN KEY가 설정되어 있기 때문에
              : 외래키로 설정되어 있어 자식 테이블에서 사용하고 있기 때문
DELETE FROM VW_JOB2
WHERE JOB_NAME = '사원';
*/

-- 삭제 성공 : 외래키로 설정되어 있어도 자식 테이블(EMPLOYEE)에서 사용하지 않기 때문
DELETE FROM VW_JOB2
WHERE JOB_NAME = '알바';
    
    
--  3) 산술연산식이나 함수식으로 정의되어 있는 경우
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
    FROM EMPLOYEE;

-- INSERT 오류 : 원본 테이블에는 연봉을 넣을 수 있는 컬럼이 없다
INSERT INTO VW_EMP_SAL
VALUES(500, 'KH정보', 4000000, 48000000);

-- UPDATE 오류 : 원본테이블에 수정 할 연봉의 컬럼이 존재하지 않음
UPDATE VW_EMP_SAL
    SET 연봉 = 70000000
    WHERE EMP_ID = 200;

-- (성공) : 원본테이블에서 업데이트가 가능하면, 뷰 테이블 업데이트도 가능하다.
UPDATE VW_EMP_SAL
    SET SALARY = 7000000
    WHERE EMP_ID = 225;    
    
-- DELETE(성공)
DELETE FROM VW_EMP_SAL
WHERE 연봉 = 84000000;
    

--  4) 그룹함수나 GROUP BY절에 포함된 경우
CREATE OR REPLACE VIEW VW_GROUP
AS SELECT DEPT_CODE, SUM(SALARY) 합계, ROUND(AVG(SALARY)) 평균
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
-- INSERT(에러) : 원본테이블에 합계와 평균 컬럼이 없기 때문
INSERT INTO VW_GROUP VALUES('D3', 7500000, 3000000);
    
-- UPDATE(에러)
UPDATE VW_GROUP
    SET 합계 = 18000000
    WHERE DEPT_CODE = 'D2';
    
    
-- 5) (※에러)DISTINCT 구문이 포함되어 있는 경우
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT DISTINCT JOB_CODE
    FROM EMPLOYEE;

-- INSERT(에러) : 원본테이블 컬럼에 NOT NULL OR PRIMARY KEY 등 여러가지 이유가 있다. 
INSERT INTO VW_EMP_JOB VALUES('J8');

-- DELETE, UPDATE(에러)


-- 6) JOIN이용하여 여러 테이블을 연결 시켰을 경우
CREATE OR REPLACE VIEW VW_JOIN
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- INSERT(에러)
-- 다른 테이블이라서 에러 & DEPT_ID가 PRIMARY KEY라서 무조건 넣어줘야 하는데 안넣음
-- 여러가지 문제가 있음
INSERT INTO VW_JOIN VALUES(300, '황제익', '총무부');

-- UPDATE(에러)
-- VW_JOIN의 컬럼 중 DEPT_TITLE과 EMP_ID는 서로 다른 원본 테이블이기 때문에
    -- 원본 테이블인 EMPLOYEE 테이블에는 DEPT_TITLE도 없고, DEPARTMENT 테이블에는 EMP_ID가 없다.
UPDATE VW_JOIN
    SET DEPT_TITLE = '총무부'
    WHERE EMP_ID = 203;

-- UPDATE - 2
UPDATE VW_JOIN
    SET EMP_NAME = '김새롬'
    WHERE EMP_ID = 200;

-- DELETE 
DELETE FROM VW_JOIN
    WHERE EMP_ID = 224;
    
DELETE FROM VW_JOIN
    WHERE DEPT_TITLE = '총무부';

ROLLBACK;

--=============================================================================
/*
    * VIEW 옵션
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
    AS 서브쿼리;
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE : 기존에 동일한 뷰가 있으면 덮어쓰기 하고, 뷰가 없으면 생성
    2) FORCE | NOFORCE
        >> FORCE : 서브쿼리에 기술된 테이블이 없어도 뷰가 생성됨
        >> NOFORCE : 서브쿼리에 기술된 테이블이 있어야만 뷰가 생성됨(기본값)
    3) WITH CHECK OPTION : DML(SELECT제외)시 서브쿼리에 기술된 제약조건에 부합하는 값으로만 DML 가능
    4) WITH READ ONLY : 뷰에 대해 조회만 가능. DML(SELECT 제외) 불가능
                                        DML = DELETE, INSERT, UPDATE
*/
-- 2) FORCE | NOFORCE
--  2.1) NOFORCE (= DEFAULT VALUE)
CREATE OR REPLACE /*NOFORCE*/ VIEW VW_TT
AS SELECT TCODE, TNAME, TCOUNT
    FROM TT;

--  2.2) FORCE
-- 오류는 발생하지만, 테이블 생성은 가능 (단, 사용할려면 DATA_TYPE은 설정해줘야 한다.)
CREATE OR REPLACE FORCE VIEW VW_TT
AS SELECT TCODE, TNAME, TCOUNT
    FROM TT;

-- TT 테이블 생성
CREATE TABLE TT(
    TCODE NUMBER, 
    TNAME VARCHAR2(20), 
    TCOUNT NUMBER
);
-- DATA_TYPE이 들어온다.
SELECT * FROM VW_TT;

-- 3) WITH CHECK OPTION
--  WITH CHECK OPTION 사용 안함
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000;    -- 10명
    
    
-- 서브쿼리에 부합되지 않는 값으로 UPDATE
UPDATE VW_EMP
    SET SALARY = 2000000
    WHERE EMP_ID = 200;         -- 9명
    
ROLLBACK;   -- 10명


--  WITH CHECK OPTION 사용
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000
    WITH CHECK OPTION;


/* ※(오류 발생) : 서브쿼리에 기술한 조건에 부합하지 않기 때문에 변경 불가
               
UPDATE VW_EMP
    SET SALARY = 2000000
    WHERE EMP_ID = 200;
*/

-- (성공) 서브쿼리 조건에 부합하기 때문에 가능
UPDATE VW_EMP
    SET SALARY = 4000000
    WHERE EMP_ID = 200;

ROLLBACK;


-- 4) WITH READ ONLY
CREATE OR REPLACE VIEW VW_EMP1
AS SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
WITH READ ONLY;

-- 읽기만 하니까 출력은 가능
SELECT * FROM VW_EMP1;


/* ※(오류 발생)DML 전부 불가
DELETE FROM VW_EMP1
    WHERE EMP_ID = 200;
*/























    
    
    