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
A, B - atributy stejného typu T
Podmínky na nerovnost:
( A < B ), ( A <= B ), ( A > B ), ( A >= B )

v - hodnota typu T
Další podmínky na nerovnost: 
( A < v ), ( A <= v ), ( A > v ), ( A >= v )
*/


/*
Například: Komu je víc jak tři roky?
*/
SELECT * FROM child WHERE age > 3;

