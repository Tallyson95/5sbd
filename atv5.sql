-- 1.
CREATE SEQUENCE seq_movimento
  START WITH 100
  INCREMENT BY 10
  NOCACHE
  NOCYCLE;

-- 2.
CREATE TABLE movimento_conta (
  movimento_id    NUMBER PRIMARY KEY,
  conta_numero    NUMBER NOT NULL,
  tipo            CHAR(1) CHECK (tipo IN ('C','D')),
  valor           NUMBER(12,2) NOT NULL,
  data_movimento  DATE DEFAULT SYSDATE
);

-- 3.
INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor)
VALUES (seq_movimento.NEXTVAL, 1, 'C', 500.00);

INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor)
VALUES (seq_movimento.NEXTVAL, 2, 'D', 200.00);

INSERT INTO movimento_conta (movimento_id, conta_numero, tipo, valor)
VALUES (seq_movimento.NEXTVAL, 3, 'C', 1500.00);

-- 4.
CREATE OR REPLACE VIEW vw_contas_clientes AS
SELECT 
  c.cliente_nome,
  co.conta_numero,
  co.saldo,
  co.agencia_cod
FROM cliente c
JOIN conta co ON c.cliente_cod = co.cliente_cod;

-- 5.
CREATE OR REPLACE VIEW vw_emprestimos_grandes AS
SELECT 
  e.emprestimo_numero,
  c.cliente_nome,
  e.quantia
FROM emprestimo e
JOIN cliente c ON e.cliente_cod = c.cliente_cod
WHERE e.quantia > 20000;

-- 6.
UPDATE vw_emprestimos_grandes
SET quantia = quantia + 1000
WHERE emprestimo_numero = 1;

-- 7.
CREATE ROLE atendente_agencia;

GRANT SELECT ON cliente TO atendente_agencia;
GRANT SELECT ON conta TO atendente_agencia;
GRANT UPDATE (endereco) ON cliente TO atendente_agencia;

-- 8.
GRANT atendente_agencia TO carla;

-- 9.
REVOKE UPDATE (endereco) ON cliente FROM atendente_agencia;

-- 10.
CREATE USER auditor IDENTIFIED BY auditor123;
GRANT CREATE SESSION TO auditor;

BEGIN
  FOR v IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v.view_name || ' TO auditor';
  END LOOP;
END;


-- 11.
SELECT *
FROM cliente
WHERE REGEXP_LIKE(cliente_nome, '^m.*a$', 'i');

-- 12.
SELECT 
  cliente_nome,
  REGEXP_REPLACE(cpf, '([0-9]{6})([0-9]{3})', '******\2') AS cpf_mascarado
FROM cliente;

-- 13.
SELECT 
  cliente_nome,
  REGEXP_SUBSTR(email, '@(.+)$', 1, 1, NULL, 1) AS dominio_email
FROM cliente;

-- 14.
SELECT *
FROM cliente
WHERE REGEXP_LIKE(cliente_nome, '^[[:alpha:]]+ [[:alpha:]]+');

-- 15.
SELECT *
FROM cliente
WHERE REGEXP_LIKE(email, '\.br$', 'i');