-- 1)
-- Faça um bloco anônimo que calcule o tempo de empresa (em anos) de um empregado,
-- conhecendo seu id, e mostre na tela seu nível:
-- . Sênior: acima de 15 anos de empresa
-- . Pleno: entre 5 e 15 anos
-- . Júnior: menor que 5 anos

SET SERVEROUTPUT ON;

DECLARE
    v_emp_id        employees.employee_id%TYPE := &employee_id;
    v_hire_date     employees.hire_date%TYPE;
    v_years         NUMBER;
    v_level         VARCHAR2(10);
BEGIN
    -- Busca a data de contratação
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = v_emp_id;

    -- Calcula o tempo de empresa em anos (aproximado)
    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    -- Determina o nível
    IF v_years > 15 THEN
        v_level := 'Sênior';
    ELSIF v_years BETWEEN 5 AND 15 THEN
        v_level := 'Pleno';
    ELSE
        v_level := 'Júnior';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Empregado ID: ' || v_emp_id);
    DBMS_OUTPUT.PUT_LINE('Tempo de empresa: ' || v_years || ' anos');
    DBMS_OUTPUT.PUT_LINE('Nível: ' || v_level);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Empregado não encontrado!');
END;
/


-- 2) 
-- O RH deseja efetuar um cálculo para adicionar ao salário um bônus de acordo com o tempo que
-- o empregado tem de contratação. A cada ano completo trabalhado, será acrescido R$50,00 ao
-- salário como bônus. Com base nesses requisitos, elabore um bloco anônimo PL/SQL no qual o
-- usuário deverá digitar o id de um empregado para saber qual o valor do bônus.
-- A saída deverá exibir na tela o id do empregado, nome, sobrenome, data de contratação,
-- quantidade de anos trabalhados, valor do salário atual e valor de bônus que o empregado tem
-- direito.
-- Para calcular tempo de contratação, use a função:
--    MONTHS_BETWEEN(SYSDATE, hire_date)/12

SET SERVEROUTPUT ON;

DECLARE
    v_emp_id        employees.employee_id%TYPE := &employee_id;
    v_first_name    employees.first_name%TYPE;
    v_last_name     employees.last_name%TYPE;
    v_hire_date     employees.hire_date%TYPE;
    v_salary        employees.salary%TYPE;
    v_years         NUMBER;
    v_bonus         NUMBER;
BEGIN
    -- Busca dados do empregado
    SELECT first_name, last_name, hire_date, salary
    INTO v_first_name, v_last_name, v_hire_date, v_salary
    FROM employees
    WHERE employee_id = v_emp_id;

    -- Calcula anos completos
    v_years := TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    -- Calcula bônus
    v_bonus := v_years * 50;

    -- Exibe resultados
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('ID do Empregado: ' || v_emp_id);
    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_first_name || ' ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Data de Contratação: ' || TO_CHAR(v_hire_date, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Anos Trabalhados: ' || v_years);
    DBMS_OUTPUT.PUT_LINE('Salário Atual: R$' || TO_CHAR(v_salary, '999,999.00'));
    DBMS_OUTPUT.PUT_LINE('Bônus: R$' || TO_CHAR(v_bonus, '999,999.00'));
    DBMS_OUTPUT.PUT_LINE('------------------------------------');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Empregado não encontrado!');
END;
/
