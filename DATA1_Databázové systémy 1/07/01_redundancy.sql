
-- Uvažujeme relační proměnnou child.

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL,
  age integer NOT NULL,
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem 'name' chodí do školky a je mu 'age' let.

INSERT INTO child ( name, age ) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4 );

TABLE child;

-- Zavedeme relační proměnnou child_name, která bude obsahovat pouze jména dětí.

DROP TABLE IF EXISTS child_name CASCADE;

CREATE TABLE child_name (
  name varchar(10) NOT NULL,
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem 'name' chodí do školky.

INSERT INTO child_name ( name )
SELECT DISTINCT name FROM child;

TABLE child_name;

/*
Databáze obsahuje redundanci. Jména dětí jsou ve dvou relačních proměnných.

Již víme, že redundance v databázi je zdrojem chyb.

Například:
*/

INSERT INTO child ( name, age ) VALUES ( 'Daniela', 5 );

SELECT * FROM child WHERE name = 'Daniela';

SELECT * FROM child_name WHERE name = 'Daniela';

/*
Podle relační proměnné child chodí Daniela do školky,
ale podle relační proměnné child_name nechodí.
*/