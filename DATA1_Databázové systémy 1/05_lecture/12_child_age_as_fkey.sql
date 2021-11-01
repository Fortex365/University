
/*
Deklarujeme proměnné child_age a child.
*/
DROP TABLE IF EXISTS child_age;

CREATE TABLE child_age ( 
  age integer NOT NULL,
  CONSTRAINT child_age_age_pkey PRIMARY KEY ( age )
);

INSERT INTO child_age ( age ) VALUES
  ( 3 ),
  ( 4 ),
  ( 5 );

TABLE child_age;

DROP TABLE IF EXISTS child CASCADE;


CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  CONSTRAINT child_name_pkey PRIMARY KEY ( name ),
  CONSTRAINT child_age_fkey FOREIGN KEY ( age ) REFERENCES child_age ( age )
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

/*
Nelze přidat šestileté dítě:
*/

INSERT INTO child (name, age) VALUES
  ( 'Daniela', 6 );


/*
Přidáme možný věk dětí ve školce:
*/
INSERT INTO child_age (age) VALUES
  ( 6 );

TABLE child_age;

/*
Nyní již lze šestileté dítě přidat:
*/

INSERT INTO child (name, age) VALUES
  ( 'Daniela', 6 );  

TABLE child;