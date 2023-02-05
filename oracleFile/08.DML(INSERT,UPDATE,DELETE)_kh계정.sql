/*
    *DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어
    테이블에 값을 삽입, 삭제, 수정, 검색하는 구문
    - INSERT, UPDATE, DELETE, SELECT
*/
---==========================================================================---
/*
    1. INSERT
        테이블에 새로운 행을 추가하는 구문
        
        [표현식]
        1)INSERT INTO 테이블명 VALUES(값1, 값2, 값3, ...);
            테이블의 모든 컬럼에 대한 값을 넣어줘야 한다.
            테이블의 컬럼의 순서를 지켜 값을 넣어야 한다.
            
            값이 컬럼의 개수보다 부족하거나 많으면 오류
*/
INSERT INTO EMPLOYEE VALUES('223', '김아무개', '221115-1234567', 
    'KIM22@NAVER.COM', '01011112222', 'D1', 'J2', 4200000, 0.25, '200', '01/02/23', NULL, 'N');

-- ※ not enough values 에러 발생 : VALUES가 부족하다 <-> 너무 많아도 오류!
/*
INSERT INTO EMPLOYEE VALUES('223', '김아무개', '221115-1234567', 
    'KIM22@NAVER.COM', '01011112222', 'D1', 'J2', 4200000, 0.25, '200', '01/02/23', 'N');
*/

---==========================================================================---
/*
    [표현식]
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬러명3, ...) VALUES(값1, 값2, 값3);
    테이블에서 선택한 컬럼의 값만 넣고 싶을 때
    한 행 추가.
    값이 들어오지 않은 컬럼은 NULL이 들어감
    => NOT NULL, 기본키일때는 직접 값을 넣어야 한다.
    
    단, 기본값(DEFAULT)가 지정되어 있으면 기본값이 들어감
*/
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SALARY)
VALUES('224', '주몽', '210512-1548635', 'J3', 5130000);

-- ※ 넣고싶은 컬럼을 써주고, INSERT할 때 컬럼의 순서만 지켜주면 된다.
INSERT INTO EMPLOYEE(HIRE_DATE, EMP_NO, EMP_NAME, EMP_ID, JOB_CODE, DEPT_CODE)
VALUES(SYSDATE, '011130-2154853', '유리', 225, 'J1', 'D3');

INSERT 
    INTO EMPLOYEE
                (
                HIRE_DATE
              , EMP_NO
              , EMP_NAME
              , EMP_ID
              , JOB_CODE
              , DEPT_CODE
              )
VALUES
               (
               SYSDATE
             , '011130-2154853'
             , '유리'
             , 225
             , 'J1'
             , 'D3'
             );

---==========================================================================---
/*
    3) INSERT INTO 테이블명(서브쿼리);
        값을 넣는 대신 서브쿼리의 결과를 값으로 입력함(여러행도 가능)
*/
-- 테이블 생성
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_NAME VARCHAR2(20)
);
-- 전체 사원의 사번, 이름, 부서명을 검색
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 기존 테이블의 출력 내용을 내가 새롭게 만든 테이블에 INSERT 할 수 있다.
INSERT INTO EMP_01
    (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));

---==========================================================================---
/*
    4) INSERT ALL
        두개 이상의 테이블에 각각 INSERT할 경우
        이때 서브쿼리가 동일할 경우 사용
        
        [표현식]
        INSERT ALL
        INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
        INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
         서브쿼리
*/
-- 테이블 2개 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1=0;
    
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- INSERT ALL
INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';


---==========================================================================---
/*
    * 조건을 이용한 2테이블의 행 삽입
    
    [표현식]
        INSERT ALL
        WHEN 조건1 THEN
            INTO 테이블1 VALUES(컬럼명, 컬럼명, ...)
        WHEN 조건2 THEN
            INTO 테이블2 VALUES(컬럼명, 컬럼명, ...)
        서브쿼리;
            
*/
-- 2000년도 이전에 입사한 사원의 사번, 이름, 입사일, 급여를 넣을 테이블 생성
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;


-- 2000년도 이후에 입사한 사원의 사번, 이름, 입사일, 이메일을 넣을 테이블 생성
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, EMAIL
    FROM EMPLOYEE
    WHERE 1=0;

SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY, EMAIL
FROM EMPLOYEE;


INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN    
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, EMAIL)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY, EMAIL
FROM EMPLOYEE;

-- 1번. 350만원보다 많이 받는 사람 / 2번. 350만원보다 적게 받는 사람
-- 아이디, 이름, 이메일, 급여를 출력

