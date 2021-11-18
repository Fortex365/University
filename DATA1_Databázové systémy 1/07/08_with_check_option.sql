
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

DROP VIEW IF EXISTS child_under_five CASCADE;

/*
Aby nebylo možné manipulovat s n-ticemi nesplňující podmínku restrikce,
přidáme nakonec deklarace virtuální proměnné:

WITH CHECK OPTION

Například:
*/

CREATE VIEW child_under_five AS SELECT * FROM child WHERE age < 5 WITH CHECK OPTION;

-- Nyní nelze nastavit věk na hodnotu, která by odporovala podmínce pohledu:

UPDATE child_under_five SET age = 5 WHERE name = 'Anna';

-- Nemůžeme volžit n-tici nesplňující podmínku pohledu:

INSERT INTO child_under_five ( name, age ) VALUES ( 'Cyril', 5 );

-- Vytvoříme restrikci pohledu:

CREATE VIEW child_under_five_above_three AS SELECT * FROM child_under_five WHERE age > 3 WITH CHECK OPTION;

TABLE child_under_five_above_three;

-- Nemůžeme porušit podmínku ani jednoho pohledu:

UPDATE child_under_five_above_three SET age = 5 WHERE name = 'Bert';

UPDATE child_under_five_above_three SET age = 3 WHERE name = 'Bert';
