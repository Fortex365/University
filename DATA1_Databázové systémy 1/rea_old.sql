DROP TABLE IF EXISTS brokers CASCADE;

CREATE TABLE brokers (
    name varchar(20) NOT NULL, 
    salary integer NOT NULL DEFAULT 0,
    PRIMARY KEY (name),
    CONSTRAINT salary_positive CHECK (salary >= 0)
);

-- Realitní makléř (name) má plat (salary).

DROP TABLE IF EXISTS property CASCADE;

CREATE TABLE property (
    name varchar(30) NOT NULL,
    PRIMARY KEY (name)
);

-- Nemovitost jménem (name), kterou realitní kancelář prodává.

DROP TABLE IF EXISTS property_owner CASCADE;

CREATE TABLE property_owner (
    owner varchar(20) NOT NULL,
    property varchar(30) NOT NULL,
    PRIMARY KEY (owner),
    FOREIGN KEY (property) REFERENCES property (name)
);

-- Vlastník (owner) vlastní nemovitost (name).

DROP TABLE IF EXISTS real_estate_agency CASCADE;

CREATE TABLE real_estate_agency (
    broker varchar(20) NOT NULL, 
    buyer varchar(20) NOT NULL, --to whom the property was sold
    seller varchar(20) NOT NULL, --the previous owner of the property
    buy_price INT NOT NULL, --the price the agency buyed the property
    sell_price INT NOT NULL, --the price the agency selled the property
    month_sold varchar(10) NOT NULL, --the month the transaction was made
    PRIMARY KEY (broker, buyer, seller),
    FOREIGN KEY (broker) REFERENCES brokers (name),
    FOREIGN KEY (seller) REFERENCES property_owner (owner),
    CONSTRAINT buy_price_sell_price_positive CHECK (buy_price > 0 AND sell_price > 0),
    CONSTRAINT buy_price_lesser_than_sell_price CHECK (buy_price < sell_price)
);

-- Realitní makléř (broker) prodává kupujímu (buyer) od původního majitele (seller) s nákupní cenou pro real. kancelář (buy_price) a prodává ji kupujícímu
-- za (sell_price) a to v daném období (month_sold).
INSERT INTO brokers (name, salary) VALUES
    ('Josef Ruml', 40000),
    ('Jan Mokrý', 40000);

INSERT INTO property (name) VALUES
    ('Kosinova 10, Olomouc'),
    ('Holická 20, Olomouc');

INSERT INTO property_owner (owner, property) VALUES
    ('Jiří Bolek', 'Kosinova 10, Olomouc'),
    ('Tomáš Marný', 'Holická 20, Olomouc');        

INSERT INTO real_estate_agency (broker, buyer, seller, buy_price, sell_price, month_sold) VALUES
    ('Josef Ruml', 'Petr Chalupa', 'Jiří Bolek', 2850000, 3000000, 'Leden'),
    ('Jan Mokrý', 'Jiří Bolek', 'Tomáš Marný', 2450000, 2500000, 'Leden');


-- Za období LEDEN

INSERT INTO brokers (name, salary) VALUES
    ('Alois Boura', 35000);

INSERT INTO property (name) VALUES
    ('Pavlovická 8, Olomouc');

INSERT INTO property_owner (owner, property) VALUES
    ('Karel Vejpustka', 'Pavlovická 8, Olomouc');

INSERT INTO real_estate_agency (broker, buyer, seller, buy_price, sell_price, month_sold) VALUES
    ('Alois Boura', 'Josef Nejezchleba', 'Karel Vejpustka', 1950000, 2000000, 'Únor');

-- Za období ÚNOR

INSERT INTO property (name) VALUES
    ('Olomoucká 4, Velký Týnec'),
    ('Opavská 4, Šternberk');

INSERT INTO property_owner (owner, property) VALUES
    ('Ivana Blatná', 'Olomoucká 4, Velký Týnec'),
    ('Jan Pavel', 'Opavská 4, Šternberk');

INSERT INTO real_estate_agency (broker, buyer, seller, buy_price, sell_price, month_sold) VALUES
    ('Josef Ruml', 'Tomáš Marný', 'Ivana Blatná', 5000000, 5250000, 'Březen'),
    ('Alois Boura', 'Jiří Lunt', 'Jan Pavel', 5700000, 6000000, 'Březen');

-- Za období BŘEZEN

INSERT INTO brokers (name) VALUES
    ('Honza Mokrý'); --salary wasnt mentioned at all, implicitly 0

INSERT INTO property (name) VALUES
    ('Bystrovanská 28, Olomouc');

INSERT INTO property_owner (owner, property) VALUES 
    ('Alena Koulová', 'Bystrovanská 28, Olomouc'),
    ('Petr Chalupa', 'Kosinova 10, Olomouc');

INSERT INTO real_estate_agency (broker, buyer, seller, buy_price, sell_price, month_sold) VALUES
    ('Josef Ruml', 'Petr Chalupa', 'Alena Koulová', 9700000, 10000000, 'Duben'),
    ('Honza Mokrý', 'Jiří Lunt', 'Petr Chalupa', 3400000, 3500000, 'Duben');

-- Za období DUBEN


-- 1) Nemovitosti, které se prodaly v daném měsíci

