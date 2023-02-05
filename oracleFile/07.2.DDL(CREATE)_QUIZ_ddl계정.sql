/*
                실습문제
도서관리 프로그램을 만들기 위한 테이블들 만들기
이때, 제약조건에 이름을 부여할 것.
       각 컬럼에 주석달기

1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
   컬럼  :  PUB_NO(출판사번호) -- 기본키(PUBLISHER_PK)
	PUB_NAME(출판사명) -- NOT NULL(PUBLISHER_NN)
	PHONE(출판사전화번호) - 제약조건 없음

   - 3개 정도의 샘플 데이터 추가하기


2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
   컬럼  :  BK_NO (도서번호) -- 기본키(BOOK_PK)
	BK_TITLE (도서명) -- NOT NULL(BOOK_NN_TITLE)
	BK_AUTHOR(저자명) -- NOT NULL(BOOK_NN_AUTHOR)
	BK_PRICE(가격)
	BK_PUB_NO(출판사번호) -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
   - 5개 정도의 샘플 데이터 추가하기


3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
   컬럼명 : MEMBER_NO(회원번호) -- 기본키(MEMBER_PK)
   MEMBER_ID(아이디) -- 중복금지(MEMBER_UQ)
   MEMBER_PWD(비밀번호)  -- NOT NULL(MEMBER_NN_PWD)
   MEMBER_NAME(회원명) -- NOT NULL(MEMBER_NN_NAME)
   GENDER(성별)  -- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
   ADDRESS(주소)
   PHONE(연락처)
   STATUS(탈퇴여부) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
   ENROLL_DATE(가입일) -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)

   - 5개 정도의 샘플 데이터 추가하기


4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
   컬럼  :  RENT_NO(대여번호) -- 기본키(RENT_PK)
	RENT_MEM_NO(대여회원번호) -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
	RENT_BOOK_NO(대여도서번호) -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
	RENT_DATE(대여일) -- 기본값 SYSDATE

   - 3개 정도 샘플데이터 추가하기
*/

---------------------------- [1번 문제] ------------------------------------------------
/*
1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
   컬럼  :  PUB_NO(출판사번호) -- 기본키(PUBLISHER_PK)
	PUB_NAME(출판사명) -- NOT NULL(PUBLISHER_NN)
	PHONE(출판사전화번호) - 제약조건 없음

   - 3개 정도의 샘플 데이터 추가하기
*/
CREATE TABLE TB_PUBLISHER (
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME VARCHAR2(20) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR2(15)
);
-- 주석달기
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';

-- 샘플 데이터 3개 추가
INSERT INTO TB_PUBLISHER VALUES(1, '홍출판사', '010-1234-4567');
INSERT INTO TB_PUBLISHER VALUES(2, '이출판사', '010-1334-4667');
INSERT INTO TB_PUBLISHER VALUES(3, '삼출판사', '010-1114-4666');

---------------------------- [2번 문제] ----------------------------------------------
/*
2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
   컬럼  :  BK_NO (도서번호) -- 기본키(BOOK_PK)
	BK_TITLE (도서명) -- NOT NULL(BOOK_NN_TITLE)
	BK_AUTHOR(저자명) -- NOT NULL(BOOK_NN_AUTHOR)
	BK_PRICE(가격)
	BK_PUB_NO(출판사번호) -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
   - 5개 정도의 샘플 데이터 추가하기
*/

CREATE TABLE TB_BOOK (
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(20) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BK_PRICE VARCHAR2(15),
    BK_PUB_NO NUMBER,
    CONSTRAINT BOOK_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER ON DELETE CASCADE
);

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';

-- 샘플 데이터 5개 추가
INSERT INTO TB_BOOK VALUES(1, '일삼역', '일주일', '1000', 1);
INSERT INTO TB_BOOK VALUES(2, '이삼역', '이주일', '2000', 2);
INSERT INTO TB_BOOK VALUES(3, '삼삼역', '삼주일', '3000', 3);
INSERT INTO TB_BOOK VALUES(4, '사삼역', '사주일', '4000', 1);
INSERT INTO TB_BOOK VALUES(5, '오삼역', '오주일', '5000', 2);

-- 삭제
DELETE FROM TB_PUBLISHER
WHERE PUB_NO = 1;


---------------------------- [3번 문제] ----------------------------------------------
/*
3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
   컬럼명 : MEMBER_NO(회원번호) -- 기본키(MEMBER_PK)
   MEMBER_ID(아이디) -- 중복금지(MEMBER_UQ)
   MEMBER_PWD(비밀번호)  -- NOT NULL(MEMBER_NN_PWD)
   MEMBER_NAME(회원명) -- NOT NULL(MEMBER_NN_NAME)
   GENDER(성별)  -- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
   ADDRESS(주소)
   PHONE(연락처)
   STATUS(탈퇴여부) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
   ENROLL_DATE(가입일) -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)

   - 5개 정도의 샘플 데이터 추가하기
*/
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(20) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(3) CONSTRAINT MEMBER_CK_GEN CHECK(GENDER IN ('M', 'F')),
    ADDRESS VARCHAR2(50),
    PHONE VARCHAR2(50),
    STATUS CHAR(3) DEFAULT 'N' CONSTRAINT MEMBER_CK_STA CHECK(STATUS IN ('Y', 'N')), 
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';

-- 샘플 데이터 5개 추가
INSERT INTO TB_MEMBER VALUES(1, 'AAA', 'AAA', '일길동', 'M', '서울특별시', '010-1111-1111', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(2, 'BBB', 'BBB', '이길동', 'M', '대구광역시', '010-2222-2222', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(3, 'CCC', 'CCC', '삼길동', 'M', '인천광역시', '010-3333-3333', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(4, 'DDD', 'DDD', '사길동', 'M', '부산광역시', '010-4444-4444', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(5, 'EEE', 'EEE', '오길동', 'M', '광주광역시', '010-5555-5555', DEFAULT, DEFAULT);

---------------------------- [4번 문제] ----------------------------------------------
/*
4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
   컬럼  :  
   RENT_NO(대여번호) -- 기본키(RENT_PK)
	RENT_MEM_NO(대여회원번호) -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
	RENT_BOOK_NO(대여도서번호) -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
	RENT_DATE(대여일) -- 기본값 SYSDATE

   - 3개 정도 샘플데이터 추가하기
*/

CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

INSERT INTO TB_RENT VALUES(1, 1, 2, SYSDATE);
INSERT INTO TB_RENT VALUES(2, 2, 3, SYSDATE);
INSERT INTO TB_RENT VALUES(3, 3, 5, SYSDATE);

-- 삭제
DELETE FROM TB_MEMBER
WHERE MEMBER_NO = 2;

DELETE FROM TB_BOOK
WHERE BK_NO = 5;





















