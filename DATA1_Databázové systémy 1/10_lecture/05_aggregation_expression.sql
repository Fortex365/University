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
Agregační výrazy

Zvolíme atributy <A1>, ..., <An>.
Vybereme atributy <B1>, ..., <Bm> z <A1>, ..., <An>

<B1>, ..., <Bm> jsou atributy, podle kterých rozdělujeme relaci.

Každý z atributů <Bi> je agregační výraz.

Pokud <f> je agregační funkce a <Ai> atribut nebo hvězdička, pak

f(Ai) nebo f(*)

je agregační výraz. 

Každý literál je agregační výraz.

Agregační výrazy můžeme vytvářet pomocí operátorů a volání funkcí
podobně jako skalární výrazy.


Agregační SELECT výraz:

( SELECT DISTINCT <aggregate_attributes_description> 
  FROM            <input_relations_descriptions> 
  WHERE           <condition>
  GROUP BY        <group_attributes> )

<aggregate_attributes_description> obsahuje popisy agregovaných atributů.

Popis agregovaného atributu má tvar:

<v> AS <A>

kde <v> je agregační výraz a <A> je název atributu.


Vyhodnocení agregačního SELECT výrazu můžeme obecně pospsat kroky:
1. Získání vstupních relací
2. Přejmenování na vstupní atributy
3. Spojení
4. Restrikce
5. Vyhodnocení agregačních výrazů
*/


SELECT   student_name AS student, 
         max(score) + min(score) AS min_max_sum
FROM     result
GROUP BY student_name;


/*
Virtuální proměnná proměnná definovaná agregačním SELECT výrazem není aktualizovatelná.
*/

DROP VIEW IF EXISTS student_max_score;

CREATE VIEW student_max_score AS SELECT    student_name, 
                                           max(score)AS max_score
                                  FROM     result
                                  GROUP BY student_name;


TABLE student_max_score;

/*
Relační proměnná student_max_score není aktualizovatelná.

Nezle například:
*/
UPDATE student_max_score 
SET    student_name = 'Daniel' 
WHERE  student_name = 'Cyril';