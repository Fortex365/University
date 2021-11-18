
-- Uvažujeme relační proměnnou child:

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL,
  picture varchar(10) NOT NULL,
  age integer NOT NULL,
  PRIMARY KEY ( name ),
  UNIQUE ( picture )
);

-- Predikát: Dítě jménem 'name' chodí do školky, má na skříňce obrázek 'picture' a je mu 'age' let.

INSERT INTO child ( name, picture, age ) VALUES
  ( 'Anna', 'slunce', 3 ),
  ( 'Bert', 'robot', 4 ),
  ( 'Cyril', 'slon', 4 );

TABLE child;


-- {name, picture} je nadklíč child. Můžeme vynechat DISTINCT:

SELECT name, picture FROM child;

-- Vytvoříme virtuální relační proměnnou, která nebude obsahovat věk:

DROP VIEW IF EXISTS child_public CASCADE;

CREATE VIEW child_public AS SELECT name, picture FROM child;

-- Predikát: Dítě jménem 'name' chodí do školky a má na skříňce obrázek 'picture'.

/*
Aktualizovatelné relační proměnné
---------------------------------

Aktualizovatelnost relační proměnné znamená, zda můžeme změnit její hodnotu pomocí INSERT, DELETE a UPDATE. 

Základní relační proměnné můžeme aktualizovat.

R: aktualizovatelná relační proměnná
K: superklíč R

Pohled, který vznikne projekcí na superklíč R (můžeme vynechat DISTINCT), lze aktualizovat.

Tedy child_public můžeme aktualizovat.
*/


-- Změna obrázku skříňky Cyrila na raketu:

UPDATE child_public SET picture = 'raketa' WHERE name = 'Cyril';

TABLE child_public;

-- Změna se propagovala do relační proměnné child:

TABLE child;

-- Odebrání Cyrila:

DELETE FROM child_public WHERE name = 'Cyril';

TABLE child_public;

-- Změna se opět propaguje do child:

TABLE child;

-- Cyrila nelze přidat:

INSERT INTO child_public ( name, picture) VALUES ( 'Cyril', 'raketa' );

-- Nevíme, jaký má mít věk.

-- Můžeme nastavit výchozí hodnotu atributu age pro proměnnou child:

ALTER TABLE child ALTER COLUMN age SET DEFAULT 3;

-- Nyní již Cyrila můžeme přidat:

INSERT INTO child_public ( name, picture) VALUES ( 'Cyril', 'raketa' );

TABLE child_public;

-- Cyrilovi budou tři roky:

TABLE child;
