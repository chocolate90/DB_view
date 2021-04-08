/*
VIEW는 제한적인 자료만 보기 위해서 사용하는 가상의 테이블이다.
VIEW는 물리적 테이블(원본 테이블)을 이용한 가상 테이블이기 때문에
필요한 데이터만 저장해 두면 조회할 때 이점을 가진다.
VIEW를 이용해서 데이터에 접근하면 원본 데이터는 안전하게 보호할 수 있다.
VIEW는 계정에 생성권한이 있어야 만들 수 있다.
*/

SELECT * FROM USER_ROLE_PRIVS; --사용자 권한 확인

--단순 VIEW - 하나의 테이블에서 필요한 데이터만 추출한 뷰

--VIEW의 컬럼명은 함수같은 가상 표현형식은 안된다.
CREATE /*OR REPLACE*/ VIEW VIEW_EMP
AS (SELECT EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME,
           JOB_ID,
           SALARY
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = 60);
    
SELECT * FROM VIEW_EMP;

--복합 VIEW - 여러 테이블을 조인해서 필요한 데이터만 저장한 뷰
CREATE OR REPLACE VIEW VIEW_EMP_DEPT_JOB
AS (SELECT E.EMPLOYEE_ID,
           E.FIRST_NAME || ' ' || E.LAST_NAME AS NAME,
           E.SALARY,
           D.DEPARTMENT_NAME,
           J.JOB_TITLE
    FROM EMPLOYEES E
    JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    JOIN JOBS J ON E.JOB_ID = J.JOB_ID
    );

SELECT * FROM VIEW_EMP_DEPT_JOB ORDER BY EMPLOYEE_ID;

--VIEW 수정 (CREATE OR REPLACE VIEW ~)
--동일한 이름으로 만들면 데이터가 변경된다.

CREATE OR REPLACE VIEW VIEW_EMP_DEPT_JOB
AS (SELECT E.EMPLOYEE_ID,
           E.FIRST_NAME || ' ' || LAST_NAME AS NAME,
           E.HIRE_DATE,
           E.SALARY,
           D.DEPARTMENT_NAME,
           J.JOB_TITLE
    FROM EMPLOYEES E
    JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    JOIN JOBS J ON E.JOB_ID = J.JOB_ID
    );

SELECT * FROM VIEW_EMP_DEPT_JOB;

--VIEW를 적절히 이용하면 데이터를 쉽게 조회할 수 있다.
SELECT JOB_TITLE,
       AVG(SALARY)
FROM VIEW_EMP_DEPT_JOB
GROUP BY JOB_TITLE;

--VIEW 삭제
DROP VIEW VIEW_EMP_DEPT_JOB;


--가상 열을 가지고 있는 경우 삽입불가.
INSERT INTO VIEW_EMP
VALUES (108, 'TEST', 'IT_PROG', 5000); --NAME이 가상열이므로 불가

--원본 테이블이 NOT NULL일 경우 삽입 불가
INSERT INTO VIEW_EMP (EMPLOYEE_ID, JOB_ID, SALARY)
VALUES (108, 'IT_PROG', 5000); --NAME중 LAST_NAME이 NOT NULL이므로 불가

--복합뷰의 경우 한번에 여러 테이블에 대해 삽입이 불가
INSERT INTO VIEW_EMP_DEPT_JOB (EMPLOYEE_ID, HIRE_DATE, SALARY, DEPARTMENT_NAME, JOB_TITLE)
VALUES (300, SYSDATE, 8000, 'TEST', 'TEST');

--WITH CHECK OPTION (조건절 컬럼의 수정을 막는 제약)
CREATE VIEW VIEW_EMP_TEST
AS (SELECT EMPLOYEE_ID,
           FIRST_NAME,
           LAST_NAME,
           EMAIL,
           JOB_ID,
           DEPARTMENT_ID
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = 100)
WITH CHECK OPTION CONSTRAINT VIEW_EMP_TEST_CK;

--DEPARTMENT_ID에 제약조건이 걸리고 변경할 수 없다.
UPDATE VIEW_EMP_TEST
SET DEPARTMENT_ID = 10 WHERE EMPLOYEE_ID = 110;

--WITH READ ONLY (읽기 전용 뷰)
CREATE OR REPLACE VIEW VIEW_EMP_TEST
AS (SELECT EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME
    FROM EMPLOYEES)
WITH READ ONLY;

SELECT * FROM VIEW_EMP_TEST;