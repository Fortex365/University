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
  ( 'Cyril', 4 ),
  ( 'Daniela', 5 ),
  ( 'Eduard', 3);

TABLE child;


/*
R: relační proměnná
c: podmínka

DELETE FROM R WHERE c;

Smaže všechny n-tice z relační proměnné R, které splňují podmínku c.
*/

/*
Například:
*/

DELETE FROM child WHERE name = 'Eduard';
TABLE child;

DELETE FROM child WHERE age >= 5;
TABLE child;