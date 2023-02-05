/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과를 반환
    
    - 단일행 함수 : N개의 값을 읽어들여 N개의 결과를 반환(매 행마다 실행)
    - 그룹 함수 : N개의 값을 읽어들여 1개의 결과를 반환(그룹별로 실행)
    
    >> SELECT절에 단일행 함수와 그룹 함수를 함께 사용할 수 없음
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/
------------------------------ 단일행 함수 --------------------------------
--=======================================================================
--                           <문자처리 함수>
--=======================================================================
/*
    * LENGTH / LENGTHB => 반환값 NUMBER
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환
    LENGTHB(컬럼|'문자열') : 해당 문자열의 BYTE수 반환
        - 한글 : XE 버전일때 => 1글자당 3BYTE(ㄱ, ㅏ 등도 1글자에 해당)
                EE 버전일때 => 1글자당 2BYTE
        - 그외 : 1글자당 1BYTE
*/
SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;     -- 오라클에서 제공하는 가상테이블

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
        EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * INSTR : 문자열에서 특정 문자가 있는 시작위치(INDEX)를 찾아서 반환(반환값:NUMBER)
      - ORACLE에서 INDEX는 1번부터 시작
      
    INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])  
      - 찾을위치 시작값
        1 : 앞에서부터 찾기(기본값)
        -1 : 뒤에서부터 찾기
*/
SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1,3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1,3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',3) FROM DUAL;

-- EMAIL에서 '_'의 INDEX값, '@'의 INDEX값
SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환
    
    SUBSTR('문자열', POSITION, [LENGTH])
     - POSITION : 문자열을 추출할 시작위치 INDEX
     - LENGTH : 추출할 문자의 갯수(생략시 맨 마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;

-- 이름과 주민번호에서 성별을 나타내는 문자 1개를 조회
SELECT EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE;

-- 여성(2,4) 사원들의 이름 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

-- 남성(1,3) 사원들의 이름 조회, 이름으로 오름차순 정렬
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3')
ORDER BY EMP_NAME;

-- 이름, 이메일, 이메일에서 아이디만 조회(kim@naver.com 이면 kim만 조회) 
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때
    LPAD|RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
    문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이 만큼의 문자열 반환
*/
-- 덧붙이는 문자가 없으면 공백으로 채움
SELECT EMP_NAME, LPAD(EMAIL, 20)    
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '#')    
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#')    
FROM EMPLOYEE;

-- 이름과 주민번호(800101-1******) 조회
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8), 14, '*') 주민번호
FROM EMPLOYEE;
--RPAD(SUBSTR(EMP_NO,1,8), 14, '*')
--RPAD(EMP_NO, 14, '*')
--RPAD(800101-1123456, 14, '*')
--RPAD('800101-1', 14, '*')
--      SUBSTR(EMP_NO,1,8)

SELECT EMP_NAME, SUBSTR(EMP_NO,1,8) || '******' 주민번호
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정문자를 제거하고 나머지 반환
    * TRIM : 문자열에서 앞/뒤 양쪽에 있는 특정 문자들을 제거하고 나머지 반환
    
    LTRIM|RTRIM('문자열',[제거하고자하는 문자])
    TRIM([LEADING|TRAILING|BOTH]제거하고자하는 문자 FROM '문자열')
*/
SELECT LTRIM('     K  H   ')|| '정보교육원' FROM DUAL;
SELECT RTRIM('     K  H   ')|| '정보교육원' FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPTJAVAORACLE','JAVA') FROM DUAL;
SELECT LTRIM('BACAABBDEFGBDK','ABC') FROM DUAL;
SELECT LTRIM('121726DIEKSL34KJ','0123456789') FROM DUAL;

SELECT TRIM('     K  H   ')|| '정보교육원' FROM DUAL;
SELECT TRIM('A' FROM 'AAABCAABDAAAA') FROM DUAL;
SELECT TRIM(BOTH 'A' FROM 'AAABCAABDAAAA') FROM DUAL;   -- BOTH가 기본값
SELECT TRIM(LEADING 'A' FROM 'AAABCAABDAAAA') FROM DUAL; -- LEADING = LTRIM
SELECT TRIM(TRAILING 'A' FROM 'AAABCAABDAAAA') FROM DUAL;   -- TRAILING = RTRIM

-- 전화번호에서 010을 제외하고 출력
SELECT LTRIM(PHONE, '01') 
FROM EMPLOYEE;

-----------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 문자열을 모두 대문자 혹은 소문자로, 단어의 첫글자만 대문자로 변환
    LOWER|UPPER|INITCAP('문자열')
