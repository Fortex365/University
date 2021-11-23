
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

-- Chceme relační proměnnou, jejíž hodnota by byla vždy hodnotou výrazu:

SELECT DISTINCT name FROM child;

/*
v: relační výraz typu A1, ..., An
R: jméno relace

Příkaz:
CREATE VIEW R AS v;
...deklaruje relační proměnnou R, jejíž hodnota je vždy hodnota výrazu v.

Proměnnou R nazýváme virtuální relační proměnná nebo pohled (anglicky view).

Relační proměnná, která není virtuální, se nazývá základní.

Relační proměnná child je základní.
*/

-- Zavedeme virtuální relační proměnnou child_name, která bude obsahovat pouze jména dětí.

DROP TABLE IF EXISTS child_name CASCADE;
DROP VIEW IF EXISTS child_name CASCADE;

-- (Nevíme, zda je child_name TABLE nebo VIEW - zkusíme odstranit obojí.)

CREATE VIEW child_name AS SELECT DISTINCT name FROM child;

-- Predikát: Dítě jménem 'name' chodí do školky.

TABLE child_name;

-- Přidáme Danielu do relační proměnné child:

INSERT INTO child ( name, age ) VALUES ( 'Daniela', 5 );

-- Nyní je Daniela chodí do školky podle obou relačních proměnných:

SELECT * FROM child WHERE name = 'Daniela';

SELECT * FROM child_name WHERE name = 'Daniela';
