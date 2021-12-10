/*
Znalost z předchozí části můžeme vyjádřit i jiným způsobem.

Znalost se nezměnila:

Víme, že Anně jsou tři roky.

Bertovi a Cyrilovi je buď oběma tři, nebo čtyři roky.
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


/*
Uvažujeme možné dvě možnosti: 
1. Všem jsou tři roky.
2. Anně jsou tři a Bartovi a Cyrilovi čtyři.

Každou možnost nazveme (možným) světem:
Svět `w1` vyjadřuje první možnost.
Svět `w2` vyjadřuje druhou možnost.
*/

DROP TABLE IF EXISTS world CASCADE;

CREATE TABLE world (
  name varchar(10) NOT NULL, 
  PRIMARY KEY ( name )
);

-- Predikát: `name` je jméno možného světa.

INSERT INTO world ( name ) VALUES
  ( 'w1' ),
  ( 'w2' );

TABLE world;



/*
Uvažujeme podmínky popisující naší znalost:

*/
DROP TABLE IF EXISTS condition CASCADE;

CREATE TABLE condition (
  name varchar(10) NOT NULL, 
  PRIMARY KEY ( name )
);

-- Predikát: Máme podmínku jménem `name`.

INSERT INTO condition ( name ) VALUES
  ( 'c1' ),
  ( 'c2' ),
  ( 'c3' );

TABLE condition;

/*
Podmínka může být splněna v možném světě.
Podmínka `c1` je splněna, právě když jsou Anně tři roky.
Podmínka `c2` je splněna, právě když jsou Bertovi i Cyrilovi tři roky.
Podmínka `c3` je splněna, právě když jsou Bertovi i Cyrilovi čtyři roky.
*/

DROP TABLE IF EXISTS satisfied_condition CASCADE;

CREATE TABLE satisfied_condition (
  condition varchar(10) NOT NULL, 
  world varchar(10) NOT NULL, 
  PRIMARY KEY ( condition, world ),
  FOREIGN KEY ( condition ) REFERENCES condition ( name ),
  FOREIGN KEY ( world ) REFERENCES world ( name )

);

-- Predikát: Podmínka `condition` je ve světe `word` splněna.
INSERT INTO satisfied_condition ( condition, world ) VALUES
  ( 'c1', 'w1' ),
  ( 'c1', 'w2' ),
  ( 'c2', 'w1' ),
  ( 'c3', 'w2' );

TABLE satisfied_condition;

-- Možný věk dětí vyjádříme proměnnou conditional_child_age:
DROP TABLE IF EXISTS conditional_child_age CASCADE;

CREATE TABLE conditional_child_age (
  name varchar(10) NOT NULL, 
  age integer NOT NULL, 
  condition varchar(10) NOT NULL, 
  PRIMARY KEY ( name, age, condition ),
  FOREIGN KEY ( name ) REFERENCES child ( name ),
  FOREIGN KEY ( condition ) REFERENCES condition ( name )
);

-- Predikát: Dítěti jménem `name` je `age` let za podmínky `condition`.

INSERT INTO conditional_child_age ( name, age, condition ) VALUES
  ( 'Anna', 3, 'c1' ),
  ( 'Bert', 3, 'c2' ),
  ( 'Cyril', 3, 'c2' ),
  ( 'Bert', 4, 'c3' ),
  ( 'Cyril', 4, 'c3' );

TABLE conditional_child_age;

-- První svět:
SELECT cond.name, cond.age
FROM   conditional_child_age AS cond, satisfied_condition AS sat
WHERE  cond.condition = sat.condition
AND    sat.world = 'w1';

-- Druhý svět:
SELECT cond.name, cond.age
FROM   conditional_child_age AS cond, satisfied_condition AS sat
WHERE  cond.condition = sat.condition
AND    sat.world = 'w2';