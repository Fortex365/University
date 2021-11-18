/*
Jméno atributu je skalární výraz. Jeho hodnota vzhledem k n-tici je hodnotou, kterou mu n-tice přiřazuje.
*/

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL,
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem 'name' chodí do školky.

INSERT INTO child ( name ) VALUES
  ( 'Anna' ),
  ( 'Bert' ),
  ( 'Cyril' );

TABLE child;


SELECT *, name AS name2 FROM ( TABLE child ) AS t;