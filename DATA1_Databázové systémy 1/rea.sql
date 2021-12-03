DROP TABLE IF EXISTS brokers CASCADE;

CREATE TABLE brokers (
    name varchar(20) NOT NULL,
    salary integer NOT NULL DEFAULT 0,
    PRIMARY KEY (name),
    CONSTRAINT salary_positive CHECK (salary >= 0)
);
-- Realitní makléř (name) si vydělává plat (salary).


DROP TABLE IF EXISTS properties CASCADE;

CREATE TABLE properties (
    name varchar(30) NOT NULL,
    size varchar(20) NOT NULL DEFAULT 'Nespecifikováno'::varchar(20),
    PRIMARY KEY (name)
);
-- Nemovitost daná jménem (name) a její velikostí (size).


DROP TABLE IF EXISTS property_owner CASCADE;

CREATE TABLE property_owner (
    owner varchar(20) NOT NULL,
    property varchar(30) NOT NULL,
    PRIMARY KEY (owner),
    FOREIGN KEY (property) REFERENCES properties (name)
);
-- Vlastník (owner) vlastní nemovitost jménem (name).


DROP TABLE IF EXISTS buyers CASCADE;

CREATE TABLE buyers (
    rea_id integer NOT NULL,
    buyer varchar(20) NOT NULL,
    PRIMARY KEY (rea_id)
);
-- Kupec (buyer) má přiřazené své id této transakce (rea_id).
-- rea = real estate agency


DROP TABLE IF EXISTS sellers CASCADE;

CREATE TABLE sellers (
    rea_id integer NOT NULL,
    seller varchar(20) NOT NULL,
    PRIMARY KEY (rea_id),
    FOREIGN KEY (seller) REFERENCES property_owner (owner)
);
-- Prodávající aka původní majitel nemov. (seller) má přiřazené své id (rea_id).


DROP TABLE IF EXISTS _allowed_months CASCADE;

CREATE TABLE _allowed_months (
    name varchar(20) NOT NULL,
    PRIMARY KEY (name)
);
-- Jakožto seznam povolených jmen kalendářních měsíců.
-- Nechtěl jsem vytvářet svůj vlastní skalářní typ, protože bych musel
-- používat value == CAST('Leden' AS varchar(20)) např. a CAST jsme si neříkali.


DROP TABLE IF EXISTS months CASCADE;

CREATE TABLE months (
    rea_id integer NOT NULL,
    month_sold varchar(20) NOT NULL,
    PRIMARY KEY (rea_id),
    FOREIGN KEY (month_sold) REFERENCES _allowed_months (name)
);
-- Měsíc (month_sold) ve kterém se transakce uskutečnila.


DROP TABLE IF EXISTS transaction CASCADE;

CREATE TABLE transaction (
    rea_id integer NOT NULL,
    buy_price integer NOT NULL,
    sell_price integer NOT NULL,
    PRIMARY KEY (rea_id),
    CONSTRAINT buy_price_sell_price_positive CHECK (buy_price > 0 AND sell_price > 0),
    CONSTRAINT buy_price_lesser_than_sell_price CHECK (buy_price < sell_price)
);
-- Transakce má svoji nákupní cenu (buy_price) za kterou jej RK odkoupila
-- od původního majitele. A prodejní novou cenu (sell_price) za kterou ji
-- nyní prodává novému majiteli. Provize RK je sell_price - buy_price.


DROP TABLE IF EXISTS real_estate_agency CASCADE;

CREATE TABLE real_estate_agency (
    broker varchar(20) NOT NULL,
    rea_id integer NOT NULL,
    PRIMARY KEY (broker, rea_id)
);


-- ************ 
-- | NYNÍ NAPLNÍME NAŠI DATABÁZI RK DATY |
-- ************

-- ************
-- Za období LEDEN:
INSERT INTO _allowed_months (name) VALUES 
    ('Leden');

INSERT INTO months (rea_id, month_sold) VALUES
    (1, 'Leden'),
    (2, 'Leden');

INSERT INTO brokers (name, salary) VALUES
    ('Josef Ruml', 40000),
    ('Jan Mokrý', 40000);
-- V prvním měsíci máme dva zaměstnance.

