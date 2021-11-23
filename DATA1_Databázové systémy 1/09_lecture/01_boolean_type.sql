/*
Zavedeme si (skalární) typ boolean, který pojmenovává množinu {true, false}.

Hodnota 'true' reprezentuje pravdu a 'false' nepravdu.
*/

-- Uvažujeme relační proměnnou pass_exam.

DROP TABLE IF EXISTS pass_exam CASCADE;

CREATE TABLE pass_exam (
  student_name varchar(10) NOT NULL,
  pass boolean NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' složil zkoušku, právě když 'pass' je pravdivé. 

INSERT INTO pass_exam ( student_name, pass ) VALUES
  ( 'Anna', true ),
  ( 'Bert', false ),
  ( 'Cyril', true );

TABLE pass_exam;

SELECT * FROM pass_exam WHERE pass = true;

SELECT * FROM pass_exam WHERE pass = false;