*/
SELECT LOWER('Java Javascript Oracle') FROM DUAL;
SELECT UPPER('Java Javascript Oracle') FROM DUAL;
SELECT INITCAP('java javascript oracle') FROM DUAL;

-- LOCATION테이블의 LOCAL_NAME 의 값을 모두 소문자로 변환하여 모든 컬럼 조회
SELECT LOCAL_CODE, NATIONAL_CODE, LOWER(LOCAL_NAME)
FROM LOCATION;

-----------------------------------------------------------------------------
/*
    * CONCAT : 문자열2개를 하나로 합쳐 반환
    CONCAT('문자열1','문자열2')
*/
SELECT CONCAT('Oracle', ' 수업중') FROM DUAL;
SELECT 'Oracle' || ' 수업중' FROM DUAL;

SELECT CONCAT('JAVA', ' B강의실에서', ' 쉬운과목 수업') FROM DUAL; -- 문자열 2개만 가능
SELECT 'JAVA' || ' B강의실에서' || ' 쉬운과목 수업' FROM DUAL;     -- 여러 문자열 가능

-----------------------------------------------------------------------------
/*
    * REPLACE : 문자열을 새로운 문자로 바꿀 때 사용
    REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr', 'naver.com')
FROM EMPLOYEE;

--=======================================================================
--                           <숫자처리 함수>
--=======================================================================
/*
    * ABS : 숫자의 절대값을 구해주는 함수
    ABS(NUMBER)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-5.7) FROM DUAL;

---------------------------------------------------------------------------
/*
    * MOD : 두수를 나눈 나머지 반환
    MOD(NUMBER, 나눌 NUMBER)
*/
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;

---------------------------------------------------------------------------
/*
    * ROUND : 반올림
    ROUND(NUMBER, [위치])
*/
SELECT ROUND(1234.5678) FROM DUAL;  -- 위치생략시 0
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(1234.5678, 2) FROM DUAL;
SELECT ROUND(1234.56, 4) FROM DUAL;
SELECT ROUND(1234.56, -2) FROM DUAL;

---------------------------------------------------------------------------
/*
    * CEIL : 무조건 올림
    CEIL(NUMBER)
*/
SELECT CEIL(123.344) FROM DUAL;
SELECT CEIL(-123.344) FROM DUAL;
--SELECT CEIL(123.344, 2) FROM DUAL; -- 오류

---------------------------------------------------------------------------
/*
    * FLOOR : 무조건 내림
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.678) FROM DUAL;
SELECT FLOOR(-123.678) FROM DUAL;

---------------------------------------------------------------------------
/*
    * TRUNC : 위치 지정하여 버림 처리
    TRUNC(NUMBER, [위치지정])
*/
SELECT TRUNC(123.956) FROM DUAL;
SELECT TRUNC(123.956, 2) FROM DUAL;
SELECT TRUNC(123.956, -2) FROM DUAL;

SELECT TRUNC(-123.956) FROM DUAL;
SELECT TRUNC(-123.956, 2) FROM DUAL;

--=======================================================================
--                           <날짜처리 함수>
--=======================================================================
/*
    * SYSDATE : 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

---------------------------------------------------------------------------
/*
    MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) || '일' 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무개월수
FROM EMPLOYEE;

-- 근무개월수의 값에 '300'개월이면 '300개월차'로 출력하도록
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') 근무개월수
FROM EMPLOYEE;

---------------------------------------------------------------------------
/*
    * ADD_MONTHS(DATE, NUMBER) : 특정날짜에 NUMBER개월수 만큼 더한 날짜 반환
*/
-- 정직원이 된 날짜(입사 6개월 후)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원이된 날짜"
FROM EMPLOYEE;

-- 현재 날짜에서 5개월 후 날짜 출력
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;

---------------------------------------------------------------------------
/*
    * NEXT_DAY : 특정 날짜 이후에 가까운 해당 요일인 날짜를 반환
    NEXT_DAY(DATE, 요일(문자|숫자))
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;

-- 숫자로 입력 1:일요일, 2:월요일 ... 7:토요일
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) || '날은 신나게 게임하는 날' FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 언어설정이 KOREAN이기 때문

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;     -- 에러

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

---------------------------------------------------------------------------
/*
    * LAST_DAY : 해당 월의 마지막 날짜 반환
*/
SELECT SYSDATE, LAST_DAY(SYSDATE) FROM DUAL;

-- 사원명, 입사일, 입사한 달의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

-- 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE)-HIRE_DATE+1 || '일' "입사한 달의 근무일수"
FROM EMPLOYEE;

