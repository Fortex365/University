-- Uvažujeme relační proměnnou result.

DROP TABLE IF EXISTS result CASCADE;

CREATE TABLE result (
  name varchar(10) NOT NULL,
  task varchar(20) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( name, task )
);

-- Predikát: Student jménem 'name' získal 'score' bodů z úkolu 'task'. 

INSERT INTO result ( name, task, score ) VALUES
  ( 'Anna', 'mathematics', 5 ),
  ( 'Anna', 'physics', 2 ),
  ( 'Bert', 'physics', 1 ),
  ( 'Bert', 'mathematics', 2 ),
  ( 'Cyril', 'mathematics', 4 ),
  ( 'Cyril', 'physics', 6 ),
  ( 'Daniel', 'physics', 2),
  ( 'Eduard', 'mathematics', 4);

TABLE result;

/*
Agregační funkce.

Je dána relace <r>.

Agregační funkce očekává atribut <A> ze záhlaví <r> nebo hvězdičku (*).

Výsledek agregační funkce je jedna hodnota skalárního typu vypočítaná z relace <r> za použití hodnot,
které n-tice v těle <r> přiřazují atributu <A>, nebo za použití n-tic v těle <r> (v případě hvězdičky).

Zápis volání agregační funkce <f> je následující:

f(A) nebo f(*)

Například count je agregační funkce, která vrací kardinalitu relace. Volání:

count(*)

Agregační funkce max a min pro atribut <A> vrací maximální a minimální hodnotu,
kterou n-tice těla <r> přiřazují atributu <A>.

Příklady volání:

max(score)
min(score)

Konečně součet hodnot přiřazených zadanému atributu získáme voláním:

sum(score)

*/


/*
Nová operace relační algebry: agregace


r: relace nad A1, ..., An
f1, ..., fm: agregační funkce
B1, ..., Bm: atributy za záhlaví relace r (ne nutně různé) nebo hvězdičky (*)
C1, ..., Cm: po dvou různé atributy

Agregace relace <r> na f1(B1) jako C1, ..., fm(Bm) jako Cm je relace <s> nad C1, ..., Cm.

Relace <s> má kardinalitu jedna. Jediná n-tice v těle <s> přiřazuje atributu <Ci> (1 <= i <= m) výsledek agregační 
funkce <fi> na <Bi> vzhledem k relaci <r>.

Výraz agregace:

v: relační výraz typu A1, ..., An
r: hodnota relačního výrazu <v>
f1, ..., fm: agregační funkce
B1, ..., Bm: atributy za záhlaví relace <r> (ne nutně různé) nebo hvězdičky (*)
C1, ..., Cm: po dvou různé atributy

Relační výraz:

( SELECT f1(B1) AS C1, ..., fm(Bm) AS Cm FROM v )

Hodnotou relačního výrazu je agregace relace <r> na f1(B1) jako C1, ..., fm(Bm) jako Cm.
*/

-- Kardinalita relace:
SELECT count(*) AS count 
FROM ( TABLE result ) AS t;

-- Počet výsledků z fyziky:
SELECT count(*) AS count 
FROM ( SELECT * FROM result WHERE task = 'physics' ) AS t;

-- Maximální skóre z testu:
SELECT max(score) AS max_score
FROM ( TABLE result ) AS t;

-- Maximální skóre z testu z matematiky:
SELECT max(score) AS max_score
FROM  ( SELECT * FROM result WHERE task = 'mathematics' ) AS t;

-- Maximální a minimální počet bodů z fyziky:
SELECT max(score) AS max_score, min(score) AS min_score
FROM ( SELECT * FROM result WHERE task = 'physics' ) AS t;

-- Součet všech bodů, které obdržela Anna:
SELECT sum(score) AS total_score
FROM ( SELECT * FROM result WHERE name = 'Anna') AS t;

-- Kdo získal nejvíce bodů?
SELECT name 
FROM   result
WHERE  score = ( 
  SELECT max(score) FROM ( TABLE result ) AS t
);