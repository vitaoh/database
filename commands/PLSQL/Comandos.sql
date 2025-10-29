SET SERVEROUTPUT ON

-- Primeiro bloco
DECLARE
    h_date    employees.hire_date%TYPE;
    emp_id    employees.employee_id%TYPE := '&input';
    emp_years NUMBER;
BEGIN
    BEGIN
        SELECT
            hire_date
        INTO h_date
        FROM
            employees
        WHERE
            employee_id = emp_id;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Empregado não encontrado.');
            RETURN;
    END;

    emp_years := months_between(sysdate, h_date) / 12;
    IF emp_years > 10 THEN
        dbms_output.put_line('Empregado '
                             || emp_id
                             || ' é sênior');
    ELSIF emp_years > 5 THEN
        dbms_output.put_line('Empregado '
                             || emp_id
                             || ' é pleno');
    ELSE
        dbms_output.put_line('Empregado '
                             || emp_id
                             || ' é júnior');
    END IF;

END;
/

-- Segundo bloco
DECLARE
    jobid    employees.job_id%TYPE;
    empid    employees.employee_id%TYPE := 115;
    reajuste NUMBER(3, 2);
BEGIN
    SELECT
        job_id
    INTO jobid
    FROM
        employees
    WHERE
        employee_id = empid;

    IF jobid = 'PU_CLERK' THEN
        reajuste :=.12;
    ELSIF jobid = 'SH_CLERK' THEN
        reajuste :=.11;
    ELSIF jobid = 'ST_CLERK' THEN
        reajuste :=.10;
    ELSE
        reajuste :=.05;
    END IF;

    UPDATE employees
    SET
        salary = salary + salary * reajuste
    WHERE
        employee_id = empid;

END;

DECLARE
    nota      CHAR(1) := upper('&nota');
    resultado VARCHAR2(20);
BEGIN
    resultado :=
        CASE
            WHEN nota = 'A' THEN
                'Excelente'
            WHEN nota = 'B' THEN
                'Muito bom'
            WHEN nota = 'C' THEN
                'Bom'
            WHEN nota IN ( 'D', 'E' ) THEN
                'Reprovado'
            ELSE 'Nota inválida'
        END;

    dbms_output.put_line('Nota: '
                         || nota
                         || '
Resultado: '
                         || resultado);
END;
/

-- Comando LOOP
DECLARE
    ctry_id locations.country_id%TYPE := 'BR';
    loc_id  locations.location_id%TYPE;
    counter NUMBER(2) := 1;
    cty     locations.city%TYPE := 'Araraquara';
BEGIN
    SELECT
        MAX(location_id)
    INTO loc_id
    FROM
        locations
    WHERE
        country_id = ctry_id;

    LOOP
        INSERT INTO locations (
            location_id,
            city,
            country_id
        ) VALUES ( ( loc_id + counter ),
                   cty,
                   ctry_id );

        counter := counter + 1;
        EXIT WHEN counter > 3;
    END LOOP;

END;
/

-- Comando WHILE
DECLARE
    ctry_id locations.country_id%TYPE := 'BR';
    loc_id  locations.location_id%TYPE;
    counter NUMBER(2) := 1;
    cty     locations.city%TYPE := 'Araraquara';
BEGIN
    SELECT
        MAX(location_id)
    INTO loc_id
    FROM
        locations
    WHERE
        country_id = ctry_id;

    WHILE counter <= 3 LOOP
        INSERT INTO locations (
            location_id,
            city,
            country_id
        ) VALUES ( ( loc_id + counter ),
                   cty,
                   ctry_id );

        counter := counter + 1;
    END LOOP;

END;
/

-- Comando FOR
DECLARE
    ctry_id locations.country_id%TYPE := 'BR';
    loc_id  locations.location_id%TYPE;
BEGIN
    SELECT
        MAX(location_id)
    INTO loc_id
    FROM
        locations
    WHERE
        country_id = ctry_id;

    FOR i IN 0..5 LOOP
        DELETE FROM locations
        WHERE
            location_id = ( loc_id - i );

    END LOOP;

END;
/

-- Registros
DECLARE
    TYPE emp_tipo_registro IS RECORD (
            last_name VARCHAR2(25),
            job_id    VARCHAR2(10),
            salary    NUMBER(8, 2)
    );
    dados_emp emp_tipo_registro;
BEGIN
    SELECT
        last_name,
        job_id,
        salary
    INTO dados_emp
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line('Empregado: '
                         || dados_emp.last_name
                         || '
Função: '
                         || dados_emp.job_id
                         || '
Salário: '
                         || dados_emp.salary);

END;

--Criar uma tabela retired_emps contendo as colunas:
--employee_id, last_name, job_id, hire_date, retire_date,
--salary, department_id
--Criar um bloco anônimo PL/SQL que consulte os dados
--de um determinado empregado e o insira na tabela
--retired_emps caso ele tenha mais de 10 anos de
--empresa
--◦ Use registro

DECLARE
    emp_info  retired_emps%rowtype;
    empid     employees.employee_id%TYPE := 100;
    emp_years NUMBER;
BEGIN
    SELECT
        employee_id,
        last_name,
        job_id,
        hire_date,
        sysdate,
        salary,
        department_id
    INTO emp_info
    FROM
        employees
    WHERE
        employee_id = empid;

    emp_years := months_between(sysdate, emp_info.hire_date) / 12;
    IF emp_years > 10 THEN
        INSERT INTO retired_emps VALUES emp_info;

    END IF;
END;
/