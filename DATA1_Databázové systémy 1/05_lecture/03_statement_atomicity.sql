/*
Uvažujeme relační proměnnou child.
*/
DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  UNIQUE (name, age)
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4 );

TABLE child;

/*
Každý příkaz SQL se provede atomicky. Tedy buď skončí v pořádku a provedou se všechny změny, nebo skončí chybou a neprovede se žádná změna.

Například:
*/
INSERT INTO child (name, age) VALUES
  ( 'Daniela', 5),
  ( 'Eduard', 'nevim');


/*
Skončí chybou, protože druhá n-tice je chybně zadaná. Přestože první n-tice je v pořádku, do relační proměnné se nepřidá. 
*/

TABLE child;