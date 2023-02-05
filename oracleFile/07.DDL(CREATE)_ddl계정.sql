/*
--  관리자 계정 USER 만들기
    CREATE USER DDL IDENTIFIED BY 1234;

-- 접속 권한 / 테이블을 만들 수 있는 권한
-- CONNECT : 사용자가 데이터베이스에 접속 가능하도록 하기 위해서 가장 기본적인 시스템 권한 8가지를 묶어 놓음
-- RESOURCE : 사용자가 객체(테이블, 뷰, 인덱스)를 생성할 수 있도록 하기 위해서 시스템 권한을 묶어 놓음
    GRANT CONNECT, RESOURCE TO DDL; 
*/

/*
    * DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어
    오라클에서 제공하는 객체(OBJECT)를 생성(CREATE), 구조를 변경(ALTER)하고, 구조 자체를 삭제(DROP)하는 언어
    즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
    주로 DB관리자, 설계자가 사용
    
    오라클에서 객체(구조) : 테이블, 뷰, 시퀀스, 인덱스, 패키지, 트리거, 프로시저, 함수, 동의어, 사용자
*/
--=================================================================================
/*
    <CREATE>
    객체를 생성하는 구문
*/
/*
    1. 테이블 생성
        - 테이블 : 행과 열로 이루어진 가장 기본적인 데이터베이스 객체
                    모든 데이터들은 테이블을 통해 저장
        
        [표현식]
        CREATE TABLE 테이블명 (
            컬럼명 자료형(크기),
            컬럼명 자료형(크기),
            컬럼명 자료형,        -- ※ NUMBER & DATE는 크기를 넣지 않는다.
            ...
        );
        
        * 자료형
        - 문자(CHAR(바이트크기) | VARCHAR2(바이트크기)) --> 반드시 바이트 크기 지정
            > CHAR : 최대 2000BYTE까지 지정 가능
                        고정길이(지정한 값보다 더 적은 값이 들어와도 공백으로 채워서 길이를 고정)
                        길이가 완전히 고정된 컬럼일 때
                        EX)
                        CHAR(6) == 홍_ _ _
                
            > VARCHAR2 : 최대 4000BYTE까지 지정 가능
                            가변길이(지정한 값보다 더 적은값이 들어오면 그 크기에 맞춰짐)
            - 숫자(NUMBER)
            - 날짜(DATE)
*/
-- 회원 정보를 담기위한 MEMBER 테이블 생성
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PW VARCHAR2(20),
    MEM_NAME VARCHAR(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);
SELECT * FROM MEMBER;

-- 사용자가 가지고 있는 테이블 정보
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 담고 있는 시스템 테이블
-- [참고] USER_TABLES : 사용자가 가지고 있는 테이블의 전반적인 구조를 담고 있는 시스템 테이블
SELECT * FROM USER_TABLES;

-- [참고] USER-TAB_COLUMNS : 사용자가 가지고 있는 테이블들의 모든 컬럼의 전반적인 구조를 담고 있는 시스템 테이블
SELECT * FROM USER_TAB_COLUMNS;

--------------------------------------------------------------------------------
/*
    2. 컬럼의 주석달기(컬럼에 대한 설명)
    
    [표현식]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성시 수정 후 다시 실행하면 됨
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PW IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블에 데이터 추가
-- INSERT INTO 테이블명 VALUES();
INSERT INTO MEMBER VALUES(1, 'user01', 'user01', '홍길동', '남', '010-1234-5678', 'hong@naver.com', '22/11/14');      -- ※ 데이터 값은 대.소문자 구분함
INSERT INTO MEMBER VALUES(2, 'user02', 'user02', '이길동', '여', 'NULL', 'null', SYSDATE);   -- ※ NULL은 대.소문자 구분 안함.
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, null, null);

-------------------------------------------------------------------------------------
/*
    <제약조건 CONSTRAINTS>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 한다
    
    * 종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY KEY, FOREIGN KEY
*/

/*
    * NOT NULL 제약조건
        해당 컬럼에 반드시 값이 존재해야 할 경우(NULL이 들어오면 안됨)
        삽입/수정 NULL값 허용하지 않는다.
        >> 제약조건 부여시 반드시 컬럼 레벨 방식만 사용할 수 있다
        
    * 제약조건 부여하는 방식
        - 컬럼 레벨 방식
        - 테이블 레벨 방식
*/

-- 컬럼 레벨 방식
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50)
);
INSERT INTO MEM_NOTNULL VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-2222-3333', 'ASD@NAVER.COM');
INSERT INTO MEM_NOTNULL VALUES(2, 'USER2', 'USER2', '이길동', NULL, NULL, NULL);

