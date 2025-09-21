-- 1.
SELECT c.cliente_nome, co.conta_numero
FROM cliente c, conta co
WHERE c.cliente_cod = co.cliente_cliente_cod;

-- 2.
SELECT c.cliente_nome, a.agencia_nome
FROM cliente c, agencia a;

-- 3.
SELECT c.cliente_nome, a.agencia_cidade
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
JOIN agencia a ON co.agencia_agencia_cod = a.agencia_cod;

-- 4.
SELECT SUM(saldo) AS total_saldo
FROM conta;

-- 5.
SELECT MAX(saldo) AS maior_saldo,
       AVG(saldo) AS media_saldo
FROM conta;

-- 6.
SELECT COUNT(*) AS total_contas
FROM conta;

-- 7.
SELECT COUNT(DISTINCT cidade) AS cidades_distintas
FROM cliente;

-- 8.
SELECT conta_numero,
       NVL(saldo, 0) AS saldo
FROM conta;

-- 9.
SELECT c.cidade, AVG(co.saldo) AS media_saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
GROUP BY c.cidade;

-- 10.
SELECT c.cidade, COUNT(*) AS qtde_contas
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
GROUP BY c.cidade
HAVING COUNT(*) > 3;

-- 11.
SELECT CASE WHEN GROUPING(a.agencia_cidade) = 1 THEN 'TOTAL GERAL'
            ELSE a.agencia_cidade
       END AS cidade_agencia,
       SUM(co.saldo) AS total_saldo
FROM agencia a
LEFT JOIN conta co ON a.agencia_cod = co.agencia_agencia_cod
GROUP BY ROLLUP(a.agencia_cidade);

-- 12.
SELECT cidade AS nome_cidade FROM cliente
UNION
SELECT agencia_cidade FROM agencia
ORDER BY nome_cidade;

-- 13.
SELECT DISTINCT c.cliente_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo > (SELECT AVG(saldo) FROM conta);

-- 14.
SELECT DISTINCT c.cliente_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo = (SELECT MAX(saldo) FROM conta);

-- 15.
SELECT cidade
FROM (
  SELECT cidade, COUNT(*) AS num_clientes
  FROM cliente
  GROUP BY cidade
) t
WHERE num_clientes > (
  SELECT AVG(num_clientes)
  FROM (
    SELECT COUNT(*) AS num_clientes
    FROM cliente
    GROUP BY cidade
  )
);

-- 16.
SELECT DISTINCT c.cliente_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo IN (
  SELECT saldo FROM (
    SELECT saldo FROM conta ORDER BY saldo DESC
  )
  WHERE ROWNUM <= 10
);

-- 17.
SELECT DISTINCT c.cliente_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo < ALL (
  SELECT co2.saldo
  FROM conta co2
  JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod
  WHERE c2.cidade = 'Niterói'
);

-- 18.
SELECT DISTINCT c.cliente_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo BETWEEN
  (SELECT MIN(co2.saldo)
   FROM conta co2 JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod
   WHERE c2.cidade = 'Volta Redonda')
  AND
  (SELECT MAX(co2.saldo)
   FROM conta co2 JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod
   WHERE c2.cidade = 'Volta Redonda');

-- 19.
SELECT DISTINCT c.cliente_nome
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo > (
  SELECT AVG(co2.saldo)
  FROM conta co2
  WHERE co2.agencia_agencia_cod = co.agencia_agencia_cod
);

-- 20.
SELECT DISTINCT c.cliente_nome, c.cidade
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
WHERE co.saldo < (
  SELECT AVG(co2.saldo)
  FROM conta co2
  JOIN cliente c2 ON co2.cliente_cliente_cod = c2.cliente_cod
  WHERE c2.cidade = c.cidade
);

-- 21.
SELECT c.cliente_nome
FROM cliente c
WHERE EXISTS (
  SELECT 1 FROM conta co WHERE co.cliente_cliente_cod = c.cliente_cod
);

-- 22.
SELECT c.cliente_nome
FROM cliente c
WHERE NOT EXISTS (
  SELECT 1 FROM conta co WHERE co.cliente_cliente_cod = c.cliente_cod
);

-- 23.
WITH media_por_cidade AS (
  SELECT c.cidade, AVG(co.saldo) AS media_saldo
  FROM cliente c
  JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
  GROUP BY c.cidade
)
SELECT DISTINCT c.cliente_nome, c.cidade, co.saldo, m.media_saldo
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cliente_cod
JOIN media_por_cidade m ON c.cidade = m.cidade
WHERE co.saldo > m.media_saldo
ORDER BY c.cidade, c.cliente_nome;
