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
    CONSTRAINT buy_price_lesser_equal_than_sell_price CHECK (buy_price <= sell_price)
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
    ('Jan Mokrý', 7);



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

TABLE sold_in_april;
TABLE sold_in_february;
TABLE sold_in_march;
TABLE sold_in_april;

-- 2) Kdo prodal komu a za kolik nějakou nemovitost

DROP VIEW IF EXISTS who_selled_to_whom CASCADE;

CREATE VIEW who_selled_to_whom AS SELECT seller, buyer, sell_price FROM (
    ((SELECT * FROM sellers) AS t1 NATURAL JOIN (TABLE buyers) AS t2) AS t3
        NATURAL JOIN (TABLE transaction) AS t4
);

TABLE who_selled_to_whom;

-- 3) Kolik RK vydělala na prodeji dané nemovitosti

DROP VIEW IF EXISTS rea_property_profit CASCADE;

CREATE VIEW rea_property_profit AS SELECT property, profit FROM (
    (SELECT seller AS owner, sell_price - buy_price AS profit FROM (
        (SELECT * FROM transaction) AS t1 NATURAL JOIN (TABLE sellers) AS t2
    )) AS t3 NATURAL JOIN (TABLE property_owner) AS t4
);

TABLE rea_property_profit;

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

TABLE rea_most_expansive_property;

-- 5) Nemovitost prodanou s nejvyší provizí

DROP VIEW IF EXISTS rea_most_property_profit CASCADE;

CREATE VIEW rea_most_property_profit AS SELECT * FROM (
    SELECT property FROM rea_property_profit 
        WHERE profit =
        (
            SELECT max(profit) FROM (TABLE rea_property_profit) AS t)
) AS t;

TABLE rea_most_property_profit;

-- 6) Zákazníky, kteří nějakou nemovitost koupili a nějakou prodali.

DROP VIEW IF EXISTS who_selled_to_whom CASCADE;

CREATE VIEW who_selled_to_whom AS SELECT * FROM (
    SELECT * FROM
    ((SELECT * FROM sellers) AS t1 NATURAL JOIN (TABLE buyers) AS t2) AS t3
) AS t;

DROP VIEW IF EXISTS who_bought_and_selled_something CASCADE;

CREATE VIEW who_bought_and_selled_something AS SELECT * FROM (
    (SELECT seller AS name FROM who_selled_to_whom WHERE
    seller IN
        (SELECT buyer FROM who_selled_to_whom) 
    )
) AS t;

TABLE who_bought_and_selled_something;

-- 7) Zákazníky, kteří koupili i prodali tu samou nemovitost.

DROP VIEW IF EXISTS who_selled_to_whom_with_property CASCADE;

CREATE VIEW who_selled_to_whom_with_property AS SELECT * FROM (
    (SELECT seller, buyer FROM who_selled_to_whom) AS t2 
    NATURAL JOIN (SELECT owner AS seller, property FROM property_owner) AS t1
) AS t;

DROP VIEW IF EXISTS who_selled_and_bought_same_property_helpb CASCADE;

CREATE VIEW who_selled_and_bought_same_property_helpb AS SELECT * FROM (
    SELECT * FROM who_selled_to_whom_with_property WHERE 
    seller IN
        (SELECT buyer FROM who_selled_to_whom_with_property)
) AS t;

DROP VIEW IF EXISTS who_selled_and_bought_same_property_back CASCADE;

CREATE VIEW who_selled_and_bought_same_property_back AS SELECT * FROM (
    SELECT DISTINCT seller AS name FROM who_selled_and_bought_same_property_helpb WHERE
    seller || property IN
        (SELECT buyer || property FROM who_selled_and_bought_same_property_helpb)
) AS t;

TABLE who_selled_and_bought_same_property_back;

-- *********
-- Nová data

INSERT INTO properties (name, size) VALUES  
    ('Riegerova 10, Olomouc', '2+1');

INSERT INTO property_owner (owner, property) VALUES
    ('Jiřina Nováková', 'Riegerova 10, Olomouc');

INSERT INTO buyers (rea_id, buyer) VALUES
    (8, 'Josef Ruml');

INSERT INTO sellers (rea_id, seller) VALUES
    (8, 'Jiřina Nováková');

INSERT INTO months (rea_id, month_sold) VALUES
    (8, 'Duben');

INSERT INTO transaction (rea_id, buy_price, sell_price) VALUES
    (8, 4000000, 4000000);

INSERT INTO real_estate_agency (broker, rea_id) VALUES
    ('Josef Ruml', 8);

