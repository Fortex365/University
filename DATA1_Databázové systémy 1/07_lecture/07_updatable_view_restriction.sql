
-- Deklarujeme relační proměnnou child:

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
  ( 'Cyril', 4 ),
  ( 'Daniela', 5 );

TABLE child;

-- Deklarujeme proměnnou child_under_five:

DROP VIEW IF EXISTS child_under_five CASCADE;

CREATE VIEW child_under_five AS SELECT * FROM child WHERE age < 5;

-- Predikát: Dítě jménem 'name' chodí do školky a je mu méně než pět let.

TABLE child_under_five;


/*
Pohled, který vznikne restrikcí aktualizovatelné relační proměnné, lze aktualizovat.

Tedy proměnná child_under_five je aktualizovatelná.
*/

-- Změna hodnoty atributu:

UPDATE child_under_five SET age = 4 WHERE name = 'Anna';

TABLE child_under_five;

TABLE child;


-- Přidání n-tice:

INSERT INTO child ( name, age ) VALUES ( 'Eduard', 3 );

TABLE child_under_five;

TABLE child;


-- Odebrání n-tice:

DELETE FROM child_under_five WHERE name = 'Cyril';

TABLE child_under_five;

TABLE child;

-- Co se stane?

UPDATE child_under_five SET age = 4 WHERE name = 'Daniela';

TABLE child_under_five;

TABLE child;


-- A teď?

UPDATE child_under_five SET age = 5 WHERE name = 'Anna';

TABLE child_under_five;

TABLE child;

-- Co tento příkaz způsobí?

INSERT INTO child_under_five ( name, age ) VALUES ( 'Cyril', 5 );

TABLE child_under_five;

TABLE child;

-- Nepřirozené: chceme zabránit manipulaci s n-ticemi, které porušují podmínku restrikce virtuální proměnné.