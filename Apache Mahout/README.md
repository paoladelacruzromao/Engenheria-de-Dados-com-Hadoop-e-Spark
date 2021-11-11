

# APACHE MAHOUT
E uma biblioteca open source, que permite a execução de modelos de machine learning em dados armazenados no HDFS. O nome Mahout significa o homem que domina ao elefante.
 
## Algoritmos:
O Apache Mahout suporta diferentes tipos de algoritmos. Se tenho os dados em uma soa máquina podemos usar algoritmos sequenciais como por exemplo regressão logística, quando os dados estão distribuídos em diferentes máquinas usamos algoritmos paralelos como random forest e Naive Bayes para aprendizagem supervisionados e K-means para aprendizagem não supervisionados
 
## Apache Mahout e outros frameworks de ML
Existem outras ferramentas como R, Scikit Learn, Tensorflow, Rapidminer, etc.
Então porque usar Apache Mahout, é por um simple motivo nenhum desses frameworks vai poder manipular em forma interativa grandes volumes de dados. Ele funciona sobre o cluster hadoop de forma distribuída. Ele ainda tem uma excelente interação com apache spark 
## Características do Apache Mahout
1.	Os algoritmos do Mahout são construídos para funcionar sobre o Hadoop e dessa forma eles funcionam em um ambiente distribuído.
2.	O framework Mahout está pronto para uso e permite realizar mineração de dados em grandes conjuntos de dados.
3.	O Mahout e eficiente nas análises de grandes conjuntos de dados.
4.	Possui diferentes opções de clustering (aprendizagem não superficionada):K-means, Cluzzy K-means, Canopy e Mean-Shift. Esses algoritmos são utilizados para agrupamento de dados e busca de padrões.
5.	Suporta a execução do algoritmo de Naive Bayes de forma distribuída (como projetos de fraudes, spans, etc) 
6.	Inclui bibliotecas para vectores e matrizes
## Instalação e configuração do Apache Mahout
1.	Procurar em https://mahout.apache.org, downloads procurar pela versão clica em downloads Latest versions e vamos usar a versão 0.13.0 -> https://downloads.apache.org/mahout/0.13.0/apache-mahout-distribution-0.13.0.tar.gz e copia o link.
2.	Ir para o diretório de downloads no terminal e baixar o arquivo o dar um wget para baixar o arquivo pelo terminal.
cd Downloads/
wget  https://downloads.apache.org/mahout/0.13.0/apache-mahout-distribution-0.13.0.tar.gz
3.	Descompactar o arquivo:
tar -xvf  apache-mahout-distribution-0.13.0.tar.gz

4.	Vamos mover o Mahout para o diretório padrão /opt/mahoud, e depois verificar que o proprietário do arquivo e o usuário hadoop.
       sudo mv apache-mahout-distribution-0.13.0 /opt/mahoud
[ingresse o password]
5.	Vamos a raiz do sistema para configurar as variáveis de ambiente
cd ~
gedit .bashrc

#Mahout
export MAHOUT_HOME=/opt/mahout
export PATH=$PATH:$MAHOUT_HOME/bin

source .bashrc

6.	Para testar digita mahout
mahout
