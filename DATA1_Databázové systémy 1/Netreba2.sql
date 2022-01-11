DROP DOMAIN IF EXISTS STRING CASCADE;

CREATE DOMAIN STRING AS VARCHAR(64) CHECK (
    LENGTH(value) > 0
);

DROP DOMAIN IF EXISTS NATURAL_NUMBER CASCADE;

CREATE DOMAIN NATURAL_NUMBER AS INT CHECK (
    value > 0
);

DROP TABLE IF EXISTS Contacts CASCADE;

CREATE TABLE Contacts (
    id INT NOT NULL,
    name STRING NOT NULL,
    surname STRING NOT NULL, 
    CONSTRAINT contacts_id_pkey PRIMARY KEY (id)
);

-- Kontakty realitní kanceláře svých zákazníků i pracovníků.
-- Kontakt (id) má jméno (name) a své přijmení (surname).

DROP TABLE IF EXISTS Brokers CASCADE;

CREATE table Brokers (
    id_contact INT NOT NULL,
    salary NATURAL_NUMBER NOT NULL,
    start_date DATE NOT NULL,
    CONSTRAINT brokers_id_contact_pkey PRIMARY KEY (id_contact),
    CONSTRAINT brokers_id_contact_fkey FOREIGN KEY (id_contact) REFERENCES Contacts(id)
);

-- Kontakty pracovníků.
-- Kontakt (id_contact) má plat (salary) a datum nástupu (start_date).

DROP TABLE IF EXISTS FlatTypes CASCADE;

CREATE TABLE FlatTypes (
    id INT NOT NULL,
    type STRING NOT NULL,
    CONSTRAINT flattypes_id_pkey PRIMARY KEY (id)
);

-- Seznam typů různých bytů.
-- Byt (id) má typ (type).

DROP TABLE IF EXISTS Properties CASCADE;

CREATE TABLE Properties (
    id INT NOT NULL,
    city STRING NOT NULL,
    street STRING NOT NULL,
    code STRING NOT NULL DEFAULT 'N/A'::varchar(64),
    CONSTRAINT properties_id_pkey PRIMARY KEY (id)
);

-- Seznam nemovitostí.
-- Nemovitost (id) je ve městě (city) na ulici (street) s popisným číslem (code).

DROP TABLE IF EXISTS Lands CASCADE;

CREATE TABLE Lands (
    id INT NOT NULL, 
    id_property INT NOT NULL,
    area NATURAL_NUMBER NOT NULL,
    CONSTRAINT lands_id_pkey PRIMARY KEY (id),
    CONSTRAINT lands_id_property_fkey FOREIGN KEY (id_property) REFERENCES Properties(id)
);

-- Seznam pozemků.
-- Pozemek (id) nemovitosti (id_property) má rozměru (area).

DROP TABLE IF EXISTS Flats CASCADE;

CREATE TABLE Flats (
    id INT NOT NULL,
    id_property INT NOT NULL,
    id_type INT NOT NULL, 
    rooms NATURAL_NUMBER NOT NULL,
    rooms_plus NATURAL_NUMBER NOT NULL,
    has_kitchen BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT flats_id_pkey PRIMARY KEY (id),
    CONSTRAINT flats_id_property_fkey FOREIGN KEY (id_property) REFERENCES Properties(id),
    CONSTRAINT flats_id_type_fkey FOREIGN KEY (id_type) REFERENCES FlatTypes(id),
    CONSTRAINT flats_has_kitchen_plus_rooms_exlusion CHECK ((rooms > 0) != has_kitchen)
);

-- Seznam bytů.
-- Byt (id) je nemovitostí (id_property) typu (id_type) s mítnostmi (rooms) a místnostmi navíc (rooms_plus) a kuchyní (has_kitchen).

DROP TABLE IF EXISTS Transactions CASCADE;

CREATE TABLE Transactions (
    id INT NOT NULL, 
    id_seller INT NOT NULL, 
    id_buyer INT NOT NULL,
    id_broker INT NOT NULL,
    id_property INT NOT NULL,
    price INT NOT NULL DEFAULT 0,
    commission INT NOT NULL DEFAULT 0,
    date DATE NOT NULL, 
    CONSTRAINT transactions_id_pkey PRIMARY KEY (id),
    CONSTRAINT transactions_id_seller_fkey FOREIGN KEY (id_seller) REFERENCES Contacts(id),
    CONSTRAINT transactions_id_buyer_fkey FOREIGN KEY (id_buyer) REFERENCES Contacts(id),
    CONSTRAINT transactions_id_broker_fkey FOREIGN KEY (id_broker) REFERENCES Brokers(id_contact),
    CONSTRAINT transaction_id_property_fkey FOREIGN KEY (id_property) REFERENCES Properties(id),
    CONSTRAINT transactions_price_greater_than_commission CHECK (price > commission)
);

