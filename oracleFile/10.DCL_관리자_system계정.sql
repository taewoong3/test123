/*
    <DCL : DATA CONTROL LANGUAGE>
    데이터 제어 언어
    
    계정에 시스템권한 또는 객체 접근 권한을 부여하거나 회수하는 구문
    > 시스템 권한 : DB에 접근하는 권한, 객체를 생성할 수 있는 권한
    > 객체접근 권한 : 특정 객체를 조작할 수 있는 권한
*/
-- 1. 사용자 생성 SAMPLE / 1234
CREATE USER SAMPLE IDENTIFIED BY 1234;

-- 2. 접속을 위한 권한부여
GRANT CREATE SESSION TO SAMPLE;

-- 3. 테이블을 생성(접근)할 수 있는 권한 부여
GRANT CREATE TABLE TO SAMPLE;

-- 4. TABLESPACE 할당(테이블을 만들 수 있는 권한)
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;

-----------------------------------------------------------------
/*
    * 객체의 접근 권한
    SELECT      TABLE, VIEW, SEQUENCE 
    INSERT      TABLE, VIEW
    UPDATE      TABLE, VIEW
    DELETE      TABLE, VIEW
    ....
    
    [표현식]
    GRANT 권한종류 ON 특정객체 TO 계정명;
    - GRANT 권한종류 ON 권한을가지고있는USER.특정객체 TO 권한을줄USER명;
*/
-- 4. SELECT ON KH.EMPLOYEE 권한부여
GRANT SELECT ON KH.EMPLOYEE TO SAMPLE;

-- 5. SAMPLE USER에게 SELECT KH.JOB 권한부여
/*
GRANT : 권한을 주겠다
SELECT ON KH.JOB : KH.JOB이 가지고 있는 SELECT 권한을 주겠다.
TO SAMPLE : SAMPLE USER에게
*/
GRANT SELECT ON KH.JOB TO SAMPLE;

-- 6. SAMPLE USER에게 INSERT KH.JOB 권한부여
GRANT INSERT ON KH.JOB TO SAMPLE;

-- 권한 회수
-- REVOKE 회수할권한 FROM 계정명;
REVOKE INSERT ON KH.JOB FROM SAMPLE;
REVOKE SELECT ON KH.JOB FROM SAMPLE;

-----------------------------------------------------
/*
    <ROLE 롤>
    - 특정 권한들을 하나의 집합으로 모아놓은 것
    CONNECT : CREATE, SESSION
    RESOURCE : CREATE TABLE, CREATE SEQUENCE, ....
    DBA : 시스템 객체 관리에 대한 모든 권한을 갖고 있는 롤
    
    GRANT CONNECT, RESOURCE TO 계정명;
*/
-- PRIVS
-- 권한에 관련된 정보가 있는 테이블
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE IN ('CONNECT', 'RESOURCE')
ORDER BY 1;


































