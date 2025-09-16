-- 1.

SELECT UPPER(cliente_nome) AS nome_maiusculo
FROM cliente;


-- 2.

SELECT INITCAP(cliente_nome) AS nome_capitalizado
FROM cliente;


-- 3.

SELECT SUBSTR(cliente_nome, 1, 3) AS iniciais
FROM cliente;


-- 4.

SELECT cliente_nome, LENGTH(cliente_nome) AS qtd_caracteres
FROM cliente;


-- 5.

SELECT conta_numero, ROUND(saldo) AS saldo_arredondado
FROM conta;


-- 6.

SELECT conta_numero, TRUNC(saldo) AS saldo_truncado
FROM conta;


-- 7.

SELECT conta_numero, MOD(saldo, 1000) AS resto_divisao
FROM conta;


-- 8.

SELECT SYSDATE AS data_atual
FROM dual;


-- 9.

SELECT SYSDATE + 30 AS data_vencimento_simulada
FROM dual;


-- 10. (supondo que exista a coluna data_abertura na tabela conta)

SELECT conta_numero,
       TRUNC(SYSDATE - data_abertura) AS dias_ativos
FROM conta;


-- 11.

SELECT conta_numero,
       TO_CHAR(saldo, 'L999G999D99') AS saldo_moeda
FROM conta;


-- 12. (supondo que exista a coluna data_abertura na tabela conta)

SELECT conta_numero,
       TO_CHAR(data_abertura, 'DD/MM/YYYY') AS abertura_formatada
FROM conta;


-- 13.

SELECT conta_numero,
       NVL(saldo, 0) AS saldo_ajustado
FROM conta;


-- 14.

SELECT cliente_nome,
       NVL(cidade, 'Sem cidade') AS cidade
FROM cliente;


-- 15.

SELECT cliente_nome,
       CASE
           WHEN cidade = 'Niterói' THEN 'Região Metropolitana'
           WHEN cidade = 'Resende' THEN 'Interior'
           ELSE 'Outra Região'
       END AS regiao
FROM cliente;


-- 16.

SELECT c.cliente_nome, ct.conta_numero, ct.saldo
FROM cliente c
JOIN conta ct ON c.cliente_cod = ct.cliente_cliente_cod;


-- 17.

SELECT c.cliente_nome, a.agencia_nome
FROM cliente c
JOIN conta ct ON c.cliente_cod = ct.cliente_cliente_cod
JOIN agencia a ON ct.agencia_agencia_cod = a.agencia_cod;


-- 18.

SELECT a.agencia_nome, c.cliente_nome
FROM agencia a
LEFT JOIN conta ct ON a.agencia_cod = ct.agencia_agencia_cod
LEFT JOIN cliente c ON ct.cliente_cliente_cod = c.cliente_cod;