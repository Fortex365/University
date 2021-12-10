/*
Víme, že Anně jsou tři roky. 
Nevíme, kolik je Bertovi a Cyrilovi. 
Každému z nich můžou být tři nebo čtyři roky.
Víme, že Cyril je starší než Bert.
*/

-- Jména dětí dáme do relační proměnné `child`:
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


/*
Máme tři možné světy:
 - Bertovi i Cyrilovi jsou tři roky.
 - Bertovi jsou tři a Cyrilovi jsou čtyři roky.
 - Bertovi i Cyrilovi jsou čtyři roky.
*/

DROP TABLE IF EXISTS world CASCADE;

CREATE TABLE world (
  name varchar(20) NOT NULL, 
  PRIMARY KEY ( name )
);

-- Predikát: `name` je jméno možného světa.

INSERT INTO world ( name ) VALUES
    ( 'world_Bert_3_Cyril_3' ),
    ( 'world_Bert_3_Cyril_4' ),
    ( 'world_Bert_4_Cyril_4' );

TABLE world;

DROP TABLE IF EXISTS world_child_age CASCADE;
DROP VIEW IF EXISTS world_child_age;

CREATE TABLE world_child_age ( 
  world varchar(20) NOT NULL,
  child varchar(20) NOT NULL,
  age integer NOT NULL, 
  PRIMARY KEY ( world, child,  age),
  FOREIGN KEY ( world ) REFERENCES world ( name ),
  FOREIGN KEY ( child ) REFERENCES child ( name )

);

-- Predikát: Ve světe `world` je dítě `child` staré `age` let.
INSERT INTO world_child_age ( world, child, age ) VALUES
  ( 'world_Bert_3_Cyril_3', 'Anna', 3 ),
  ( 'world_Bert_3_Cyril_4', 'Anna', 3 ),
  ( 'world_Bert_4_Cyril_4', 'Anna', 3 ),
  ( 'world_Bert_3_Cyril_3', 'Bert', 3 ),
  ( 'world_Bert_3_Cyril_4', 'Bert', 3 ),
  ( 'world_Bert_4_Cyril_4', 'Bert', 4 ),
  ( 'world_Bert_3_Cyril_3', 'Cyril', 3 ),
  ( 'world_Bert_3_Cyril_4', 'Cyril', 4 ),
  ( 'world_Bert_4_Cyril_4', 'Cyril', 4 );

TABLE world_child_age;

-- První svět:
SELECT child, age
FROM   world_child_age
WHERE  world = 'world_Bert_3_Cyril_3';

-- Druhý svět:

SELECT child, age
FROM   world_child_age
WHERE  world = 'world_Bert_3_Cyril_4';

-- Třetí svět:

SELECT child, age
FROM   world_child_age
WHERE  world = 'world_Bert_4_Cyril_4';


-- Ve kterých světech jsou Bertovi tři?
SELECT world
FROM   world_child_age
WHERE  child = 'Bert'
AND    age = 3;

-- Ve kterých světech je Bertovi stejně jako Cyrilovi?
SELECT w1.world
FROM   world_child_age AS w1, world_child_age AS w2 
WHERE  w1.child = 'Bert'
AND    w2.child = 'Cyril'
AND    w1.world = w2.world
AND    w1.age = w2.age;

-- Zjistíme, že Bertovi a Cyrilovi je stejně let.

-- Je potřeba odstranit svět:
SELECT w1.world
FROM   world_child_age AS w1, world_child_age AS w2 
WHERE  w1.child = 'Bert'
AND    w2.child = 'Cyril'
AND    w1.world = w2.world
AND    w1.age <> w2.age;

-- Odstraníme z world_child_age:
DELETE FROM world_child_age
WHERE  world = 'world_Bert_3_Cyril_4';

-- Odstraníme svět:
DELETE FROM world
WHERE  name = 'world_Bert_3_Cyril_4';


-- Druhý svět přestal existovat:

SELECT child, age
FROM   world_child_age
WHERE  world = 'world_Bert_3_Cyril_4';