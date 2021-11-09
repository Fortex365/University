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
v: relační výraz typu A1, ..., An
r: hodnota relačního výrazu v

INSERT INTO R ( A1, ..., An ) v;
... přidá do relační proměnné R všechny n-tice v těle r.
*/

-- Například uvažujme relační proměnnou:
DROP TABLE IF EXISTS kindergarten1 CASCADE;
CREATE TABLE kindergarten1 (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  PRIMARY KEY ( child_name, child_age ) 
);

-- Chceme do ní přidat n-tice z těla hodnoty výrazu:
SELECT DISTINCT child_name, child_age FROM kindergarten;

-- To provedeme příkazem:
INSERT INTO kindergarten1 ( child_name, child_age ) 
SELECT DISTINCT child_name, child_age FROM kindergarten;

TABLE kindergarten1;