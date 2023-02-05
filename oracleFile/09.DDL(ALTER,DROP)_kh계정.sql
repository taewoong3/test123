/*
    <ALTER>
    객체를 수정하는 구문
    
    [표현식]
    ALTER TABLE 테이블명 변경할내용;
    
    - 변경 할 내용
    1) 컬럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제 -> 수정불가(수정하려면 삭제하고 새로 만들어야 함)
    3) 컬럼명 / 제약조건명 / 테이블명 변경
*/

/*
    1) 컬럼 추가/수정/삭제
*/

-- 1.1) 컬럼 추가 (ADD) : ADD 컬럼명 데이터타입[(크기)] [DEFAULT]
-- DEPT_COPY 테이블에 DNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD DNAME VARCHAR2(20);
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT 'KH';


-- 1.2) 컬럼 수정 (MODIFY)
--    데이터 타입 수정 : MODIFY 컬럼명 바꾸고자하는 데이터 타입
--    DEFAULT값 구정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는 값

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- 오류발생 : 컬럼의 데이터 타입을 변경하기 위해서는 해당 컬럼의 값을 모두 지워야 변경이 가능
ALTER TABLE EMPLOYEE_COPY3 MODIFY EMP_ID NUMBER;

-- 오류발생 : 들어있는 값이 10BYTE를 넘는 것이 있기 때문
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);

------- [문제]

-- DEPT_TITLE 컬럼을 VARCHAR2(50)변경
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(50);

-- LOCATION_ID 컬럼을 VARCHAR2(3)변경
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR2(3);

-- LNAME 컬럼의 DEFAULT를 'KH.KR'로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KH.KR';

-- 다중 변경 가능
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(50)
    MODIFY LOCATION_ID VARCHAR2(5)
    MODIFY LNAME DEFAULT 'KH.JP';


-- 1.3) 컬럼 삭제
-- DROP COLUMN : DROP COLUMN 삭제하고자하는컬럼명
ALTER TABLE DEPT_COPY DROP COLUMN DNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;
-- 삭제는 다중삭제 안됨 개별적으로 하나씩 삭제만 가능

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;

-- 오류발생 : 적어도 한개의 컬럼은 남겨야 하기 때문(마지막 한개 컬럼은 삭제 불가)
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;

--============================================================================--

/*
    2. 제약조건 추가 / 삭제
        2.1) 삭제
        DROP CONSTRAINT 제약조건
*/
ALTER TABLE SAL_GRADE DROP CONSTRAINT SYS_C007013;


--============================================================================--
/*
    3) 컬럼명 / 제약조건명 / 테이블명 변경
*/
--      3.1) 컬럼명 변경 : RENAME COLUMN 기존 컬럼명 TO 바꿀컬럼명   
ALTER TABLE EMP_DEPT RENAME COLUMN EMP_NAME TO NAME;

--      3.2) 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
ALTER TABLE EMP_DEPT RENAME CONSTRAINT SYS_C007161 TO NAME_NN;

--      3.3) 테이블명 변경 : RENAME [기존테이블명] TO 바꿀테이블명
ALTER TABLE EMP_DEPT RENAME TO EMP_CHANGE;

--============================================================================--
/*
    <DROP>
    테이블 삭제
    DROP TABLE 테이블명;
*/
DROP TABLE DEPT_COPY;

/*
 테이블이 어딘가에서 참조되고 있는 부모 테이블은 삭제 안됨
 그래도 삭제하고 싶다면
    1) 자식테이블을 삭제하고 부모테이블 삭제
    2) 제약조건을 삭제하고 부모테이블을 삭제
  DROP TABLE 테이블명 CASCADE CONSTRAINTS;
*/







