/*
    <SEQUENCE>
    자동으로 번호를 부여해주는 객체
    정수의 값으로 일정값씩 증가하면서 생성되는 값
    EX) 회원번호, 사원번호
*/
/*
    1. 시퀀스 객체 생성
    [표현식]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자] : 시퀀스 시작값(기본값 1)
    [INCREMENT BY 숫자] : 몇씩 증가시킬것인지의 값(기본값 1)
    [MAXVALUE 숫자] : 최대값 지정(기본값 많이 큼)
    [MINVALUE 숫자] : 최소값 지정(기본값 1)
    [CYCLE | NOCYCLE] : 값 순환 여부 지정(기본값 NOCYCLE)
    [NOCACHE | CACHE 바이트크기] : 캐시메모리 할당(기본값 CACHE 20)
        * 캐시메모리 : 미리 발생될 값들을 생성하여 저장해두는 공간
                     매번 호출할 때마다 번호를 생성하는 것이 아니라
                     캐시메모리에 미리 생성한 값들을 가져다 씀
                     접속 해제하면 => 캐시메모리에 미리 만들어놓은 번호는 없어짐
*/
CREATE SEQUENCE SEQ_TEST;
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용
    시퀀스명.CURRVAL : 현재 시퀀스 값(마지막 성공한 값)
    시퀀스명.NEXTVAL : 현재 시퀀스 + INCREMENT BY에 넣었던 값
                     시퀀스명.CURRVAL + INCREMENT BY 값
*/
-- ★ NEXTVAL를 수행한 다음에만 CURRVAL를 실행 할 수 있음
/*  ※ 오류 발생!!!
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
*/

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;

/*
    3. 시퀀스 구조 변경
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 숫자]
    [MAXVALUE 숫자]
    [MINVALUE 숫자]
    [CYCLE | NOCYCLE]
    [NOCACHE | CACHE 바이트크기]
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;

-- 4. 삭제
DROP SEQUENCE SEQ_EMPNO;
SELECT * FROM USER_SEQUENCES;

--------------------------------------------------------------------------------
-- 사원번호를 시퀀스로 활용
CREATE SEQUENCE SEQ_EID
START WITH 400;

INSERT INTO EMPLOYEE (EMP_ID
                    , EMP_NAME
                    , EMP_NO
                    , JOB_CODE
                    , HIRE_DATE
                    )
            VALUES(SEQ_EID.NEXTVAL
                    , '시퀀스1'
                    , '201002-2516325'
                    , 'J5'
                    , SYSDATE
                    );


