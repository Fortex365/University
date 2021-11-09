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
B1, ..., Bm: unikátní atributy
C1, ..., Ck: unikátní atributy

platí, že {A1, ..., An} je rovna {B1, ..., Bm} sjednoceno s {C1, ..., Ck}

Uvažujeme dvě relace:
r1: projekce r na B1, ..., Bm
r2: projekce r na C1, ..., Ck

Relace r1 a r2 jsou rozkladem relace r na {B1, ..., Bm} a {C1, ..., Ck}.
*/

-- První příklad:
SELECT DISTINCT child_name, child_age FROM kindergarten;
SELECT DISTINCT child_name, adult_name FROM kindergarten;


-- Druhý příklad:
SELECT DISTINCT child_name, child_age FROM kindergarten;
SELECT DISTINCT adult_name FROM kindergarten;

-- Třetí příklad:
SELECT DISTINCT child_age FROM kindergarten;
SELECT DISTINCT child_name, adult_name FROM kindergarten;