-- Seznam obchodních transakcí.
-- Transakce (id) s prodávajícím (id_seller) a nakupujícím (id_buyer) zprostředkována (id_broker) o nemovitost (id_property) s cenou (price) a provizí (commission) dne (date).

INSERT INTO Contacts (id, name, surname) VALUES
    (1,'Petr','Chalupa'),
    (2,'Jiří','Bolek'),
    (3,'Tomáš','Marný'),
    (4,'Karel','Vejpustek'),
    (5,'Josef','Nejezchleba'),
    (6,'Ivana','Blatná'),
    (7,'Jan','Pavel'),
    (8,'Jiří','Lunt'),
    (9,'Alena','Koulová'),
    (10,'Josef','Ruml'),
    (11,'Jan','Mokrý'),
    (12,'Alois','Boura'),
    (13,'Jiřina','Nováková');

INSERT INTO Brokers (id_contact, salary, start_date) VALUES
    (10, 40000, '2021-01-01'),
    (11, 40000, '2021-01-01'),
    (12, 35000, '2021-02-06');

INSERT INTO Properties (id, city, street, code) VALUES
    (1, 'Olomouc', 'Kosinova', '10'),
    (2, 'Olomouc', 'Holická', '20'),
    (3, 'Olomouc', 'Pavlovická', '10'),
    (4, 'Velký Týnec', 'Olomoucká', '4'),
    (5, 'Šternberk', 'Opavská', '4'),
    (6, 'Olomouc', 'Bystrovanská', '28'),
    (7, 'Olomouc', 'Riegrova', '10');

INSERT INTO Lands (id, id_property, area) VALUES
    (1, 2, 800);

INSERT INTO FlatTypes (id, type) VALUES
    (1, 'byt'),
    (2, 'řadový dům'),
    (3, 'rodinný dům'),
    (4, 'domek');

INSERT INTO Flats (id, id_property, id_type, rooms, rooms_plus) VALUES
    (1, 1, 1, 1, 1),
    (2, 3, 1, 2, 1),
    (3, 4, 3, 6, 1),
    (4, 5, 2, 4, 1),
    (5, 6, 4, 5, 2),
    (6, 7, 1, 2, 1);

INSERT INTO Transactions (id, id_seller, id_buyer, id_broker, id_property, price, commission, date) VALUES
    (1, 2, 1, 10, 1, 3000000, 150000, '2021-01-22'),
    (2, 3, 2, 11, 2, 2500000, 50000, '2021-01-24'),
    (3, 4, 5, 12, 3, 2000000, 50000, '2021-02-12'),
    (4, 6, 3, 10, 4, 5250000, 250000, '2021-03-23'),
    (5, 7, 8, 12, 5, 6000000, 300000, '2021-03-23'),
    (6, 9, 1, 10, 6, 10000000, 300000, '2021-04-14'),
    (7, 1, 8, 11, 1, 3500000, 100000, '2021-04-18'),
    (8, 13, 10, 10, 7, 4000000, 0, '2021-04-30');


--*********
-- Dotazy: 
--*********


-- 1, Nemovitosti, které se prodaly v daném měsíci.

SELECT EXTRACT(MONTH FROM t.date) AS month, p.city AS city, p.street AS street, p.code AS house_code FROM
    (SELECT city, street, code, id AS id_property FROM Properties) AS p
    NATURAL JOIN
    (SELECT id_property, date FROM Transactions) AS t;

-- 2, Kdo prodal komu a za kolik nějakou nemovitost.

SELECT seller_name, seller_surname, buyer_name, buyer_surname, price FROM 
    (SELECT id_seller, id_buyer, price FROM Transactions) AS t
    NATURAL JOIN
    (SELECT c.name AS seller_name, c.surname AS seller_surname, c.id AS id_seller,
    cc.name AS buyer_name, cc.surname AS buyer_surname, cc.id AS id_buyer FROM Contacts AS c, Contacts AS cc) AS h;

-- 3. Kolik RK vydělala na prodeji dané nemovitosti.

