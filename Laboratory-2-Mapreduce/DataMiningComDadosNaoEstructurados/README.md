# Laboratory-2-Mapreduce- Data Mining de Dados Não Estructurados
## Usando MapReduce em Grandes Volumes de Dados
Como vimos o MapReduce é um modelo de programação que trabalhar de forma distribuída baseado em linguagem funcional e fornece duas operações (funções) que devem ser definidas pelo desenvolvedor: Map() e Reduce().O objetivo desse tutorial é praticar um pouco do MapReduce com a linguagem Python.

Em nossos datasets temos um arquivo do livro chamado OrgulhoePreconceito.txt dentro do website www.gutenberg.org/ebooks/1342. O nosso objetivo é analisar um conjunto de dados não estructurados como um livro e contar a quantidade de palavras. O arquivo é não estructurado. Nosso trabalho é pegar o dataset original e calcular a quantidade de cada palavra.

## Processo

1.  No terminal cria a pasta Datasets e salva o arquivo .txt
```sh
mkdir Datasets
```

2. Abrir o arquivo OrgulhoePreconceito.txt com um editor de textos, neste caso vamos usar o sublimetext
```sh
subl OrgulhoePreconceito.txt
```

3.  No terminal cria a pasta no HDFS mapred 
```sh
hdfs dfs -mkdir mapred
```

4. Vamos salvar os arquivo OrgulhoePreconceito.txt pasta mapred do HDFS
```sh
hdfs dfs -put OrgulhoePreconceito.txt /mapred
```

5. Listando o arquivo para verificar sé esta no HDFS
```sh
hdfs dfs -ls /mapred
```

6. Vamos abrir do directorio MR-DataMining-1.py, podemos observar que estamos usando o MRJob do pacote mrjob.job, esse pacote nos permite criar um programa em python para executar o mapreduce. Depois foi criada a classe MRDataMining para instanciar o MRJob, para depois criar dois funciones o mapper e reducer.O MRJob é um atalho do hadoop streaming. 
```sh
subl MR-DataMining-1.py
```

No **mapper** estamos pegando todas as colunas com o underline (def mapper(self, _, line):) e separando pelo caracter espaço, como pode ver quando line.split() é vazio significa que por default vai ter espaço é coloco em na variavel: palavras.
Depois temos a palavra reservada **yield**, que permite fazer uma iteração em uma sequencia de valores, sem precisar gravar a sequencia na memoria para no sobrecargar o cluster, e quero retornar a palavra em minuscula associada a 1. 

No **reducer**, vamos receber a chave que vai ser a palavra e os valores. E novamente vamos chamar o yield para sumar a quantidade de vezes em que aparece essa palavra.
Finalmente executo minha classe.
```sh
from mrjob.job import MRJob
 
class MRDataMining(MRJob):

    def mapper(self, _, line):
        palavras = line.split()
        for palavra in palavras:
            yield palavra.lower(), 1

    def reducer(self, key, values):
        yield key, sum(values)


if __name__ == '__main__':
    MRDataMining.run()

```
7. Executar o arquivo python, vai ver que o MRjob vai convertir seu código python para Hadoop Streaming. Ele acciona o yarn porque ele que vi inicializar a execução de seu job. Seu job e dividido em tarefas que nosso caso de ter varias máquinas vai distribuir as tarefas no cluster, nosso caso a maneira de estudio estamos usando o pseudocluster (1 só máquina). Depois vai executar o mapeamento e redução, podemos observar 

