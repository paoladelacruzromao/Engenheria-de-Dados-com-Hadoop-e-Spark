# Manipulação de Dados com Hive
1. Verificamos que o Hadoop e o yarn estão inicializados com o comando jps
Em caso de não estar inicializados digita no terminal
```sh
jps
start-dfs.sh
start-yarn.sh
```
2. Agora inicializamos o hive :
```sh
hive
```
3. Vamos executar no hive a lista de banco de dados com o comando:
```sh
show databases;
```
4. Podemos ver que so aparece o banco de dados default, no hive vamos criar um banco de dados e verificar que foi criada:
```sh
create database dsteste;
show databases;
use dsteste;
```
5. Vamos criar uma tabela colaboradores no hive com hql que terminam com "/t", e as linhas serão terminadas com "/n":
```sh
CREATE TABLE IF NOT EXISTS colaboradores (id int, nome String, cargo String, salario decimal)
COMMENT 'tabela de colaboradores'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';
```
6. Vamos verificar se foi criada a tabela:
```sh
show tables;
```
7. Vamos fazer um describe para ver as colunas da tabela:
```sh
describe colaboradores;
```
8. Vamos mudar a coluna salário de decimal para double:
```sh
ALTER TABLE colaboradores CHANGE salario salario Double;
describe colaboradores;
```
9. Tambem podemos adicionar colunas:
```sh
ALTER TABLE colaboradores ADD COLUMNS (cidade String COMMENT 'Nome da Cidade');
describe colaboradores;
```
10. Os metadatos foram para o Apache Derby ja os dados iram no HDFS, vamos copiar colaboradores.csv na raiz de nosso cluster hadoop

11. Agora temos que cargar esses dados em Apache Hive para isso criamos uma staging area uma area temporararia para depois ir a tabela final.
```sh
create table temp_colab (texto String);
```
12. Para cargar os dados do arquivo csv para a tabela temporaria digitamos o seguiente comando:
LOAD DATA LOCAL INPATH '/home/hadoop/colaboradores.csv' OVERWRITE INTO TABLE temp_colab;
SELECT * FROM temp_colab;

13. Vamos inserir dados em a tabela colaboradores usando expressões regulares desde uma consulta da tabela temporal:
```sh
INSERT overwrite table colaboradores 
SELECT  
  
  regexp_extract(texto, '^(?:([^,]*),?){1}', 1) ID,  
  regexp_extract(texto, '^(?:([^,]*),?){2}', 1) nome,  
  regexp_extract(texto, '^(?:([^,]*),?){3}', 1) cargo,
  regexp_extract(texto, '^(?:([^,]*),?){4}', 1) salario,  
  regexp_extract(texto, '^(?:([^,]*),?){5}', 1) cidade

FROM temp_colab;
```
14. Agora sim podemos fazer consultas:
```sh
SELECT * FROM colaboradores;

SELECT * FROM colaboradores WHERE Id = 1002;

SELECT * FROM colaboradores WHERE salario >= 25000;

SELECT * FROM colaboradores WHERE salario > 10000 AND cidade = 'Natal';

//Isso é um job mapreduce
SELECT sum(salario), cidade FROM colaboradores GROUP BY cidade;

```
