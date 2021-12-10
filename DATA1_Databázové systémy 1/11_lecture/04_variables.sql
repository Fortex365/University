/*
Chceme vyjádřit znalost:

Víme, že Anně jsou tři roky. Nevíme, kolik je Bertovi a Cyrilovi, 
ale víme, že je jim stějně.
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

-- Zavedeme novou relační proměnou `known_child_age`:
DROP VIEW IF EXISTS known_child_age;
DROP TABLE IF EXISTS known_child_age;
CREATE TABLE known_child_age (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  PRIMARY KEY ( name ),
  FOREIGN KEY ( name ) REFERENCES child ( name )
);

-- Predikát: Víme, že dítěti jménem `name` je `age` let.

INSERT INTO known_child_age ( name, age ) VALUES ( 'Anna', 3 );

TABLE known_child_age;

/*
Zavedeme proměnnou 'age_var_1', která bude vystihovat neznámý věk.
*/

DROP TABLE IF EXISTS age_variable CASCADE;
CREATE TABLE age_variable ( 
  name varchar(10) NOT NULL,
  PRIMARY KEY ( name )
);
-- Predikát: `name` je jméno proměnné popisující věk.

INSERT INTO age_variable ( name ) VALUES ( 'age_var_1' );

TABLE age_variable;

/*
Věk Berta a Cyrila je proměnná 'age_var_1'.
*/

DROP TABLE IF EXISTS variable_child_age CASCADE;
CREATE TABLE variable_child_age (
  name varchar(10) NOT NULL, 
  age_variable varchar(10) NOT NULL,
  PRIMARY KEY ( name ),
  FOREIGN KEY ( name ) REFERENCES child ( name ),
  FOREIGN KEY ( age_variable ) REFERENCES age_variable ( name )
);
-- Predikát: Proměnná jménem `age_variable` vyjadřuje,
-- kolik může být dítěti jménem `name` let.

INSERT INTO variable_child_age ( name, age_variable ) VALUES 
( 'Bert', 'age_var_1' ),
( 'Cyril', 'age_var_1' );

TABLE variable_child_age;

-- Znalost je popsána v relačních proměnných:
TABLE known_child_age;
TABLE variable_child_age;

/*
Dozvíme se, že Bertovi a Cyrilovi může být buď tři, nebo čtyři.
*/

DROP TABLE IF EXISTS age_variable_possible_value;
CREATE TABLE age_variable_possible_value ( 
  name varchar(10) NOT NULL,
  value integer NOT NULL,
  PRIMARY KEY ( name, value ),
  FOREIGN KEY ( name ) REFERENCES age_variable ( name )
);
-- Predikát: Proměnná jménem `name` může nabývat hodnoty `value`.

INSERT INTO age_variable_possible_value ( name, value ) VALUES 
    ( 'age_var_1', 3 ),
    ( 'age_var_1', 4 );

TABLE age_variable_possible_value;

-- Kolik může být Cyrilovi?

SELECT possible.value 
FROM   variable_child_age AS var, 
       age_variable_possible_value AS possible
WHERE  var.age_variable = possible.name  
AND    var.name = 'Cyril';

/*
Obejdeme se bez proměnné known_child_age tak, 
že věk Anny vyjádříme proměnnou, která má jedinou možnou hodnotu. 
*/

INSERT INTO age_variable ( name ) VALUES ( 'age_var_2' );

INSERT INTO variable_child_age ( name, age_variable ) VALUES 
( 'Anna', 'age_var_2' );
INSERT INTO age_variable_possible_value ( name, value ) VALUES 
    ( 'age_var_2', 3 );

TABLE age_variable;

TABLE variable_child_age;

TABLE age_variable_possible_value;

-- Proměnnou known_child_age můžeme zrušit:
DROP TABLE IF EXISTS known_child_age;

/*
Získáme možné hodnoty věků dětí bez závislostí mezi proměnnými.
*/

SELECT var.name, possible.value 
FROM   variable_child_age AS var, 
       age_variable_possible_value AS possible
WHERE  var.age_variable = possible.name;

DROP TABLE IF EXISTS possible_child_age CASCADE; 
DROP VIEW IF EXISTS possible_child_age;
CREATE VIEW possible_child_age 
AS     SELECT var.name, possible.value AS age
       FROM   variable_child_age AS var, 
              age_variable_possible_value AS possible
       WHERE  var.age_variable = possible.name;
-- Predikát: Dítěti jménem `name` může být `age` let.

TABLE possible_child_age;

-- U koho známe věk?
SELECT   name
FROM     possible_child_age
GROUP BY name
HAVING   count(*) = 1;

DROP VIEW IF EXISTS  known_child_age_name;

CREATE VIEW known_child_age_name
AS     SELECT   name
       FROM     possible_child_age
       GROUP BY name
       HAVING   count(*) = 1;

-- Predikát: Víme, kolik je dítěti jménem `name` let.

TABLE known_child_age_name;

DROP TABLE IF EXISTS  known_child_age;
DROP VIEW IF EXISTS  known_child_age;

CREATE VIEW known_child_age
AS     SELECT possible.name, possible.age
       FROM known_child_age_name AS known, possible_child_age AS possible
       WHERE known.name = possible.name;

TABLE known_child_age;

-- Zjistíme, že Bertovi nejsou tři roky.

-- Proměnná vyjadřující Bertův věk:
SELECT age_variable
FROM   variable_child_age
WHERE  name = 'Bert';

DELETE FROM age_variable_possible_value
WHERE  name = ( SELECT age_variable
                FROM   variable_child_age
                WHERE  name = 'Bert' )
AND    value = 3;

TABLE age_variable_possible_value;

TABLE known_child_age;

-- I Cyrilovi musí být čtyři.