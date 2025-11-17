-- 1. Elabore uma função que, dado o id do empregado, retorne quantos empregados são mais antigos 
-- que ele na empresa.

-- 2. Faça uma função que, dados first_name, last_name e nome da empresa, retorne um endereço de 
-- email com o seguinte formato: first_name.last_name@nome_empresa.com

-- 3. Faça um procedimento para atualizar o email de um determinado empregado, com os parâmetros: 
-- id do empregado e nome da empresa. Utilize a função criada no exercício anterior para gerar o 
-- endereço de e-mail.

-- 4. Criar a função emp_status (emp_id) RETURN varchar2, que retorne o status de um funcionário 
-- com relação aos anos de trabalho na empresa:
--         Maior que 12 anos: status = ‘master’
--         Entre 8 e 12 anos: status = ‘senior’
--         Menor que 8 anos: status = ‘pleno’
--         Executar a function
--         SELECT first_name, last_name, emp_status(employee_id) 
--         FROM employees;

-- 5. Criar o procedimento aumento_salario (emp_id) que aumente o salário de um determinado 
-- empregado com relação ao seu status
--     Master  ->  aumento de 10%
--     Senior  ->  aumento de 5%
--     Pleno   ->  sem aumento
-- Use a função emp_status para saber qual o status do empregado

-- 6. Elabore um procedimento para alterar o gerente de um departamento, passando o id do 
-- departamento e o id do empregado que será seu novo gerente. - Um empregado somente pode ser gerente do departamento ao qual pertence. Caso o empregado 
-- pertença a outro departamento, exiba uma mensagem na tela dizendo que não é possível alterar o 
-- gerente, pois ele deve pertencer ao mesmo departamento que gerencia