/*
    <PL/SQL>
    PROCEDURE LANGUAGE EXTENSTION TO SQL
    
    오라클 자체내에 내장되어 있는 절차적 언어
    SQL문장 내에서 변수를 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하는 SQL문의 단점 보완
    다수의 SQL문을 한번에 실행가능(BLOCK구조)
    
    * PL/SQL 구조
    - [선언부(DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
        >> ※ 필요하지 않으면 사용하지 않아도 된다.
    - 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
    - [예외발생부(EXCEPTION SECTION)] : EXCEPTION으로 시작, 예외발생시 해결하기 위한 구문
*/
-- 화면에 HELLO ORACLE 출력
SET SERVEROUTPUT ON   -- SERVEROUTPUT에 출력문이 있다. 실행하기전 한번만 ON 해주면 됨.

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/
/*
    1. DECLARE 선언부
    변수 및 상수를 선언하거나 초기화하는 공간
    일반타입변수(상수), 레퍼런스타입의 변수(상수), ROW타입의 변수(상수)
    
    1.1) 일반타입의 변수선언 및 초기화
        [표현식] 
        변수명 [CONSTANT] 자료형 [:=값];
        EX.)
        --------- [JAVA] ---------
        int num1 = 3;
        
        --------- [PL/SQL] ---------
        num1 number := 3;
*/
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);                -- 변수 선언
    PI CONSTANT NUMBER := 3.141592;    -- 상수 선언과 초기화
BEGIN
    EID := &ID;         -- &__ : 사용자로부터 입력받는 대화창이 표시
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('아이디 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/
--============================================================================--
/*
 1.2) 레퍼런스 타입의 변수 선언 및 초기화
        : 테이블의 컬럼을 데이터 타입을 참조하여 그 타입으로 지정
          [표현식] 
          변수명 테이블명.컬럼명%TYPE;
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '400';
    ENAME := '김똥깡';
    SAL := 5000000;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/

/*
테이블에 있는 데이터를 변수에 저장하여 출력하기
사번 200인 사원의 사번, 이름, 급여 검색하기
*/
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_ID = 200;

-- PL/SQL 작성 위의 3개의 컬럼의 값을 넣을 변수 선언
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL    -- INTO : 해당 컬럼에 선언한 변수를 집어 넣을 때
    FROM EMPLOYEE
    WHERE EMP_ID = &사번입력;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/

------------------------------- [실습문제] -------------------------------
/*
    레퍼런스타입변수를 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형은 EMPLOYEE 테이블과 DEPARTMENT 테이블의 타입으로 지정
    값을 넣어 출력하시오.
*/
-- 초기 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- ★ 변수에는 오직 하나의 값만 들어가기 때문에 반드시 WHERE절로 값을 받아와야 한다.
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = '&사번입력';
    
    DBMS_OUTPUT.PUT_LINE('아이디 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('직업코드 : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
END;
/

/*
    1.3) ROW타입 변수
        테이블의 한 행에 대한 모든 값을 담을 수 있는 변수
        [표현식]
        변수명 테이블명%ROWTYPE;
*/

DECLARE
    E EMPLOYEE%ROWTYPE; -- ROWTYPE의 변수 사용시 반드시 * 이어야한다. (내가 원하는 값만 가져올 수 없다.)
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    -- 보너스 출력 : 보너스가 있으면 그 값을, 보너스가 NULL이면 0 출력
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, 0));
END;
/

--------------------------------------------------------------------------------
/*
    2.BEGIN 실행부
    <조건문> - 단일 IF문
    1) IF 조건식 THEN 실행내용 END IF;     -- >> IF문을 끝내겠다는 의미
*/

-- 사번을 입력받아 사원의 사번, 이름, 보너스율(%)출력
--    단, 보너스를 받지 않는 사원은 보너스율을 출력하기 전에 '보너스를 받지않는 사원' 출력하시오
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('아이디 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원');
    END IF;
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100 || '%');
END;
/

--  2) IF 조건식 THEN 실행내용 ELSE 실행 내용 END IF;  -> IF-ELSE

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('아이디 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100 || '%');
    END IF;
END;
/

------------------------------ [실습 문제] ----------------------------------
/*
    레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
        참조 컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    일반 변수 : TEAM(소속)
    
    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 출력
        단) NCODE값이 KO일 경우 => TEAM 변수에 '국내팀'
            NCODE값이 KO일 아니면 => TEAM 변수에 '해외팀'
            
    출력 : 사번, 이름, 부서명, 소속  출력
*/
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID);


DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('아이디 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('국가코드 : ' || NCODE);
    IF NCODE = 'KO' THEN
        TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    DBMS_OUTPUT.PUT_LINE('TEAM : ' || TEAM);
END;
/

/*
 3) IF 조건식1 
        THEN 실행내용1 
    ELSIF 조건식2 
        THEN 실행내용2 
    ... 
    ELSE
        실행내용N
    END IF;
*/
-- 사용자로부터 점수를 입력받아 학점 출력
--  변수1 = 점수 / 변수2 = 학점

DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';        
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('학점 : ' || GRADE);
    DBMS_OUTPUT.PUT_LINE('점수 : ' || SCORE);
END;
/
----------------------------[실습문제]----------------------------------
/*
    사용자로부터 사번을 입력받아 급여를 변수에 저장하고
    급여가 500만원 이상이면 '고급'
    급여가 200만원 이상이면 '중급'
    급여가 200만원 미만이면 '초급'
    출력 : '해당사원의 급여등급은 ?? 입니다.'
*/

SELECT EMP_ID, SALARY
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- 최종

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 2000000 THEN GRADE := '중급';        
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당사원의 급여등급은 ' || GRADE || '입니다.');
END;
/
/*


 4) CASE 비교대상자 
        WHEN 비교할값1 THEN 실행내용1 
        WHEN 비교할값2 THEN 실행내용2 
        WHEN 비교할값3 THEN 실행내용3 
        ....
        ELSE 실행내용N
    END;
    
        [JAVA - SWITCH ~ CASE 문]
        
    SWITCH(변수) {        -> CASE
        CASE ?? :        -> WHEN
            실행내용       -> THEN
        DEFAULT :        -> ELSE
    }
*/
DECLARE 
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT DEPT_CODE
        INTO DCODE
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DNAME := CASE DCODE
        WHEN 'D1' THEN '인사관리부'
        WHEN 'D2' THEN '회계관리부'
        WHEN 'D3' THEN '마케팅부'
        WHEN 'D4' THEN '국내영업부'
        WHEN 'D8' THEN '기술지원부'
        WHEN 'D9' THEN '총무부'
        ELSE '해외영업부'
    END;
    
    DBMS_OUTPUT.PUT_LINE('해당 부서는 ' || DNAME || '입니다.');
END;
/
    
--------------------------------------------------------------------------------
/*
    <LOOP>
    1) BASIC LOOP문
    
    [표현식]
    LOOP
        반복적으로 실행 할 구문;
        * 반복을 빠져나갈 수 있는 구문이 필요
    END LOOP;
    
    * 반복문을 빠져나오는 조건문 2가지
    1) IF 조건식 THEN EXIT; END IF;      >> 조건식에 맞으면 빠져 나와라
    2) EXIT WHEN 조건식;                 >> 조건식일 때 빠져나와라
    
*/
-- 1~5까지 1씩 증가하면서 출력
--  1) IF 조건식 THEN EXIT; END IF;
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
        
        IF I = 6 THEN EXIT;
        END IF;
    END LOOP;
END;
/

--  2) EXIT WHEN 조건식;
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
        
      EXIT WHEN I = 6;
    END LOOP;
END;
/
        
--------------------------------------------------------------------------------
/*
    2) FOR LOOP문
    
    
    ● 초기값 ~ 최종값까지 하나씩 변수에 집어 넣으면서 FOR문 실행
    ● [REVERSE] 최종값 ~ 초기값까지 
    
    [표현식]
    FOR 변수 IN [REVERSE] 초기값..최종값       
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
            
*/
BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

-- REVERSE
BEGIN
    FOR N IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

CREATE TABLE TEST (
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);
DROP SEQUENCE SEQ_TNO;

CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
/*
    3) WHILE LOOP문
    
    [표현식]
    WHILE 조건식
    LOOP
        반복할 실행구문;
    END LOOP;
*/
DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
    END LOOP;
END;
/

--------------------------------------------------------------------------------
/*
    3. 예외발생부
    예외 : 실행 중 발생하는 오류를 처리하는 구문
    
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1;
        WHEN 예외명2 THEN 예외처리구문2;
        WHEN 예외명3 THEN 예외처리구문3;
        ...
        WHEN OTHERS THEN 예외처리구문N;
    
    * 시스템 예외(오라클에서 미리 정의해둔 예외)
        - NO_DATA_FOUND : SELECT한 결과 한 행도 없을 경우
        - TOO_MANY_ROWS : SELECT한 결과 여러행일 경우
        - ZERO_DIVIDE : 0으로 나눌 때
        - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 때
        ....
*/
-- 사용자가 입력한 수로 나눗셈 한 결과 출력
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/&숫자;
    DBMS_OUTPUT.PUT_LINE(RESULT);
EXCEPTION
--    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.'); >> 무슨 예외처리인지 알고있을 때
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');    -- 어떤 예외든 이 문장으로 처리하겠다는 의미
END;
/

-- UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
        SET EMP_ID = '&변경할사번'
        WHERE EMP_NAME = '황정보';
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 ID입니다.');
END;
/

-- SELECT한 결과가 여러행일 경우의 EXCEPTION
-- 사수번호를 입력하면 그 사수를 지니고있는 사원검색

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = '&사수번호';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회됩니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다');
END;
/
















