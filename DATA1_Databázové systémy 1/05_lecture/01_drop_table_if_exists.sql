/*
Na začátku nevíme, zda relační proměnná child existuje.

Není možné deklarovat relační proměnnou dvakrát.

Následující příkaz zruší relační proměnnou child pokud existuje.
*/
DROP TABLE IF EXISTS child;


/*
Na relační proměnné můžou záviset další databázové objekty. Následující 
varianta odstraní relační proměnnou i objekty, které na ni závisí. 
Objekty, které můžou záviset na relační proměnné, si představíme za chvíli.
*/

DROP TABLE IF EXISTS child CASCADE;

/*
Nyní již můžeme bezpečně proměnou child deklarovat:
*/
CREATE TABLE child (
  name varchar(10) NOT NULL, 
  age integer NOT NULL,
  UNIQUE (name, age)
);

TABLE child;

