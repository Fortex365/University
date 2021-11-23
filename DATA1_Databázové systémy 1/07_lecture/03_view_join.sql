
-- Uvažujeme relační proměnné child a responsibility.

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL,
  age integer NOT NULL,
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem 'name' chodí do školky a je mu 'age' let.

INSERT INTO child (name, age) VALUES
  ( 'Anna', 3 ),
  ( 'Bert', 4 ),
  ( 'Cyril', 4);

TABLE child;

DROP TABLE IF EXISTS responsibility CASCADE;

CREATE TABLE responsibility (
  adult_name varchar(10) NOT NULL,
  child_name varchar(10) NOT NULL,
  PRIMARY KEY ( adult_name, child_name )
);

-- Predikát: Dospělý jménem 'adult_name' je zodpovědný za dítě jménem 'child_name'.

INSERT INTO responsibility ( adult_name, child_name ) VALUES
  ( 'Pavel', 'Anna' ),
  ( 'Monika', 'Bert' ),
  ( 'Petr', 'Bert' );

TABLE responsibility;

-- Zavedeme virtuální relační proměnnou kindergarten.

DROP TABLE IF EXISTS kindergarten CASCADE;
DROP VIEW IF EXISTS kindergarten CASCADE;

CREATE VIEW kindergarten AS SELECT  * FROM ( SELECT name AS child_name, age AS child_age FROM child ) AS t1
                            NATURAL JOIN ( TABLE responsibility ) AS t2;

-- Predikát: Dítě jménem 'child_name' chodí do školky, je mu 'child_age' let a je za něj zodpovědný dospělý člověk jménem 'adult_name'.

TABLE kindergarten;

-- Přidáme Danielu do relační proměnné child.

INSERT INTO responsibility ( adult_name, child_name ) VALUES ( 'Pavel', 'Cyril' );

TABLE kindergarten;


-- Dotazy:

SELECT DISTINCT child_name FROM kindergarten WHERE adult_name = 'Pavel';

SELECT DISTINCT adult_name FROM kindergarten WHERE child_age = 4;


-- Virtuální relační proměnné lze použít v dotazech definujících další virtuální proměnné.

-- Například:

DROP VIEW IF EXISTS kindergarten_age_four CASCADE;

CREATE VIEW kindergarten_age_four AS SELECT * FROM kindergarten WHERE child_age = 4;

TABLE kindergarten_age_four;

INSERT INTO child ( name, age ) VALUES ( 'Daniela', 4 );

TABLE child;

TABLE kindergarten_age_four;

INSERT INTO responsibility ( adult_name, child_name ) VALUES ( 'Monika', 'Daniela' );

TABLE responsibility;

TABLE kindergarten_age_four;
