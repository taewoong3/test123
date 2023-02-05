/*
    <TCL : TRANSACTION CONTROL LANGUAGE>
    트렌잭션 제어 언어
    
    * 트랜잭션
    - 데이터베이스의 논리적 연산 단위
    - 데이터의 변경사항(DML) 들을 하나의 트랜잭션 묶어서 처리
        DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                            트랜잭션이 존재하지 않으면 트랜잭션을 만들어서 묶음
        COMMIT하기전까지의 변경사항들을 하나의 트랜잭션에 담기게 됨
    -   트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE(DML)
    
    COMMIT(트랜잭션 종료 처리 후 확정)
    ROLLBACK(트랜잭션 취소)
    SAVEPOINT(임시저장)
    
    - COMMIT; 진행 : 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미(그 후에 트랜잭션 종료)
    - ROLLBACK; 진행 : 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT시점으로 돌아감
    - SAVEPOINT 포인트명; 진행 : 현 시점에 해당 포인트명으로 임시저장점을 정의해 둠
        ROLLBACK 진행시 전체 변경사항을 다 삭제하지 않고 일부만 ROLLBACK 가능
*/
SELECT * FROM EMP_01 ORDER BY EMP_ID;

-- 사번 225번 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 225;

DELETE FROM EMP_01
WHERE EMP_ID = 224;

ROLLBACK;

------------------------------------------------------------------

-- 구문 실행 시 트랜잭션(225번 지우겠다는) 생성
DELETE FROM EMP_01
WHERE EMP_ID = 225;


SELECT * FROM EMP_01 ORDER BY EMP_ID;

INSERT INTO EMP_01
VALUES(700, '아무개', '인사관리부');

-- 트랜잭션안에 있던 DELETE 225 & INSERT 700 구문이 DB로 이동한다.
COMMIT;

-- ★ COMMIT의 시점으로 되돌리는 것이기 때문에, COMMIT으로 인해 트랜잭션에 있던 정보들이 DB로 옮겨지면, ROLLBACK을 해도 소용없다.
ROLLBACK;

--------------------------------------------------------------------------------
-- 220, 221, 222
SELECT *
FROM EMP_01
ORDER BY EMP_ID;

DELETE FROM EMP_01
WHERE EMP_ID IN (220, 221, 222);

-- 임시저장점
SAVEPOINT SP;

INSERT INTO EMP_01 VALUES(701, 'GGG', '총무부');

-- 223 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 223;

ROLLBACK TO SP;

COMMIT;

----------------------------------------------------------------------------
-- 223, 224 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (223,224);


-- 219, 700 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (219, 700);

-- DDL문
CREATE TABLE TEST1 (
    TID NUMBER
);

-- ★ DDL문(CREATE, ALTER, DROP)을 수행하는 순간 기존의 트랜잭션에 있던
    -- 변경사항들은 무조건 COMMIT되어 이후 ROLLBACK 불가!!
ROLLBACK;





