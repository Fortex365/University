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
A: atribut v záhlaví R typu T
v: hodnota typu T

UPDATE R SET A = v WHERE c;

V každé n-tici t v těle relace R, která splňuje podmínku c, nastaví hodnotu komponenty A v n-tici t na hodnotu v. 
*/

/*
Například:
*/
UPDATE child SET age = 6 WHERE name = 'Daniela';

TABLE child;

UPDATE child SET age = 5 WHERE age = 4;

TABLE child;
