# Ingestão de Dados para HDFS usando Sqoop e Mysql

## Trabalhando com o Sqoop

### Ingestão de Dados de Marketing Banco
1. Crie uma tabela no banco de dados testeingestao chamada “marketing_banco”

  a) No terminal digite:
   ```sh
   mysql -u root -p
  ```
  b) Caso não exista vamos criar uma base chamada “testeingestao”, digite:
   ```sh
   create database testeingestao;
   ```
  c) Agora criaremos a tabela “marketing_banco”. Ainda no terminal digite todo o script a seguir:
   ```sh
   use testeingestao;
   CREATE TABLE marketing_banco(
   idade int not null,
   estadoCivil varchar(30) not null,
   trabalho varchar(50) not null,
   casa int not null,
   emprestimo int not null,
   campanha int not null,
   contato varchar(50) not null);
  ```
2. Essa tabela deve conter os seguintes campos:
• idade inteiro não nulo,
• estado civil varchar tamanho 30 não nulo,
• trabalho varchar tamanho 50 não nulo,
• casa inteiro não nulo,
• empréstimo inteiro não nulo,
• campanha inteiro não nulo
• contato varchar tamanho 50 não nulo
Baixe os dados no seguinte link: Salve eles em "/home/cloudera/Downloads/”
https://drive.google.com/file/d/1s5JotiouBon3DU7urq8JfDJeTtN2IZbY

 Agora você deve inserir os dados na tabela. Você pode inserir rapidamente no MySQL usando o seguinte comando LOAD conforme visto no tutorial do Sqooq.
 ```sh
 load data local infile "/home/cloudera/Downloads/makt_banco.csv "
 into table marketing_banco fields terminated by ","
 lines terminated by "\n" ignore 1 lines;
```
3. Importe os dados da tabela “marketing_banco” para o HDFS usando o Sqoop.
 ```sh
sqoop import --connect jdbc:mysql://localhost:3306/testeingestao --username root --password cloudera --table marketing_banco -m 1
```
