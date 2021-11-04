# ETL Oracle/Hadoop com Sqoop

########### Conectar no SO como usuário hadoop ###########
Logear com usuario Hadoop em no SO. Verificamos que o Hadoop e o yarn estão inicializados com o comando jps
Em caso de não estar inicializados digita no terminal

# Como usuario hadoop, inicializar HDFS e Yarn
```sh
jps
start-dfs.sh
start-yarn.sh
```


########### Conectar no SO como usuário oracle ###########

# Baixar o driver JDBC para o Sqoop
https://www.oracle.com/database/technologies/jdbc-ucp-122-downloads.html


# Descompactar o arquivo
tar -xvf ojdbc8-full.tar.gz


# Copiar o arquivo para o diretorio do sqoop
cp ojdbc8.jar /opt/sqoop/lib


# No usuario oracle, configurar as variáveis de ambiente para o Hadoop e Sqoop no arquivo ˜/.bashrc

# Java JDK
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



# Como usuário hadoop, definir os privilégios com os comandos abaixo:s

hdfs dfs -chmod -R 777 /
chmod -R 777 /opt/hadoop/logs

# Como root:
groups oracle
usermod -a -G hadoop oracle


# Importação de Dados do Oracle para o HDFS

sqoop import --connect jdbc:oracle:thin:aluno/dsahadoop@dataserver.localdomain:1539/orcl --username aluno -password dsahadoop --query "select user_id, movie_id from cinema where rating = 1 and \$CONDITIONS" --target-dir /user/oracle/output -m 1

sqoop import -D mapreduce.map.memory.mb=1024 -D mapreduce.map.java.opts=-Xmx768m --connect jdbc:oracle:thin:aluno/dsahadoop@dataserver.localdomain:1539/orcl --username aluno -password dsahadoop --query "select user_id, movie_id from cinema where rating = 1 and \$CONDITIONS" --target-dir /user/oracle/output -m 1

# Checar o HDFS:
hdfs dfs -ls /user

# Comando usado para corrigir problemas com blocos corrompidos, caso ocorra
hdfs fsck / | egrep -v '^\.+$' | grep -v replica | grep -v Replica

# Para deixar o modo de segurança do Hadoop
hdfs dfsadmin -safemode leave

