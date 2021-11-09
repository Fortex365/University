-- Uvažujeme relační proměnnou kindergarten.
DROP TABLE IF EXISTS kindergarten CASCADE;

CREATE TABLE kindergarten (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  adult_name varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name) 
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
Kartézský součin relace se sebou samou (jen přejmenujeme atributy):
*/
SELECT k1.child_name AS child_name1, k1.child_age AS child_age1, k1.adult_name AS adult_name1,
       k2.child_name AS child_name2, k2.child_age AS child_age2, k2.adult_name AS adult_name2
FROM   kindergarten AS k1, kindergarten AS k2;

/*
Omezíme se na n-tice, kde child_name1 = child_name2:
*/

SELECT k1.child_name AS child_name1, k1.child_age AS child_age1, k1.adult_name AS adult_name1,
       k2.child_name AS child_name2, k2.child_age AS child_age2, k2.adult_name AS adult_name2
FROM   kindergarten AS k1, kindergarten AS k2
WHERE  k1.child_name = k2.child_name;


/*
Pak se musí rovnat i child_age1 a child_age2:
*/

SELECT k1.child_name AS child_name1, k1.child_age AS child_age1, k1.adult_name AS adult_name1,
       k2.child_name AS child_name2, k2.child_age AS child_age2, k2.adult_name AS adult_name2
FROM   kindergarten AS k1, kindergarten AS k2
WHERE  k1.child_name = k2.child_name 
AND  ( NOT ( k1.child_age = k2.child_age ) );

/*
Výsledek je prázdná relace, právě když child_name -> child_age

Tedy platí: child_name -> child_age 

Ale neplatí: child_name -> adult_name
*/
SELECT k1.child_name AS child_name1, k1.child_age AS child_age1, k1.adult_name AS adult_name1,
       k2.child_name AS child_name2, k2.child_age AS child_age2, k2.adult_name AS adult_name2
FROM   kindergarten AS k1, kindergarten AS k2
WHERE  k1.child_name = k2.child_name 
AND  ( NOT ( k1.adult_name = k2.adult_name ) );