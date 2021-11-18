
-- Deklarujeme relační proměnnou child:

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL,
  picture varchar(10) NOT NULL,
  age integer NOT NULL DEFAULT 3,
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem 'name' chodí do školky, má na skříňce obrázek 'picture' a je mu 'age' let.

INSERT INTO child ( name, picture, age ) VALUES
  ( 'Anna', 'slunce', 3 ),
  ( 'Bert', 'robot', 4 ),
  ( 'Cyril', 'slon', 4 ),
  ( 'Daniela', 'jablko', 5);

TABLE child;

-- Deklarujeme relační proměnnou child_age:

DROP VIEW IF EXISTS child_age CASCADE;

DROP TABLE IF EXISTS child_age CASCADE;

CREATE VIEW child_age AS SELECT name, age FROM child WITH CHECK OPTION;

-- Predikát: Dítě jménem 'name' chodí do školky a je mu 'age' let.

TABLE child_age;

-- Deklarujeme relační proměnnou child_age_under_five:

DROP VIEW IF EXISTS child_age_under_five;

CREATE VIEW child_age_under_five AS SELECT * FROM child_age WHERE age < 5 WITH CHECK OPTION;

-- Predikát: Dítě jménem 'name' chodí do školky a je mu 'age' let a je mladší než pět let.

TABLE child_age_under_five;


-- Změníme věk Anny:

UPDATE child_age_under_five SET age = 4 WHERE name = 'Anna';

TABLE child_age_under_five;

TABLE child_age;

TABLE child;

/*
Obecně pohled je aktualizovatelný, pokud je definovaný SELECT výrazem, který

1) má jen jeden popis vstupní relace a ten musí být aktualizovatelná relační proměnná
2) nesmí mít DISTINCT
*/

-- Smažeme pohledy:

DROP VIEW IF EXISTS child_age CASCADE;
DROP VIEW IF EXISTS child_age_under_five CASCADE;

-- Vytvoříme rovnou child_age_under_five:

CREATE VIEW child_age_under_five AS SELECT name, age FROM child WHERE age < 5 WITH CHECK OPTION;

TABLE child_age_under_five;

-- child_age_under_five je měnitelné:

UPDATE child_age_under_five SET age = 3 WHERE name = 'Anna';

TABLE child_age_under_five;