SELECT p.city, p.street, p.code AS house_code, t.commission FROM
    (SELECT id_property, commission FROM Transactions) AS t
    NATURAL JOIN
    (SELECT id AS id_property, city, street, code FROM Properties) AS p;

-- 4, Nejdražší již prodanou nemovitost (pokud je jich více s maximální cenou, tak všechny takové).

SELECT p.id_property AS id, p.city, p.street, p.code AS house_code FROM
    (SELECT id_property, price FROM Transactions) AS t
    NATURAL JOIN
    (SELECT id AS id_property, city, street, code FROM Properties) AS p
        WHERE t.price = (SELECT max(price) FROM Transactions);

-- 5, Nemovitost prodanou s největší provizí (pokud je jich více s maximální provizí, tak všechny takové).

SELECT p.id_property AS id, p.city, p.street, p.code AS house_code FROM
    (SELECT id_property, commission FROM Transactions) AS t
    NATURAL JOIN
    (SELECT id AS id_property, city, street, code FROM Properties) AS p
        WHERE t.commission = (SELECT max(commission) FROM Transactions);

-- 6, Zákazníky, kteří nějakou nemovitost koupili a nějakou prodali.

SELECT c.id_buyer AS id, c.name, c.surname FROM
        (SELECT id_buyer FROM Transactions) AS t
        NATURAL JOIN 
        (SELECT id AS id_buyer, name, surname FROM Contacts) AS c
    INTERSECT
        SELECT cc.id_seller AS id, cc.name, cc.surname FROM
            (SELECT id_seller FROM Transactions) AS t
            NATURAL JOIN
            (SELECT id AS id_seller, name, surname FROM Contacts) AS cc;

-- 7, Zákazníky, kteří koupili i prodali tu samou nemovitost.

SELECT c.id_contact AS id, c.name, c.surname FROM
    (SELECT id AS id_contact, name, surname FROM Contacts) AS c
    NATURAL JOIN
    (SELECT t1.id_seller AS id_contact FROM Transactions AS t1, Transactions AS t2
        WHERE t1.id_property = t2.id_property AND t1.id_seller = t2.id_buyer) AS h;

-- 8, Který zaměstnanec vydělal na provizích nejvíce v daném období.

SELECT id_broker AS id, name, surname FROM 
    (SELECT id_broker FROM 
        (SELECT id_broker, commission, date FROM Transactions) AS t
            WHERE date BETWEEN '2021-01-01' AND '2021-12-31' GROUP BY id_broker
        HAVING sum(t.commission) = (SELECT max(summation) FROM 
            (SELECT id_broker, sum(t.commission) AS summation FROM 
                (SELECT id_broker, commission, date FROM Transactions) AS t
                    WHERE date BETWEEN '2021-01-01' AND '2021-12-31' GROUP BY id_broker
            ) AS s)) AS h
    NATURAL JOIN
    (SELECT id AS id_broker, name, surname FROM Contacts) AS c;

-- 9, Zaměstnance, kteří v zadaném měsíci získali menší provize než je jejich plat.

SELECT id_broker AS id, name, surname FROM 
    (SELECT id_broker FROM
        (SELECT id_broker, commission FROM Transactions
            WHERE EXTRACT(MONTH FROM date) = 4
        UNION
        SELECT id_contact AS id_broker, 0 AS commission FROM Brokers) AS h GROUP BY id_broker
            HAVING sum(h.commission) < (SELECT salary FROM Brokers WHERE id_contact = h.id_broker)
    ) AS t
    NATURAL JOIN
    (SELECT id AS id_broker, name, surname FROM Contacts) AS c;

-- 10, Zaměstnance, kteří za celou dobu od svého nástupu získali v součtu menší provize, než byl součet jejich platů.

SELECT id_contact AS id, name, surname, summation AS commission_sum, t AS salary_to_may FROM
    (SELECT id_contact, k.summ AS summation,
    (DATE_PART('year', '2021-05-01'::DATE) - DATE_PART('year', start_date)) + 
        (DATE_PART('month', '2021-05-01'::DATE) - DATE_PART('month', start_date)) * salary AS t FROM Brokers
    NATURAL JOIN
    (SELECT id_contact, sum(commission) AS summ FROM
        (SELECT id_broker AS id_contact, commission FROM Transactions
        UNION
        SELECT id_contact, 0 AS commission FROM Brokers) AS b GROUP BY id_contact) AS k
    ) AS h
    NATURAL JOIN
    (SELECT id AS id_contact, name, surname FROM Contacts) AS c
        WHERE summation < t;