# Engenheria-de-Dados-com-Hadoop-e-Spark
# Engenheria-de-Dados-com-Hadoop-e-Spark

## O que é um Cluster Hadoop?
Um Cluster Hadoop é um conjunto de máquinas com Hadoop instalado
que é criado para armazenar e analisar grandes quantidades de dados,
sejam eles estruturados ou não estruturados. Em um Cluster Hadoop, os
dados são armazenados e processados ao longo de diversos
computadores e tudo isso é feito de forma paralela.

![image](https://user-images.githubusercontent.com/87387315/138696715-6fd9d7eb-99ef-45de-b373-0a93c2492243.png)

## Arquitetura do Cluster Hadoop

![image](https://user-images.githubusercontent.com/87387315/138697076-4460dcee-86fb-41a9-b308-3a808da9fbc0.png)

1. Dados → Datanode.
2. Metadados → Namenode.
3. DataNode → Armazena/Recupera Dados.
4. TaskTracker → Executa Jobs de MapReduce.

## Workflow de um Cluster Hadoop
1. Os dados são divididos em blocos e distribuídos pelo cluster
Hadoop
2. MapReduce analisa os dados baseado nos pares de chave-valor
3. Os resultados são colocados em blocos através do cluster Hadoop
4. Os resultados podem ser lidos do cluster

## Workflow de Gravação de Dados no HDFS
O objetivo do Cluster Hadoop, é o rápido processamento, em paralelo, de grandes quantidades de dados.
A configuração padrão do Hadoop, é ter 3 cópias de cada bloco de dados no cluster (o que pode ser modificado pelo parâmetro dfs.replication no arquivo de configuração hdfs-site.xml).
Vamos verificar, como é o processo de gravação de dados no HDFS.
1. O cliente interage com o NameNode para obter a localidade onde o storage está disponível.
2. O cliente então interage diretamente com o DataNode
3. O cliente envia osdados, que são divididos em pequenos pedaços de blocos.
4. Após o dado ser completamente gravado pelo primeiro node, a replicação é feita para os demais nodes.
5. Após todos os DataNodes terminarem a gravação do dado, o relatório de blocos envia um sinal ao cliente, que então comunica o NameNode.
Os DataNodes também enviam o relatório de blocos ao NameNode. O NameNode utiliza o relatório de blocos para atualizar os Metadados.

## A Função do NameNode no Processo de Gravação no HDFS
O NameNode é o controlador principal do HDFS, que mantém os metadados de todo o sistema de
arquivos para o cluster.
Principais características do NameNode:
❑ Mantém o track de como cada bloco compõe um arquivo e a localização de cada bloco no cluster
❑ O NameNode não contém qualquer bloco de dados
❑ Direciona o cliente para os DataNodes e mantém o histórico de condições de cada DataNode
❑ Garante que cada bloco de dado atende aos critérios mínimos definidos pela política de replicação

O NameNode funciona da seguinte
forma:
✓ Os DataNodes enviam sinais (heartbeats) para o NameNode a cada 3 segundos através de TCP Handshake.
✓ Cada décimo sinal é um relatório de bloco.
✓ O relatório de bloco permite que o NameNode crie os metadados e garanta que 3 cópias de cada bloco existam em nodes diferentes.

![image](https://user-images.githubusercontent.com/87387315/138715501-9fac6713-6e35-40c8-ab2c-6ff567c1492f.png)

## Workflow de Leitura de Dados no HDFS
➢ Para recuperar um documento do HDFS, o cliente aciona o NameNode e solicita o endereço (bloco) onde o dado está armazenado.
➢ O cliente então solicita ao DataNode o dado, com o endereço do bloco fornecido pelo NameNode. Tudo isso ocorre via protocolo TCP na porta 50010.

![image](https://user-images.githubusercontent.com/87387315/138718199-46266d4c-80b1-4f85-acc8-d8e66a8f988a.png)

## Fatores para Planejamento do Cluster Hadoop
1, Objetivo : Volume de dados x Alta disponibilidade
2. Serviços : MapReduce (JobTracker, TaskTracker),HDFS (NameNode, DataNode), Storage (NFS, SAN)
3. Layout: Pseudo-Distribuído para desenvolvimento e Totalmente Distribuído para produção Local / Nuvem

## Hardware e Configuração de Rede do Cluster Hadoop
### Worker- Configuração 
1. Storage: Em um ambiente de intensivo i/o, recomenda-se 12 discos SATA 7200 RPM de 2 TB cada um, para balanceamento entre custo e performance. RAID não é recomendado em máquinas com serviços workers do Hadoop.
2. Memória: Nodes slaves requerem normalmente entre 24 e 48 GB de memória RAM. Memória não utilizada será consumida por outras aplicações Hadoop.
3. Processador Processadores com clock médio e menos de 2 sockets são recomendados.
4. Rede: Cluster de tamanho considerável, tipicamente requer links de 1 GB para todos os nodes em um rack com 20 nodes.

### Master - Configuração
1. Storage: Deve-se utilizar 2 servidores: um para o NameNode Principal e outro para o Secundário. O Master deve ter pelo menos 4 volumes de storage redundantes,
seja local ou em rede.
2. Memória: 64 GB de RAM suportam aproximadamente 100 milhões de arquivos.
3. Processador :16 ou 24 CPU’s para suportar o tráfego de mensagens.

(*) Estas são apenas recomendações e que podem variar de acordo com os fatores para o planejamento do cluster: objetivo, serviços e layout.
