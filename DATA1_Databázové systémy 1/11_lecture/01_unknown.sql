/*
Uvažujeme relační proměnnou child.
*/
DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  PRIMARY KEY (name)
);

-- Predikát: Dítě jménem `name` chodí do školky a je mu `age` let.

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 );

TABLE child;

-- Do školky začne chodit Cyril, ale nevíme, kolik mu je let.


-- Zavedeme novou relační proměnou `known_child_age`:
DROP TABLE IF EXISTS known_child_age;
DROP VIEW IF EXISTS  known_child_age;
CREATE TABLE known_child_age (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  PRIMARY KEY ( name ),
  FOREIGN KEY ( name ) REFERENCES child ( name )
);

-- Predikát: Víme, že dítěti jménem `name` je `age` let.

TABLE known_child_age;
-- Přesuneme znalost věku z relační proměnné child:
INSERT INTO known_child_age ( name, age ) 
SELECT * FROM child;

--  Odebereme atribut age z relační proměnné child:
ALTER TABLE child DROP COLUMN age;
-- Nový predikát relační proměnné child: Dítě jménem `name` chodí do školky.

TABLE child;

-- Přidáme Cyrila do relační proměnné `child`:
INSERT INTO child ( name ) VALUES ( 'Cyril' );

TABLE child;
TABLE known_child_age;

/*
To, že žádná n-tice v relaci child_age nepřiřazuje atributu name hodnotu 'Cyril',
znamená, že nevíme, kolik je Cyrilovi let.
*/

-- U kterých dětí neznáme věk?
( TABLE child ) 
  EXCEPT 
( SELECT name FROM known_child_age);

DROP VIEW IF EXISTS unknown_child_age;
CREATE VIEW unknown_child_age AS 
     ( SELECT * FROM child ) 
       EXCEPT 
     ( SELECT name FROM known_child_age);

-- Predikát: Nevímke, kolik je dítěti jménem `name` let.

TABLE unknown_child_age;

-- Zapomeneme, kolik je Anně let:
DELETE FROM known_child_age WHERE name = 'Anna';

TABLE known_child_age;
TABLE unknown_child_age;
