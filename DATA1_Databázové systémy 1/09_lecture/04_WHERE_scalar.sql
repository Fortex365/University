/*
Klauzule WHERE výrazu SELECT má tvar:

WHERE <condition>

kde <condition> je skalární výraz typu boolean.
*/

-- Uvažujeme relační proměnnou results.

DROP TABLE IF EXISTS results CASCADE;

CREATE TABLE results (
  student_name varchar(10) NOT NULL,
  mathematics integer NOT NULL,
  informatics integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal z testu z matematiky 'mathematics' bodů a z testu z informatiky 'informatics' bodů.

INSERT INTO results ( student_name, mathematics, informatics ) VALUES
  ( 'Anna', 2, 3 ),
  ( 'Bert', 0, 1 ),
  ( 'Cyril', 5, 4 );

TABLE results;

SELECT student_name FROM results WHERE mathematics + informatics > 4;