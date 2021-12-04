-- Uvažujeme relační proměnnou result.

DROP TABLE IF EXISTS result CASCADE;


CREATE TABLE result (
  task_no integer NOT NULL,
  field varchar(20) NOT NULL,
  student_name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( task_no, student_name )
);

-- Predikát: Student jménem 'student_name' získal z úkolu číslo 'task_no', které spadá do 'field' oboru, 'score' bodů.


INSERT INTO result ( task_no, field, student_name, score ) VALUES
  ( 1, 'mathematics', 'Anna', 5 ),
  ( 2, 'physics', 'Anna', 2 ),
  ( 3, 'physics', 'Anna', 4 ),
  ( 1, 'mathematics', 'Bert', 1 ),
  ( 3, 'physics', 'Bert', 2),
  ( 1, 'mathematics', 'Cyril', 4),
  ( 2, 'physics', 'Cyril', 3),
  ( 3, 'physics', 'Cyril', 5);


TABLE result;

/*
Tvar agregačního SELECT výrazu:

( SELECT DISTINCT <aggregate_attributes_description> 
  FROM            <input_relations_descriptions> 
  WHERE           <condition>
  GROUP BY        <group_attributes> )

První čtyry kroky probíhají stejně, jako u klasického SELECT výrazu:
1. Získání vstupních relací
2. Přejmenování na vstupní atributy
3. Spojení
4. Restrikce

Pátým krokem je agregace:

Výsledek čtvrtého kroku restrikce si označíme <r>.

Nechť <D1>, ..., <Dn> jsou všechny atributy v <group_attributes>.

Část <aggregate_attributes_description> může obsahovat jak atributy <Di>, tak agregaci tvaru: <f>(<B>) AS <C>.

Nechť <f1>(<B1>) AS <C1>, ..., <fm>(<Bm>) AS <Cm> jsou všechna volání agregačních funkcí v <aggregate_attributes_description>.

Výsledkem pátého kroku je agregace relace <r> rozdělené atributy <D1>, ..., <Dk> na <f1>(<B1>) jako <C1>, ..., <fm>(<Bm>) jako <Cm>.

Šestým krokem je projekce na atributy uvedené v <aggregate_attributes_description> 

Souhrn kroků agregačního SELECT výrazu:
1. Získání vstupních relací
2. Přejmenování na vstupní atributy
3. Spojení
4. Restrikce
5. Agregace
6. Projekce

Klauzule WHERE a GROUP BY jsou nepovinné.

Pokud chybí klauzule GROUP BY uvažuje se rozdělení relace prázdnou množinou atributů.

Absence WHERE klauzule způsobí přeskočení čtvrtého kroku (restrikce). 

Pokud <aggregate_attributes_description> obsahuje všechny atributy z <group_attributes>,
pak můžeme DISTINCT vynechat.
*/


SELECT   field, student_name, 
         sum(score) AS total_score
FROM     result
GROUP BY field, student_name;


SELECT   student_name, 
         sum(score) AS total_score
FROM     result
GROUP BY student_name;

SELECT   student_name, 
         sum(score) AS total_score
FROM     result
WHERE    score > 2
GROUP BY student_name;

SELECT sum(score) AS total_score
FROM   result


