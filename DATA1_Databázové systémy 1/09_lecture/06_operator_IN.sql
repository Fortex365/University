-- Uvažujeme relační proměnné result a student.

DROP TABLE IF EXISTS result CASCADE;

DROP TABLE IF EXISTS student CASCADE;

CREATE TABLE result (
  name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( name )
);

-- Predikát: Student jménem 'name' získal 'score' bodů. 

CREATE TABLE student (
  name varchar(10) NOT NULL,
  street varchar(10) NOT NULL,
  PRIMARY KEY ( name )
);

-- Predikát: Student jménem 'name' bydlí v ulici 'street'. 


INSERT INTO result ( name, score ) VALUES
  ( 'Anna', 5 ),
  ( 'Bert', 2 ),
  ( 'Cyril', 4 ),
  ( 'Daniela', 5 );

INSERT INTO student ( name, street ) VALUES
  ( 'Anna', 'Kosinova' ),
  ( 'Bert', 'Fibichova' ),
  ( 'Cyril', 'Fibichova' ),
  ( 'Daniela', 'Kosinova' );


-- Chceme získat výsledky studentů, kteří bydlí v ulici Kosinova.

/*
Podmínka:
( <scalar_expression> IN <relation_expression> ) 

<scalar_expression> je skalární výraz
<relation_expression> je unární relační výraz (arity jedna)

Typ <scalar_expression> musí být stejný jako typ jediného atributu v <scalar_expression>.
*/

SELECT * 
FROM result 
WHERE name IN ( 
  SELECT name FROM student WHERE street = 'Kosinova' 
); 

-- Lepší zápis:

SELECT result.name, result.score 
FROM result, student 
WHERE result.name = student.name 
AND student.street = 'Kosinova';