```sh
python MR-DataMining-1.py hdfs:///mapred/OrgulhoePreconceito.txt -r hadoop
```
![image](https://user-images.githubusercontent.com/87387315/138970449-a6393798-718b-4f2a-aed6-87d500a1b2fd.png)

Veja que temos cada uma das palavras , mas não diferenceu por exemplo "yesterday", de "yesterday." e de "yesterday,". Embora seja a mesma palavra nosso job achou que eram palavras diferentes. Para isso antes de apresentar o resultado final precisa fazer uma limpieza dos dados.

8. Vamos abrir do directorio MR-DataMining-2.py, para fazer a limpieza com expressões regulares. 
```sh
subl MR-DataMining-1.py
```
Estamos usando **expressões regulares**  do pacote re ("import re"), aplicando a formula "(r"[\w']+")", estamos falando que retorne só palavras (w=word) em REGEXP_PALAVRA.

No **mapper** estamos pegando todas as colunas com o underline (def mapper(self, _, line):) e por cada linha vamos buscar só palavras aplicando palavras = REGEXP_PALAVRA.findall(line).
Depois temos a palavra reservada **yield**, que permite fazer uma iteração em uma sequencia de valores, sem precisar gravar a sequencia na memoria para no sobrecargar o cluster, e quero retornar a palavra em minuscula associada a 1. 

No **reducer**, vamos receber a chave que vai ser a palavra e os valores. E novamente vamos chamar o yield para sumar a quantidade de vezes em que aparece essa palavra.
Finalmente executo minha classe.

```sh
from mrjob.job import MRJob
import re

REGEXP_PALAVRA = re.compile(r"[\w']+")

class MRDataMining(MRJob):

    def mapper(self, _, line):
        palavras = REGEXP_PALAVRA.findall(line)
        for palavra in palavras:
            yield palavra.lower(), 1

    def reducer(self, key, values):
        yield key, sum(values)

if __name__ == '__main__':
    MRDataMining.run()

```
7. Executar o arquivo python, vai ver que o MRjob vai convertir seu código python para Hadoop Streaming. Ele acciona o yarn porque ele que vi inicializar a execução de seu job. Seu job e dividido em tarefas que nosso caso de ter varias máquinas vai distribuir as tarefas no cluster, nosso caso a maneira de estudio estamos usando o pseudocluster (1 só máquina). Depois vai executar o mapeamento e redução, podemos observar que agora só devolvio as palavras sem caracteres especiales(númeres, virgulas, pontos, etc).

```sh
python MR-DataMining-2.py hdfs:///mapred/OrgulhoePreconceito.txt -r hadoop
```
![image](https://user-images.githubusercontent.com/87387315/138972263-8fc738f8-af6f-4567-ab47-69ee2b27a392.png)

Olha a palavra yesterday aparece uma vez nossa lista. E ela sé repite 13 vezes no livro. Podemos ver que o resultado esta sendo apresentado em ordem alfabetico da chave que é a palavra. E se por acaso o tomador de decisão quer saber quais palavras aparecem com mais frequencias.

8. Criar o mapreduce com as palavras que aparecem com maior e menor frequencia. Para isso vamos aplicar ##jobs aninados## aplicando o MR-DataMining-3.py, 
```sh
subl MR-DataMining-3.py
```
Estamos usando **jobs aninados**, para isso vamos usar MRStep. E vamos definir o metodo steps onde vou executar o mapeamento e redução o qual vai ser a entrada para o proxímo mappper.


No método def mapper_get_words(self, _, line) do primer **mapper** estamos pegando todas as colunas com o underline (def mapper(self, _, line):) e por cada linha vamos buscar só palavras aplicando palavras = REGEXP_PALAVRA.findall(line).
Depois temos a palavra reservada **yield**, que permite fazer uma iteração em uma sequencia de valores, sem precisar gravar a sequencia na memoria para no sobrecargar o cluster, e quero retornar a palavra em minuscula associada a 1. 

No método reducer_count_words(self, palavra, values) do primer **reducer**, vamos receber a chave que vai ser a palavra e os valores. E novamente vamos chamar o yield para sumar a quantidade de vezes em que aparece essa palavra.

No método  def mapper_make_counts_key(self, palavra, count) do segundor **mapper** estamos pegando a saída do primer reducer e vai contabilizar quantas vezes a palavra aparece.
Depois temos a palavra reservada **yield**, que permite fazer uma iteração em uma sequencia de valores, sem precisar gravar a sequencia na memoria para no sobrecargar o cluster, e quero retornar a quantidade de palavras.O "'%04d'%int(count)", é para entregar o resultado em um formato de 4 casas. 

No método reducer_count_words(self, palavra, values) do segundo **reducer** . E novamente vamos chamar o yield mais vamos invertir a saída primeiro vou receber a suma da quantidade de vezes em que aparece essa palavra e depois a palavra .

Finalmente executo minha classe.

```sh
from mrjob.job import MRJob
from mrjob.step import MRStep
import re

REGEXP_PALAVRA = re.compile(r"[\w']+")

class MRDataMining(MRJob):

    def steps(self):
        return [
            MRStep(mapper = self.mapper_get_words, reducer = self.reducer_count_words),
            MRStep(mapper = self.mapper_make_counts_key, reducer = self.reducer_output_words)
        ]

    def mapper_get_words(self, _, line):
        palavras = REGEXP_PALAVRA.findall(line)
        for palavra in palavras:
            yield palavra.lower(), 1

    def reducer_count_words(self, palavra, values):
        yield palavra, sum(values)

    def mapper_make_counts_key(self, palavra, count):
        yield '%04d'%int(count), palavra

    def reducer_output_words(self, count, palavras):
        for palavra in palavras:
            yield count, palavra


if __name__ == '__main__':
    MRDataMining.run()

```