-- (★오류 발생) NOT NULL 제약조건 위반
INSERT INTO MEM_NOTNULL VALUES(3, 'USER3', NULL, '박길도', NULL, NULL, NULL); 

-- NO가 중복되어도 잘 삽입 됨
-- 중복이 되어서는 유저 구분을 못하는 문제 발생 (UNIQUE로 해결)
INSERT INTO MEM_NOTNULL VALUES(2, 'USER2', 'USER2', '박길도', NULL, NULL, NULL);


-------------------------------------------------------------------------------------
/*
    * UNIQUE 제약조건
    해당 컬럼에 중복된 값이 들어가서는 안되는 경우
    삽입/수정 시 중복된 값을 허용하지 않는다.
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER UNIQUE NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50)
);

-- 테이블 레벨 방식 : 모든 컬럼을 나열한 후 맨 마지막에 기술
--      [표현식] : 제약조건(컬럼명)
CREATE TABLE MEM_UNIQUE2 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_NO),
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE2 VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-4444-5555', 'HONE@NAVER.COM');
INSERT INTO MEM_UNIQUE2 VALUES(2, 'user2', 'user2', '이길동', '여', '010-4123-1235', 'lee@NAVER.COM');

-- ※ UNIQUE 제약조건 오류 발생
-- 오류 구문은 제약조건명으로 알려줌. 제약조건명을 지정하지 않으면 시스템 자동 부여
INSERT INTO MEM_UNIQUE2 VALUES(2, 'user2', 'USER3', '박길도', '남', '010-5613-1225', 'park@NAVER.COM');

/*
    * 제약조건 부여시 제약조건명까지 지어주는 방법
    
    -- 컬럼 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형([크기]) [CONSTRAINT 제약조건명] 제약조건,
        ...
    );
    
    - 테이블 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형([크기])
        ...
        [CONSTRAINT 제약조건명] 제약조건(컬럼명)
    );
*/
CREATE TABLE MEM_UNIQUE3 (
    MEM_NO NUMBER CONSTRAINT NO_NN NOT NULL /*CONSTRAINT MEMNO_UQ UNIQUE == 컬럼 레벨 방식*/,
    MEM_ID VARCHAR2(20) CONSTRAINT ID_NN NOT NULL,
    MAM_PW VARCHAR2(20) CONSTRAINT PW_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT NAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMNO_UQ UNIQUE(MEM_NO)
);
INSERT INTO MEM_UNIQUE3 VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-4444-5555', 'HONE@NAVER.COM');
INSERT INTO MEM_UNIQUE3 VALUES(2, 'user2', NULL, '이길동', '여', '010-4123-1235', 'lee@NAVER.COM');
INSERT INTO MEM_UNIQUE3 VALUES(2, 'user2', 'USER3', '박길도', '남', '010-5613-1225', 'park@NAVER.COM');

-- ※ 성별에 유효한 값이 아니어도 삽입됨
INSERT INTO MEM_UNIQUE3 VALUES(3, 'USER3', 'USER3', '삼길도', 'ㄴ', '010-5613-1225', 'park@NAVER.COM');


-------------------------------------------------------------------------------------
/*
    * CHECK(조건식) 제약조건
    해당 컬럼에 들어올 수 없는 값에 대한 조건 제시
    조건에 맞는 값만 입력하도록 할 수 있다.
*/

CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- ※ '남' '여' 유효한 값으로 지정 // 컬럼 레벨 방식
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_NO)
--    CHECK(GENDER IN ('남', '여')) : 테이블 레벨 방식
);
INSERT INTO MEM_CHECK VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-4444-5555', 'HONE@NAVER.COM');
INSERT INTO MEM_CHECK VALUES(2, 'user2', 'user2', '이길동', '여', '010-4123-1235', 'lee@NAVER.COM');

-- ※ CHECK 제약조건 위반 오류 발생
INSERT INTO MEM_CHECK VALUES(3, 'USER3', 'USER3', '삼길도', 'ㄴ', '010-5613-1225', 'park@NAVER.COM');


-------------------------------------------------------------------------------------
/*
    * PRIMARY KEY(기본키) 제약조건
    테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건
    EX) 회원번호, 학번, 사원번호, 부서코드, 직급코드, 주문번호, 예약번호......
    
    PRIMARY KEY = NOT NULL + UNIQUE 제약조건을 의미
    >> 검색, 수정, 삭제 기본키의 컬럼값을 이용함
    
    - 유의사항 : 한 테이블당 오로지 1개만 설정 가능
*/

