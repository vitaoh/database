-- 1. Elabore uma função que, dado o id do empregado, retorne quantos empregados são mais antigos 
-- que ele na empresa.

CREATE OR REPLACE FUNCTION qtd_mais_antigos(emp_id IN NUMBER)
RETURN NUMBER IS
    v_hire_date DATE;
  v_count NUMBER;
BEGIN
    SELECT hire_date INTO v_hire_date FROM employees WHERE employee_id = emp_id;
    SELECT COUNT(*) INTO v_count FROM employees WHERE hire_date < v_hire_date;
    RETURN v_count;
END;
/

-- 2. Faça uma função que, dados first_name, last_name e nome da empresa, retorne um endereço de 
-- email com o seguinte formato: first_name.last_name@nome_empresa.com

CREATE OR REPLACE FUNCTION gerar_email(
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_empresa IN VARCHAR2
) RETURN VARCHAR2 IS
    v_email VARCHAR2(100);
BEGIN
    v_email := LOWER(p_first_name || '.' || p_last_name) || '@' ||
                LOWER(REPLACE(p_empresa, ' ', '')) || '.com';
    RETURN v_email;
END;
/

-- 3. Faça um procedimento para atualizar o email de um determinado empregado, com os parâmetros: 
-- id do empregado e nome da empresa. Utilize a função criada no exercício anterior para gerar o 
-- endereço de e-mail.

CREATE OR REPLACE PROCEDURE atualizar_email(
    p_emp_id IN NUMBER,
    p_empresa IN VARCHAR2
) IS
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_email VARCHAR2(100);
BEGIN
    SELECT first_name, last_name INTO v_first_name, v_last_name
        FROM employees WHERE employee_id = p_emp_id;
    v_email := gerar_email(v_first_name, v_last_name, p_empresa);

    UPDATE employees SET email = v_email WHERE employee_id = p_emp_id;
    COMMIT;
END;
/

-- 4. Criar a função emp_status (emp_id) RETURN varchar2, que retorne o status de um funcionário 
-- com relação aos anos de trabalho na empresa:
--         Maior que 12 anos: status = ‘master’
--         Entre 8 e 12 anos: status = ‘senior’
--         Menor que 8 anos: status = ‘pleno’
--         Executar a function
--         SELECT first_name, last_name, emp_status(employee_id) 
--         FROM employees;

CREATE OR REPLACE FUNCTION emp_status(emp_id IN NUMBER)
RETURN VARCHAR2 IS
    v_years NUMBER;
    v_hire_date DATE;
BEGIN
    SELECT hire_date INTO v_hire_date FROM employees WHERE employee_id = emp_id;
    v_years := FLOOR(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);

    IF v_years > 12 THEN
        RETURN 'master';
    ELSIF v_years BETWEEN 8 AND 12 THEN
        RETURN 'senior';
    ELSE
        RETURN 'pleno';
    END IF;
END;
/

-- 5. Criar o procedimento aumento_salario (emp_id) que aumente o salário de um determinado 
-- empregado com relação ao seu status
--     Master  ->  aumento de 10%
--     Senior  ->  aumento de 5%
--     Pleno   ->  sem aumento
-- Use a função emp_status para saber qual o status do empregado

CREATE OR REPLACE PROCEDURE aumento_salario(emp_id IN NUMBER) IS
    v_status VARCHAR2(10);
    v_salary NUMBER;
    v_aumento NUMBER := 0;
BEGIN
    v_status := emp_status(emp_id);
    SELECT salary INTO v_salary FROM employees WHERE employee_id = emp_id;

    IF v_status = 'master' THEN
        v_aumento := v_salary * 0.10;
    ELSIF v_status = 'senior' THEN
        v_aumento := v_salary * 0.05;
    END IF;

    IF v_aumento > 0 THEN
        UPDATE employees SET salary = salary + v_aumento WHERE employee_id = emp_id;
        DBMS_OUTPUT.PUT_LINE('Salário atualizado em ' || TO_CHAR(v_aumento) || ' para empregado ' || emp_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Sem aumento para empregado ' || emp_id);
    END IF;
    COMMIT;
END;
/

-- 6. Elabore um procedimento para alterar o gerente de um departamento, passando o id do 
-- departamento e o id do empregado que será seu novo gerente. - Um empregado somente pode ser gerente do departamento ao qual pertence. Caso o empregado 
-- pertença a outro departamento, exiba uma mensagem na tela dizendo que não é possível alterar o 
-- gerente, pois ele deve pertencer ao mesmo departamento que gerencia

CREATE OR REPLACE PROCEDURE alterar_gerente(
    p_dept_id IN NUMBER,
    p_emp_id IN NUMBER
) IS
    v_emp_dept NUMBER;
BEGIN
    SELECT department_id INTO v_emp_dept FROM employees WHERE employee_id = p_emp_id;
    IF v_emp_dept = p_dept_id THEN
        UPDATE departments SET manager_id = p_emp_id WHERE department_id = p_dept_id;
        DBMS_OUTPUT.PUT_LINE('Gerente alterado com sucesso para o departamento ' || p_dept_id);
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Não é possível alterar o gerente: empregado deve pertencer ao mesmo departamento.');
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Empregado ou departamento inválido.');
END;
/