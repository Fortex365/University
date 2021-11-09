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
Boyce-Coddova normální forma
----------------------------

R: relační proměnná

R je v Boyce-Coddově normální formě (BCNF) pokud pro každou netriviální funkční závislost X -> Y relační proměnné R platí, že X je nadklíč R.
*/


/*

Relační proměnná kindergarten není v BCNF, protože 

child_name -> child_age

je netriviální funkční závislost kindergarten, ale {child_name} není nadklíč kindergarten.
*/

/*
Pokud X -> Y, kde X není nadklíč, pak říkáme, že X -> Y porušuje BCNF.

Tedy child_name -> child_age porušuje BCNF.
*/