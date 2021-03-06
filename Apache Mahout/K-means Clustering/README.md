# K-means com Mahout

A ideia do algoritmo K-médias está baseada na ideia de centroide. Centroide é uma instância, seja uma instância real ou virtual,
localizada no “centro” de um grupo de instâncias. Por exemplo:se tivermos 3 instâncias de saldos de clientes 100, 100 e 400, 
o “centro” seria uma instância de saldo 300 (virtual), valor médio de todas as instâncias. Você também pode pensar num centroide como um centro de massa.

O algoritmo K-médias inicia escolhendo K centroides aleatórios, C01, C02, ..., C0K. Como no agrupamento hierárquico, o número
de grupos é você que determina, embora existam técnicas e critérios para buscar melhores valores de K. O algoritmo é
iterativo, a inicialização sendo a iteração 0. Na próxima iteração serão calculados os centroides C11, C12, ..., C1K , cada novo
centroide calculado como a média dos elementos mais próximos a cada centroide da iteração anterior. O processo segue até que os
valores dos centroides não se modifiquem.

![image](https://user-images.githubusercontent.com/87387315/141522953-b91faf4d-7bc2-45ec-bed0-5225c51e11f7.png)

Um exemplo numérico em dimensão 1 Sayad (2018) deixa claro o procedimento utilizado. Você e um amigo estão levando um
grupo com pessoas de diferentes idades para uma excursão na cidade. Vocês querem dividir o grupo para que cada um possa
ser guia de uma parte do grupo. Vocês decidem usar então um K-médias, K=2, para fazer a divisão do grupo.

![image](https://user-images.githubusercontent.com/87387315/141522368-95813fef-62a3-4314-ba74-9d03e5f59f53.png)
![image](https://user-images.githubusercontent.com/87387315/141522409-d3bef091-0651-46a0-a805-26573e9dfec8.png)

Inicialmente são empregados 2 centróides arbitrários (2 elementos quaisquer do grupo), 16 e 22. No passo seguinte os elementos
mais próximos de 16, isto é [15, 15, 16], são empregados para o cálculo do novo centroide, média dos valores do grupo (15.33 = 
média(15 + 15 + 16)). O mesmo é feito para o centróide 22 (36,25 = média(19,19,20,20,21,22,28,35,40,41,42,43,44,60,61,65)). O
procedimento segue até que os centroides estabilizem em algum valor.

Em este projeto vamos usar o algoritmo k-medias para fazer a clusterização dos grupos de noticias usando Mahout, de forma de classificar a noticia em esporte, politica, etc.
Reclacandoo algorimo não sabe o tipo de noticia, ele só cria os grupos e o cientista de dados que define esse grupo.
# Criando um modelo preditivo de aprendizagem não-supervisionada
## Copiar os arquivos do file compartilhado 
```sh
su
[password]
cd /media/sf_Cap10/
cd Apache\ Mahout/
cd K-means\ Clustering/
cp -R news/ /home/hadoop
chown -R hadoop:hadoop /home/hadoop/news

//Sair do root
exit
ls -la / news
```
## Cria uma pasta no HDFS
```sh
hdfs dfs -mkdir /mahout/clustering
hdfs dfs -mkdir /mahout/clustering/data
```
## Copia os datasets para o HDFS
```sh
hdfs dfs -copyFromLocal news/* /mahout/clustering/data
hdfs dfs -cat /mahout/clustering/data/*
```
## Converte o dataset para objeto sequence
```sh
mahout seqdirectory -i /mahout/clustering/data -o /mahout/clustering/kmeansseq
```

## Converte a sequence para objetos TF-IDF vectors
```sh
mahout seq2sparse -i /mahout/clustering/kmeansseq -o /mahout/clustering/kmeanssparse

hdfs dfs -ls /mahout/clustering/kmeanssparse
```

## Construindo o modelo K-means
```sh
-i	diretório com arquivos de entrada
-c	diretório de destino para os centroids
-o	diretório de saída
-k	número de clusters
-ow	overwrite 
-x	número de iterações
-dm	medida de distância
```
```sh
mahout kmeans -i /mahout/clustering/kmeanssparse/tfidf-vectors/ -c /mahout/clustering/kmeanscentroids -cl -o /mahout/clustering/kmeansclusters -k 3 -ow -x 10 -dm org.apache.mahout.common.distance.CosineDistanceMeasure
```

# Visualiza os arquivos no HDFS
```sh
hdfs dfs -ls /mahout/clustering/kmeansclusters
```
# Dump dos clusters para um arquivo texto
```sh
mahout clusterdump -i /mahout/clustering/kmeansclusters/clusters-1-final -o clusterdump.txt -p /mahout/clustering/kmeansclusters/clusteredPoints/ -d /mahout/clustering/kmeanssparse/dictionary.file-0 -dt sequencefile -n 20 -b 100
```
# Visualiza os clusters.
```sh
cat clusterdump.txt
```
Podemos ver que os clusters estão definidos como "VL-#", p para o cluster VL-6 temos dois arquivos. Podemos ver que temos 7 arquivos em total, agrupados em 3 clusters. Se observa que o sistema fez o calculo de distancia com o centroide para definir os clusters 
Weight : [props - optional]:  Point:
	1.0 : [distance=0.3098571362238056]: [{"big":1.336},{"fast":1.847},{"obama":1.847},{"senate":1.847},{"track":1.847},{"trade":3.186},{"won":1.847}]
	1.0 : [distance=0.05348222003716152]: [{"domination":1.847},{"fast":1.847},{"has":1.56},{"life":1.847},{"obama":1.847},{"our":3.186},{"senate":1.847},{"track":1.847},{"world":1.847}]
  
![image](https://user-images.githubusercontent.com/87387315/141534817-093ec439-406d-4c43-bb18-c21d8e2c15ab.png)
