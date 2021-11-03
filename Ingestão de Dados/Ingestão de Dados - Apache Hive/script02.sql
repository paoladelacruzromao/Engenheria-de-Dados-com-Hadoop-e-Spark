create table temp_colab (texto String);

LOAD DATA LOCAL INPATH '/home/hadoop/colaboradores.csv' OVERWRITE INTO TABLE temp_colab;

SELECT * FROM temp_colab;

INSERT overwrite table colaboradores 
SELECT  
  
  regexp_extract(texto, '^(?:([^,]*),?){1}', 1) ID,  
  regexp_extract(texto, '^(?:([^,]*),?){2}', 1) nome,  
  regexp_extract(texto, '^(?:([^,]*),?){3}', 1) cargo,
  regexp_extract(texto, '^(?:([^,]*),?){4}', 1) salario,  
  regexp_extract(texto, '^(?:([^,]*),?){5}', 1) cidade

FROM temp_colab;


SELECT * FROM colaboradores;

SELECT * FROM colaboradores WHERE Id = 1002;

SELECT * FROM colaboradores WHERE salario >= 25000;

SELECT * FROM colaboradores WHERE salario > 10000 AND cidade = 'Natal';

SELECT sum(salario), cidade FROM colaboradores GROUP BY cidade;





