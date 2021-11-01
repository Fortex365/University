/*
Uvažujeme relační proměnné child a parent.
*/

DROP TABLE IF EXISTS child;

CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  CONSTRAINT child_name_pkey PRIMARY KEY ( name )
);

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

TABLE child;

DROP TABLE IF EXISTS parent;

CREATE TABLE parent (
  parent_name varchar(10) NOT NULL, 
  child_name varchar(10) NOT NULL,
  CONSTRAINT parent_parent_namec_hild_name_pkey PRIMARY KEY ( parent_name, child_name )
);

INSERT INTO parent ( parent_name, child_name ) VALUES
  ( 'Pavel', 'Anna' ),
  ( 'Monika', 'Bert' ),
  ( 'Petr', 'Bert' );

TABLE parent;


/*
Atribut child_name je cizí klíč relační proměnné parent na atribut name relační proměnné child, 
právě když tělo relace:
*/
SELECT DISTINCT child_name FROM parent;

/*
je podmnožinou těla relace:
*/
SELECT DISTINCT name AS child_name FROM child;


/*
Nebo ekvivalentně, právě když je následující relace prázdná.
*/
( SELECT DISTINCT child_name FROM parent )
  EXCEPT
( SELECT DISTINCT name AS child_name FROM child );
