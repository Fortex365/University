-- Uvažujeme relační proměnnou result.

DROP TABLE IF EXISTS result CASCADE;

CREATE TABLE result (
  student_name varchar(10) NOT NULL,
  score integer NOT NULL,
  PRIMARY KEY ( student_name )
);

-- Predikát: Student jménem 'student_name' získal z testu 'score' bodů.

INSERT INTO result ( student_name, score) VALUES
  ( 'Anna', 2),
  ( 'Bert', 0),
  ( 'Cyril', 5);

TABLE result;

UPDATE result SET score = score + 1 WHERE student_name = 'Anna';