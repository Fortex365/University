/*
Znalost:

Víme, že Anně jsou tři roky, Bertovi čtyři a Cyrilovi tři nebo čtyři. 
*/

-- Jména dětí dáme do relační proměnné child:
DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem `name` chodí do školky.

INSERT INTO child ( name ) VALUES
  ( 'Anna' ),
  ( 'Bert' ),
  ( 'Cyril' );

TABLE child;

-- Znalost o věku dáme do relační proměnné possible_child_age:

DROP TABLE IF EXISTS possible_child_age CASCADE;
DROP VIEW IF EXISTS possible_child_age CASCADE;

CREATE TABLE possible_child_age (
  name varchar(10) NOT NULL,
  age integer NOT NULL, 
  PRIMARY KEY ( name, age ),
  FOREIGN KEY ( name ) REFERENCES child ( name )
);

-- Predikát: Je možné, že dítě jménem `name` má `age` let.

INSERT INTO possible_child_age ( name, age ) VALUES 
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 3 ),
  ( 'Cyril', 4 );

TABLE possible_child_age;

-- Anně jsou tři roky:
SELECT * FROM possible_child_age WHERE name = 'Anna';

-- Cyrilovi může být tři nebo čtyři:
SELECT * FROM possible_child_age WHERE name = 'Cyril';

-- U koho známe věk přesně:
SELECT   name
FROM     possible_child_age 
GROUP BY name 
HAVING   count(*) = 1;

DROP VIEW IF EXISTS known_child_age_name;

CREATE VIEW known_child_age_name 
AS     SELECT      name
       FROM        possible_child_age 
       GROUP BY    name 
       HAVING      count(*) = 1; 

-- Predikát: Víme, kolik je dítěti jménem `name` let.

TABLE known_child_age_name;

-- Známé věky dětí:
SELECT possible.name, possible.age
FROM known_child_age_name AS known, possible_child_age AS possible
WHERE known.name = possible.name;

DROP TABLE IF EXISTS known_child_age CASCADE; 
DROP VIEW IF EXISTS known_child_age;

CREATE VIEW known_child_age 
AS     SELECT possible.name, possible.age
       FROM   known_child_age_name AS known, 
              possible_child_age AS possible
       WHERE  known.name = possible.name;

-- Predikát: Víme, že jménem `name` je `age` let.

TABLE known_child_age;

-- U koho věk přesně neznáme?
( SELECT   DISTINCT name
  FROM     possible_child_age )
  EXCEPT
( TABLE known_child_age_name );


DROP VIEW IF EXISTS unknown_child_age;

CREATE VIEW unknown_child_age AS
          ( SELECT DISTINCT name
            FROM possible_child_age )
            EXCEPT
          ( TABLE known_child_age_name );
-- Predikát: Nevíme přesně, kolik je dítěti `name` let.

TABLE unknown_child_age;

-- Zjistíme, že Cyrilovi nejsou tři:
DELETE FROM possible_child_age 
WHERE  name = 'Cyril' 
AND    age = 3;

TABLE possible_child_age;
TABLE known_child_age;
TABLE unknown_child_age;