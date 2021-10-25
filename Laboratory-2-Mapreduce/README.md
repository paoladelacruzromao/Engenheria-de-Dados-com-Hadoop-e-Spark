# Laboratory-2-Mapreduce
## Usando MapReduce em Grandes Volumes de Dados
Como vimos o MapReduce é um modelo de programação que trabalhar de forma distribuída baseado em linguagem funcional e fornece duas operações (funções) que devem ser definidas pelo desenvolvedor: Map() e Reduce().O objetivo desse tutorial é praticar um pouco do MapReduce com a linguagem Python.

Em nossa prática temos um arquivo chamado ml-25m.zip que contém o registro das avaliações de vários filmes. O nosso objetivo é contar o total avaliações cada estrella recebeu. A estrutura do arquivo é: userID, movieID, raiting, timestamp.

Por exemplo,
Abra sua máquina Cloudera e acesse, no navegador da máquina, os dados do ml-25m.zip no seguinte link:
https://files.grouplens.org/datasets/movielens/ml-25m.zip

1.  No terminal cria a pasta Datasets e salva o arquivo .zip
```sh
mkdir Datasets
```

2.  Descompactar o arquivo o arquivo que nos interessa é o u.data
```sh
unzip ml-25m.zip
```

3. Abrir o arquivo u.data com um editor de textos
```sh
subl u.data
```

5.  No terminal cria a pasta no HDFS mapred 
```sh
hdfs dfs -mkdir mapred
```

6. Vamos salvar os arquivo u.data pasta mapred do HDFS
```sh
hdfs dfs -put u.data /mapred
```

7. Listando o arquivo para verificar sé esta no HDFS
```sh
hdfs dfs -ls /mapred
```

8. Vamos abrir do directorio Analytics AvaliaFilme.py, podemos observar que estamos usando o MRJob do pacote mrjob.job, esse pacote nos permite criar um programa em python para executar o mapreduce.Depois foi criada a classe MRAvaliaFilme para instanciar o MRJob, para depois criar dois funciones o mapper e reducer.O MRJob é um atalho do hadoop streaming
```sh
subl AvaliaFilme.py
```

No **mapper** estamos pegando todas as colunas e separando pelo caracter tab("/t") é coloco em cada variavel: userID, movieID, raiting, timestamp.
Depois temos a palavra reservada **yield**, que permite fazer uma iteração em uma sequencia de valores, sem precisar gravar a sequencia na memoria para no sobrecargar o cluster, e quero retornar o raiting com 1.

No **reducer**, vamos receber o raiting e as sequencias. E novamente vamos chmar o yield para sumar o numero de ocorrencia por cada raiting(estrellas classificadas).
Finalmente executo minha classe.

      from mrjob.job import MRJob

      class MRAvaliaFilme(MRJob):
          def mapper(self, key, line):
              (userID, movieID, rating, timestamp) = line.split('\t')
              yield rating, 1

          def reducer(self, rating, occurences):
              yield rating, sum(occurences)

      if __name__ == '__main__':
          MRAvaliaFilme.run()


  #### Fase 1 – Mapeamento
  A palavra reservada yield define qual das colunas será a chave (nesse caso a coluna rating, pois queremos saber o total de filmes em cada rating, que vai de 1 a 5). Cada    rating é mapeado e identificado com o valor 1, registrando a ocorrência do rating. Esse código é definido pelo Cientista de Dados.
  
    ![image](https://user-images.githubusercontent.com/87387315/138766479-ba6e4bdc-42c2-4584-bae7-45f422a27a78.png)

  #### Fase 2 – Shuffle e Sort
  Essa fase é processada automaticamente pelo framework MapReduce, que então agrupa os ratings e identifica quantas ocorrências cada rating obteve ao longo do arquivo.
  
  ![image](https://user-images.githubusercontent.com/87387315/138766609-2c38571b-0e20-4e70-979d-0d3c435dd832.png)
  
  #### Fase 3 – Redução
  Também definida pelo Cientista de Dados, esta fase aplica o cálculo matemático (no caso soma, com a função sum()) e retorna o resultado: total de filmes com rating 1, total de filmes com rating 2, etc....
  ![image](https://user-images.githubusercontent.com/87387315/138766757-1fc75da9-b7a1-4425-98b6-d6a398a518f7.png)

9. Executar o arquivo python
```sh
python AvaliaFilme.py hdfs:///mapred/u.data -r hadoop
```

(*) Em caso de falhas verificar os errors PipeMapRed.waitOutputThreads(), No configs found falling back on auto-configuration.O MRJob não achou o interpretador python do Anaconda. Para corregir esse erro precisamos criar um arquivo de configuração em **/home/hadoop** para o MRjob
Terminal
```sh
gedit .mrjob.conf
```
```sh
 runners:
  hadoop:
   python_bin: /home/hadoop/anaconda3/python
 ```
 Salvar o arquivo
 
 Terminal executar novamente
 ```sh
 python AvaliaFilme.py hdfs:///mapred/u.data -r hadoop
```
![image](https://user-images.githubusercontent.com/87387315/138778944-560b0dd3-5fb6-439f-9421-6993d9664636.png)




