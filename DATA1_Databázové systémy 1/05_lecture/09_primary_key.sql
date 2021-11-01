/*
Uvažujme relační proměnou child.
*/
DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  CONSTRAINT child_name_key UNIQUE (name)
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

TABLE child;


/*
Jako primární klíč relační proměnné je vybrán jeden z kandidátních klíčů.

Ostatní klíče relační proměnné se nazývají alternativní klíče.

{A1, ..., An}: kandidátní klíč relační proměnné
c: jméno (končí pkey)

primární klíč:
CONSTRAINT c PRIMARY KEY ( A1, ..., An )

*/
/*
Přidáme primární klíč relační proměnné child:
*/
ALTER TABLE child ADD CONSTRAINT child_name_pkey PRIMARY KEY ( name );

/*
Odebereme alternativní klíč:
*/

ALTER TABLE child DROP CONSTRAINT child_name_key;

/*
Deklarace primárního klíče při definici relační proměnné:
*/

DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age child_age NOT NULL,
  CONSTRAINT child_name_pkey PRIMARY KEY ( name )
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

/*
Deklarujeme relační proměnnou parent s primárním klíčem.
*/

DROP TABLE IF EXISTS parent;

CREATE TABLE parent (
  parent_name varchar(10) NOT NULL, 
  child_name varchar(10) NOT NULL,
  role varchar(10) NOT NULL,
  CONSTRAINT parent_parent_name_child_name_pkey PRIMARY KEY ( parent_name, child_name )
);

INSERT INTO parent ( parent_name, child_name, role ) VALUES
  ( 'Pavel', 'Anna', 'otec' ),
  ( 'Monika', 'Bert', 'matka' ),
  ( 'Petr', 'Bert', 'otec' ),
  ( 'Marie', 'Daniela', 'matka' );


TABLE parent;