# ETL Oracle/Hadoop com Sqoop

![ETL Hadoop Sqoop Hive](https://user-images.githubusercontent.com/87387315/140417928-756d9bd4-2947-4cd2-8d25-4e31b4f69a57.png)
![sqoop caracteristicas](https://user-images.githubusercontent.com/87387315/140417956-055f4a0f-c311-42b1-90d6-ebdf6703f17e.png)
![execução sqoop](https://user-images.githubusercontent.com/87387315/140417976-0f90c5c3-af9d-4d84-9143-ba82ca12fe40.png)

## Conectar no SO como usuário hadoop ###

Logear com usuario Hadoop em no SO. Verificamos que o Hadoop e o yarn estão inicializados com o comando jps
Em caso de não estar inicializados digita no terminal

1. Como usuario hadoop, inicializar HDFS e Yarn
```sh
jps
start-dfs.sh
start-yarn.sh
```

Para não sair do usuário oracle podemos conectar da seguinte forma:
```sh
//Conecto com usuário root
su [senha] 

//Conectar com usuário hadoop e as variáveis do sistema com
su - hadoop 
start-dfs.sh
start-yarn.sh

//Digita exit para sair do usuário hadoop
exit

//Digita exit para sair so usuário root
exit
```
## Conectar no SO como usuário oracle ##

1. Baixar o driver JDBC para o Sqoop. Baixe a versão full
https://www.oracle.com/database/technologies/jdbc-ucp-122-downloads.html


2. Descompactar o arquivo
```sh
cd Downloads/
tar -xvf ojdbc8-full.tar.gz

cd OJDBC8-Full/
ls -la

```

3. Copiar o arquivo para o diretorio do sqoop. Eu não consigo fazer essa copia com usuário oracle preciso conectar com usuário root
```sh
su 
[senha]
cp ojdbc8.jar /opt/sqoop/lib
cd /opt/sqoop/lib/
ls -la

//Vamos mudar a propiedade do propitario do arquivo
chown hadoop:hadoop ojdbc8.jar

//Dar exit para sair do usuário root
exit
```

### No usuario oracle, configurar as variáveis de ambiente para o Hadoop e Sqoop no arquivo ˜/.bashrc
O usuário oracle não tem acesso ao HDFS, porque ele foi instalado com o usuário hadoop para isso precisamos configurar as variáveis de ambiente
cd ~
gedit .bashrc

4. Java JDK - colar todo em .bashrc
```sh
export JAVA_HOME=/opt/jdk
export PATH=$PATH:$JAVA_HOME/bin

# Hadoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Sqoop
export SQOOP_HOME=/opt/sqoop
export PATH=$PATH:$SQOOP_HOME/bin
export HCAT_HOME=/opt/sqoop/hcatalog
export ACCUMULO_HOME=/opt/sqoop/accumulo
```
Para efectuar os cambios no .bashrc digita:
```sh
source .bashrc
hdfs dfs -ls
```
O usuário  oracle não tem privilegios para escrever. Podemos dar essos privilegios usando Kerberos , mas em este caso vamos configurar para que qualquer um possa escrever no HDFS.

5. Como usuário hadoop, definir os privilégios com os comandos abaixo:s
```sh
su
[senha]
su - hadoop
hdfs dfs -chmod -R 777 /
chmod -R 777 /opt/hadoop/logs
exit
```
6. Como root:
```sh
groups oracle
usermod -a -G hadoop oracle
```

7. Importação de Dados do Oracle para o HDFS
```sh
sqoop import --connect jdbc:oracle:thin:aluno/dsahadoop@dataserver.localdomain:1539/orcl --username aluno -password dsahadoop --query "select user_id, movie_id from cinema where rating = 1 and \$CONDITIONS" --target-dir /user/oracle/output -m 1

sqoop import -D mapreduce.map.memory.mb=1024 -D mapreduce.map.java.opts=-Xmx768m --connect jdbc:oracle:thin:aluno/dsahadoop@dataserver.localdomain:1539/orcl --username aluno -password dsahadoop --query "select user_id, movie_id from cinema where rating = 1 and \$CONDITIONS" --target-dir /user/oracle/output -m 1
```
8. Checar o HDFS:
```sh
hdfs dfs -ls /user
```
9. Comando usado para corrigir problemas com blocos corrompidos, caso ocorra
```sh
hdfs fsck / | egrep -v '^\.+$' | grep -v replica | grep -v Replica
```
10. Para deixar o modo de segurança do Hadoop
```sh
hdfs dfsadmin -safemode leave
```

