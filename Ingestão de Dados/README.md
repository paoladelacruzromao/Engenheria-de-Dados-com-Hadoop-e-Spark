# Ingestão de dados
 
 O fluxo de trabalho de um projeto Big Data pode ser construído seguindo as seguintes etapas de ingestão de dados, integração, armazenamento dos dados, processamento e consumo dos dados processados. A figura 1 apresenta um exemplo desse fluxo; nós procedemos a ingestão dos dados que serão armazenados em um repositório com o HDFS ou HBase. Depois podemos processá-los de modo a efetuar análises sobre os dados e então podemos armazenar os resultados. Nesta trilha de aprendizagem focaremos na primeira etapa: a ingestão dos dados.

Os dados podem ser transmitidos e ingeridos em tempo real, fluxo ou em lotes. Quando os dados são ingeridos em tempo real, cada item de dados é importado conforme é emitido pela fonte. Quando os dados são ingeridos em lotes, os itens de dados são importados em blocos discretos em intervalos de tempo periódicos. Um processo efetivo de ingestão de dados começa pela priorização de fontes de dados, validando arquivos individuais e roteando itens de dados para o destino correto.

![image](https://user-images.githubusercontent.com/87387315/139254813-5d1ae50c-b022-4581-bd83-05aa620ac4e5.png)

Podemos dizer também que a ingestão de dados significa tirar os dados provenientes de várias fontes e colocá-los em algum lugar no qual possam ser acessados e posteriormente analisados. A ingestão de dados pode ser contínua ou assíncrona, em tempo real ou em conjunto, ou ambos dependendo das características da origem e do destino.
Dentro do ecossistema hadoop você pode montar data lakes no HDFS ou HBase, por exemplo.Um lago de dados (data lake) é onde todos os dados ingeridos ficam no seu formato de dados mais antigo. Isso inclui dados estruturados, semi-estruturados e não estruturados, bem como dados binários.

A ideia é manter em um único local (data storage) todos os dados na empresa, desde dados brutos até os dados transformados que são usados para várias tarefas, incluindo relatórios, visualização, análise e aprendizado automático.

Pode-se armazenar os dados no HDFS diretamente ou por meio do HBase. O consumidor de dados (data consumer) lê/acessa os dados no HDFS aleatoriamente usando HBase. O HBase (figura 2) fica em cima do hadoop file system fornecendo acesso de leitura/ gravação em tempo real aos dados do HDFS.

![image](https://user-images.githubusercontent.com/87387315/139260505-9d7a7f0f-2067-4171-8e63-b4e9e5c3d9db.png)

## Principais ferramentas para ingestão de dados para o HDFS e HBase: apache flume, apache sqoop e apache kafka.

### 1. Apache Flume: 
O apache flume é uma ferramenta de ingestão de dados que opera de maneira distribuída ideal para coletar, agregar e transportar de maneira eficiente grandes quantidades de arquivos de logs em tempo real de diferentes origens em um ambiente de armazenamento como o HDFS. Em geral, um arquivo de log é um arquivo que lista eventos/ações que ocorrem em um sistema operacional.

![image](https://user-images.githubusercontent.com/87387315/139256198-cecdf5ab-98e6-4a58-8c88-bd22c7ffcfea.png)

Os principais componentes do flume são:
• Flume event - um evento é a unidade básica dos dados transportados dentro do flume. Ele contém uma carga útil de matriz de bytes que deve ser transportada da origem para o destino, acompanhada de cabeçalhos opcionais;
• Flume agent - um agente é um processo daemon independente (JVM) no flume. Recebe os dados (eventos) de clientes ou outros agentes e os encaminha para seu próximo destino (coletor ou agente). O flume pode ter mais de um agente. Contém três componentes principais: source, channel e sink.
A figura 4 apresenta um diagrama do flume agente:

![image](https://user-images.githubusercontent.com/87387315/139256465-39759f31-5b8c-48d6-8fc2-0684537f9c06.png)

### 2. Apache SQOOP
O apache sqoop é uma ferramenta designada para transferir dados entre o hadoop e bancos de dados relacionais, isto é, o sqoop permite importar dados de bancos de dados, como MySQL, SQL Server, PostegreSQL, Oracle para hadoop HDFS, e exportar do sistema de arquivos hadoop estes bancos de dados relacionais. Por
padrão, o sqoop inclui conectores para vários bancos de dados populares, como MySQL, PostgreSQL, Oracle, SQL Server e DB2. Incluem também um conector JDBC genérico
que pode ser usado para se conectar a qualquer banco de dados acessível via JDBC.

O recurso de importação do sqoop importa as tabelas individuais de um banco de dados relacional para o HDFS, e cada uma das linhas da tabela é tratada como um registro no HDFS. Assim, todos esses registros podem ser armazenados como arquivos de textos ou como dados binários em arquivos do tipo avro e sequenceFile. SequenceFile é um arquivo do tipo flat específico do hadoop, constituído de pares de chave/valor binários. Esses registros são lidos e analisados em um conjunto de registros e delimitados com o delimitador especificado pelo usuário (figura 5).

![image](https://user-images.githubusercontent.com/87387315/139257284-441eb238-3f85-45a8-91e7-3a44700de640.png)

O sqoop importa os dados em paralelo a partir da maioria das fontes de banco de dados. Você pode especificar o número de tarefas de mapa (processos paralelos) para usar para executar a importação. A importação é feita em duas etapas, como mostrado na figura 6. Na primeira etapa, o sqoop examina o banco de dados
para reunir os metadados necessários para os dados que estão sendo importados. O segundo passo é a execução do map no hadoop a fim de armazenar os dados no HDFS. É este trabalho
que faz a transferência de dados reais usando os metadados capturados na etapa anterior.

![image](https://user-images.githubusercontent.com/87387315/139258970-cbfadf07-0899-4f1d-b497-ab5affe86910.png)

A exportação também é feita seguindo duas etapas, conforme descrito na figura 7. O primeiro passo consiste na introspecção do banco de dados para metadados, para que no segundo passo ocorra a transferência dos dados. O sqoop divide o conjunto de dados de entrada e, em seguida, usa tarefas de map individuais para encaminhar os pedaços ao banco de dados. Cada tarefa de map executa esta transferência em muitas transações para garantir um rendimento ótimo e uma utilização mínima dos recursos.

![image](https://user-images.githubusercontent.com/87387315/139259299-56d346f6-be4d-45dd-8f80-bc384903af4b.png)

### 3. Apache kafka
O apache kafka é um sistema para gerenciamento de streams de dados, como logs de aplicativos, sequências de eventos, transações financeiras, dados de sensores, em tempo real. Essencialmente, esse sistema coleta dados de alto volume, como, por exemplo, as atividades de usuários e logs, e torna estes dados disponíveis como um fluxo em tempo real para o consumo por outras aplicações.
A ferramenta possui um componente chamado producer que escreve os streams de dados em tópicos e um consumer que faz a leitura dos tópicos. Kafka é executado como um cluster em um ou mais servidores, e, como é um sistema distribuído, os tópicos são particionados e replicados em vários nós para evitar a perda de dados.
Cada tópico é visto como um log, isto é, um conjunto ordenado de mensagens. Mensagens são simplesmente arrays de bytes que os desenvolvedores podem usá-los para armazenar qualquer objeto em qualquer formato - com string, JSON e avro.

Assim, os fluxos de dados são estruturados como mensagens que são consumidas e produzidas por meio de tópicos. Um tópico funciona como um agrupamento de mensagens; assim, todas asmensagens enviadas para o kafka pertencem a um tópico.
Existem quatro principais APIs na ferramenta:
• producer API - permite publicar as mensagens nos tópicos;
• consumer API - permite que uma aplicação tenha acesso e leia as mensagens de um tópico;
• streams API - permite que uma aplicação atue como um processador de fluxo de dados. Consome um fluxo de entrada de um ou mais tópicos e produz um fluxo de saída para um ou
mais tópicos de saída. Isto é, transforma os fluxos de entrada para fluxos de saída;
• connector API - permite fazer a conexão entre o kafka e outros sistemas; por exemplo: uma conexão com um banco de dados.

A figura 8 mostra o diagrama de cluster de kafka. Geralmente, o cluster kafka consiste em vários brokers para manter o equilíbrio da carga. O ZooKeeper é usado para gerenciar e coordenar o broker kafka. Uma instância do broker pode lidar com centenas de milhares de leituras e gravações por segundo, e cada broker pode lidar com TB de mensagens sem impacto na performance.
O serviço ZooKeeper é usado principalmente para notificar o produtor (producer) e o consumidor (consumer) sobre a presença de qualquer broker novo no sistema kafka ou falha em algumbroker. Os produtores enviam dados aos brokers. Consumidores leem mensagens dos brokers.

![image](https://user-images.githubusercontent.com/87387315/139260061-46bb2448-c173-42a4-abc9-24f8aa740b7e.png)

