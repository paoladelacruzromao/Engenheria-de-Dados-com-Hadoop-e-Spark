import sys

from pyspark import  SparkContext, SparkConf



if __name__ == "__main__":

	# Criar Spark Context


	sc.stop()
	conf = SparkConf().setMaster("spark://192.168.0.81:7077").setAppName("Conta Palavras"))
	sc2 = SparkContext(conf = conf)
	
	#conf = SparkConf().setAppName("Conta Palavras").setMaster("spark://192.168.0.81:7077")

	#sc = SparkContext(conf = conf)



	#Carregar arquivos. Textfile cria um RDD, onde posso fazer transformações(gera outro RDD) e ações

	palavras = sc2.textFile("/users/paola/input.txt").flatMap(lambda line: line.split(" "))



	#Contagem - Mapreduce

	contagem = palavras.map(lambda palavra: (palavra, 1)).reduceByKey( lambda a,b: a+b )



	#Salvar o resultado

	contagem.saveAsTextFile("users/paola/saida1")







