DROP TABLE IF EXISTS R CASCADE;

CREATE TABLE R (
    Jmeno varchar(20),
    Vek varchar(20)
);

INSERT INTO R VALUES 
    ('Josef', '10'),
    ('Tom', '20'),
    ('Jan', '30');

DROP TABLE IF EXISTS S CASCADE;

CREATE TABLE S (
    Jmeno varchar(20),
    Vek varchar(20)
);

INSERT INTO S VALUES
    ('Tom', '20'),
    ('Josef', '20'),
    ('Jan', '20');

DROP TABLE IF EXISTS T CASCADE;

CREATE TABLE T (
    Jmeno varchar(20),
    Prijmeni varchar(20)
);

INSERT INTO T VALUES
    ('Jan', 'Nový'),
    ('Josef', 'Novák');

DROP TABLE IF EXISTS W CASCADE;

CREATE TABLE W (
    Vek varchar(20),
    Prijmeni varchar(20),
    Bydliste varchar(20)
);

INSERT INTO W VALUES
    ('20', 'Novák', 'Olomouc'),
    ('15', 'Novák', 'Olomouc'),
    ('30', 'Blatný', 'Praha'),
    ('30', 'Kodlet', 'Brno'),
    ('40', 'Brázdil', 'Olomouc');