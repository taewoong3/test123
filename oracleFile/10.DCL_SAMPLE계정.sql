CREATE TABLE TEST1(
    TEST_ID NUMBER,
    TEST_NAME VARCHAR2(10)
);

INSERT INTO TEST1 VALUES(1, 'HI');
-- CREATE TABLE 권한을 부여 받는 순간 테이블 조작 가능

--======================================================
-- KH계정에 있는 EMPLOYEE 테이블에 접근(외부 테이블 접근 권한 없어서 오류 발생!)
SELECT * 
FROM KH.JOB;

INSERT INTO KH.JOB
VALUES('J8','수습사원');
-- COMMIT 하지 않으면 DB에는 들어가지 않는 대기상태임.

SELECT *
FROM KH.JOB;