---------------------------------------------------------------------------
/*
    * EXTRACT : 특정날짜로 부터 년|월|일 값을 추출하여 반환(반환값:NUMBER)
    EXTRACT(YEAR FROM DATE) : 년도 추출
    EXTRACT(MONTH FROM DATE) : 월 추출
    EXTRACT(DAY FROM DATE) : 일 추출
*/
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE) 년도,
        EXTRACT(MONTH FROM SYSDATE) 월,
        EXTRACT(DAY FROM SYSDATE) 일
FROM DUAL;

-- 이름, HIRE_DATE, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, HIRE_DATE, EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
        EXTRACT(MONTH FROM HIRE_DATE) 입사월,
        EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE;

--=======================================================================
--                           <형변환 함수>
--=======================================================================
/*
    * TO_CHAR : 숫자, 날짜 타입의 값을 문자로 변환시켜주는 함수
                변환 결과를 특정 형식에 맞게 출력도 가능
    [표현법]
    TO_CHAR(숫자|날짜, [포맷])
*/
----------------------------숫자타입 -> 문자타입
/*
    9 : 해당자리의 숫자를 의미한다.
        - 해당자리에 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
    
    0 : 해당자리의 숫자를 의미한다.
        - 해당자리에 값이 없을 경우 0으로 표시, 숫자의 고정적으로 표시할 때 사용
    
    FM : 9로 치환했을 경우 소수점 이상은 공백제거, 소수점 이하는 0을 제거함
*/
SELECT TO_CHAR(1234) FROM DUAL; -- TIP) 숫자타입은 오른쪽 정렬 / 문자타입은 왼쪽 정렬
SELECT TO_CHAR(1234, '999999') "문자" FROM DUAL;   -- 6(총6칸 = 1234[4칸] + 남은 빈공간[2칸])칸 확보
SELECT TO_CHAR(1234, '000000') "문자" FROM DUAL; 
SELECT TO_CHAR(1234, 'L999999') "문자" FROM DUAL; -- LOCAL의 의미 : 현재 설정된 나라의 화폐 단위
SELECT TO_CHAR(1234, '$999999') "문자" FROM DUAL; -- 다른 나라의 화폐단위를 하고싶을 때, 해당 화폐 직접 입력

SELECT TO_CHAR(1234, 'L99,999') "문자" FROM DUAL;

-- 이름, 급여와 연봉 원 표시하고 3자리마다 ,(컴마)가 나타나도록
SELECT EMP_NAME, TO_CHAR(SALARY, 'L99,999,999') "월급", TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE;

-- FM을 사용하면 왼쪽 정렬이 된다.
SELECT TO_CHAR(123.456, 'FM99990.999'),
        TO_CHAR(123.45, 'FM9990.99'),
        TO_CHAR(0.1000, 'FM9990.999'),
        TO_CHAR(0.1000, 'FM9999.999')
FROM DUAL;

-- FM을 없애면, 앞의 공백 남은 자리만큼 공백 표시
SELECT TO_CHAR(123.456, '99990.999'),
        TO_CHAR(123.45, '9990.99'),
        TO_CHAR(0.1000, '9990.999'),
        TO_CHAR(0.1000, '9999.999')
FROM DUAL;

----------------------------날짜타입 -> 문자타입
-- 시간 TO_CHAR(DATE, AM|PM) => 오전인지 오후인지 출력
SELECT TO_CHAR(SYSDATE, 'AM') "KOREA",
        TO_CHAR(SYSDATE, 'PM', 'NLS_DATE_LANGUAGE=AMERICAN') "AMERICAN"
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') "현재 시간(12시간 형식)"
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') "현재 시간(24시간 형식)"
FROM DUAL;

-- 날짜
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') "오늘 날짜" FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') FROM DUAL;   -- 요일까지
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DY') FROM DUAL;    -- 요일 앞 글자
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;   -- 한국어 기준 요일까지
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DY') FROM DUAL; -- 직접 문자열 입력하고 싶을 때 "(쌍따옴표 사용)

-- 입사년도 EX)90-10-05 형태로 조회
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD DY') "입사년도"
FROM EMPLOYEE;

-- 입사년도 한글 기준(요일포함)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'DL') "입사년도"
FROM EMPLOYEE;

-- 입사년도 한글 기준(요일빼고)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') "입사년도"
FROM EMPLOYEE;

-- 년도
SELECT TO_CHAR(SYSDATE, 'YYYY') 년,
        TO_CHAR(SYSDATE, 'YY') 년,
        TO_CHAR(SYSDATE, 'RRRR') 년,
        TO_CHAR(SYSDATE, 'RR') 년,
        TO_CHAR(SYSDATE, 'YEAR') 년  -- AMERICAN 표기법