INSERT INTO properties (name, size) VALUES
    ('Kosinova 10, Olomouc', '1+1');
-- Nemovitost u níž známe její doplňující informace.

INSERT INTO properties (name) VALUES
    ('Holická 20, Olomouc');
-- Nemovitost u níž neznáme její doplňující informace.

INSERT INTO property_owner (owner, property) VALUES
    ('Jiří Bolek', 'Kosinova 10, Olomouc'),
    ('Tomáš Marný', 'Holická 20, Olomouc');
-- Původní majitel nemovitosti a jeho nemovitost co prodává.

INSERT INTO sellers (rea_id, seller) VALUES
    (1, 'Jiří Bolek'),
    (2, 'Tomáš Marný');

INSERT INTO buyers (rea_id, buyer) VALUES
    (1, 'Petr Chalupa'),
    (2, 'Jiří Bolek');

INSERT INTO transaction (rea_id, buy_price, sell_price) VALUES
    (1, 2850000, 3000000),
    (2, 2450000, 2500000);

INSERT INTO real_estate_agency (broker, rea_id) VALUES
    ('Josef Ruml', 1),
    ('Jan Mokrý', 2);



-- ************
-- Za období ÚNOR:
INSERT INTO _allowed_months (name) VALUES 
    ('Únor');

INSERT INTO brokers (name, salary) VALUES
    ('Alois Boura', 35000);

INSERT INTO properties (name, size) VALUES
    ('Pavlovická 8, Olomouc', '2+1');

INSERT INTO property_owner (owner, property) VALUES
    ('Karel Vejpustka', 'Pavlovická 8, Olomouc');

INSERT INTO sellers (rea_id, seller) VALUES
    (3, 'Karel Vejpustka');

INSERT INTO buyers (rea_id, buyer) VALUES
    (3, 'Josef Nejezchleba');

INSERT INTO months (rea_id, month_sold) VALUES
    (3, 'Únor');

INSERT INTO transaction (rea_id, buy_price, sell_price) VALUES
    (3, 1950000, 2000000);

INSERT INTO real_estate_agency (broker, rea_id) VALUES
    ('Alois Boura', 3);



-- ************
-- Za období BŘEZEN:
INSERT INTO _allowed_months (name) VALUES 
    ('Březen');

INSERT INTO properties (name) VALUES
    ('Olomoucká 4, Velký Týnec');

INSERT INTO properties (name, size) VALUES
    ('Opavská 4, Šternberk', '4+1');

INSERT INTO property_owner (owner, property) VALUES
    ('Ivana Blatná', 'Olomoucká 4, Velký Týnec'),
    ('Jan Pavel', 'Opavská 4, Šternberk');

INSERT INTO sellers (rea_id, seller) VALUES
    (4, 'Ivana Blatná'),
    (5, 'Jan Pavel');

INSERT INTO buyers (rea_id, buyer) VALUES
    (4, 'Tomáš Marný'),
    (5, 'Jiří Lunt');

INSERT INTO months (rea_id, month_sold) VALUES
    (4, 'Březen'),
    (5, 'Březen');

INSERT INTO transaction (rea_id, buy_price, sell_price) VALUES
    (4, 5000000, 5250000),
    (5, 5700000, 6000000);

INSERT INTO real_estate_agency (broker, rea_id) VALUES
    ('Josef Ruml', 4),
    ('Alois Boura', 5);



-- ************
-- Za období DUBEN:
INSERT INTO _allowed_months (name) VALUES 
    ('Duben');

INSERT INTO brokers (name) VALUES
    ('Honza Mokrý'); 

INSERT INTO properties (name, size) VALUES
    ('Bystrovanská 28, Olomouc', '5+2');

INSERT INTO property_owner (owner, property) VALUES 
    ('Alena Koulová', 'Bystrovanská 28, Olomouc'),
    ('Petr Chalupa', 'Kosinova 10, Olomouc');

INSERT INTO sellers (rea_id, seller) VALUES
    (6, 'Alena Koulová'),
    (7, 'Petr Chalupa');

INSERT INTO buyers (rea_id, buyer) VALUES
    (6, 'Petr Chalupa'),
    (7, 'Jiří Lunt');