CREATE TABLE MEM_PRIMARY (
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,  -- 컬럼 레벨 방식
    MEM_ID VARCHAR2(20) NOT NULL,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- ※ '남' '여' 유효한 값으로 지정 // 컬럼 레벨 방식
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50)
--    CONSTRAINT MEMNO_PK PRIMARY KEY(MEM_NO) : 테이블 방식
);
INSERT INTO MEM_PRIMARY VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-4444-5555', 'HONE@NAVER.COM');

-- ※ NOT NULL 제약 조건 오류 발생
INSERT INTO MEM_PRIMARY VALUES(NULL, 'user2', 'user2', '이길동', '여', '010-4123-1235', 'lee@NAVER.COM');

-- ※ UNIQUE 제약 조건 오류 발생
INSERT INTO MEM_PRIMARY VALUES(1, 'user2', 'user2', '이길동', '여', '010-4123-1235', 'lee@NAVER.COM');

-- 복합키 : 2개의 컬럼을 기본키로 정함(2개의 컬럼값이 복합으로 유일하고, NOT NULL이면 됨)
CREATE TABLE PRO_MEM_PRI (
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(50),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

INSERT INTO PRO_MEM_PRI VALUES(1, 'A', SYSDATE);
INSERT INTO PRO_MEM_PRI VALUES(1, 'B', SYSDATE);

-- ※ 복합키 제약조건 오류 발생
INSERT INTO PRO_MEM_PRI VALUES(1, 'A', SYSDATE);

-------------------------------------------------------------------------------------
-- 회원 등급에 따른 데이터 따로 보관하는 테이블
CREATE TABLE MEM_GRADE (
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME CHAR(12) NOT NULL
);
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특급회원');

CREATE TABLE MEM (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER
);
INSERT INTO MEM VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-4444-5555', 'HONE@NAVER.COM', 10);
INSERT INTO MEM VALUES(2, 'USER2', 'USER2', '특길동', '남', '010-4444-5555', 'HONE@NAVER.COM', 30);

-- (!!이상한점)유효한 회원등급번호가 아님에도 입력됨 
INSERT INTO MEM VALUES(3, 'USER3', 'USER3', '삼길동', '여', '010-4444-5555', 'HONE@NAVER.COM', 90);

-------------------------------------------------------------------------------------
/*
    FOREIGN KEY(외래키) 제약조건
    다른 테이블에 존재하는 값만 들어와야하는 특정 컬럼에 부여하는 제약조건
    -- > 다른 테이블 참조를 표현
    -- > 주로 FOREIGN KEY(외래키)로 테이블 간의 관계가 형성됨
    
    >> 컬럼 레벨 방식
    
    [표현식]       ↓ 내가 부여하지 않으면, 시스템이 알아서 부여
    컬럼명 자료명 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(참조 할 컬럼명)]
        - 참조 할 컬럼명 생략은 기본키(PRIMARY KEY)로 되었을때 가능
        
    >> 테이블 레벨 방식
    
    [표현식]      
    - FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조 할 컬럼명)]
    
    - [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조 할 컬럼명)  
*/

CREATE TABLE MEM2 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MAM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER CONSTRAINT GRA_FOR REFERENCES MEM_GRADE(GRADE_CODE)
    -- 테이블 방식
--    CONSTRAINT GRA_FOR FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE)
);
INSERT INTO MEM2 VALUES(1, 'USER1', 'USER1', '홍길동', '남', '010-4444-5555', 'HONE@NAVER.COM', 10);
INSERT INTO MEM2 VALUES(2, 'USER2', 'USER2', '특길동', '남', '010-4444-5555', 'HONE@NAVER.COM', 30);

-- 외래키 제약조건 오류
INSERT INTO MEM2 VALUES(3, 'USER3', 'USER3', '삼길동', '여', '010-4444-5555', 'HONE@NAVER.COM', 90);

-- > 이때 부모 테이블의 값을 삭제할 경우
-- 데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;

-- MEM_GRADE 테이블에서 10번 등급 삭제
-- 자식 테이블에 10이라는 값을 사용하고 있기 때문에 삭제 안됨
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;


DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 20;

-- > 자식테이블에 이미 사용하고 있는 값일 경우
--  무조건 삭제가 안되는 옵션이 기본값이라서 삭제가 안됨

INSERT INTO MEM_GRADE VALUES(20, '우수회원');