-- 테이블 2개 생성
CREATE TABLE RICHMAN
AS SELECT EMP_ID, EMP_NAME, EMAIL, SALARY
    FROM EMPLOYEE
    WHERE 1=0;

CREATE TABLE POOLMAN
AS SELECT EMP_ID, EMP_NAME, EMAIL, SALARY
    FROM EMPLOYEE
    WHERE 1=0;

SELECT EMP_ID, EMP_NAME, EMAIL, SALARY
FROM EMPLOYEE;




INSERT ALL
WHEN SALARY >= 3500000 THEN
    INTO RICHMAN VALUES(EMP_ID, EMP_NAME, EMAIL, SALARY)
WHEN SALARY < 3500000 THEN
    INTO POOLMAN VALUES(EMP_ID, EMP_NAME, EMAIL, SALARY)
SELECT EMP_ID, EMP_NAME, EMAIL, SALARY
FROM EMPLOYEE; 


---==========================================================================---
/*
    3. UPDATE
    테이블의 값들을 수정하는 구문
    
    [표현식]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...
    WHERE 조건
    => 주의 : 조건을 제시하지 않으면 모든 컬럼의 데이터가 바뀜
*/
-- 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

UPDATE DEPT_COPY
SET DEPT_TITLE = 'KH기획팀';

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = 'KH기획팀'
WHERE DEPT_ID = 'D9';

-- 복사본 테이블 생성
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE;
    
-- 박정보 사원의 급여를 4백만원으로 변경
UPDATE EMP_SALARY
SET SALARY = 4000000
WHERE EMP_NAME = '박정보';

-- 지정보 사원의 급여를 2,200,00으로 보너스를 0.1로 변경
UPDATE EMP_SALARY
SET SALARY = 2200000,
    BONUS = 0.1
WHERE EMP_NAME = '지정보';

-- 전체 사원의 급여를 10% 인상한 금액으로 변경
UPDATE EMP_SALARY
SET SALARY = SALARY * 0.1 + SALARY;

---==========================================================================---
/*
    * UPDATE 시 서브쿼리 사용
    
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    WHERE 조건,
*/

-- 왕정보 사원의 급여와 보너스를 하정연의 급여와 보너스값으로 변경
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '하정연'),
    BONUS = (SELECT BONUS
                FROM EMPLOYEE
                WHERE EMP_NAME = '하정연')
WHERE EMP_NAME = '왕정보';

-- 다중열 서브쿼리 사용
UPDATE EMP_SALARY
SET(SALARY, BONUS) = (SELECT SALARY, BONUS
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '선우정보')
WHERE EMP_NAME = '선정보';


-- ASIA지역에서 근무하는 사원들의 보너스값을 0.3으로 변경



-- ASIA지역에서 근무하는 사원의 사번 검색
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                FROM EMPLOYEE
                JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                WHERE LOCAL_NAME LIKE 'ASIA%');
                
--===========================================================================---
-- UPDATE시에도 제약조건에 위배되면 UPDATE안됨

-- 200번 사원의 이름을 NULL로 수정하기 ※ 에러발생
UPDATE EMP_SALARY
SET EMP_NAME = NULL
WHERE EMP_ID = 200;

ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

/* 부모에 D0이라는 값이 없기 때문에 ERROR
UPDATE EMPLOYEE
SET DEPT_CODE = 'D0'
WHERE EMP_ID = 200;
*/

/* 부모의 J9라는 값이 없기 때문에 ERROR
UPDATE EMPLOYEE
SET JOB_CODE = 'J9'
WHERE EMP_ID = 200;
*/

--===========================================================================---
/*
    4. DELETE
        테이블의 값을 삭제하는 구문
        
        [표현식]
        DELETE FROM 테이블명
        [WHERE 조건식]
*/
DELETE FROM EMPLOYEE_COPY;

ROLLBACK;

-- '오정보' 사원의 데이터 지우기
DELETE FROM EMPLOYEE_COPY
WHERE EMP_NAME = '오정보';

DELETE FROM EMPLOYEE_COPY
WHERE DEPT_CODE = 'D1';

-- 제약조건에 위배되는 것은 삭제 할 수 없음 ???
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D2';

/*
    * TRUNCATE : 테이블 전체 데이터를 삭제하는 구문
                DELETE 구문보다 속도가 빠름
                별도의 조건 제시 불가
                ★ 주의사항
                    - ROLLBACK 불가
    [표현식]
    TRUNCATE TABLE 테이블명;  
*/
TRUNCATE TABLE EMPLOYEE_COPY;
ROLLBACK;

