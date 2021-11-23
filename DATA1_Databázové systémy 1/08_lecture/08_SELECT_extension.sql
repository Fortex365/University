-- Uvažujeme relační proměnnou results.

DROP TABLE IF EXISTS results CASCADE;

CREATE TABLE results (
  student_name varchar(10) NOT NULL,
  mathematics integer NOT NULL,
  informatics integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal z testu z matematiky 'mathematics' bodů a z testu z informatiky 'informatics' bodů.

INSERT INTO results ( student_name, mathematics, informatics) VALUES
  ( 'Anna', 2, 3 ),
  ( 'Bert', 0, 1 ),
  ( 'Cyril', 5, 4 );

TABLE results;

/*
Tvar SELECT výrazu:
( SELECT <output_attributes_description> FROM <input_relations_descriptions> WHERE <condition> )

Připomeňme, že výraz SELECT se provádí v těchto krocích:
1. Získání vstupních relací
2. Přejmenování na vstupní atributy
3. Spojení
4. Restrikce
5. Projekce
6. Přejmenování na výstupní atributy
*/


/*
Popis výstupního atributu v SELECT výrazu můžeme mít tvar:

<scalar_expression> AS <attribute>

kde <scalar_expression> je skalární výraz a <attribute> je jméno výstupního atributu.

Mezi 4. a 5. krok vložíme krok nový: Rozšíření.

Kroky přečíslujeme:

...
4. Restrikce
5. Rozšíření
6. Projekce
7. Přejmenování na výstupní atributy

Pátý krok probíhá tak, že pro každý popis výstupního atributu tvaru:

<scalar_expression> AS <attribute>

se zvolí dosud nepoužitý název atributu 'A' a spočítá rozšíření o atribut 'A' vypočítaný výrazem <scalar_expression>.

V kroku šest se provádí projekce i na zvolený atribut 'A'.

Nakonec krok sedm provede přejmenování 'A' na <attribute>.
*/

-- Součet hodnot atributů:
SELECT student_name, mathematics + informatics AS total FROM results;

-- Lze rozepsat:
SELECT DISTINCT student_name, temp_a AS total FROM ( 
  SELECT *, mathematics + informatics AS temp_a FROM results
) AS t1;

-- Výraz:
SELECT student_name, mathematics + 1 AS mathematics FROM results;

-- Znamená:
SELECT DISTINCT student_name, temp_a AS total FROM ( 
  SELECT *, mathematics + 1 AS temp_a FROM results
) AS t1;

