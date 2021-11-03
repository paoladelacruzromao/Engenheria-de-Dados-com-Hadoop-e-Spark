show databases;

create database dsacademy;

use dsacademy;

show tables;

CREATE TABLE IF NOT EXISTS colaboradores (id int, nome String, cargo String, salario decimal)
COMMENT 'tabela de colaboradores'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';

show tables;

describe colaboradores;

ALTER TABLE colaboradores CHANGE salario salario Double;

describe colaboradores;

ALTER TABLE colaboradores ADD COLUMNS (cidade String COMMENT 'Nome da Cidade');

describe colaboradores;


