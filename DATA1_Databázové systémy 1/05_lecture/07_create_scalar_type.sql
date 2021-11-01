
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
  ( 'Cyril', 4);

TABLE child;


 /*
 Můžeme přidat dítě s neplatným věkem:
 */
INSERT INTO child (name, age) VALUES
  ( 'Daniela', -1 );

/*
Nebo:
*/
INSERT INTO child (name, age) VALUES
  ( 'Eduard', 1000 );

/* 
Máme relaci, která nereprezentuje školku:
*/
TABLE child;

/*
Řešením je zavést vlastní (skalární) typ. 
*/

-- Smažeme skalární typ, pokud existuje:
DROP DOMAIN IF EXISTS child_age_type;

/*
Deklarace nového skalárního typu.

A: nové jméno typu
B: základní vestavěný typ
c: podmínka nad value

CREATE DOMAIN A AS B
              CHECK (c);

Vytvoří nový typ jménem A, který bude tvořen
právě prvky B splňující podmínku c.

Typ A je podmnožinou typu B.
*/


/*
Vytvoříme nový skalární typ child_age, který
je tvořen přirozenými čísly 0, 1, 2, 3, 4, 5, 6:
*/
CREATE DOMAIN child_age_type AS integer
              CHECK ( value >= 0 AND value <= 6 );

/*
Smažeme chybné n-tice z proměnné child:
*/
DELETE FROM child WHERE name = 'Daniela' OR name = 'Eduard';

TABLE child;

/*
Změníme typ atributu age na child_age:
*/
ALTER TABLE child ALTER COLUMN age SET DATA TYPE child_age_type;

/*
n-tice s chybným věkem nejdou přidat:
*/
INSERT INTO child (name, age) VALUES
  ( 'Daniela', -1 );

TABLE child;

INSERT INTO child (name, age) VALUES
  ( 'Eduard', 1000 );

TABLE child;

/*
Nelze ani změnit věk na nepřípustnou hodnotu:
*/
UPDATE child SET age = 10 WHERE name = 'Anna';

TABLE child;

/*
Vytvoření relační proměnné rovnou s novým skalárním typem.
*/
DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age child_age_type NOT NULL,
  UNIQUE (name, age)
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4 );

  TABLE child;