/*
Volání funkce je skalární výraz.

Volání funkce má tvar:

<function>(<expr1>, ..., <exprN>)

kde 
 - <function> je jméno funkce, která očekává N argumentů a
 - <expr1>, ..., <exprN> jsou skalární výrazy.

Typy skalárních výrazů musí korespondovat s očekávanými typy argumentů funkce.
*/

/*
Funkce char_length očekává jeden textový argument (typ VARCHAR(n)) a vrací délku řetězce.
*/

SELECT char_length('Anna') AS result;

-- Uvažujeme relační proměnnou result.

DROP TABLE IF EXISTS result CASCADE;

CREATE TABLE result (
  student_name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' složil získal 'score' bodů. 

INSERT INTO result ( student_name, score ) VALUES
  ( 'Anna', 2 ),
  ( 'Bert', 3 ),
  ( 'Cyril', 4 );

TABLE result;

SELECT student_name, char_length(student_name) AS name_length FROM result;

/*
Přehled funkcí a operátorů:
https://www.postgresql.org/docs/14/functions.html
*/