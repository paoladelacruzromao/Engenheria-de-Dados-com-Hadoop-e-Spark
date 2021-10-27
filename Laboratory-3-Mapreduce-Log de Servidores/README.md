# Laboratory-3-Mapreduce - Analisando Logs de Servidores
## Usando MapReduce em Grandes Volumes de Dados
Como vimos o MapReduce é um modelo de programação que trabalhar de forma distribuída baseado em linguagem funcional e fornece duas operações (funções) que devem ser definidas pelo desenvolvedor: Map() e Reduce().O objetivo desse tutorial é praticar um pouco do MapReduce com a linguagem Python usando um arquivo log.

Em nossa prática temos um arquivo chamado web_server.log.zip que contém o log de registro de servidores. O nosso objetivo é analisar o log dos servidores e contar quantas vezes um endereço ip aparece no arquivo. 

Por exemplo,
Abra sua máquina Cloudera e acesse, no navegador da máquina, os dados do web_server.log.zip :

1.  No terminal cria a pasta Datasets e Analytics. Para salvar o arquivo o arquivo .zip, para isso o usuário precisa estar como root.
```sh
mkdir Datasets
mkdir Analytics

su
[ingressa o password cloudera]

```
Agora você está no diretório como root

2.  Ingressa no diretório compartilhado entre sua maquina e a maquina virtual para copiar os dados.
```sh
cd /media/sf_Cap05
cd Datasets
```

3. Copiar o arquivo web_server.log.zip de Datasets para /home/cloudera/Datasets/
```sh
cp web_server.log.zip /home/cloudera/Datasets/
```

4. Copiar os arquivos de Analytics para /home/cloudera/Analytics/ , a gente esta com dois arquivos, porque agora vamos usar o Hadoop streaming e não MRJob. Feito isso vamos executar exit para sair do usuário root. 
```sh
cp mapper.py reducer.py /home/cloudera/Analytics/
exit
```
5.  Como a gente fez a cópia com o usuário root precisamos mudar a propriedade deles para o usuário cloudera
```sh
cd /home/cloudera/Datasets
ls -la
```
![image](https://user-images.githubusercontent.com/87387315/139140298-0813543b-13b4-473d-b7d9-673472f126d2.png)
6.  Vamos mudar o usuário root, saímos do diretório Datasets. Com o comando "chown", mudamos o proprietário de maneira recursiva -R, para o usuário cloudera do grupo cloudera do diretório Datasets e Analytics.
```sh
cd ..
sudo chown -R cloudera:cloudera /Datasets
sudo chown -R cloudera:cloudera /Analytics
```
![image](https://user-images.githubusercontent.com/87387315/139141159-0be55ffe-c868-4100-bd9d-cdec77400709.png)

7.  No diretório Datasets vamos descompactar o arquivo
```sh
unzip web_server.log.zip
ls -la
```

8.  No terminal cria a pasta no HDFS mapred 
```sh
hdfs dfs -mkdir mapred
```

9. Vamos salvar o arquivo web_server.log pasta mapred do HDFS
```sh
hdfs dfs -put web_server.log /mapred
```
10. Vamos listar o arquivo para verificar sé esta no HDFS
```sh
hdfs dfs -ls /mapred
```

11. Vamos abrir do diretório Analytics mapper.py, podemos observar 
```sh
gedit mapper.py
```

No **mapper** estamos pegando todas a linha do log e separando pelo espaço (" ") é coloco o objeto data, verifico que o len(data) seja igual a 10 e guardo cada valor em cada variável: ip_address, identity, username, datetime, timezone, method, path, proto, status, size = data

```sh
   import sys

      for line in sys.stdin:
          data = line.strip().split(" ")
          if len(data) == 10:
              ip_address, identity, username, datetime, timezone, method, path, proto, status, size = data
              print ip_address

```

No **reducer**, vamos inicializar as variáveis current_ip_address com None e current_ip_address_count com 0. Crio um loop for para pegar cada linha que vai receber como entrada. Depois vamos verificar se o comprimento da linha é igual a 1 então posso estar com uma linha invalida e dou um continue. Verifica se existe current_ip_address e ele não é igual a new_ip_address então imprimo em tela o current_ip_address e a quantidade de vezes que aparece, e limpo o contador do current_ip_address_count = 0. Em caso contrário vou associar current_ip_address com new_ip_address, e vou incrementar o contador current_ip_address_count em 1. Finalmente sé o endereço ip fora diferente de None vou formatar a saída e imprimir na tela. O objetivo é contar quantas vezes cada endereço ip aparece em nosso arquivo log.

```sh
#!/usr/bin/env python

import sys

current_ip_address = None
current_ip_address_count = 0

for line in sys.stdin:
    new_ip_address = line.strip().split()
    if len(new_ip_address) != 1:
        continue

    if current_ip_address and current_ip_address != new_ip_address:
        print "{0}\t{1}".format(current_ip_address, current_ip_address_count)
        current_ip_address_count = 0

    current_ip_address = new_ip_address
    current_ip_address_count += 1

if current_ip_address != None:
    print "{0}\t{1}".format(current_ip_address, current_ip_address_count)
 ```     
  
12. Executar o arquivo python dentro do diretório Analytics precisamos do hadoop jar, definindo que é o mapper assim como o reducer.
```sh
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.6.0-mr1-cdh5.13.0.jar -mapper mapper.py -reducer reducer.py -files mapper.py, reducer.py -input /mapred/web_server.log -output /saida
```
Em caso de erro de não reconhecer files podemos mudar para:
```sh
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.6.0-mr1-cdh5.13.0.jar -mapper mapper.py -reducer reducer.py -file mapper.py -file reducer.py -input /mapred/web_server.log -output /saida
```
Em caso de PipeMapRed.waitOutputThreads() erro, significa que não estamos encontrando o interpretador da linguagem python. Para isso vamos verificar onde esta o interpretador da linguagem com o comando:
```sh
which python
```
Vai retornar /usr/bin/python. Isso significa que tanto no reducer como no mapper devemos indicar onde esta o interpretador: #!/usr/bin/env python. Para corrigir o problema devemos incluir o path do interpretador no mapper.py

```sh
  #!/usr/bin/env python
   import sys

      for line in sys.stdin:
          data = line.strip().split(" ")
          if len(data) == 10:
              ip_address, identity, username, datetime, timezone, method, path, proto, status, size = data
              print ip_address

```
Voltamos a executar:
```sh
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.6.0-mr1-cdh5.13.0.jar -mapper mapper.py -reducer reducer.py -file mapper.py -file reducer.py -input /mapred/web_server.log -output /saida2
```
Verificando o resultado. Vamos encontrar dois arquivos o primeiro que indica que o job foi executado com sucesso e o outro o resultado.
```sh
hdfs dfs -ls /saida2
hdfs dfs -cat /saida2/part-00000
```
