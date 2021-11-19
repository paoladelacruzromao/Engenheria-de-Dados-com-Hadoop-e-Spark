
# Processando e Analisando Bilhões de Registros com Presto, Hive, AWS EMR (Elastic Map Reduce)  

![image](https://user-images.githubusercontent.com/87387315/142626396-106c4eb2-6c6d-4b03-8a52-c61bb8664892.png)

Este é um projeto de demonstração para que você veja como configurar um cluster multinode e processar grandes volumes de dados. Usaremos o cluster Hadoop com Amazon EMR – Elastic MapReduce e os serviços de motor de banco de dados Presto e Hive para análise dos dados.

**Tudo será demonstrado passo a passo e o ambiente configurado tem custo na AWS. **

O ponto de partida é a Console de Gerenciamento AWS, para acessar o catálogo de serviços da AWS, dar click em Todos os Serviços, você vai ver os serviços de Machine Learning, assim como o de Análise de Dados, onde vai estar o serviço que vamos usar EMR. Em ele vamos criar o cluster definindo quantas máquinas estamos usando.
## Fonte de Dados
1.	Baixe o arquivo csv do Yellow taxi trip records do mês de janeiro.
2.	Movendo os dados para o AWS S3
•	Vamos para Console de gerenciamento AWS e digitas S3 na caixinha de busca digitas em S3 Armazenamento escalável em a nuvem. Ele vai levar para o Dashboard do S3. 
•	Vamos criar um bucket, lembra o nome tem que ser único em toda aws. Trabalhar com a região do Ohio o custo é menor que trabalhar na região de São Paulo. Clica em Criar Bucket
•	Acessa Bucket clica em carregar, vai abrir outra tela, arrastre de seu explorer para nuvem, clica em carregar. Depois de fazer a carga vai aparecer uma tela verde indicando que o upload foi realizado com sucesso, pode clicar em Fechar, e vai levar para tela de resumo mostrando o arquivo na nuvem. Clica no ícone AWS com botão direito e abra uma nova aba e vamos voltar novamente para o Console de gerenciamento.

![image](https://user-images.githubusercontent.com/87387315/142626423-be3b32ad-ff19-4d89-8c16-8db7b5444dbd.png)

3.	Agora vamos criar o multinode Cluster, para isso precisamos de EMR, que é uma forma que AWS encontrou de ofrecer para você um cluster com apache Hadoop com apenas uns clicks.
•	Clica em Criar cluster, ele vai levar a uma tela para você configurar seu cluster:

	Defina o nome do cluster: ProjetoBonus.
	Click Registro em log.
	Modo de execução: cluster
	Versão de configuração:emr-6.3.0
	Configuração de Software PrestoSQL com Hadoop 3.2.1 HDFS e Hive 3.1.2 Metastore

 ![image](https://user-images.githubusercontent.com/87387315/142626483-c1479049-a270-45fc-a598-7a73726931b3.png)

	Configuração de HW, cada um dessas opções tem preços diferentes em este caso vamos usar m5.xlarge, eu poderia configurar alta escalabilidade no cluster, mas neste caso vamos deixar sem marcar:
 ![image](https://user-images.githubusercontent.com/87387315/142626509-e20fad6e-7f6d-4e7c-942d-5ebfad1e62d2.png)

	Na segurança de acesso, você precisa criar uma chave para poder acessar sega as instruções de: Saiba como criar uma chave de EC2, deixar em formato padrão, salve a chave em um diretório pode ser /Keys.
```sh
mkdir Keys
```
![image](https://user-images.githubusercontent.com/87387315/142626570-0308f1b3-ba47-439a-be84-db1cf8dea844.png)

•	No início da tela clica em opções avançadas: Nessa tela você pode customizar um pouco mais seu cluster, você pode escolher diferentes opções, fique sempre observando as versões.

•	Clica em criar Cluster vai demorar entre 5 e 10 minutos aproximadamente.

•	Revisando as configurações do cluster. Se o volumem de dados é muito grande pode que justifique a implementação local e não em nuvem.

•	Uma vez terminado o projeto não esqueça de “Encerrar” o cluster para não ser cobrado.

•	Ele mostra o DNS publico para poder acessar remotamente. E muito importante lembrar a chave que foi usada.

•	Se quer ver as máquinas rodando vai para Aws botão direito e abra uma nova aba clica EC2, vai ver as 3 instancias em execução.

•	Voltamos para EMR, e vamos conectar no cluster: Connect to the Master Node using SSH. Para ver o tipo de conexão em Linux ou Windows.

•	Acesso remoto ao cluster: Copia esse comando e depois vai para o terminal o primer passo é acessar a pasta onde está a chave em meu caso está no diretório keys

![image](https://user-images.githubusercontent.com/87387315/142626658-9ad10e12-cae0-40f8-a65d-279cf5329e0c.png)

 ```sh
cd Keys/
ssh -i ~/aws-dsa.pem hadoop@ec2-18.....
```
•	Vai ver que não acontece nada porque está faltando desbloquear o acesso publico. Vai nessa opção e da alterar.

 ![image](https://user-images.githubusercontent.com/87387315/142626714-c27b7bdd-5176-4bff-83ef-3e4957081e46.png)

•	Executa novamente o comando ssh -i ~/aws-dsa.pem hadoop@ec2-18..... e da enter:

 ![image](https://user-images.githubusercontent.com/87387315/142626770-38907f37-b03a-44af-938f-6a65cb81ac2e.png)

•	Em caso você tenha ainda problema para conectar no cluster. Vai para o EC2, vai aonde estão as três instancias e procura pela coluna grupo de segurança. Vê no menu esquerdo em Rede de Segurança e vai em security groups.

## Ajustando Permissões de acesso. 
No terminal digita screen para ver o símbolo emr

1. Ajusta o privilégio de acesso
```sh
sudo su -c 'mkdir -p /var/log/hive/user/hadoop && chown -R hadoop /var/log/hive/user/hadoop'
```
## Executa o Hive
```sh
hive
```
1. Cria tabela externa para o arquivo CSV no Hive.
 Com o bucket criado anteriormente substitui por projeto-bonus-cap12
 ```sh
CREATE EXTERNAL TABLE tb_dados_taxis (vendor_id VARCHAR(3), pickup_datetime TIMESTAMP, dropoff_datetime TIMESTAMP, passenger_count SMALLINT, trip_distance DECIMAL(6,3), rate_code_id SMALLINT, store_and_fwd_flag VARCHAR(1), PULocationID SMALLINT, DOLocationID SMALLINT, payment_type VARCHAR(3), fare_amount DECIMAL(6,2), extra DECIMAL(6,2), mta_tax DECIMAL(6,2), tip_amount DECIMAL(6,2), tolls_amount DECIMAL(6,2), improvement_surcharge DECIMAL(6,2), total_amount DECIMAL(6,2), congestion_surcharge DECIMAL(6,2)) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION 's3://projeto-bonus-cap12/';
```

## Executa no SO (Sistema Operacional)
Lembra tem que sair do hive com “quit:”, e voltara para o sistema operacional para executar o comando:
```sh
echo "LOAD DATA INPATH 's3://projeto-bonus-cap12/yellow_tripdata_2020-01.csv' INTO TABLE tb_dados_taxis;" | hive
```

## Executa no SO. Execução do Presto
```sh
presto-cli --catalog hive --schema default
```

### Executa no Presto Sql, 
Ele é um motor de execução SQL que roda sobre produtos de sistema SQL, em caso de não executar Presto pode ser usado HQL

```sh
SELECT passenger_count, count(*) FROM tb_dados_taxis GROUP BY passenger_count;
SELECT passenger_count, year(pickup_datetime), count(*) FROM tb_dados_taxis GROUP BY passenger_count, year(pickup_datetime);

SELECT passenger_count, year(pickup_datetime) trip_year, round(trip_distance), count(*) trips FROM tb_dados_taxis GROUP BY passenger_count, year(pickup_datetime), round(trip_distance) ORDER BY trip_year, trips desc;
```
## Desligar o Cluster

Vai em EMR no Cluster (lista do lado esquerdo da tela), clica em  Encerrar, e não esqueça de remover os arquivos do bucket.
