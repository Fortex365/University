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
r: relace nad A1, ..., An
r1 a r2: rozklad relace r

Rozklad r na r1 a r2 je bezeztrátový, pokud r je rovno r1 spojení s r2.
*/

-- Bezeztrátová dekompozice:
SELECT * FROM (SELECT DISTINCT child_name, child_age FROM kindergarten) AS t1
NATURAL JOIN (SELECT DISTINCT child_name, adult_name FROM kindergarten) AS t2;

-- Musí být prázdná množina:
( ( TABLE kindergarten ) 
    EXCEPT
  ( SELECT * FROM (SELECT DISTINCT child_name, child_age FROM kindergarten) AS t1
    NATURAL JOIN (SELECT DISTINCT child_name, adult_name FROM kindergarten) AS t2 ) )
    UNION
( ( SELECT * FROM (SELECT DISTINCT child_name, child_age FROM kindergarten) AS t1
    NATURAL JOIN (SELECT DISTINCT child_name, adult_name FROM kindergarten) AS t2 )
    EXCEPT 
  ( TABLE kindergarten ) );


-- Není bezeztrátová:
SELECT * FROM ( SELECT DISTINCT child_name, child_age FROM kindergarten ) AS t1
NATURAL JOIN  ( SELECT DISTINCT adult_name FROM kindergarten ) AS t2;

-- Taky není bezeztrátová:
SELECT * FROM ( SELECT DISTINCT child_age FROM kindergarten ) AS t1
NATURAL JOIN ( SELECT DISTINCT child_name, adult_name FROM kindergarten ) AS t2;

/*
r: relace nad A1, ..., An
X -> Y: funkční závislost r

H1:  X sjednoceno s Y
H2: {A1, ..., An} mínus Y

Rozklad relace r na H1 a H2 je bezeztrátorvý.

*/

/*
Například:
r: hodnota relační proměnné kindergarten

Funkční závislost

child_name -> child_age

platí v relaci r.

Rozklad r na {child_name, child_age} a {child_name, adult_name} je bezeztrátový.

*/