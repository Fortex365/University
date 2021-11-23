-- Uvažujeme relační proměnnou result.

DROP TABLE IF EXISTS result CASCADE;

CREATE TABLE result (
  student_name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal 'score' bodů. 

INSERT INTO result ( student_name, score ) VALUES
  ( 'Anna', 5 ),
  ( 'Bert', 2 ),
  ( 'Cyril', 4 );

SELECT *, score > 3 AS pass FROM result;