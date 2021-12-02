# Prevendo a Ocorrência de Doenças Cardíacas
Um grande hospital ou uma rede de serviços de saúde pode ser capaz de coletar grandes quantidades de dados sobre seus pacientes e um cluster Hadoop pode ser a solução ideal para armazenar e processar esse “Big Data da Saúde”. Nossa solução, portanto, vai utilizar um cluster Hadoop e as ferramentas:

**Hive –** como os dados estão em formato estruturado, usaremos o Hive para armazenar os dados no HDFS e realizar consultas interativas através da linguagem HQL.
**Pig –** será usado para transformação e pré-processamento nos dados.
**Mahout –** será usado para construção do modelo preditivo.

A solução contempla 5 etapas:

• Etapa 1 - Carregando o dataset no Hive e visualizando os dados com SQL
• Etapa 2 - Análise Exploratória e Pré-processamento nos dados com Pig
• Etapa 3 - Transformação de Dados com o Pig
• Etapa 4 - Criação do Modelo Preditivo de Classificação
• Etapa 5 - Otimização do Modelo Preditivo de Classificação

## Processo:
1.	Na etapa 1, carregamos os dados em uma tabela criada com o Hive. O Hive é a solução ideal para dados estruturados e permite utilizar a HQL, uma variação da linguagem SQL, que nos permite consultar os dados de forma rápida e eficiente.
```sh
# Etapa 1 - Carregando o dataset no Hive e visualizando os dados com SQL

CREATE DATABASE usecase location '/user/cloudera/projeto'; 

CREATE TABLE pacientes (ID INT, IDADE INT, SEXO INT, PRESSAO_SANGUINEA INT, COLESTEROL INT, ACUCAR_SANGUE INT, ECG INT, BATIMENTOS INT, DOENCA INT ) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE; 

LOAD DATA LOCAL INPATH 'pacientes.csv' OVERWRITE INTO TABLE pacientes;

SELECT count(*) FROM pacientes;

SELECT doenca, count(*), avg(idade), avg(pressao_sanguinea), avg(colesterol), avg(acucar_sangue), avg(batimentos) FROM pacientes GROUP BY doenca;
```
2.	Na etapa 2, usaremos o Pig para compreender como os dados se relacionam e realizar análises estatísticas.
```sh
# Etapa 2 - Análise Exploratória e pré-processamento nos dados com Pig

hdfs dfs -put pacientes.csv /user/hadooop

#copiar datafu-1.2.0.jar em user/hadoop
#dadosPacientes = load 'hdfs://localhost:9000/user/hadoop/testepig/pacientes.csv' AS ( ID:int, Idade:int, Sexo:int, PressaoSanguinea:int, Colesterol:int, AcucarSangue:int, ECG:int, Batimentos:int, Doenca:int);

dadosPacientes = LOAD 'pacientes.csv' USING PigStorage(',') AS ( ID:int, Idade:int, Sexo:int, PressaoSanguinea:int, Colesterol:int, AcucarSangue:int, ECG:int, Batimentos:int, Doenca:int);

REGISTER datafu-1.2.0.jar; 

DEFINE Quantile datafu.pig.stats.Quantile('0.0','0.25','0.5','0.75','1.0'); 

diseaseGroup = GROUP dadosPacientes BY Doenca; 

quanData = FOREACH diseaseGroup GENERATE group, Quantile(dadosPacientes.Idade) as Age, Quantile(dadosPacientes.PressaoSanguinea) as BP, Quantile(dadosPacientes.Colesterol) as Colesterol, Quantile(dadosPacientes.AcucarSangue) as AcucarSangue; 

DUMP quanData;
```
![mapreduced gerando arquivo](https://user-images.githubusercontent.com/87387315/144418984-ba2a10dc-4f07-42bd-a975-bb39dee018ac.png)

3.	Na etapa 3, o Pig será usado para transformar os dados de forma a facilitar o trabalho de construção do modelo preditivo.
```sh
ageRange = FOREACH dadosPacientes GENERATE ID, CEIL(Idade/10) as AgeRange; 
bpRange = FOREACH dadosPacientes GENERATE ID, CEIL(PressaoSanguinea/25) as bpRange; 
chRange = FOREACH dadosPacientes GENERATE ID, CEIL(Colesterol/25) as chRange; 
hrRange = FOREACH dadosPacientes GENERATE ID, CEIL(Batimentos/25) as hrRange; 
enhancedData = JOIN dadosPacientes by ID, ageRange by ID, bpRange by ID, hrRange by ID; 
describe enhancedData;

predictionData = FOREACH enhancedData GENERATE dadosPacientes::Sexo, dadosPacientes::AcucarSangue, dadosPacientes::ECG, ageRange::AgeRange, bpRange::bpRange, hrRange::hrRange, dadosPacientes::Doenca; 

STORE predictionData INTO 'enhancedHeartDisease' USING PigStorage(',');
```
![mapreduced pig](https://user-images.githubusercontent.com/87387315/144418802-78a4453f-dd19-4718-8fb3-40344ee00ff2.png)

4.	As etapas 4 e 5 são a criação do modelo preditivo com algoritmo Random Forest. Inicialmente criamos um modelo e avaliamos a Confusion Matrix.
```sh
# Etapa 4 - Criação do Modelo Preditivo de Classificação

# Cria a pasta no HDFS
hdfs dfs -mkdir /projeto

# Copia o arquivo gerado pela transformação com o Pig para o HDFS 
hdfs dfs -copyFromLocal enhancedHeartDisease/* /projeto

# Cria um descritor para os dados
mahout describe -p /projeto/part-r-00000 -f /projeto/desc -d 6 N L

# Divide os dados em treino e teste 
mahout splitDataset --input /projeto/part-r-00000 --output /projeto/splitdata --trainingPercentage 0.7 --probePercentage 0.3

# Constrói o modelo RandomForest com uma árvore t indica número de arvores
mahout buildforest -d /projeto/splitdata/trainingSet/* -ds /projeto/desc -sl 3 -p -t 1 -o /projeto/model

# Testa o modelo
mahout testforest -i /projeto/splitdata/probeSet -ds /projeto/desc -m /projeto/model -a -mr -o /projeto/predictions
```
![confussion matrix 1](https://user-images.githubusercontent.com/87387315/144418855-c81d7c7a-0999-4f07-b193-7d9cab175f27.png)

5.	Na sequência otimizamos o modelo aumentando o número de árvores de decisão.
```sh
# Construir o modelo com 25 árvores, a fim de aumentar a acurácia
mahout buildforest -d /projeto/splitdata/trainingSet/* -ds /projeto/desc -sl 3 -p -t 25 -o /projeto/model1

# Testa o modelo
mahout testforest -i /projeto/splitdata/probeSet -ds /projeto/desc -m /projeto/model1 -a -mr -o /projeto/predictions1
```
#Aumentando o número de árvores aumentamos a acurácia do modelo.
![confussion matrix 2](https://user-images.githubusercontent.com/87387315/144418881-4fd6a062-107a-47c8-a6d5-885167e1078a.png)