FROM DUAL;

-- 월
SELECT TO_CHAR(SYSDATE, 'MM') 월,
        TO_CHAR(SYSDATE, 'MON') 월,
        TO_CHAR(SYSDATE, 'MONTH') 월,
        TO_CHAR(SYSDATE, 'RM') 월 -- 로마 글자로 표기
FROM DUAL;

-- 일
SELECT TO_CHAR(SYSDATE, 'DD') 일,    -- 월 기준
        TO_CHAR(SYSDATE, 'DDD') 일,  -- 년 기준 몇일째
        TO_CHAR(SYSDATE, 'D') 일    -- 주 기준(1: 월요일 ~ 7:일요일)
FROM DUAL;

-- 요일
SELECT TO_CHAR(SYSDATE, 'DAY') 요일,
        TO_CHAR(SYSDATE, 'DY') 요일
FROM DUAL;

------------------------------------------------------------------------
/*
    * TO_DATE : 숫자나 문자를 날짜 형태로 변환
    
    [표현법]
    TO_DATE(숫자|문자, [포맷=형태])
*/

SELECT TO_DATE(20220101) FROM DUAL;
SELECT TO_DATE(221109) FROM DUAL;

SELECT TO_DATE(070101) FROM DUAL;   -- 맨 앞에 0일 때 없는 것으로 표시되어 오류!!
SELECT TO_DATE('070101') FROM DUAL;   -- ★ 앞이 0일 때는 문자 타입으로 변경해야 함!!

-- 12시까지 표기하기 때문에 13시 이상을 표시하고 싶으면, HH24(24시) 표시를 해주거나,
    -- 13시보다 작은 숫자를 입력할 것
SELECT TO_DATE('051125 132030', 'YYMMDD HH24:MI:SS') FROM DUAL;

-- YY : 현재 세기를 기준으로 반영
SELECT TO_DATE('030725', 'YYMMDD') FROM DUAL;   -- 2003년 현재 세기를 기준
SELECT TO_DATE('980303', 'YYMMDD') FROM DUAL;   -- 2098년

-- RR : 앞 년도의 2자리가 50미만이면 현재세기, 50이상이면 이전세기
SELECT TO_DATE('030725', 'RRMMDD') FROM DUAL;   -- 2003년
SELECT TO_DATE('980303', 'RRMMDD') FROM DUAL;   -- 1998년

------------------------------------------------------------------------
/*
    * TO_NUMBER : 문자를 숫자타입으로 변환
    
    [표현법]
    TO_NUMBER(문자, [포맷=형태])
*/
SELECT TO_NUMBER('02123456')FROM DUAL;  -- 앞에 0은 나타나지 않는다.
SELECT '1000' + '5000' FROM DUAL;   -- 문자끼리 더해도 숫자 형태라면 사칙연산 적용
SELECT '1,000,000' + '500,000' FROM DUAL;   -- 컴마(,)는 연산 불가 오류 발생!!
SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('500,000', '999,999') "계산" FROM DUAL;


--=======================================================================
--                           <NULL처리 함수>
--=======================================================================
/*
    NVL(컬럼, 컬럼값이 NULL일 때 반환할 값)
*/
-- BONUS NULL 값을 0으로 반환
SELECT EMP_NAME, NVL(BONUS, 0) FROM EMPLOYEE;

-- 전사원의 이름, 보너스포함 연봉 조회
SELECT EMP_NAME, (SALARY*BONUS + SALARY)*12 "보너스 포함 연봉"
FROM EMPLOYEE;

SELECT EMP_NAME, (SALARY*(1+BONUS))*12 "보너스 포함 연봉"
FROM EMPLOYEE;

-- NULL일 때, 해결 방법
SELECT EMP_NAME, (SALARY*NVL(BONUS, 0) + SALARY)*12 "보너스 포함 연봉", '원' AS "\"
FROM EMPLOYEE;

SELECT EMP_NAME, (SALARY*NVL(1+BONUS, 1))*12 "보너스 포함 연봉"
FROM EMPLOYEE;

-- 사원의 이름, 부서코드(부서가 없으면 '부서없음'으로 나오게) 조회
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음') "부서"
FROM EMPLOYEE;

-------------------------------------------------------------------------
/*
    NVL2(컬럼, 컬럼값이 있을 때 반환값, 컬럼값이 NULL일 때 반환할 값)
*/
-- BONUS에 값이 있으면 30%, NULL이면 10% 보너스를 주기로 함
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.3, 0.1) "보너스 비율", SALARY*NVL2(BONUS, 0.3, 0.1)+SALARY "보너스 포함 월급"
FROM EMPLOYEE;


