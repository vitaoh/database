SET SERVEROUTPUT ON;

--    1. Considere a tabela retired_emps contendo as colunas: employee_id, last_name, job_id, hire_date,
--    retire_date, salary, department_id. Crie um bloco anônimo PL/SQL (ou procedimento) que
--    verifique todos empregados e os insira na tabela retired_emps caso tenham mais de 20 anos
--    completos de empresa.
--    Sugestão: usar a função MONTHS_BETWEEN(SYSDATE, date)/12;

DECLARE
    v_years NUMBER;
BEGIN
    FOR r IN (SELECT employee_id, last_name, job_id, hire_date, salary, department_id FROM employees) LOOP
        v_years := MONTHS_BETWEEN(SYSDATE, r.hire_date) / 12;
        IF v_years > 20 THEN
            INSERT INTO retired_emps(employee_id, last_name, job_id, hire_date, retire_date, salary, department_id)
            VALUES (r.employee_id, r.last_name, r.job_id, r.hire_date, SYSDATE, r.salary, r.department_id);
        END IF;
    END LOOP;
    COMMIT;
END;
/

--    2. Criar uma tabela temp contendo t_id e e-mail. Crie um bloco anônimo (ou procedimento)
--    PL/SQL que insira tuplas na tabela temp com:
--    t_id = employee_id
--    email = email do empregado concatenado com ‘@hr.com’, tudo em letras minúsculas

CREATE TABLE temp (
    t_id   NUMBER,
    email  VARCHAR2(100)
);

DECLARE
    CURSOR c_emp IS
        SELECT employee_id, email
        FROM employees;
    v_id    employees.employee_id%TYPE;
    v_email employees.email%TYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_id, v_email;
        EXIT WHEN c_emp%NOTFOUND;
        INSERT INTO temp (t_id, email)
          VALUES (v_id, LOWER(v_email || '@hr.com'));
    END LOOP;
    CLOSE c_emp;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Registros inseridos na tabela TEMP com sucesso.');
END;
/

SELECT * FROM temp;


--    3. Faça um bloco anônimo PL/SQL (ou procedimento) que descreva na tela o sobrenome e a função
--    (job_id) dos empregados que tenham função contendo a expressão ‘CLERK’

BEGIN
    FOR r IN (SELECT last_name, job_id FROM employees WHERE job_id LIKE '%CLERK%') LOOP
        DBMS_OUTPUT.PUT_LINE('Sobrenome: ' || r.last_name || ', Função: ' || r.job_id);
    END LOOP;
END;

--    4. Faça um bloco anônimo PL/SQL (ou procedimento) que descreva na tela o sobrenome e o
--    job_title dos 5 primeiros empregados, em ordem alfabética de sobrenome, cujo gerente é o
--    empregado com id = 100.

BEGIN
    FOR r IN (
        SELECT last_name, job_id
        FROM (
            SELECT last_name, job_id
            FROM employees
            WHERE manager_id = 100
            ORDER BY last_name
        ) 
        WHERE ROWNUM <= 5
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Sobrenome: ' || r.last_name || ', Cargo: ' || r.job_id);
    END LOOP;
END;

--    5. Faça um bloco anônimo (ou procedimento) que imprima na tela dados de todos os gerentes de
--    departamento: Sobrenome, nome do departamento que gerencia, salário atual e salário com aumento
--    de 5%.

BEGIN
    FOR r IN (
        SELECT d.department_name, e.last_name AS gerente_sobrenome, e.salary, e.salary * 1.05 AS salario_com_aumento
        FROM departments d
        JOIN employees e ON d.manager_id = e.employee_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Gerente do departamento ' || r.department_name || ': ' || r.gerente_sobrenome || ', Salário: ' || r.salary || ', Com aumento: ' || r.salario_com_aumento);
    END LOOP;
END;


--    6. Faça um bloco anônimo (ou procedimento) que exiba o tempo de empresa (calculado em anos)
--    de todos os empregados de um determinado departamento, obtendo o id do departamento por uma
--    variável de substituição, e mostre na tela para cada empregado - primeiro nome, sobrenome, data de
--    contratação e nível:

ACCEPT dpto_id NUMBER;
DECLARE
    v_depto_id NUMBER := &dpto_id;
BEGIN
    FOR r IN (
        SELECT first_name, last_name, hire_date, job_id
        FROM employees
        WHERE department_id = v_depto_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || r.first_name || ' ' || r.last_name || ', Data contratação: ' || r.hire_date || ', Cargo: ' || r.job_id);
    END LOOP;
END;

--    7. O RH deseja efetuar um cálculo para adicionar ao salário um bônus de acordo com o tempo que o
--    empregado tem de contratação. A cada ano completo trabalhado, será acrescido R$50,00 ao salário
--    como bônus. Com base nesses requisitos, elabore um bloco anônimo PL/SQL para saber qual o
--    valor do bônus para cada empregado da empresa. A saída deverá exibir na tela, para cada
--    empregado: o id do empregado, nome, sobrenome, data de contratação, quantidade de anos
--    trabalhados, valor do salário atual e valor de bônus que o empregado tem direito

BEGIN
    FOR r IN (SELECT employee_id, first_name, last_name, hire_date, SALARY FROM employees) LOOP
        DECLARE
            anos_trabalhados NUMBER := FLOOR(MONTHS_BETWEEN(SYSDATE, r.hire_date) / 12);
            bonus NUMBER := anos_trabalhados * 50;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('ID: ' || r.employee_id || ', Nome: ' || r.first_name || ' ' || r.last_name || ', Data contratação: ' || r.hire_date || ', Anos: ' || anos_trabalhados || ', Salário atual: ' || r.salary || ', Bônus: ' || bonus);
        END;
    END LOOP;
END;