-- 8) Který zaměstnanec vydělal na provizích nejvíce v daném období

DROP VIEW IF EXISTS id_property_profit CASCADE;

CREATE VIEW id_property_profit AS SELECT rea_id, property, profit FROM (
    (SELECT rea_id, seller AS owner, sell_price - buy_price AS profit FROM (
        (SELECT * FROM transaction) AS t1 NATURAL JOIN (TABLE sellers) AS t2
    )) AS t3 NATURAL JOIN (TABLE property_owner) AS t4
);

DROP VIEW IF EXISTS property_profit_employee_help CASCADE;

CREATE VIEW property_profit_employee_help AS
SELECT * FROM (
    ((SELECT * FROM id_property_profit) AS t1 NATURAL JOIN (TABLE real_estate_agency) AS t2)
 AS t3 NATURAL JOIN (TABLE months) AS t4);

DROP VIEW IF EXISTS employee_profit_january CASCADE;
DROP VIEW IF EXISTS employee_profit_february CASCADE;
DROP VIEW IF EXISTS employee_profit_march CASCADE;
DROP VIEW IF EXISTS employee_profit_april CASCADE;

CREATE VIEW employee_profit_january AS SELECT * FROM (
    SELECT rea_id, profit, broker FROM property_profit_employee_help WHERE month_sold='Leden'
) AS t;

CREATE VIEW employee_profit_february AS SELECT * FROM (
    SELECT rea_id, profit, broker FROM property_profit_employee_help WHERE month_sold='Únor'
) AS t;

CREATE VIEW employee_profit_march AS SELECT * FROM (
    SELECT rea_id, profit, broker FROM property_profit_employee_help WHERE month_sold='Březen'
) AS t;

CREATE VIEW employee_profit_april AS SELECT * FROM (
    SELECT rea_id, profit, broker FROM property_profit_employee_help WHERE month_sold='Duben'
) AS t;

-- Za leden

DROP VIEW IF EXISTS employee_top_profit_in_january CASCADE;

CREATE VIEW employee_top_profit_in_january AS SELECT * FROM (
    SELECT broker FROM employee_profit_january
    WHERE profit = (
        SELECT max(total_profit) FROM (
            SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_january) AS t
            GROUP BY broker) AS t1
    )
) AS t2;

TABLE employee_top_profit_in_january;

-- Za únor 

DROP VIEW IF EXISTS employee_top_profit_in_february CASCADE;

CREATE VIEW employee_top_profit_in_february AS SELECT * FROM (
    SELECT broker FROM employee_profit_february
    WHERE profit = (
        SELECT max(total_profit) FROM (
            SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_february) AS t
            GROUP BY broker) AS t1
    )
) AS t2;

TABLE employee_top_profit_in_february;

-- Za březen

DROP VIEW IF EXISTS employee_top_profit_in_march CASCADE;

CREATE VIEW employee_top_profit_in_march AS SELECT * FROM (
    SELECT broker FROM employee_profit_march
    WHERE profit = (
        SELECT max(total_profit) FROM (
            SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_march) AS t
            GROUP BY broker) AS t1
    )
) AS t2;

TABLE employee_top_profit_in_march;

-- Za duben

DROP VIEW IF EXISTS employee_top_profit_in_april CASCADE;

CREATE VIEW employee_top_profit_in_april AS SELECT * FROM (
    SELECT broker FROM employee_profit_april
    WHERE profit = (
        SELECT max(total_profit) FROM (
            SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_april) AS t
            GROUP BY broker) AS t1
    )
) AS t2;

TABLE employee_top_profit_in_april;

-- 9) Zaměstnance, kteří v zadaném měsíci získali menší provize než je jejich plat

DROP VIEW IF EXISTS employee_profit_worse_than_salary_january CASCADE;
DROP VIEW IF EXISTS employee_profit_worse_than_salary_february CASCADE;
DROP VIEW IF EXISTS employee_profit_worse_than_salary_march CASCADE;
DROP VIEW IF EXISTS employee_profit_worse_than_salary_april CASCADE;

-- V lednu

CREATE VIEW employee_profit_worse_than_salary_january AS SELECT * FROM (  
    (SELECT name AS broker FROM brokers) 
    EXCEPT
    (SELECT broker FROM (
        SELECT * FROM (
            (SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_january) AS t5
            GROUP BY broker) AS t1 
                NATURAL JOIN (SELECT name AS broker, salary FROM brokers) AS t2
        ) AS t3
    ) AS t4 WHERE total_profit > salary)
) AS t;

