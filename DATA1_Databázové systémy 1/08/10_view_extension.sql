-- Uvažujeme relační proměnnou results.

DROP TABLE IF EXISTS results CASCADE;

CREATE TABLE results (
  student_name varchar(10) NOT NULL,
  mathematics integer NOT NULL,
  informatics integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal z testu z matematiky 'mathematics' bodů a z testu z informatiky 'informatics' bodů.

INSERT INTO results ( student_name, mathematics, informatics) VALUES
  ( 'Anna', 2, 3 ),
  ( 'Bert', 0, 1 ),
  ( 'Cyril', 5, 4 );

TABLE results;

/*
Rozšíření aktualizovatelné relační proměnné je aktualizovatelné.
*/
DROP VIEW results_total;

CREATE VIEW results_total  AS SELECT *, mathematics + informatics AS total FROM results AS t1;

TABLE results_total;

/*
Nemůžeme však aktualizovat všechny atributy.
*/

-- Ano:
UPDATE results_total SET mathematics = 1 WHERE student_name = 'Bert'; 

-- Ne:
UPDATE results_total SET total = 3 WHERE student_name = 'Bert'; 

/*
Aktualizovatelné relační proměnné můžou mít aktualizovatelné jen některé atributy.

Všechny atributy základní proměnné jsou aktualizovatelné.

Aktualizovatelná virtuální proměnná je definováva SELECT výrazem.

Atribut aktualizovatelné virtuální relační proměnné je aktualizovatelný, 
pokud je definovaný skalárním výrazem tvořeným pouze aktualizovatelným atributem.

Tedy virtuální relační proměnná má aktualizovatelné pouze atributy:
- student_name, mathematics, informatics

Připomeňme, že hvězdička ve výrazu:

SELECT *, mathematics + informatics AS total FROM results AS t1

je zkratkou za:

student_name, mathematics, informatics
*/

DROP TABLE IF EXISTS task_result CASCADE;

CREATE TABLE task_result (
  student_name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal z testu 'score' bodů.

INSERT INTO task_result ( student_name, score ) VALUES
  ( 'Anna', 2 ),
  ( 'Bert', 0 ),
  ( 'Cyril', 5 );

TABLE task_result;

DROP VIEW IF EXISTS task_result2;

CREATE VIEW task_result2 AS SELECT *, score + 1 AS score_succ FROM task_result;

TABLE task_result2;

-- Nelze:
UPDATE task_result2 SET score_succ = score_succ - 1;  

-- Atribut score_succ není aktualizovatelný.