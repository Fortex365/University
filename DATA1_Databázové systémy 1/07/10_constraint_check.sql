-- Deklarujeme relační proměnnou child_history:

DROP TABLE IF EXISTS child_history CASCADE;

CREATE TABLE child_history (
  name varchar(10) NOT NULL,
  year_from integer NOT NULL,
  year_to integer NOT NULL,
  PRIMARY KEY ( name, year_from, year_to )
);

-- Predikát: Dítě jménem 'name' chodilo do školky od roku 'year_from' do roku 'year_to'.

INSERT INTO child_history (name, year_from, year_to) VALUES
  ( 'Anna', 2015, 2018 ),
  ( 'Anna', 2000, 2004 ),
  ( 'Bert', 2016, 2017 );

TABLE child_history;

-- Nesmysl:

INSERT INTO child_history (name, year_from, year_to) VALUES
  ( 'Cyril', 2002, 2000 );

TABLE child_history;

-- Opravíme:

UPDATE child_history SET year_from = 2000, year_to = 2002 WHERE name = 'Cyril';

-- (Můžeme nastavit hodnoty více atributům najednou.)

TABLE child_history;

-- Vytvoříme bezpečný pohled:

DROP VIEW IF EXISTS child_history_safe CASCADE;
CREATE VIEW child_history_safe AS SELECT * FROM child_history WHERE year_from < year_to WITH CHECK OPTION;

-- Nesmysl už nelze přidat:

INSERT INTO child_history_safe (name, year_from, year_to) VALUES
  ( 'Eduard', 1984, 1980 );


/*
Nešikovné řešení: integritu by měla hlídat už základní relační proměnná.

Zavedeme tedy integritní omezení pro základní relační proměnné.

R: relační proměnná nad A1, ..., An
c: podmínka nad A1, ..., An
n: jméno integritního omezení

CONSTRAINT n CHECK (c)
...integritní omezení

Každá n-tice relace R musí splňovat podmínku c.
*/

ALTER TABLE child_history ADD CONSTRAINT child_history_check CHECK (year_from < year_to);

-- Nesmysl nelze přidat ani do základní proměnné:

INSERT INTO child_history ( name, year_from, year_to ) VALUES ( 'Eduard', 1984, 1980 );

-- Pohled již nepotřebujeme:

DROP VIEW IF EXISTS child_history_safe CASCADE;


-- Deklarujeme relační proměnnou child_history rovnou s kontrolou:

DROP TABLE IF EXISTS child_history CASCADE;

CREATE TABLE child_history (
  name varchar(10) NOT NULL,
  year_from integer NOT NULL,
  year_to integer NOT NULL,
  PRIMARY KEY ( name, year_from, year_to ),
  CONSTRAINT child_history_check CHECK (year_from < year_to)
);

-- Predikát: Dítě jménem 'name' chodilo do školky od roku 'year_from' do roku 'year_to'.

INSERT INTO child_history (name, year_from, year_to) VALUES
  ( 'Anna', 2015, 2018 ),
  ( 'Anna', 2000, 2004 ),
  ( 'Bert', 2016, 2017 );

TABLE child_history;


-- Nesmysl nelze přidat:

INSERT INTO child_history ( name, year_from, year_to ) VALUES ( 'Eduard', 1984, 1980 );