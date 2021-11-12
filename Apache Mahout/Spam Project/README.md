![image](https://user-images.githubusercontent.com/87387315/141359311-6e388677-af3d-4d77-871a-4e17e3cec173.png)
![image](https://user-images.githubusercontent.com/87387315/141359330-c23fbe43-4357-4318-82eb-e2b9ddd1a595.png)

# Spam Project com Mahout

O serviço de e-mail é uma das principais ferramentas utilizadas nos dias de hoje e é um exemplo de que a tecnologia facilita a troca de informações.
 Por outro lado, um dos maiores empecilhos enfrentados pelos serviços de e-mail corresponde ao spam, nome dado à mensagem não solicitada recebida por
 um usuário. A aplicação de aprendizado de máquina (machine learning) vem ganhando destaque nos últimos anos como alternativa para identificação eficiente
 de spam. Nessa área, diferentes algoritmos podem ser avaliados para identificar qual apresenta melhor desempenho. O objetivo deste projeto consiste em classificar corretamente os e-mails usando o algoritmo Naive Bayes do Mahout

![image](https://user-images.githubusercontent.com/87387315/141359355-d8d9b1a2-5322-42c4-827c-15c93a8683f5.png)

## Processo
1.	Copiar os arquivos do file compartilhado com a VM
```sh
su
[password]
cd /media/sf_Cap10/
cd Apache\ Mahout/
cd Spam\ Project/
cp -R ham/ /home/Hadoop
cp -R spam/ /home/Hadoop
```
2.	O proprietário dos diretórios é o usuário root
```sh
cd /home/hadoop/
ls -la
chown -R hadoop:hadoop ham
chown -R hadoop:hadoop spam
exit
```

3.	Depois de copiar os dados da máquina física para máquina virtual. Agora vamos copiar os dados para o hfdfs:
```sh
start-dfs.sh
start-yarn.sh
jps
```

# Criação do Modelo Preditivo com Naive Bayes

## Criar pastas no HDFS
```sh
hdfs dfs -mkdir /mahout
hdfs dfs -mkdir /mahout/input
hdfs dfs -mkdir /mahout/input/ham
hdfs dfs -mkdir /mahout/input/spam
```

## Copiando dados do filesystem local para o HDFS
```sh
hdfs dfs -copyFromLocal ham/* /mahout/input/ham
hdfs dfs -copyFromLocal spam/* /mahout/input/spam
```

## Converte os dados para uma sequence (obrigatório quando se trabalha com Mahout)
```sh
mahout seqdirectory -i /mahout/input -o /mahout/output/seqoutput
```

## Converte a sequence em vetores TF-IDF 
```sh
mahout seq2sparse -i /mahout/output/seqoutput -o /mahout/output/sparseoutput
```

## Visualiza a saída
```sh
hdfs dfs -ls /mahout/output/sparseoutput
```

## Split dos dados em treino e teste
```sh
-i pasta com dados de entrada
--trainingOutput dados de treino
--testOutput dados de teste
--randomSelectionPct percentual de divisão dos dados
--overwrite overwrite
--sequenceFiles input sequencial
--xm tipo de processamento. 
```

```sh
mahout split -i /mahout/output/sparseoutput/tfidf-vectors --trainingOutput /mahout/nbTrain --testOutput /mahout/nbTest --randomSelectionPct 30 --overwrite --sequenceFiles -xm sequencial
```

## Construção do Modelo Preditivo
```sh
-i dados de treino
-li onde armazenar os labels
-o onde armazenar o modelo
-ow overwrite
-c complementary
```
```sh

mahout trainnb -i /mahout/nbTrain -li /mahout/nbLabels -o /mahout/nbmodel -ow -c
```
## Teste do Modelo
	-i  pasta com os dados de teste
	-m	pasta do modelo
	-l	labels 
	-ow	overwrite
	-o	pasta com as previsões
	-c	complementary 

```sh

mahout testnb -i /mahout/nbTest -m /mahout/nbmodel -l /mahout/nbLabels -ow -o /mahout/nbpredictions -c
```




