-- Uvažujeme relační proměnnou result.

DROP TABLE IF EXISTS result CASCADE;

CREATE TABLE result (
  student_name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal 'score' bodů. 

INSERT INTO result ( student_name, score ) VALUES
  ( 'Anna', 5 ),
  ( 'Bert', 2 ),
  ( 'Cyril', 4 ),
  ( 'Daniela', 5 );

-- Chceme získat množinu studentů, kteří mají stejně bodů jako Anna.

/*
Počet atributů v záhlaví relace se nazývá arita relace.

Relace s aritou jedna se nazývají unární, s aritou dva binární, ...

Relace, která má aritu a kardinalitu jedna, se nazývá singleton.

Tělo singletonu obsahuje jedinou n-tici.

Záhlaví singletonu obsahuje jediný atribut. 

Singleton lze ztotožnit s jedinou hodnotou, kterou obsahuje. 
*/

-- Singleton 1:
SELECT * FROM ( VALUES ( 1 ) ) AS R ( result );

-- Singleton 1:
SELECT 1 AS result;

/*
Relační výraz, jehož hodnota je singleton, je skalárním výrazem.
*/

SELECT 1 + ( SELECT 1 AS result ) AS result;

-- Chyba: Hodnota relačního výrazu má kardinalitu dva:
SELECT 1 + ( SELECT * FROM ( VALUES ( 1 ), ( 2 ) ) AS R ( result )) AS result;


-- Chyba: Hodnota relačního výrazu má aritu dva:
SELECT 1 + ( SELECT * FROM ( VALUES ( 1 ,  2 ) ) AS R ( r1, r2 )) AS result;

-- Studenti, kteří získali stejně bodů jako Anna:
SELECT student_name 
FROM   result 
WHERE  score = ( 
  SELECT score FROM result WHERE student_name = 'Anna' 
);

-- Lepší zápis:
SELECT result1.student_name 
FROM result AS result1, result AS result2 
WHERE result1.score = result2.score
AND result2.student_name = 'Anna'; 