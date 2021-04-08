/*
VIEW�� �������� �ڷḸ ���� ���ؼ� ����ϴ� ������ ���̺��̴�.
VIEW�� ������ ���̺�(���� ���̺�)�� �̿��� ���� ���̺��̱� ������
�ʿ��� �����͸� ������ �θ� ��ȸ�� �� ������ ������.
VIEW�� �̿��ؼ� �����Ϳ� �����ϸ� ���� �����ʹ� �����ϰ� ��ȣ�� �� �ִ�.
VIEW�� ������ ���������� �־�� ���� �� �ִ�.
*/

SELECT * FROM USER_ROLE_PRIVS; --����� ���� Ȯ��

--�ܼ� VIEW - �ϳ��� ���̺��� �ʿ��� �����͸� ������ ��

--VIEW�� �÷����� �Լ����� ���� ǥ�������� �ȵȴ�.
CREATE /*OR REPLACE*/ VIEW VIEW_EMP
AS (SELECT EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME,
           JOB_ID,
           SALARY
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = 60);
    
SELECT * FROM VIEW_EMP;

--���� VIEW - ���� ���̺��� �����ؼ� �ʿ��� �����͸� ������ ��
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

--VIEW ���� (CREATE OR REPLACE VIEW ~)
--������ �̸����� ����� �����Ͱ� ����ȴ�.

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

--VIEW�� ������ �̿��ϸ� �����͸� ���� ��ȸ�� �� �ִ�.
SELECT JOB_TITLE,
       AVG(SALARY)
FROM VIEW_EMP_DEPT_JOB
GROUP BY JOB_TITLE;

--VIEW ����
DROP VIEW VIEW_EMP_DEPT_JOB;


--���� ���� ������ �ִ� ��� ���ԺҰ�.
INSERT INTO VIEW_EMP
VALUES (108, 'TEST', 'IT_PROG', 5000); --NAME�� �����̹Ƿ� �Ұ�

--���� ���̺��� NOT NULL�� ��� ���� �Ұ�
INSERT INTO VIEW_EMP (EMPLOYEE_ID, JOB_ID, SALARY)
VALUES (108, 'IT_PROG', 5000); --NAME�� LAST_NAME�� NOT NULL�̹Ƿ� �Ұ�

--���պ��� ��� �ѹ��� ���� ���̺� ���� ������ �Ұ�
INSERT INTO VIEW_EMP_DEPT_JOB (EMPLOYEE_ID, HIRE_DATE, SALARY, DEPARTMENT_NAME, JOB_TITLE)
VALUES (300, SYSDATE, 8000, 'TEST', 'TEST');

--WITH CHECK OPTION (������ �÷��� ������ ���� ����)
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

--DEPARTMENT_ID�� ���������� �ɸ��� ������ �� ����.
UPDATE VIEW_EMP_TEST
SET DEPARTMENT_ID = 10 WHERE EMPLOYEE_ID = 110;

--WITH READ ONLY (�б� ���� ��)
CREATE OR REPLACE VIEW VIEW_EMP_TEST
AS (SELECT EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME
    FROM EMPLOYEES)
WITH READ ONLY;

SELECT * FROM VIEW_EMP_TEST;