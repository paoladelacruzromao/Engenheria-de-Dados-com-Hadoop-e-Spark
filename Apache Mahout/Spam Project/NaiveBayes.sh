# Ciação do Modelo Preditivo com Naive Bayes

# Criar pastas no HDFS
hdfs dfs -mkdir /mahout
hdfs dfs -mkdir /mahout/input
hdfs dfs -mkdir /mahout/input/ham
hdfs dfs -mkdir /mahout/input/spam

# Copiando dados do filesystem local para o HDFS
hdfs dfs -copyFromLocal ham/* /mahout/input/ham
hdfs dfs -copyFromLocal spam/* /mahout/input/spam

# Converte os dados para uma sequence (obrigatório quando se trabalha com Mahout)
mahout seqdirectory -i /mahout/input -o /mahout/output/seqoutput

# Converte a sequence em vetores TF-IDF 
mahout seq2sparse -i /mahout/output/seqoutput -o /mahout/output/sparseoutput

# Visualiza a saída
hdfs dfs -ls /mahout/output/sparseoutput

# Split dos dados em treino e teste
#	-i	                    pasta com dados de entrada
#	--trainingOutput	    dados de treino
#	--testOutput		    dados de teste
#	--randomSelectionPct	percentual de divisão dos dados
#	--overwrite			    overwrite
#	--sequenceFiles		    input sequencial
#	--xm				    tipo de processamento. 
mahout split -i /mahout/output/sparseoutput/tfidf-vectors --trainingOutput /mahout/nbTrain --testOutput /mahout/nbTest --randomSelectionPct 30 --overwrite --sequenceFiles -xm sequencial

# Construção do Modelo Preditivo
#	-i	dados de treino
#	-li onde armazenar os labels
#	-o	onde armazenar o modelo
#	-ow	overwrite
#	-c	complementary
mahout trainnb -i /mahout/nbTrain -li /mahout/nbLabels -o /mahout/nbmodel -ow -c

# Teste do Modelo
#	-i  pasta com os dados de teste
#	-m	pasta do modelo
#	-l	labels 
#	-ow	overwrite
#	-o	pasta com as previsões
#	-c	complementary 
mahout testnb -i /mahout/nbTest -m /mahout/nbmodel -l /mahout/nbLabels -ow -o /mahout/nbpredictions -c




