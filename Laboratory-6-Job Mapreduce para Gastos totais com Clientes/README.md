# Design de um Job MapReduce para Gastos Totais por Cliente

Neste projeto vai ser calculado o total de vendas por cliente da empresa XYZ. Tarefa aparentemente simples para um banco de dados transacional, onde só precisaríamos, cruzar os dados com o cadastro de clientes e obter o valor total gasto por cliente. 
Mas o principal problema surge se a solicitação fosse para gerar o total gasto por cliente nos últimos 5 anos, de modo a criar uma campanha personalizada para os clientes que tiveram os maiores gastos ao longo dos anos. 
Após alguma pesquisa, vamos obter um dataset no seguinte formato:

 ![image](https://user-images.githubusercontent.com/87387315/144422541-86a061b4-6114-4113-bc66-f712714862eb.png)

Sua pesquisa identificou que todos os registros dos últimos 5 anos geram
um dataset com apenas duas colunas, mas 200 milhões de registros. 

Definitivamente esse não é um trabalho para um banco de dados relacional. 
E necessário uma ferramenta que possa rapidamente processar os dados e retornar apenas um valor total por cliente. Você então decide criar um job de mapeamento e redução.

Com poucas linhas de código e usando linguagem Python, você consegue gerar o resultado esperado. Mas ainda tem um problema.
Como processar esse job da forma mais rápida possível? Spark/Hadoop é a
solução ideal.

Esse é um exemplo claro de projeto de Big Data. Um grande volume de
dados e tudo que você precisa é extrair uma simples informação, que poderá fazer toda diferença na estratégia da empresa.

## Criando Pasta em HDFS para armazenar os dados gastos-cliente.csv
```sh
# Criar uma pasta no HDFS
hdfs dfs -mkdir /clientes

# Copiar o dataset para o HDFS
hdfs dfs -put gastos-cliente.csv /clientes

# Confirmar que o arquivo foi copiado
hdfs dfs -ls /clientes
```
## Criando o Job de MapReduce em Python gastos-cliente.py
```sh
from pyspark import SparkConf, SparkContext

# Define o Spark Context, pois o job será executado via linha de comando com o spark-submit
conf = SparkConf().setMaster("local").setAppName("GastosPorCliente")
sc = SparkContext(conf = conf)

# Função de mapeamento que separa cada um dos campos no dataset
def MapCliente(line):
    campos = line.split(',')
    return (int(campos[0]), float(campos[2]))

# Leitura do dataset a partir do HDFS
input = sc.textFile("hdfs://clientes/gastos-cliente.csv")
mappedInput = input.map(MapCliente)

# Operação de redução por chave para calcular o total gasto por cliente
totalPorCliente = mappedInput.reduceByKey(lambda x, y: x + y)

# Imprime o resultado
resultados = totalPorCliente.collect();
for resultado in resultados:
    print(resultado)
```

## Executa o job na linha de comando spark-summit
```sh
spark-submit gastos-cliente
```
