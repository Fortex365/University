-- Uvažujeme relační proměnnou kindergarten.
DROP TABLE IF EXISTS kindergarten CASCADE;

CREATE TABLE kindergarten (
  child_name varchar(10) NOT NULL, 
  child_age integer NOT NULL,
  adult_name varchar(10) NOT NULL,
  PRIMARY KEY ( child_name, adult_name) 
);
-- Vztah: dítě child_name chodí do školky je mu child_age let a smí si jej vyzvednout dospělý adult_name.


INSERT INTO kindergarten ( child_name, child_age, adult_name ) VALUES
  ( 'Anna', 3, 'Pavel' ),
  ( 'Bert', 4, 'Monika' ),
  ( 'Bert', 4, 'Petr' ),
  ( 'Cyril', 4, 'Jana' ),
  ( 'Daniela', 5, 'Jana' );

TABLE kindergarten;

/*
Shoda n-tic v atributech
------------------------

t1, t2: n-tice nad A1, ..., An
X: podmnožina {A1, ..., An}

n-tice t1 se shoduje s n-ticí t2 v X, pokud se projekce t1 na X rovná projekci t2 na X.
*/


/*
Funkční závoslost pro relaci
----------------------------

r: relace nad A1, ..., An
X, Y: podmnožiny {A1, ..., An}

V relaci r je Y funkčně závislé na X  (píšeme X -> Y) pokud platní následující.

Pro každé dvě n-tice t1, t2 v těle relace r platí, že pokud se t1 shoduje s t2 v X, pak se t1 shoduje s t2 v Y.

Stručněji: Pokud se dvě n-tice shodují v atributech X, pak se také shodují v atributech Y.

Místo {B1, .., Bn} -> {C1, ..., Cm} někdy píšeme B1, ..., Bn -> C1, ..., Cm.
*/


/*
Pokud X -> Y v každé relaci, pak se X -> Y nazývá triviální. 

Například:
child_name -> child_name
*/

/*
Funkční závoslost pro relační proměnnou
---------------------------------------

R: relační proměnná nad A1, ..., An
X, Y: podmnožiny {A1, ..., An}

V relační proměnné R je Y funkčně závislé na X (píšeme X -> Y) pokud Y je funkčně závislé na X v každé přípustné hodnotě proměnné R.
*/


/*
Netriviální funkční závislosti relační proměnné kindergarten:
child_name -> child_age
child_name, adult_name -> child_name, child_age, adult_name

Otázkou je, zda:
adult_name, child_age -> child_name
*/


/*
Vztah funkční závislosti a nadklíče
-----------------------------------

R: relační proměnná nad A1, ..., An
K: podmnožina {A1, ..., An}

Platí: K je superklíč (nebo taky nadklíč), právě když K -> {A1, ..., An}.

Například protože: 

child_name, adult_name -> child_name, child_age, adult_name

víme, že 

{child_name, adult_name}

je nadklíč.
*/
