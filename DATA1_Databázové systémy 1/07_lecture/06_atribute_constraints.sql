/*
Popis atributu při deklaraci základní relační proměnné má tento tvar:

jméno_atributu typ_atributu omezení_atributu

NOT NULL je omezení atributu, které zatím uvádíme povinně.

Pokud 'v' je hodnota typu 'typ_atributu', pak

DEFAULT v

je omezení atributu, které definuje výchozí hodnotu atributu. (Název omezení atributu je v tomto případě zavádějící.)

Jednotlivá omezení oddělujeme mezerou.
*/

-- Deklarujeme relační proměnnou child, s výchozím věkem tři roky:

DROP TABLE IF EXISTS child CASCADE;

CREATE TABLE child (
  name varchar(10) NOT NULL,
  picture varchar(10) NOT NULL,
  age integer NOT NULL DEFAULT 3,
  PRIMARY KEY ( name )
);

-- Predikát: Dítě jménem 'name' chodí do školky, má na skříňce obrázek 'picture' a je mu 'age' let.

-- Při vkládání n-tic do relační proměnné nemusíme uvádět atributy s výchozí hodnotou:

INSERT INTO child ( name, picture ) VALUES
  ( 'Anna', 'slunce' );

-- Anně budou tři roky:

TABLE child;
