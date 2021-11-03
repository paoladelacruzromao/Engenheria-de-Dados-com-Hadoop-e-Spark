# Pipeline de Dados no Hbase com API Java


Para esse projeto vamos utilizar a máquina da Cloudera, para poder usar o eclipse
1.	Vamos abrir o eclipse e criar um projeto, botão direito Novo-> Java Projeto (Java Project), vamos colocar o Nome do projeto, vamos ver que a Cloudera usa Java 1.7
2.	Clica em Next, ele pergunta se você quer um diretório diferente para seus arquivos, ele sugere src que o padrão em java, vamos deixar o arquivo padrão src e clicar em finish.
3.	Observe que aparece src e JRE System Library com o java 1.7 que estamos trabalhando
4.	Dentro de src vamos criar um pacote (conjunto de classes) em java, que vão compor nossa aplicação de pipeline de dados. Em src clica botão direito clica new e Package. Ele vai perguntar o nome do pacote.
5.	Agora vamos criar as classes java que contêm tudo o processo do pipeline. As classes estão anexadas a este laboratório. Se observamos cada classe esta composta por métodos e atributos. Um atributo é uma ação que você faz com aquela classe, È uma característica, uma propriedade da classe.
6.	Em Hbase_create.java, primeiro vamos definir o nome do pacote definido no ponto 4, vou importar o pacote IOException, porque quero tratar as excepciones, assim como vários pacotes do Hadoop Hbase.
7.	Uma vez importado os pacotes criamos nossa própria classe Hbase_create, botão direito no pacote e new class, o fazer drag and drop dessas classes já definidas.
8.	 Dentro da classe temos uma função método chamado main , que o método principal daquela classe, que pode ou não receber argumentos e em caso de erro devolve uma exceção
9.	Criamos a conexão com Apache Hbase, instanciando a classe configuration
Configuration con = HBaseConfiguration.create();
10.	Depois instanciamos a HbaseAdmin para definir como vou trabalhar no Apache Hbase: HBaseAdmin admin = new HBaseAdmin(con);
11.	Instanciamos o table descriptor para criar uma tabela no Hbase que é um banco de dados não relacional: HTableDescriptor tableDescriptor = new HTableDescriptor(TableName.valueOf("RH"));

12.	Feito isso vamos adicionar a família de colunas

      tableDescriptor.addFamily(new HColumnDescriptor("pessoal"));
      tableDescriptor.addFamily(new HColumnDescriptor("profissional"));

13.	O código completo de minha classe vai ser:

15.	Vamos ver que as dependências não estão sendo encontradas por eclipse
pse

