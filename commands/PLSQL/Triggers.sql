-- 1. impedir redução de salário
CREATE OR REPLACE TRIGGER trg_no_salary_decrease
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
IF :NEW.salary < :OLD.salary THEN
RAISE_APPLICATION_ERROR(-20111, 'Salários não podem ser reduzidos!');
END IF;
END;
/​

-- 2. tabela DEPT_MGR_HISTORY e trigger básico
CREATE TABLE dept_mgr_history (
dept_id NUMBER(4) NOT NULL,
manager_id NUMBER(6) NOT NULL,
end_date DATE NOT NULL
);

CREATE OR REPLACE TRIGGER trg_dept_mgr_history
AFTER UPDATE OF manager_id ON departments
FOR EACH ROW
BEGIN
INSERT INTO dept_mgr_history (dept_id, manager_id, end_date)
VALUES (:OLD.department_id, :OLD.manager_id, SYSDATE);
END;
/​

-- 3. incluir START_DATE e ajustar trigger
ALTER TABLE dept_mgr_history
ADD (start_date DATE);

CREATE OR REPLACE TRIGGER trg_dept_mgr_history
AFTER UPDATE OF manager_id ON departments
FOR EACH ROW
DECLARE
v_last_end_date DATE;
v_start_date DATE;
BEGIN
SELECT MAX(end_date)
INTO v_last_end_date
FROM dept_mgr_history
WHERE dept_id = :OLD.department_id;

IF v_last_end_date IS NULL THEN
SELECT hire_date
INTO v_start_date
FROM employees
WHERE employee_id = :OLD.manager_id;
ELSE
v_start_date := v_last_end_date + 1;
END IF;

INSERT INTO dept_mgr_history (dept_id, manager_id, start_date, end_date)
VALUES (:OLD.department_id, :OLD.manager_id, v_start_date, SYSDATE);
END;
/