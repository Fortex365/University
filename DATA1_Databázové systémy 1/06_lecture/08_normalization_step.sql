-- Uvažujeme relační proměnnou kindergarten.
DROP TABLE IF EXISTS kindergarten CASCADE;

CREATE TABLE kindergarten (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  adult_name varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name ) 
);
-- Vztah: dítě child_name chodí do školky je mu child_age let a smí si jej vyzvednout dospělý adult_name.

INSERT INTO kindergarten ( child_name, child_age, adult_name ) VALUES
  ( 'Anna', 3, 'Pavel' ),
  ( 'Bert', 4, 'Monika' ),
  ( 'Bert', 4, 'Petr' ),
  ( 'Cyril', 4, 'Jana' ),
  ( 'Daniela', 5, 'Jana' );

TABLE kindergarten;

/*
R: relační proměnná nad A1, ..., An
X -> Y: funkční závislost, která porušuje BCNF

Rozložíme R na R1 a R2, kde

R1: relační proměnná nad X sjednoceno s Y
R2: relační proměnná nad {A1, ..., An} mínus Y

Rozklad R na R1 a R2 je bezeztrátový.
*/

/*
Například child_name -> child_age porušuje BCNF.

Rozložíme relační proměnnou kindergarten na:

kindergarten1: relační proměnná nad child_name, child_age
kindergarten2: relační proměnná nad child_name, adult_name
*/

DROP TABLE IF EXISTS kindergarten1 CASCADE;
CREATE TABLE kindergarten1 (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  PRIMARY KEY ( child_name ) 
);

DROP TABLE IF EXISTS kindergarten2 CASCADE;
CREATE TABLE kindergarten2 (
  child_name varchar(10) NOT NULL, 
  adult_name varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name ) 
);

INSERT INTO kindergarten1 ( child_name, child_age ) 
SELECT DISTINCT child_name, child_age FROM kindergarten;
TABLE kindergarten1;

INSERT INTO kindergarten2 ( child_name, adult_name ) 
SELECT DISTINCT child_name, adult_name FROM kindergarten;
TABLE kindergarten2;

-- Relační proměnná kindergarten je nadbytečná: 
SELECT * FROM ( TABLE kindergarten1 ) AS t1
NATURAL JOIN ( TABLE kindergarten2 ) AS t2;

-- Můžeme ji odstranit:
DROP TABLE kindergarten;

-- Dáme relačním proměnným výstižnější jména:
DROP TABLE IF EXISTS child CASCADE;
DROP TABLE IF EXISTS adult CASCADE;
ALTER TABLE kindergarten1 RENAME TO child;
ALTER TABLE kindergarten2 RENAME TO adult;

TABLE child;
TABLE adult;

-- Původní relace:
SELECT * FROM ( TABLE child ) AS t1
NATURAL JOIN ( TABLE adult ) AS t2;