DROP VIEW IF EXISTS sold_in_january CASCADE;
DROP VIEW IF EXISTS sold_in_february CASCADE;
DROP VIEW IF EXISTS sold_in_march CASCADE;
DROP VIEW IF EXISTS sold_in_april CASCADE;

CREATE VIEW sold_in_january AS SELECT property FROM (SELECT * FROM (SELECT seller AS previous_owner FROM real_estate_agency WHERE month_sold = 'Leden') AS t1
    NATURAL JOIN (TABLE property_owner) AS t2) AS t3 WHERE previous_owner = owner;

CREATE VIEW sold_in_february AS SELECT property FROM (SELECT * FROM (SELECT seller AS previous_owner FROM real_estate_agency WHERE month_sold = 'Únor') AS t1
    NATURAL JOIN (TABLE property_owner) AS t2) AS t3 WHERE previous_owner = owner;

CREATE VIEW sold_in_march AS SELECT property FROM (SELECT * FROM (SELECT seller AS previous_owner FROM real_estate_agency WHERE month_sold = 'Březen') AS t1
    NATURAL JOIN (TABLE property_owner) AS t2) AS t3 WHERE previous_owner = owner;

CREATE VIEW sold_in_april AS SELECT property FROM (SELECT * FROM (SELECT seller AS previous_owner FROM real_estate_agency WHERE month_sold = 'Duben') AS t1
    NATURAL JOIN (TABLE property_owner) AS t2) AS t3 WHERE previous_owner = owner;


-- 2) Kdo prodal komu a za kolik nějakou nemovitost.

DROP VIEW IF EXISTS broker_selled_to_who CASCADE;

-- Kdo prodal komu ve smyslu, který makléř to zprostředkoval

CREATE VIEW broker_selled_to_who AS SELECT broker, buyer, sell_price AS price FROM (TABLE real_estate_agency) AS t1;

DROP VIEW IF EXISTS who_selled_to_whom CASCADE;

-- Kdo prodal komu ve smyslu původní majitel novému majiteli

CREATE VIEW who_selled_to_whom AS SELECT seller AS who_selled, buyer AS who_bought, sell_price AS price FROM (TABLE real_estate_agency) AS t1;


-- 3) Kolik RK vydělala na prodeji dané nemovitosti

DROP VIEW IF EXISTS property_profit CASCADE;

CREATE VIEW property_profit AS SELECT property, sell_price - buy_price AS profit FROM (
    SELECT * FROM (SELECT owner AS seller, property FROM property_owner) AS t1
        NATURAL JOIN (TABLE real_estate_agency) AS t2
) AS t3;

-- Konkrétně kolik RK vydělala za nemovitost "Kosinova 10, Olomouc", když jej prodávala vícekrát?
SELECT sum(profit) AS total_profit
    FROM (SELECT * FROM property_profit WHERE property = 'Kosinova 10, Olomouc') AS t1;


-- 4) Nejdražší již prodanou nemovitost

DROP VIEW IF EXISTS property_prices CASCADE;

CREATE VIEW property_prices AS SELECT property, sell_price AS price FROM (
    SELECT * FROM (SELECT owner AS seller, property FROM property_owner) AS t1
        NATURAL JOIN (TABLE real_estate_agency) AS t2
) AS t3;

SELECT property FROM property_prices WHERE price = (SELECT max(price) FROM (TABLE property_prices) AS t);


-- 5) Nemovitost prodanou s nejvyší provizí

SELECT property FROM property_profit WHERE profit = (SELECT max(profit) FROM (TABLE property_profit) AS t);


-- 6) Zákazníky, kteří nějakou nemovitost koupili a nějakou prodali.

DROP VIEW IF EXISTS who_bought_and_selled_something CASCADE;

CREATE VIEW who_bought_and_selled_something AS SELECT * FROM 
    (SELECT who_selled AS name FROM who_selled_to_whom WHERE who_selled IN 
        (SELECT who_bought FROM who_selled_to_whom)
    ) AS t2;

TABLE who_bought_and_selled_something;

-- 7) Zákazníky, kteří koupili i prodali tu samou nemovitost.

DROP VIEW IF EXISTS who_selled_to_whom_with_property CASCADE;

CREATE VIEW who_selled_to_whom_with_property AS SELECT * FROM (
    SELECT who_selled, who_bought, property FROM (TABLE who_selled_to_whom) AS t2 
    NATURAL JOIN (TABLE property_owner) AS t1) AS t;

DROP VIEW IF EXISTS selled_and_bought_same_property_help CASCADE;

CREATE VIEW selled_and_bought_same_property_help AS SELECT * FROM (
    SELECT *
    FROM who_selled_to_whom_with_property
    WHERE who_selled IN
        (SELECT who_bought FROM who_selled_to_whom_with_property)) AS t;

DROP VIEW IF EXISTS selled_and_bought_same_property CASCADE;

CREATE VIEW selled_and_bought_same_property AS SELECT * FROM (
    SELECT DISTINCT who_selled as name
    FROM selled_and_bought_same_property_help
    WHERE who_selled || property IN
        (SELECT who_bought || property from selled_and_bought_same_property_help)
) AS t;

TABLE selled_and_bought_same_property;