-------------------------------------------------------------------------------------
/*
    자식테이블 생성시 외래키 제약조건 부여시 삭제 옵션 지정가능
    * 삭제 옵션 : 부모테이블의 값 삭제시 그 데이터를 자식테이블에서 사용하고 있을 경우 그 값을 어떻게 처리할지 지정
    
    - ON DELETE RESTRICTED(기본값) : 자식이 쓰는 데이터값은 무조건 삭제 안됨
    - ON DELETE SET NULL : 자식테이블의 데이터값을 NULL로 바꾸고 부모 테이블 데이터 값을 삭제함
    - ON DELETE CASCADE : 자식테이블의 데이터값과 부모의 데이터값을 모두 삭제함
*/

-- 테이블 삭제
DROP TABLE MEM;

CREATE TABLE MEM (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    GRADE_ID NUMBER CONSTRAINT GRA_FOR REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, '홍길동', '남', 10);
INSERT INTO MEM VALUES(2, '이길동', '남', 30);
INSERT INTO MEM VALUES(3, '삼길동', '남', 10);
INSERT INTO MEM VALUES(4, '사길동', '남', 20);
INSERT INTO MEM VALUES(5, '오길동', '남', NULL);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;



CREATE TABLE MEM2 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO MEM2 VALUES(1, '홍길동', '남', 10);
INSERT INTO MEM2 VALUES(2, '이길동', '남', 30);
INSERT INTO MEM2 VALUES(3, '삼길동', '남', 10);
INSERT INTO MEM2 VALUES(4, '사길동', '남', 20);
INSERT INTO MEM2 VALUES(5, '오길동', '남', NULL);

-- 자식 테이블의 데이터 값도 모두 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30;


-------------------------------------------------------------------------------------
/*
    제약조건 아님
    <DEFAULT 기본값>
    컬럼의 값이 들어오지 않았을 때 설정한 기본값으로 입력됨
    
    CREATE TABLE 테이블명 (
        컬럼명 자료형 DEFAULT 기본값
    );
*/
CREATE TABLE MEM3 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER DEFAULT 1,
    HOBBY VARCHAR2(50) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE
);

-- NULL은 데이터 값이 없음 / DEFAULT는 기본값을 의미
INSERT INTO MEM3 VALUES(1, '일길동', 20, '운동', '21/11/13');
INSERT INTO MEM3 VALUES(2, '이길동', NULL, DEFAULT, '21/11/13');
INSERT INTO MEM3 VALUES(3, '삼길동', 22, DEFAULT, DEFAULT);

                    -- DEFAULT 값이 자동으로 들어온다
                    -- ↓ 컬럼 값과 데이터 값 순서만 맞춰주면 된다.
INSERT INTO MEM3(HOBBY, MEM_NO, MEM_NAME) VALUES('노래하기', 4, '사길동'); 
INSERT INTO MEM3(MEM_NO, MEM_NAME) VALUES(5, '오길동'); 

--=============================================================================
/*
    ==============================KH계정==================================
    <SUBQUERY를 이용한 테이블 생성>
    테이블을 복사하는 개념
    
    [표현식]
    CREATE TABLE 테이블명
    AS 서브쿼리;
*/
-- EMPLOYEE 테이블에서 복제하여 새로운 테이블 생성
CREATE TABLE EMPLOYEE_COPY
AS SELECT *
    FROM EMPLOYEE;
    -- 컬럼, 데이터 값, 제약조건은 NOT NULL만 복사됨
    -- DEFAULT, PRIMARY KEY, FOREIGN KEY, UNIQUE는 복제 안됨
    
-- EMPLOYEE 테이블의 구조만 가지고 오고 데이터는 복사를 안하고 테이블을 생성
CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE 1=0;     -- (같지 않다)구조만 가지고 올 때


-- 서브쿼리 SELECT절에 산술식 또는 함수식이 기술된 경우는 반드시 별칭을 지정해야 됨
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉   
FROM EMPLOYEE;

-------------------------------------------------------------------------------------
/*
    * 테이블을 생성한 후에 제약조건을 추가하기
    ALTER TABLE 테이블명 변경할내용
    - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    - FOREIGN KEY : ALTER TABLE 테이블명 ADD REFERENCES 참조할테이블명[(참조할컬럼명)];
    - UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    - CHECK       : ALTER TABLE 테이블명 ADD CHECK(컬럼에대한조건식);
    - NOT NULL    : ALTER TABLE 테이블명 MODIFY(\수정) 컬럼명 NOT NULL;
        > 설정안하면, 기본값이 NULLABLE이 YES
*/
-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 제약조건 추가
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLYEE_COPY 테이블의 DEPT_CODE 컬럼에 외래키 추가(DEPARTMENT(DEPT_CODE))
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

-- EMPLOYEE_COPY 테이블의 JOB_CODE 컬럼에 외래키 추가(JOB)
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;





