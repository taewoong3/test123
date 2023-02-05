-- 한줄 주석(단축키 : ctrl + /)
/*
    여러주 주석
*/
-- 실행할 줄에 커서 놓고 ctrl+enter 한줄 실행
-- 여러줄 실행 블럭 잡고 ctrl+enter로 실행

-- 사용자 계정 조회
SELECT * FROM DBA_USERS;

-- 사용자 계정 생성(관리자 계정에서만 생성가능)
-- 계정명은 대소문자 가리지 않는다
-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER kh IDENTIFIED BY 1234;
CREATE USER jsp IDENTIFIED BY 1234;

-- 권한 설정
-- [표현법] GRANT 권한1, 권한2, .... TO 계정명;
GRANT RESOURCE, CONNECT TO KH;
GRANT RESOURCE, CONNECT TO jsp;

-- 계정 생성 예시)
--CREATE USER kh_function IDENTIFIED BY 1234;

-- 계정 생성 후 권한 예시)
--GRANT RESOURCE, CONNECT TO kh_function;






