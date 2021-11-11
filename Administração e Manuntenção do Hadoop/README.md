# Administração e configuração de um cluster Hadoop
## Desafios na gestão de um cluster hadoop

![image](https://user-images.githubusercontent.com/87387315/141306999-d4707676-6cd1-4552-97de-4498a434ebf3.png)

1.	Falta de gestão de configuração: deve existir um processo de gestão de boas práticas para que a gestão do cluster hadoop não se torne inadministrável
2.	Baixa locação de recursos: não por ter um cluster vamos renunciar a boas máquinas e alocação de memória para ter um bom processamento e ambiente de armazenamento.
3.	Gargalhos de rede: o administrador de rede tem que estar envolvido na gestão da rede para evitar problemas de performance e falhas no cluster como timeout, tempo de espera do processamento, tempo de espera de buscar os blocos etc.
4.	Falta de métricas de monitoramento: A documentação do Apache hadoop oferece um direcionamento para administrar estas métricas
5.	Medidas drásticas para problemas simples: como formatar o namenode o reconstruir o cluster, a utilização do secondary namenode poderia resolver este problema.
6.	Pontos únicos de falha o cluster hadoop pode possuir muitos pontos únicos de falha que podem comprometer o cluster e os dados.
7.	Utilização dos valores default para os parâmetros: se você mante os valores default você não está customizando o hadoop as necessidades de sua empresa.
8.	Falta de professionais qualificados: Aprender a trabalhar eficientemente com hadoop requere grandes conhecimentos do sistema operacional.

##  Namenode e Estrutura de Diretórios
 
![image](https://user-images.githubusercontent.com/87387315/141307028-38869158-2a6e-4b51-96a7-e7f9da2f533b.png)
 
Name node vai gravando pequenas alterações em edit logs, com o tempo o edit logs fica muito grande pelo que temos que gravar no fsimage essa é a função do secondary Namenode, mantendo assim toda a consistência dos dados.
![image](https://user-images.githubusercontent.com/87387315/141307072-4c1f1f1a-2100-4525-9420-76875c2fa55e.png)

O hadoop permite que se informe detalhes sobre a topologia da rede em que o cluster está configurado para ter uma melhor distribuição. Verificar que estão em racks diferentes para não impactar nosso trabalho em caso de falhas.

## Namenode
Onde fica o parâmetro de configuração do Namenode em nossa máquina
Os de hadoop estão:
```sh
cd  opt/hadoop/etc/hadoop/
ls -la

//Nesse arquivo temos o diretório apontando ao localhost do hdfs
cat core-site.xml

```
E onde estão os parâmetros do diretório, veja que temos dfs.namenode.name.dir apontando para o diretório opt/hadoop/dfs/namespace_logs. E o diretório dfs.datanode.data.dir. O secondary namenode não esta aqui porque o hadoop por default leva no diretório temporário cd /tmp/hadoop-hadoop/dfs/namesecondary

```sh
cd  opt/hadoop/etc/hadoop/
cat  hdfs-site.xml
```
Vamos configurar o parâmetro do secondary namenode, para saber qual o parâmetro vai na documentação hadoop.apache.org : https://hadoop.apache.org/docs/r3.2.2/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
```sh
cd  opt/hadoop/etc/hadoop/
gedit  hdfs-site.xml
```
Mudar o arquivo com:
```sh
<property>
      <name>dfs.namenode.checkpoint.dir</name>
      <value>/opt/hadoop/dfs/namesecondary</value>
</property>
```
Adicionar esse diretório
```sh
 cd >/opt/hadoop/dfs/
mkdir namesecondary
cd ~
```
Lembrando precisamos parar e inicializar novamente hadoop para pode fazer a leitura do parâmetro 
```sh
stop-yarn.sh
stop-dfs.sh
start-yarn.sh
start-dfs.sh
```
Agora vamos entrar em /opt/hadoop/dfs/namespace_logs, vai ver que tem um arquivo in_use.lock , isso que decir que nosso cluster esta em uso, pelo que temos que ter cuidado em manipular os arquivos para não corromper eles. Em current veja que temos vários edit logs e fsimage no disco. Hadoop leio o arquivo fsimage e cargo na memoria do computador, esse arquivo contém os metadados, ele sabe que datanode corresponde para que bloco, quantos blocos eu tenho para cada bloco. O tamanho padrão do bloco é de 128 megas. 
À medida que vamos trabalhando modificações são feitas essas pequenas modificações são gravadas em edit logs. De tempo em tempo o secondary namenode vai gravando no fsimage de tempo em tempo. Você não pode editar esses arquivos se não corrompe seu cluster.
```sh
cd current
```
##  A importância do secondary namenode
Com ele podemos reconstruir o namenode, mas não substitui o namenode. O secondary namenode é o processo responsável por sincronizar os arquivos edit logs com a imagem do fsimage, para gerar um fsimage maia atualizado. Em clusters com diferentes máquinas e recomendável manter o secondary namenode em uma máquina exclusiva, diferente da máquina onde esta o namenode. Então não podemos afirmar que o secondary namenode é um backup do namenode.

## Datanode e estrutura de diretórios
E o responsável por armazenar blocos de dados usados pelos usuários. Cada datanode se comunica com outros datanodes para fazer a replicação de seus dados. Cada bloco tem 128 megas é tem 3 replicas para cada bloco.

Os datanodes não precisam ser formatados assim como fazemos com os namenode, eles criam seu diretório no storage automaticamente na inicialização.
A estrutura do Datanode é similar a do namenode com um arquivo chamado version, com informações sobre o servidor é os arquivos binários 
Não se usa RAID de discos para fazer copias de seguranças dos blocos. O RAID e uma forma de ter redundância de disco, você tem um HD e você tem um segundo HD para espelhamento. Em um ambiente hadoop não preciso de RAID porque eu tenho 3 replicas de cada bloco, não faz sentido aplicar raid, porque arquitetura hadoop e preparada para tolerância a falhas.
 
![image](https://user-images.githubusercontent.com/87387315/141307146-65b044db-87b2-4415-9346-ede42bb5c3b2.png)

## Metadados de sistema de arquivos
**Metadados** são informações gerais sobre o cluster e sobre os dados. São dados sobre os dados, nos permitem buscar informações sobre os dados.
Atenção não intente modificar diretórios ou arquivos de metadados, porque pode causar a interrupção do HDFS ou até mesmo a perda de dados de forma permanente. O backup de dados é uma tarefa crítica em um cluster hadoop.

![image](https://user-images.githubusercontent.com/87387315/141307234-6754e7b5-e975-40e7-b5de-65d41a9c92b3.png)
 
Exemplo de como os dados estão estruturados: O checkpoint garante poder recuperar os dados ate ultimo checkpoint.

 ![image](https://user-images.githubusercontent.com/87387315/141307261-c7ad67ed-3d06-435e-b1ad-bb73ce04f22b.png)

## Procedimento de checkpoint
O Namenode lei os metadados do fsimage(formato próprio para leitura) e grava os metadados em no editlog. O Namenode registra operação de modificação no editlog. 
Dessa forma em caso de falha do namenode ele poderá restaurar seu estado, carregando fsimage e enseguida repetindo todas as operações do edit log.

