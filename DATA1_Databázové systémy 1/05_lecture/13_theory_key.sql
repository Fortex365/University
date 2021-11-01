/*
Uvažujeme relační proměnnou child.
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
  ( 'Cyril', 4 );

/*
Kartézský součin relace se sebou samou (jen přejmenujeme atributy):
*/
SELECT child1.name AS name1, child1.age AS age1, child2.name AS name2, child2.age AS age2  
FROM   child AS child1, child AS child2;

/*
Omezíme se na n-tice, kde name1 = name2:
*/

SELECT child1.name AS name1, child1.age AS age1, child2.name AS name2, child2.age AS age2  
FROM   child AS child1, child AS child2
WHERE  child1.name = child2.name;


/*
Pak se musí rovnat i age1 a age2:
*/

SELECT  child1.name AS name1, child1.age AS age1, child2.name AS name2, child2.age AS age2  
FROM    child AS child1, child AS child2
WHERE ( child1.name = child2.name ) AND ( NOT ( child1.age = child2.age ) );

/*
Výsledek je prázdná relace, právě když {name} je superklíčem relace child.

Tedy {name} je superklíčem relace child.

Ale množina {age} není superklíčem relace child:
*/

SELECT  child1.name AS name1, child1.age AS age1, child2.name AS name2, child2.age AS age2  
FROM    child AS child1, child AS child2
WHERE ( child1.age = child2.age ) AND ( NOT ( child1.name = child2.name ) );