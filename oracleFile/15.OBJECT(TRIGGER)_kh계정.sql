/*
    <TRIGGER>
    테이블의 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경사항 발생할 때
    자동으로 실행할 내용을 미리 정의해둘 수 있는 객체
    
    * 트리거의 종류
    - SQL문의 실행시기에 따른 분류
        > BEFORE TRIGGER : 테이블에 이벤트가 발생되기 전에 트리거 실행
        > AFTER TRIGGER : 테이블에 이벤트가 발생한 후 트리거 실행
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
        > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 딱 한번만 트리거 실행
        > ROW TRIGGER(행트리거) : 해당 SQL문을 실행할 때마다 매번 트리거 실행
                                (옵션 : FOR EACH ROW 기술)
                            > :OLD -> BEFORE UPDATE (수정전자료), BEFORE DELETE(삭제전 자료)
                            > :NEW -> AFTER INSERT(추가된자료), AFTER UPDATE(수정후 자료)
    [표현법]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블
    [FOR EACH ROW]
    [DECLARE
        변수선언;]
    BEGIN
        실행내용(위에 지정된 이벤트 발생시 자동으로 실행할 구문)
    [EXCEPTION
        예외처리 구문;]
    END;
    /
*/
-- EMPLOYEE 테이블에 새로운 행이 INSERT 될때마다 자동으로 메시지를 출력하는 트리거
SET SERVEROUTPUT ON

CREATE OR REPLACE TRIGGER TRG_EM_I
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(503, '삼트리', '221118-4567891', 'J2', SYSDATE);


-- 상품 입출고 관련
-- 상품에 대한 보관 테이블 생성(TB_PRODUCT)
CREATE TABLE TB_PRODUCT (
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30) NOT NULL,
    BRAND VARCHAR2(30) NOT NULL,
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);

-- 상품번호 중복되지 않게 시퀀스 생성
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5;

INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, 'IPHONE14', 'APPLE', 2100000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, 'IPHONE13', 'APPLE2', 2300000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, 'IPHONE12', 'APPLE3', 2500000, 20);

COMMIT;

-- 2. 상품의 입출고 테이블(TB_PRODETAIL)
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY,   -- 이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT,
    PDTAE DATE NOT NULL,
    AMOUNT NUMBER NOT NULL,     -- 입출고수량
    STATUS CHAR(6) CHECK(STATUS IN ('Y', 'N'))
);

-- 이력번호에 넣을 시퀀스
CREATE SEQUENCE SEQ_DCODE;

-- 300번 상품이 오늘날짜로 10개 입고
INSERT INTO TB_PRODETAIL 
VALUES(SEQ_DCODE.NEXTVAL, 300, SYSDATE, 10, 'Y');

-- 300번 상품의 재고수량을 10증가
UPDATE TB_PRODUCT
 SET STOCK = STOCK + 10
 WHERE PCODE = 300;

-- 305번 상품이 오늘날자로 5개 출고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 315, SYSDATE, 5, 'N');

-- 305번 재고수량을 5감소
UPDATE TB_PRODUCT
 SET STOCK = STOCK - 5
 WHERE PCODE = 315;
 
 
-- 트리거로 생성
CREATE OR REPLACE TRIGGER TRG_PRO
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    -- 상품이 'Y'이면 => 재고수량 증가
    IF ( :NEW.STATUS = 'Y')
        THEN
        UPDATE TB_PRODUCT
         SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
    
    -- 상품이 'N'이면 => 재고수량 감소
    IF ( :NEW.STATUS = 'N')
        THEN
        UPDATE TB_PRODUCT
         SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

INSERT INTO TB_PRODETAIL 
VALUES(SEQ_DCODE.NEXTVAL, 300, SYSDATE, 10, 'Y');


-- ★★★ 이해 안감 ↓

-- 입고 수량을 잘못 입력하여 수량을 수정 시 트리거
CREATE OR REPLACE TRIGGER TRG_PRO_UP
AFTER UPDATE ON TB_PRODETAIL
FOR EACH ROW
BEGIN
        UPDATE TB_PRODUCT
         SET STOCK = STOCK - :OLD.AMOUNT + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;   -- UPDATE 할 PRIMARY KEY
END;
/



-- 입고취소(DELETE)
--STOCK = STOCK - :OLD:AMOUNT











