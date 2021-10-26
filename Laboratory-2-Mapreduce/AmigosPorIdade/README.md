# Laboratory-2-Mapreduce-Amigos por Idade
## Usando MapReduce em Grandes Volumes de Dados
Como vimos o MapReduce é um modelo de programação que trabalhar de forma distribuída baseado em linguagem funcional e fornece duas operações (funções) que devem ser definidas pelo desenvolvedor: Map() e Reduce().O objetivo desse tutorial é praticar um pouco do MapReduce com a linguagem Python.

Em nossos datasets temos um arquivo chamado amigos_facebook.csv que contém o registro de uma campanha de uma empresa dos clientes no facebook. O nosso objetivo é contar a media de amigos por idade. A estrutura do arquivo é: ID, nome, idade, numamigos. Nosso trabalho é pegar o dataset original e calcular o número medio de amigos por idade.

## Por exemplo,
Abra sua máquina Cloudera e acesse, no navegador da máquina, os dados do amigos_facebook.csv. imagina que a gente tem 2 registros :
```sh
0, Eduardo, 33, 385
1, Paola, 33, 2
```
a. Aplicamos o Mapeamento
idade, número de amigos
```sh
33, 385
33, 2
```

b. Shuffle sort
```sh
33, 385 + 2
```

c.Redução
```sh
33, (385 + 2)/2
```

## Processo

1.  No terminal cria a pasta Datasets e salva o arquivo .csv
```sh
mkdir Datasets
```

2. Abrir o arquivo amigos_facebook.csv com um editor de textos, neste caso vamos usar o sublimetext
```sh
subl amigos_facebook.csv
```

3.  No terminal cria a pasta no HDFS mapred 
```sh
hdfs dfs -mkdir mapred
```

4. Vamos salvar os arquivo amigos_facebook.csv pasta mapred do HDFS
```sh
hdfs dfs -put amigos_facebook.csv /mapred
```

5. Listando o arquivo para verificar sé esta no HDFS
```sh
hdfs dfs -ls /mapred
```

6. Vamos abrir do directorio AmigosIdade.py, podemos observar que estamos usando o MRJob do pacote mrjob.job, esse pacote nos permite criar um programa em python para executar o mapreduce.Depois foi criada a classe MRAmigosPorIdade para instanciar o MRJob, para depois criar dois funciones o mapper e reducer.O MRJob é um atalho do hadoop streaming. 
```sh
subl AmigosIdade.py
```

No **mapper** estamos pegando todas as colunas com o underline (def mapper(self, _, line):) e separando pelo caracter (",") é coloco em cada variavel: ID, nome, idade,numamigos.
Depois temos a palavra reservada **yield**, que permite fazer uma iteração em uma sequencia de valores, sem precisar gravar a sequencia na memoria para no sobrecargar o cluster, e quero retornar a idade e o número de amigos com float(numamigos). Convertimos para float porque a gente vai calcular a media.

No **reducer**, vamos receber a idade e o número de amigos. E novamente vamos chamar o yield para sumar o numero de amigos por idade e calcular a media.
Finalmente executo minha classe.
```sh
  from mrjob.job import MRJob

  class MRAmigosPorIdade(MRJob):

      def mapper(self, _, line):
          (ID, nome, idade, numAmigos) = line.split(',')
          yield idade, float(numAmigos)

      def reducer(self, idade, numAmigos):
          total = 0
          numElementos = 0
          for x in numAmigos:
              total += x
              numElementos += 1

          yield idade, total / numElementos


    if __name__ == '__main__':
        MRAmigosPorIdade.run()
```

7. Em caso de querer remover o arquivo anterior do HDFS pode executar
```sh
hdfs dfs -rm /mapred/u.data
```

8. Executar o arquivo python, vai ver que o MRjob vai convertir seu código python para Hadoop Streaming. Ele acciona o yarn porque ele que vi inicializar a execução de seu job. Seu job e dividido em tarefas que nosso caso de ter varias máquinas vai distribuir as tarefas no cluster, nosso caso a maneira de estudio estamos usando o pseudocluster (1 só máquina). Depois vai executar o mapeamento e redução, podemos observar que a idade mínima encontrada e 18, mentras que idade máxima é 69 anos. Usuários com 18 anos tem em media 343.375 amigos.

```sh
python AmigosIdade.py hdfs:///mapred/amigos_facebook.csv -r hadoop
```
![image](https://user-images.githubusercontent.com/87387315/138907868-0ae57571-5c00-42bf-a546-f5c11600912d.png)