INSERT INTO months (rea_id, month_sold) VALUES
    (6, 'Duben'),
    (7, 'Duben');

INSERT INTO transaction (rea_id, buy_price, sell_price) VALUES
    (6, 9700000, 10000000),
    (7, 3400000, 3500000);

INSERT INTO real_estate_agency (broker, rea_id) VALUES
    ('Josef Ruml', 6),
    ('Honza Mokrý', 7);



-- 1) Nemovitosti, které se prodaly v daném měsíci

DROP VIEW IF EXISTS sold_in_january CASCADE;
DROP VIEW IF EXISTS sold_in_february CASCADE;
DROP VIEW IF EXISTS sold_in_march CASCADE;
DROP VIEW IF EXISTS sold_in_april CASCADE;


CREATE VIEW sold_in_january AS SELECT property FROM (
    (SELECT * FROM property_owner) AS t1 NATURAL JOIN (
        SELECT owner FROM (
            (SELECT rea_id, seller AS owner FROM sellers) AS t3 NATURAL JOIN (TABLE months) AS t4)
        WHERE month_sold='Leden'
    ) AS t2
);

CREATE VIEW sold_in_february AS SELECT property FROM (
    (SELECT * FROM property_owner) AS t1 NATURAL JOIN (
        SELECT owner FROM (
            (SELECT rea_id, seller AS owner FROM sellers) AS t3 NATURAL JOIN (TABLE months) AS t4)
        WHERE month_sold='Únor'
    ) AS t2
);

CREATE VIEW sold_in_march AS SELECT property FROM (
    (SELECT * FROM property_owner) AS t1 NATURAL JOIN (
        SELECT owner FROM (
            (SELECT rea_id, seller AS owner FROM sellers) AS t3 NATURAL JOIN (TABLE months) AS t4)
        WHERE month_sold='Březen'
    ) AS t2
);

CREATE VIEW sold_in_april AS SELECT property FROM (
    (SELECT * FROM property_owner) AS t1 NATURAL JOIN (
        SELECT owner FROM (
            (SELECT rea_id, seller AS owner FROM sellers) AS t3 NATURAL JOIN (TABLE months) AS t4)
        WHERE month_sold='Duben'
    ) AS t2
);

-- 2) Kdo prodal komu a za kolik nějakou nemovitost

DROP VIEW IF EXISTS who_selled_to_whom CASCADE;

CREATE VIEW who_selled_to_whom AS SELECT seller, buyer, sell_price FROM (
    ((SELECT * FROM sellers) AS t1 NATURAL JOIN (TABLE buyers) AS t2) AS t3
        NATURAL JOIN (TABLE transaction) AS t4
);

-- 3) Kolik RK vydělala na prodeji dané nemovitosti

DROP VIEW IF EXISTS rea_property_profit CASCADE;

CREATE VIEW rea_property_profit AS SELECT property, profit FROM (
    (SELECT seller AS owner, sell_price - buy_price AS profit FROM (
        (SELECT * FROM transaction) AS t1 NATURAL JOIN (TABLE sellers) AS t2
    )) AS t3 NATURAL JOIN (TABLE property_owner) AS t4
);

SELECT sum(profit) AS total_profit
    FROM (SELECT * FROM rea_property_profit WHERE property = 'Kosinova 10, Olomouc') AS t1;

-- 4) Nejdražší již prodanou nemovitost

DROP VIEW IF EXISTS rea_most_expansive_property CASCADE;

CREATE VIEW rea_most_expansive_property AS SELECT property FROM (
    (SELECT seller AS owner, sell_price AS price FROM 
    (
        (SELECT * FROM transaction) AS t1 NATURAL JOIN (TABLE sellers) AS t2
    ) WHERE sell_price =
        (SELECT max(sell_price) FROM (TABLE transaction) AS t5)) AS t3 NATURAL JOIN (TABLE property_owner) AS t4
);

-- 5) Nemovitost prodanou s nejvyší provizí

DROP VIEW IF EXISTS rea_most_property_profit CASCADE;

CREATE VIEW rea_most_property_profit AS SELECT * FROM (
    SELECT property FROM rea_property_profit 
        WHERE profit =
        (
            SELECT max(profit) FROM (TABLE rea_property_profit) AS t)
) AS t;