-------------------------------------------------------------------------
/*
    NULLIF(비교대상1, 비교대상2)
        - 두 개의 값이 일치하면 NULL 반환
        - 일치하지 않으면 '비교대상1'을 반환
*/
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '1243') FROM DUAL;


--=======================================================================
--                           <선택 함수>
--=======================================================================
/*
    DECODE(비교하고자하는 대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ...)
    
    ※ 비슷하다
    SWITCH(비교대상) {
    CASE 비교값1 : 결과값1
    CASE 비교값2 : 결과값2
    ...
    DEFAULT :
*/
-- 사번, 이름, 주민번호, 성별 조회
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별
FROM EMPLOYEE;

-- 급여 조회 시 직급에 따라 인상하여 조회
-- J7 => 10% 인상 (급여 * 0.1)+급여 == (급여 * 1.1)
-- J6 => 15% 인상 (급여 * 0.15)+급여 == (급여 * 1.15)
-- J5 => 20% 인상 (급여 * 0.2)+급여 == (급여 * 1.2)
-- 그외 => 5% 인상  (급여 * 0.05)+급여 == (급여 * 1.05)

-- 사원명, 직급코드, 기존급여, 인상된 급여
SELECT EMP_NAME, JOB_CODE, SALARY,
    DECODE(JOB_CODE, 'J7', SALARY*1.1,
                    'J6', SALARY*1.15,
                    'J5', SALARY*1.2,
                          SALARY*1.05) "인상된 급여" -- 맨 마지막은 비교값 없이 결과값만
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    CASE WHEN THEN
    END
    
    [표현법]
    CASE WHEN 조건식1 THEN 결과값1
        WHEN 조건식2 THEN 결과값2
        ...
        ELSE 결과값N 
    END
    
    ※ 자바의 IF-ELSE와 비슷
*/

-- 급여가 500만원 이상이면 고급, 300만원 ~ 500만원 중급, 나머지는 초급
-- 이름, 급여, 급수 조회
SELECT EMP_NAME, SALARY, 
    CASE WHEN SALARY >= 5000000 THEN '고급'
        WHEN SALARY >= 3000000 THEN '중급'
        ELSE '초급'
    END AS "급수"
FROM EMPLOYEE;

--=======================================================================
--                           <그룹 함수>
--=======================================================================
/*
    SUM(숫자 타입의 컬럼) : 컬럼값들의 총 합계를 반환해주는 함수
*/
-- 전사원의 급여의 총 합계를 구하시오.
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 남자 사원의 급여의 총합계를 구하시오.
SELECT SUM(SALARY)
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO, 8, 1) = '1' OR SUBSTR(EMP_NO, 8, 1) = '3';
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3');

-- 부서코드가 D5인 사원들의 연봉의 합을 구하시오.
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-------------------------------------------------------------------------
/*
    AVG(숫자 타입의 컬럼) : 컬럼 값의 평균을 반환해주는 함수
*/
-- 전체 사원 급여의 평균(소수점 2자리까지)
SELECT ROUND(AVG(SALARY), 2)
FROM EMPLOYEE;

-- 직급(JOB_CODE)이 J5인 사원들의 급여의 평균
SELECT ROUND(AVG(SALARY), 2)
FROM EMPLOYEE
WHERE JOB_CODE = 'J5';


-------------------------------------------------------------------------
/*
    MIN(모든 타입의 컬럼) : 컬럼 값들 중 가장 작은 값을 반환해주는 함수
*/
SELECT MIN(EMP_NAME), MIN(SALARY) 급여, MIN(HIRE_DATE) 입사날짜
FROM EMPLOYEE;

/*
    MAX(모든 타입의 컬럼) : 컬럼 값들 중 가장 큰 값을 반환해주는 함수
*/
SELECT MAX(EMP_NAME), MAX(SALARY) 급여, MAX(HIRE_DATE) 입사날짜
FROM EMPLOYEE;

-------------------------------------------------------------------------
/*
    COUNT(*|컬럼|DISTINCT 컬럼) : 행의 개수
    
    COUNT(*) : 테이블의 행의 개수
    COUNT(컬럼) : 컬럼값에 NULL 값을 제외한 행의 개수
    COUNT(DISTINCT 컬럼) : 중복값을 제외한 행의 개수
*/
-- 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 전체 사원 중 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- 전체 사원 중 부서배치(DEPT_CODE)를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 전체 사원 중 여성 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 직급은 몇개의 직급으로 되어 있는가?
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;

-- 현재 사원들은 총 몇개의 부서에 분포되어 있는가?!
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;