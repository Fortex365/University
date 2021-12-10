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
Zavedeme proměnné 'Anna_age_var', 'Bert_age_var' a 'Cyril_age_var'.
*/

DROP TABLE IF EXISTS age_variable CASCADE;
CREATE TABLE age_variable ( 
  name varchar(20) NOT NULL,
  PRIMARY KEY ( name )
);
-- Predikát: `name` je jméno proměnné popisující věk.

INSERT INTO age_variable ( name ) VALUES 
     ( 'Anna_age_var' ),
     ( 'Bert_age_var' ),
     ( 'Cyril_age_var' );

TABLE age_variable;

/*
Proměnné 'Anna_age_var', 'Bert_age_var' a 'Cyril_age_var'
vystihují věk Anny, Berta a Cyrila.
*/

DROP TABLE IF EXISTS variable_child_age CASCADE;
CREATE TABLE variable_child_age (
  name varchar(10) NOT NULL, 
  age_variable varchar(20) NOT NULL,
  PRIMARY KEY ( name ),
  FOREIGN KEY ( name ) REFERENCES child ( name ),
  FOREIGN KEY ( age_variable ) REFERENCES age_variable ( name )
);
-- Predikát: Proměnná jménem `age_variable` vyjadřuje,
-- kolik může být dítěti jménem `name` let.

INSERT INTO variable_child_age ( name, age_variable ) VALUES 
         ( 'Anna', 'Anna_age_var' ),
         ( 'Bert', 'Bert_age_var' ),
         ( 'Cyril', 'Cyril_age_var' );


TABLE variable_child_age;


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

/*
Uvažujeme podmínky popisující naší znalost:
*/
DROP TABLE IF EXISTS condition CASCADE;

CREATE TABLE condition (
  name varchar(20) NOT NULL, 
  PRIMARY KEY ( name )
);

-- Predikát: Máme podmínku jménem `name`.

INSERT INTO condition ( name ) VALUES
  ( 'cond_Anna_3' ),
  ( 'cond_Bert_3' ),
  ( 'cond_Bert_4' ),
  ( 'cond_Cyril_3' ),
  ( 'cond_Cyril_4' );

TABLE condition;

DROP TABLE IF EXISTS satisfied_condition CASCADE;

CREATE TABLE satisfied_condition (
  condition varchar(20) NOT NULL, 
  world varchar(20) NOT NULL, 
  PRIMARY KEY ( condition, world ),
  FOREIGN KEY ( condition ) REFERENCES condition ( name ),
  FOREIGN KEY ( world ) REFERENCES world ( name )

);

-- Predikát: Podmínka `condition` je ve světe `word` splněna.
INSERT INTO satisfied_condition ( condition, world ) VALUES
  ( 'cond_Anna_3', 'world_Bert_3_Cyril_3' ),
  ( 'cond_Anna_3', 'world_Bert_3_Cyril_4' ),
  ( 'cond_Anna_3', 'world_Bert_4_Cyril_4' ),
  ( 'cond_Bert_3', 'world_Bert_3_Cyril_3' ),
  ( 'cond_Bert_3', 'world_Bert_3_Cyril_4' ),
  ( 'cond_Bert_4', 'world_Bert_4_Cyril_4' ),
  ( 'cond_Cyril_3', 'world_Bert_3_Cyril_3' ),
  ( 'cond_Cyril_4', 'world_Bert_3_Cyril_4' ),
  ( 'cond_Cyril_4', 'world_Bert_4_Cyril_4' );

TABLE satisfied_condition;


-- Možné hodnoty proměnných::
DROP TABLE IF EXISTS conditional_varable_child_age CASCADE;

CREATE TABLE conditional_varable_child_age (
  variable varchar(20) NOT NULL, 
  age integer NOT NULL, 
  condition varchar(20) NOT NULL, 
  PRIMARY KEY ( variable, age, condition ),
  FOREIGN KEY ( variable ) REFERENCES age_variable ( name ),
  FOREIGN KEY ( condition ) REFERENCES condition ( name )
);

-- Predikát: Dítěti jménem `name` je `age` let za podmínky `condition`.

INSERT INTO conditional_varable_child_age ( variable, age, condition ) VALUES
  ( 'Anna_age_var', 3, 'cond_Anna_3' ),
  ( 'Bert_age_var', 3, 'cond_Bert_3' ),
  ( 'Bert_age_var', 4, 'cond_Bert_4' ),
  ( 'Cyril_age_var', 3, 'cond_Cyril_3' ),
  ( 'Cyril_age_var', 4, 'cond_Cyril_4' );

TABLE conditional_varable_child_age;

/*
Za jaké podmínky má dítě určitý věk?
*/

SELECT var.name, cond.age, cond.condition
FROM   variable_child_age AS var, 
       conditional_varable_child_age AS cond
WHERE  var.age_variable = cond.variable;

DROP TABLE IF EXISTS conditional_child_age;
DROP VIEW IF EXISTS conditional_child_age;

CREATE VIEW conditional_child_age 
AS     SELECT var.name, cond.age, cond.condition
       FROM   variable_child_age AS var, 
              conditional_varable_child_age AS cond
       WHERE  var.age_variable = cond.variable;

-- Predikát: Dítěti jménem `name` je `age` let za podmínky `condition`. 
TABLE conditional_child_age;

-- Hodnoty proměnných ve světech:

SELECT  cond.variable, sat.world, cond.age AS value
FROM    conditional_varable_child_age AS cond, 
        satisfied_condition AS sat
WHERE   cond.condition = sat.condition;

DROP VIEW IF EXISTS variable_value CASCADE;
CREATE VIEW variable_value
AS     SELECT  cond.variable, sat.world, cond.age AS value
       FROM    conditional_varable_child_age AS cond, 
               satisfied_condition AS sat
       WHERE   cond.condition = sat.condition;

-- Predikát: Proměnná `variable` má ve světě `world` 
--           hodnotu `value`.
TABLE  variable_value;


-- Věky dětí ve světech:
SELECT child_age.name, var_value.world, var_value.value 
FROM variable_value AS var_value,
     variable_child_age AS child_age
WHERE var_value.variable = child_age.age_variable;

DROP VIEW IF EXISTS world_child_age;
DROP TABLE IF EXISTS world_child_age;

CREATE VIEW world_child_age
AS     SELECT child_age.name, var_value.world, var_value.value AS age
       FROM   variable_value AS var_value,
              variable_child_age AS child_age
       WHERE var_value.variable = child_age.age_variable;

-- Predikát: Dítě jménem `name` má ve světe `world` věk `age`.

TABLE world_child_age;


-- První svět:
SELECT name AS child, age
FROM   world_child_age
WHERE  world = 'world_Bert_3_Cyril_3';

-- Druhý svět:
SELECT name AS child, age
FROM   world_child_age
WHERE  world = 'world_Bert_3_Cyril_4';

-- Třetí svět:
SELECT name AS child, age
FROM   world_child_age
WHERE  world = 'world_Bert_4_Cyril_4';

-- Ve kterých světech jsou Bertovi čtyři?
SELECT world
FROM   world_child_age
WHERE  name = 'Bert'
AND    age = 4;

-- Ve kterých světech je Bertovi stejně jako Cyrilovi?
SELECT w1.world
FROM   world_child_age AS w1, world_child_age AS w2 
WHERE  w1.name = 'Bert'
AND    w2.name = 'Cyril'
AND    w1.world = w2.world
AND    w1.age = w2.age;



     