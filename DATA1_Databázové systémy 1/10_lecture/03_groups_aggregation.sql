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
Vezmeme relaci <r> nad <A1>, ..., <An>.

Vybereme atributy <D1>, ..., <Dk> ze záhlaví relace <r>.

Relace <s> nad <A1>, ..., <Ak> se nazývá skupina rozdělená atributy <D1>, ..., <Dk>, pokud
1) <s> je neprázdná relace
2) existuje podmínka <c> tvaru <D1> = <v1> AND ... AND <Dk> = <vk> taková, 
   že relace <s> je restrikce relace <r> vzhledem k podmínce <c>.

Pokud <s> je skupina rozdělená atributy <D1>, ..., <Dk>, pak říkáme, 
že podmínka <c> z předchozí definice určuje skupinu <s>.
*/

-- Například podmínka student_name = 'Anna' určuje skupinu rozdělenou atributem student_name:
SELECT *
FROM result
WHERE student_name = 'Anna';


-- Také podmínka student_name = 'Anna' AND field = 'mathematics' určuje skupinu rozdělenou atributy student_name a field:
SELECT *
FROM result
WHERE student_name = 'Anna' AND field = 'mathematics';

-- Ale podmínka task_no = 2 AND student_name = 'Bert' skupinu rozdělenou atributy task_no a student_name neurčuje:
SELECT *
FROM result
WHERE task_no = 2 AND student_name = 'Bert';


-- Skupina rozdělená atributem student_name:
SELECT *
FROM result
WHERE student_name = 'Anna';

-- Jiná skupina rozdělená atributem student_name:
SELECT *
FROM result
WHERE student_name = 'Bert';

/*
Rozdělení relace <r> atributy <D1>, ..., <Dk> je množina všech skupin rozdělených atributy <D1>, ..., <Dk>.
*/

/*
Například rozdělením relace result atributem student_name dostáváme tři skupiny:
*/

SELECT *
FROM result
WHERE student_name = 'Anna';

SELECT *
FROM result
WHERE student_name = 'Bert';

SELECT *
FROM result
WHERE student_name = 'Cyril';

/*
Rozdělením relace result atributy student_name a field dostáváme šest skupin:
*/

SELECT *
FROM result
WHERE student_name = 'Anna' AND field = 'mathematics';

SELECT *
FROM result
WHERE student_name = 'Anna' AND field = 'physics';

SELECT *
FROM result
WHERE student_name = 'Bert' AND field = 'mathematics';

SELECT *
FROM result
WHERE student_name = 'Bert' AND field = 'physics';

SELECT *
FROM result
WHERE student_name = 'Cyril' AND field = 'mathematics';

SELECT *
FROM result
WHERE student_name = 'Cyril' AND field = 'physics';

/*
Rozšíříme relační operaci agregace.

Vezmeme relaci <r> nad atributy <A1>, ..., <An>.

Vybereme atributy <D1>, ..., <Dk> ze záhlaví relace <r>.

Zvolíme agregační funkce <f1>, ..., <fm>,
atributy <B1>, ..., <Bm> za záhlaví relace <r> (ne nutně různé) nebo hvězdičky (*) a
po dvou různé atributy <C1>, ..., <Cm>.

Agregace relace <r> rozdělené atributy <D1>, ..., <Dk> na <f1>(<B1>) jako <C1>, ..., <fm>(<Bm>) jako <Cm> 
je relace <s> nad atributy <D1>, ..., <Dk>, <C1>, ..., <Cm>.

Vezmeme libovolnou n-tici <t> nad atributy <D1>, ..., <Dk>, <C1>, ..., <Cm>.

Pak n-tice <t> náleží do těla <s>, 
pokud existuje skupina <s> určená podmínkou <D1> = <v1> AND ... AND <Dn> = <vn> taková, že

1) <t> přiřazuje atributu <Di> hodnotu <vi> (pro 1 <= i <= k)
2) <t> přiřazuje atributu <Ci> výsledek agregační funkce <fi> volané na <Bi> vzhledem k relaci <s> (pro 1 <= i <= m).


Relace <s> má takovou kardinalitu, kolik je skupin rozdělených atributy <D1>, ..., <Dk>.

Výraz agregace:

Vezmeme relační výraz <v> typu <A1>, ..., <An>.
Označíme hodnotu relačního výrazu <v> jako <r>.
Nechť <D1>, ..., <Dk> jsou všechny atributy v záhlaví relace <r>.

Zvolíme agregační funkce <f1>, ..., <fm>, 
atributy <B1>, ..., <Bm> za záhlaví relace r (ne nutně různé) nebo hvězdičky (*),
po dvou různé atributy <C1>, ..., <Cm> a
název relace <R>.

Relační výraz:

( SELECT   <D1>, ..., <Dk>, 
           <f1>(<B1>) AS <C1>, ..., <fm>(<Bm>) AS <Cm> 
  FROM     <v> AS <R>
  GROUP BY <D1>, ..., <Dk> )

Hodnotou relačního výrazu je agregace relace <r> rozdělené atributy <D1>, ..., <Dk> na <f1>(<B1>) jako <C1>, ..., <fm>(<Bm>) jako <Cm>.
*/

SELECT   student_name, 
         max(score) AS max_score
FROM   ( TABLE result ) AS t
GROUP BY student_name;


SELECT   field, student_name, 
         sum(score) AS field_score
FROM   ( TABLE result ) AS t
GROUP BY field, student_name;

SELECT   student_name, 
         sum(score) AS total_score
FROM   ( TABLE result ) AS t
GROUP BY student_name;


/*
Pokud uvažujeme agregaci rozdělenou prázdnou množinou atributů, pak dostaneme předchozí typ agregace celé relace.

Pro relaci <r> určuje podmínka true jedinou skupinu a to opět <r>.

Rozdělení relace <r> prázdnou množinou atributů získáváme jednoprvkovou množinu obsahující pouze <r>.
*/