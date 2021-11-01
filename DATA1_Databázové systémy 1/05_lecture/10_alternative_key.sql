/*
Uvažujme relační proměnnou  child.
*/
DROP TABLE IF EXISTS child;


CREATE TABLE child (
  id integer NOT NULL,
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  CONSTRAINT child_id_name_age_key UNIQUE ( id, name, age )
);

INSERT INTO child (id, name, age) VALUES
  ( 0, 'Anna', 3 ),
  ( 1, 'Bert', 4 ),
  ( 2, 'Cyril', 4);

TABLE child;

/*
Jak {id}, tak {name} jsou kandidátní klíče child.

Jako primární klíč zvolíme {id}:
*/

ALTER TABLE child ADD CONSTRAINT child_id_pkey PRIMARY KEY ( id );

/*
Množina {name} bude alternativním klíčem:
*/
ALTER TABLE child ADD CONSTRAINT child_name_key UNIQUE ( name );

/*
Odebrání původního kandidátního klíče:
*/
ALTER TABLE child DROP CONSTRAINT child_id_name_age_key;

/*
Následující nelze provést. Porušení primárního klíče:
*/
INSERT INTO child ( id, name, age ) VALUES
  ( 0, 'Daniela', 3 );


/*
Následující také nelze provést. Porušení alternativního klíče:
*/

INSERT INTO child ( id, name, age ) VALUES
  ( 3, 'Anna', 5 );


TABLE child;

/*
Definice relační proměnné rovnou s klíči:
*/

DROP TABLE IF EXISTS child;

CREATE TABLE child (
  id integer NOT NULL,
  name varchar(10) NOT NULL, 
  age child_age NOT NULL,
  CONSTRAINT child_id_pkey PRIMARY KEY ( id ),
  CONSTRAINT child_name_key UNIQUE ( name )
);

INSERT INTO child ( id, name, age ) VALUES
  ( 0, 'Anna', 3 ),
  ( 1, 'Bert', 4 ),
  ( 2, 'Cyril', 4 );

TABLE child;