TABLE employee_profit_worse_than_salary_january;

-- V únoru

CREATE VIEW employee_profit_worse_than_salary_february AS SELECT * FROM (
    (SELECT name AS broker FROM brokers) 
    EXCEPT
    (SELECT broker FROM (
        SELECT * FROM (
            (SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_february) AS t5
            GROUP BY broker) AS t1 
                NATURAL JOIN (SELECT name AS broker, salary FROM brokers) AS t2
        ) AS t3
    ) AS t4 WHERE total_profit > salary)
) AS t;

TABLE employee_profit_worse_than_salary_february;

-- V březnu

CREATE VIEW employee_profit_worse_than_salary_march AS SELECT * FROM (
    (SELECT name AS broker FROM brokers) 
    EXCEPT
    (SELECT broker FROM (
        SELECT * FROM (
            (SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_march) AS t5
            GROUP BY broker) AS t1 
                NATURAL JOIN (SELECT name AS broker, salary FROM brokers) AS t2
        ) AS t3
    ) AS t4 WHERE total_profit > salary)
) AS t;

TABLE employee_profit_worse_than_salary_march;

-- V dubnu

CREATE VIEW employee_profit_worse_than_salary_april AS SELECT * FROM (
    (SELECT name AS broker FROM brokers) 
    EXCEPT
    (SELECT broker FROM (
        SELECT * FROM (
            (SELECT broker, sum(profit) AS total_profit
            FROM (TABLE employee_profit_april) AS t5
            GROUP BY broker) AS t1 
                NATURAL JOIN (SELECT name AS broker, salary FROM brokers) AS t2
        ) AS t3
    ) AS t4 WHERE total_profit > salary)
) AS t;

TABLE employee_profit_worse_than_salary_april;

-- 10) Zaměstnance, kteří za celou dobu od svého nástupu získali v součtu menší provize, než byl součet jejich platů.

-- Původní návrh databáze nepočítal s ničím jako datumem nástupu zaměstnanců, bude proto
-- stávající databáze o toto rozšířena teď.

DROP TABLE IF EXISTS brokers_start_month CASCADE;

CREATE TABLE brokers_start_month (
    broker varchar(20) NOT NULL,
    start_month varchar(20) NOT NULL,
    FOREIGN KEY (broker) REFERENCES brokers (name),
    FOREIGN KEY (start_month) REFERENCES _allowed_months (name)
);

INSERT INTO brokers_start_month VALUES
    ('Josef Ruml', 'Leden'),
    ('Jan Mokrý', 'Leden'),
    ('Alois Boura', 'Únor');

DROP VIEW IF EXISTS working_table_brokers CASCADE;

CREATE VIEW working_table_brokers AS SELECT * FROM (
    (SELECT profit, broker, month_sold FROM property_profit_employee_help) AS t1 NATURAL JOIN (SELECT name AS broker, salary FROM brokers) AS t2
) AS t;

-- Josef Ruml a Jan Mokrý pracují od Ledna-Duben (4 měsíce), a Alois Boura Únor-Duben (3 měsíce)

DROP VIEW IF EXISTS fullfilled_missing_data CASCADE;

CREATE VIEW fullfilled_missing_data AS SELECT * FROM (
    (SELECT * FROM (VALUES 
    ('Josef Ruml', 0, 'Únor', 40000),
    ('Jan Mokrý', 0, 'Únor', 40000),
    ('Jan Mokrý', 0, 'Březen', 40000),
    ('Alois Boura', 0, 'Duben', 35000)) AS t2 (broker, profit, month_sold, salary))
UNION
    (TABLE working_table_brokers)
) AS t;

DROP VIEW IF EXISTS working_table_brokers_semifinal CASCADE;

CREATE VIEW working_table_brokers_semifinal AS SELECT * FROM (
    (SELECT broker, sum(profit) AS total_profit, sum(salary) AS total_salary FROM
    fullfilled_missing_data GROUP BY broker) AS t1 NATURAL JOIN
    (SELECT name AS broker, salary AS monthly_salary FROM brokers) AS t2
) AS t;

-- Konečně tedy brokers (broker) který total_profit (aka veškeré provize) < total_salary (aka vše co vydělal)

DROP VIEW IF EXISTS underpaid_broker CASCADE;

CREATE VIEW underpaid_broker AS SELECT broker FROM (
    SELECT * FROM working_table_brokers_semifinal WHERE total_profit < total_salary
) AS t;

TABLE underpaid_broker;