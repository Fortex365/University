-- Uvažujeme relační proměnnou kindergarten.
DROP TABLE IF EXISTS kindergarten CASCADE;

CREATE TABLE kindergarten (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  adult_name varchar(10) NOT NULL,
  adult_street varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name ) 
);
-- Vztah: dítě child_name chodí do školky je mu child_age let a smí si jej vyzvednout dospělý adult_name, který bydlí v ulici adult_street.

INSERT INTO kindergarten ( child_name, child_age, adult_name, adult_street ) VALUES
  ( 'Anna', 3, 'Pavel', 'Kosinova' ),
  ( 'Bert', 4, 'Monika', 'Mahlerova'  ),
  ( 'Bert', 4, 'Petr',  'Husova'),
  ( 'Cyril', 4, 'Jana', 'Kosinova' ),
  ( 'Daniela', 5, 'Jana', 'Kosinova' );

TABLE kindergarten;

/*
Krok normalizace opakujeme, dokud existuje funkční závislost porušující BCNF.
*/

/*
Krok jedna: child_name -> child_age porušuje BCNF
*/
/*

Rozložíme relační proměnnou kindergarten na:

kindergarten1: relační proměnná nad child_name, child_age
kindergarten2: relační proměnná nad child_name, adult_name, adult_street
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
  adult_street varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name ) 
);

INSERT INTO kindergarten1 ( child_name, child_age ) 
SELECT DISTINCT child_name, child_age FROM kindergarten;
TABLE kindergarten1;

INSERT INTO kindergarten2 ( child_name, adult_name, adult_street ) 
SELECT DISTINCT child_name, adult_name, adult_street FROM kindergarten;
TABLE kindergarten2;

DROP TABLE kindergarten;


/*
kindergarten1 je v BCNF, ale kindergarten2 není:

adult_name -> adult_street porušuje BCNF

Rozložíme relační proměnnou kindergarten2 na:

kindergarten3: relační proměnná nad adult_name, adult_street
kindergarten4: relační proměnná nad child_name, adult_name

*/

DROP TABLE IF EXISTS kindergarten3 CASCADE;
CREATE TABLE kindergarten3 (
  adult_name varchar(10) NOT NULL, 
  adult_street varchar(10) NOT NULL,
  PRIMARY KEY ( adult_name ) 
);

DROP TABLE IF EXISTS kindergarten4 CASCADE;
CREATE TABLE kindergarten4 (
  child_name varchar(10) NOT NULL, 
  adult_name varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name ) 
);

INSERT INTO kindergarten3 ( adult_name, adult_street ) 
SELECT DISTINCT adult_name, adult_street FROM kindergarten2;
TABLE kindergarten3;

INSERT INTO kindergarten4 ( child_name, adult_name) 
SELECT DISTINCT child_name, adult_name FROM kindergarten2;
TABLE kindergarten4;

DROP TABLE kindergarten2;

/*
Máme tři relační proměnné v BCNF:
*/

TABLE kindergarten1;

TABLE kindergarten3;

TABLE kindergarten4;

-- Dáme relačním proměnným výstižnější jména:
DROP TABLE IF EXISTS child CASCADE; 
DROP TABLE IF EXISTS adult CASCADE; 
DROP TABLE IF EXISTS legal_representative CASCADE; 
ALTER TABLE kindergarten1 RENAME TO child;
ALTER TABLE kindergarten3 RENAME TO adult;
ALTER TABLE kindergarten4 RENAME TO legal_representative;

TABLE child;
TABLE adult;
TABLE legal_representative;

-- Původní relace:
SELECT  * FROM ( TABLE child ) AS t1
NATURAL JOIN ( 
  SELECT  * FROM ( TABLE legal_representative ) AS t1
  NATURAL JOIN ( TABLE adult ) AS t2
) AS t2;