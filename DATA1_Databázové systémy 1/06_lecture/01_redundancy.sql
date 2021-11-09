-- Uvažujeme relační proměnnou kindergarten.
DROP TABLE IF EXISTS kindergarten CASCADE;

CREATE TABLE kindergarten (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  adult_name varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name) 
);
-- Vztah: dítě child_name chodí do školky je mu child_age let a smí si jej vyzvednout dospělý adult_name.

/*
Poznámka: integritní omezení nemusíme pojmenovávat (systém jméno zvolí za nás).
*/

INSERT INTO kindergarten ( child_name, child_age, adult_name ) VALUES
  ( 'Anna', 3, 'Pavel' ),
  ( 'Bert', 4, 'Monika' ),
  ( 'Bert', 4, 'Petr' ),
  ( 'Cyril', 4, 'Jana' ),
  ( 'Daniela', 5, 'Jana' );

TABLE kindergarten;

-- Obdržíme informaci, že jediné dítě Moniky má pět let:

UPDATE kindergarten SET child_age = 5 WHERE adult_name = 'Monika';

TABLE kindergarten;

-- Bertovi je čtyři a pět let současně:
SELECT DISTINCT child_age FROM kindergarten WHERE child_name = 'Bert';

-- Opravíme:
UPDATE kindergarten SET child_age = 5 WHERE child_name = 'Bert';

SELECT DISTINCT child_age FROM kindergarten WHERE child_name = 'Bert';


-- Zjistíme, že Pavel si ze školky nesmí vyzvedávat Annu:

DELETE FROM kindergarten WHERE child_name = 'Anna' AND adult_name = 'Pavel';

-- Přišli jsme o Annu:
SELECT DISTINCT * FROM kindergarten WHERE child_name = 'Anna';

/*
Chybu nelze opravit. Mlčky předpokládáme, že každé dítě si může někdo vyzvednout.
*/

-- Pavla vrátíme:

INSERT INTO kindergarten ( child_name, child_age, adult_name ) VALUES
  ( 'Anna', 3, 'Pavel' );

TABLE kindergarten;
