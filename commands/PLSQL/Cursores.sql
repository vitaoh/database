SET SERVEROUTPUT ON;

--    1. Considere a tabela retired_emps contendo as colunas: employee_id, last_name, job_id, hire_date,
--    retire_date, salary, department_id. Crie um bloco anônimo PL/SQL (ou procedimento) que
--    verifique todos empregados e os insira na tabela retired_emps caso tenham mais de 20 anos
--    completos de empresa.
--    Sugestão: usar a função MONTHS_BETWEEN(SYSDATE, date)/12;


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


--    4. Faça um bloco anônimo PL/SQL (ou procedimento) que descreva na tela o sobrenome e o
--    job_title dos 5 primeiros empregados, em ordem alfabética de sobrenome, cujo gerente é o
--    empregado com id = 100.


--    5. Faça um bloco anônimo (ou procedimento) que imprima na tela dados de todos os gerentes de
--    departamento: Sobrenome, nome do departamento que gerencia, salário atual e salário com aumento
--    de 5%.


--    6. Faça um bloco anônimo (ou procedimento) que exiba o tempo de empresa (calculado em anos)
--    de todos os empregados de um determinado departamento, obtendo o id do departamento por uma
--    variável de substituição, e mostre na tela para cada empregado - primeiro nome, sobrenome, data de
--    contratação e nível:


--    7. O RH deseja efetuar um cálculo para adicionar ao salário um bônus de acordo com o tempo que o
--    empregado tem de contratação. A cada ano completo trabalhado, será acrescido R$50,00 ao salário
--    como bônus. Com base nesses requisitos, elabore um bloco anônimo PL/SQL para saber qual o
--    valor do bônus para cada empregado da empresa. A saída deverá exibir na tela, para cada
--    empregado: o id do empregado, nome, sobrenome, data de contratação, quantidade de anos
--    trabalhados, valor do salário atual e valor de bônus que o empregado tem direito