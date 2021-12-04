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
Uvažujme výraz:
*/

SELECT   student_name, sum(score) AS total_score
FROM     result
GROUP BY student_name;

/*
Vyřazení některých agregovaných výsledků:
*/

SELECT * 
FROM (
  SELECT   student_name, sum(score) AS total_score
  FROM     result
  GROUP BY student_name
     ) AS t
WHERE total_score > 5;


/*
Rozšíříme agregační SELECT výraz:

( SELECT DISTINCT <aggregate_attributes_description> 
  FROM            <input_relations_descriptions> 
  WHERE           <condition>
  GROUP BY        <group_attributes>
  HAVING          <group_condition> )

Klauzule HAVING je nepovinná a 
může být zařazena pouze za klauzulí GROUP BY.

Kroky vyhodnocení agregačního SELECT výrazu:
1. Získání vstupních relací
2. Přejmenování na vstupní atributy
3. Spojení
4. Restrikce
5. Vytvoření skupin podle <group_attributes>
6. Vyřazení skupin nesplňujících podmínku: <group_attributes>
7. Vyhodnocení agregačních výrazů


Podmínka <group_condition> může být tvořena pouze nad agregačními výrazy.

Krok 5. - 7. obcházejí relační přístup. Abychom zůstali v relačním přístupu
potřebovali bychom, aby hodnoty v relaci mohly být opět relace. Viz část o slučování. To však SQL neumožňuje.

Pokud by databázový systém umožňoval slučování, 
pak by pátý krok byl slučování, 
šestý restrikce sloučené relace a
konečně v šestém kroku by se počítaly agregace relací v sloučených atributech.
*/

SELECT   student_name, 
         sum(score) AS total_score
FROM     result
GROUP BY student_name
HAVING   sum(score) > 5;


SELECT   student_name, 
         sum(score) AS total_score
FROM     result
WHERE    score > 3
GROUP BY student_name
HAVING   sum(score) > 5;