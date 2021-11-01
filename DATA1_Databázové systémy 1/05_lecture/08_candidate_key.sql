
/*
Uvažujme relační proměnou child.
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
Vložíme n-tici.
*/
INSERT INTO child (name, age) VALUES ( 'Anna', 5 );

TABLE child;

/*
Relace věrně nereprezentuje školku. Anně jsou 3 a 5 let:
*/
SELECT DISTINCT age FROM child WHERE name = 'Anna';


/*
Smažeme chybnou n-tici:
*/
DELETE FROM child WHERE name = 'Anna' AND age = 5;

TABLE child;

/*
R: relační proměnná nad A1, ..., An
K: podmnožina {A1, ..., An}
r: hodnota proměnné R

K je superklíč relace R pokud platí následující.

Pro každé dvě n-tice t1, t2 v těle relace r platí, že
pokud projekce t1 na K se rovná projekci t2 na K, pak t1 se rovná t2.

Volněji: Každá n-tice z těla relace r je určena hodnotami atributů z K.

K je kandidátní klíč relace R pokud:
1) K je superklíč.
2) Žádná vlastní podmnožina K není superklíč.

*/

/*
A1, ..., An: atributy
Ai je typu Ti (1 <= i <= n)
c1, ..., cm: integritní omezení (constraint)

CREATE TABLE R (
  A1 T1 NOT NULL,
  ...
  An Tn NOT NULL,
  c1,
  ...
  cm
)
*/

/*
{B1, ..., Bn}: kandidátní klíč
c: jméno omezení

omezení:
CONSTRAINT c UNIQUE ( B1, ..., Bn)

*/

/*
Například:
*/

DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  CONSTRAINT child_name_age_key UNIQUE (name, age)
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

TABLE child;

/*
Víme, že {name} by měl být kandidátní klíč relační proměnné child.
*/

/*
R: relační proměnná
c: integritní omezení

Přidání integritního omezení:
ALTER TABLE R ADD c;
*/


/*
Přidáme kandidátní klíč {name} k relační proměnné child:
*/
ALTER TABLE child ADD CONSTRAINT child_name_key UNIQUE ( name );

/*
R: relační proměnná
c: jméno integritního omezení R

Odebrání integritního omezení:
ALTER TABLE R DROP CONSTRAINT c;
*/

/*
Odebereme integritní omezení child_name_age_key z child:
*/
ALTER TABLE child DROP CONSTRAINT child_name_age_key;


/*
Není možné přidat n-tici: 
*/
INSERT INTO child (name, age) VALUES ( 'Anna', 5 );

TABLE child;

/*
Není možné provést změnu:
*/
UPDATE child SET name = 'Anna' WHERE name = 'Bert';

TABLE child;

/*
Každá relační proměnná má aspoň jeden kandidátní klíč.

Deklarace kandidántího klíče při definici relační proměnné:
*/

DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  CONSTRAINT child_name_key UNIQUE ( name )
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

/*
Deklarujeme relační proměnnou parent.
*/

DROP TABLE IF EXISTS parent;

/*
Kandidátní klíč parent je tvořen dvěmi atributy.
*/
CREATE TABLE parent (
  parent_name varchar(10) NOT NULL, 
  child_name varchar(10) NOT NULL,
  role varchar(10) NOT NULL,
  CONSTRAINT parent_parent_name_child_name_key UNIQUE ( parent_name, child_name )
);

INSERT INTO parent ( parent_name, child_name, role ) VALUES
  ( 'Pavel', 'Anna', 'otec' ),
  ( 'Monika', 'Bert', 'matka' ),
  ( 'Petr', 'Bert', 'otec' ),
  ( 'Marie', 'Daniela', 'matka' );

TABLE parent;
