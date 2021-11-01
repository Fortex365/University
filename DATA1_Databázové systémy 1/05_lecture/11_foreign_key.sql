/*
Referenční integritní omezení
*/


/*
Deklarujeme relační proměnné child a parent.
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
  ( 'Petr', 'Bert' ),
  ( 'Marie', 'Daniela' );

TABLE parent;

/*
Kdo je Daniela? Chceme aby pro každou n-tice t1 v parent existovala n-tice t2 v child tak, že t1 přiřazuje atributu child_name stejnou hodnotu jako n-tice t2 atributu name.

Danielu odebereme:
*/

DELETE FROM parent WHERE parent_name = 'Marie' AND child_name = 'Daniela';

TABLE parent;


/*
R1: relační proměnná nad A1, ..., An
R2: relační proměnná nad B1, ..., Bm
r1: hodnota proměnné R1
r2: hodnota proměnné R2

C1, ..., Ck: atributy ze záhlaví R1
D1, ..., Dk: kandidátní klíč R2 

C1, ..., Ck je cizí klíč relační proměnné R1 na atributy D1, ..., Dk relační proměnné R2 pokud platí následující.

Pro každou n-tici t1 v těle r1 existuje n-tice t2 v těle r2 taková, že
  pro každé 1 <= i <= k je hodnota přiřazená n-ticí t1 atributu Ci rovna hodnotě přiřazené n-ticí t2 atributu Di.

Například:
Atribut child_name je cizí klíč relační proměnné parent na atribut name relační proměnné child.

c: jméno omezení (končí fkey)

integritní omezení:
CONSTRAINT c FOREIGN KEY ( C1, ..., Ck ) REFERENCES R2 ( D1, ..., Dk )
*/


ALTER TABLE parent ADD CONSTRAINT parent_child_name_fkey 
FOREIGN KEY ( child_name ) REFERENCES child ( name );


/*
Vztah Marie je rodičem Daniely nelze přidat:
*/

INSERT INTO parent ( parent_name, child_name ) VALUES 
          ( 'Marie', 'Daniela' );

/*
Berta nelze odebrat:
*/

DELETE FROM child WHERE name = 'Bert';

/*
Relační proměnné je potřeba rušit v tomto pořadí (nebo použít CASCADE).
*/

DROP TABLE IF EXISTS parent;

DROP TABLE IF EXISTS child;

/*
Přidání cizího klíče rovnou při deklaraci proměnné:
*/

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

CREATE TABLE parent (
  parent_name varchar(10) NOT NULL, 
  child_name varchar(10) NOT NULL,
  CONSTRAINT parent_parent_namec_hild_name_pkey PRIMARY KEY ( parent_name, child_name ),
  CONSTRAINT parent_child_name_fkey FOREIGN KEY ( child_name ) REFERENCES child ( name )
);

INSERT INTO parent ( parent_name, child_name ) VALUES
  ( 'Pavel', 'Anna' ),
  ( 'Monika', 'Bert' ),
  ( 'Petr', 'Bert' );

TABLE parent;