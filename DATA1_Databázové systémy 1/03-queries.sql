http://apollo.inf.upol.cz/~urbanec/teaching/2021/dasy/21-10-06.html

#1 Objekty, které mají v domácnosti Nováků nebo v domácnosti Kroupů.
(SELECT predmet FROM novakovi) UNION (SELECT predmet FROM kroupovi);

#2 Všechny objekty všech domácností (tj Nováků, Kroupů i Králíků).
((SELECT predmet FROM novakovi) UNION (SELECT predmet FROM kroupovi))
     UNION (SELECT predmet FROM kralikovi);

#3 Objekty, které mají jen Novácí (tj nemají je Kroupovi ani Králíkovi).
(SELECT predmet FROM novakovi) EXCEPT 
    ((SELECT predmet FROM kroupovi) UNION (SELECT predmet FROM kralikovi));

#4 Objekty, které má jen jedna rodina (kterákoliv).
(((SELECT predmet FROM novakovi) EXCEPT 
    ((SELECT predmet FROM kroupovi) UNION (SELECT predmet FROM kralikovi))
UNION ((SELECT predmet FROM kroupovi) EXCEPT 
    ((SELECT predmet FROM novakovi) UNION (SELECT predmet FROM kralikovi))))
    UNION ((SELECT predmet FROM kralikovi) EXCEPT 
    ((SELECT predmet FROM kroupovi) UNION (SELECT predmet FROM novakovi))));

# Nyní si představte, že můžete do relace novakovi pouze přidávat (INSERT),
# z relace kroupovi pouze mazat (DELETE) a v relaci kralikovi pouze měnit hodnoty (UPDATE).
# Pomocí těchto akcí zajistěte, aby platilo:

#5 Dotaz 1. a dotaz 2. vrátí stejnou relaci.

- Ve druhém dotazu je navíc vana, obraz
- Tyto predmety se navic nachazeji v relaci Králíků
- Odstraňovat v této tabulce nemůžeme, ale můžeme přidat tyto předměty do Novákovi.

INSERT INTO novakovi VALUES ('vana',50,'bila',1000);
INSERT INTO novakovi VALUES ('obraz',3,'mix',10000000);

#6 Dotaz 3. a dotaz 4. vrátí stejnou relaci.

- Ve druhém dotazu je navíc zehlicka, postel
INSERT INTO kralikovi VALUES ('zehlicka',1,'ruzova',2000);
INSERT INTO kralikovi VALUES ('postel',30,'oranzova',50000);

#7 Dotaz 1. a 3. vrátí stejnou relaci.

UPDATE kralikovi SET predmet='hodiny' WHERE predmet='zidle';
UPDATE kralikovi SET predmet='lzice' WHERE predmet='vidlicka';
UPDATE kralikovi SET predmet='zehlici prkno' WHERE predmet='zehlicka';
UPDATE kralikovi SET predmet='DVD' WHERE predmet='televize';
UPDATE kralikovi SET predmet='konvice' WHERE predmet='obraz';
UPDATE kralikovi SET predmet='vesak' WHERE predmet='stul';
UPDATE kralikovi SET predmet='zrcadlo' WHERE predmet='vana';
UPDATE kralikovi SET predmet='hreben' WHERE predmet='kartac';
UPDATE kralikovi SET predmet='deka' WHERE predmet='postel';
DELETE FROM kroupovi WHERE predmet='zidle';
DELETE FROM kroupovi WHERE predmet='vidlicka';
DELETE FROM kroupovi WHERE predmet='zehlicka';
DELETE FROM kroupovi WHERE predmet='televize';
DELETE FROM kroupovi WHERE predmet='stul';
DELETE FROM kroupovi WHERE predmet='kartac';
DELETE FROM kroupovi WHERE predmet='postel';

# Nyní pracujte pouze s relací novakovi a vyjádřete nejprve pomocí množinových operací 
#nad restrikcí tabulky s jednoduchou podmínkou 
# a poté pomocí složených podmínek v restrikci relace:

#8 Obsahující pouze objekty s jinou než bílou barvou.
(SELECT predmet FROM novakovi) EXCEPT ((SELECT predmet FROM novakovi WHERE barva='bila') UNION
                                        (SELECT predmet FROM novakovi WHERE barva='modra'));

(SELECT predmet FROM novakovi WHERE (NOT ((barva='bila') OR (barva='modra'))));

#9 Obsahující pouze objekty s cenou vyšší než 1000.
(SELECT predmet FROM novakovi) EXCEPT (SELECT predmet FROM novakovi WHERE cena < 1000);

(SELECT predmet FROM novakovi WHERE cena >= 1000);

#10 Obsahující pouze bíle objekty těžší než 5.
(SELECT predmet FROM novakovi) EXCEPT (SELECT predmet FROM novakovi WHERE (NOT ((vaha > 5) AND (barva='bila'))));

(SELECT predmet FROM novakovi WHERE (vaha > 5) AND (barva='bila'));