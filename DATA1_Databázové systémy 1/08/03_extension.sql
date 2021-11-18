/*
Zavedeme si novou relační operaci: rozšíření
*/

/*
r: relace nad A1, ..., An
B: atribut různý od A1, ..., An
e: skalární výraz

Rozšířením relace 'r' o atribut 'B' vypočítaný výrazem 'e' je relace 's' nad A1, ..., An, B.

n-tice 't' náleží do těla relace 's' právě tehdy, když:

1) projekce 't' na A1, ..., An  (označíme si ji 't1') náleží do těla relace 'r',
2) n-tice 't' přiřazuje atributu 'B' hodnotu výrazu 'e' vzhledem k n-tici 't1'.
*/

/*
<relation_expression> je relační výraz typu A1, ..., An
<attribute> je jméno atributu, který je různý od A1, ..., An
<scalar_expression> je skalární výraz nad atributy A1, ..., An
<relation_name> je jméno relace (nepoužívá se)

Relační výraz rozšíření:
( SELECT *, <scalar_expression> AS <attribute> FROM ( <relation_expression> ) AS <relation_name> )

'r' je hodnota výrazu <relation_expression>

Hodnota výrazu rozšíření je rozšíření relace 'r' o atribut <attribute> vypočítaný výrazem <scalar_expression>.
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

SELECT *, 1 AS const FROM ( TABLE child ) AS t;