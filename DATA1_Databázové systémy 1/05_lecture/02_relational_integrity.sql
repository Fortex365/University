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
  ( 'Cyril', 4 );

TABLE child;

/*
Selže na nesprávný typ:
*/
INSERT INTO child (name, age) VALUES
  (5 , 'Daniela');


/*
Selže na chybějící hodnoty:
*/
  INSERT INTO child (name) VALUES
  ('Daniela');

/*
Selže na přebývající hodnoty:
*/
  INSERT INTO child (name, age, street) VALUES
  ('Daniela', 5, 'Kosinova');


/*
Nelze přidat n-tici, která již v relační proměnné je:
*/
  INSERT INTO child (name, age) VALUES
  ('Anna', 3);

  TABLE child;