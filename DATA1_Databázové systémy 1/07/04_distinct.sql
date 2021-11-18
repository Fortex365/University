-- Uvažujeme relační proměnnou child.

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child(
  name varchar(10) NOT NULL,
  age integer NOT NULL,
  PRIMARY KEY (name)
);

-- Predikát: Dítě jménem 'name' chodí do školky a je mu 'age' let.

INSERT INTO child ( name, age ) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4 );


TABLE child;


-- DISTINCT v SELECT výrazu můžeme v některých případech vynechat.

-- DISTINCT můžeme vynechat u restrikce relační proměnné:

SELECT * FROM child WHERE age = 4;

-- DISTINCT můžeme vynechat u projekce relační proměnné na atributy, které jsou nadklíčem:

SELECT name FROM child;

-- DISTINCT můžeme vynechat u kombinace projekce a restrikce na nadklíč:

SELECT name FROM child WHERE age = 4;

-- Zde není možné DISTINCT vynechat:

SELECT age FROM child;

-- {age} není nadklíč