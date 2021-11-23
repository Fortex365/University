/*
Vezměme dva skalární výrazy typu integer: <expr1> a <expr2> 

Běžné operace s čísly zapíšeme následujícími skalárními výrazy.

Součet: ( <expr1> + <expr2> )
Rozdíl: ( <expr1> - <expr2> )
Součin: ( <expr1> * <expr2> )
Celočíselný podíl: ( <expr1> / <expr2> )
Zbytek po celočíselném podílu: ( <expr1> % <expr2> )
Opačné číslo: ( - <expr1> )
Mocnina: ( <expr1> ^ <expr2> )
*/

-- Například:
SELECT ( 1 + 2 ) AS result;

SELECT ( ( 5 / 2 ) ^ 3 ) AS result;

-- Vnější závorky kolem skalárního výrazu vynecháváme:

SELECT ( 5 / 2 ) ^ 3  AS result;


SELECT 1 + 1 AS result;
SELECT 2 - 1 AS result;
SELECT 2 * 2 AS result;
SELECT 5 / 2 AS result;
SELECT 5 % 2 AS result;
SELECT - 5 AS result;
SELECT 2 ^ 3 AS result;

/*
Priorita operátorů:
 1. -x (unární mínus)
 2. ^	
 3. * / %
 4. + -	

Asociativita operátorů je z leva do prava.

Závorky můžeme vynechat a použít prioritu a asociativitu operátorů.
*/

SELECT 2 + 3 * 2 AS result;

-- Je:

SELECT 2 + ( 3 * 2 ) AS result;

SELECT 2 ^ 3 ^ 2 AS result;

-- Je:
SELECT ( 2 ^ 3 ) ^ 2 AS result;


SELECT 2 - 2 - 2 AS result;

-- Je:
SELECT ( 2 - 2 ) - 2 AS result;

/*
Dva skalární výrazy jsou ekvivalentní, pokud se jejich hodnoty rovnají v každé přípustné n-tici.

Například skalární výraz:

a + b

je ekvivalentní skalárnímu výrazu:

b + a

protože se jejich hodnoty rovnají v každé n-tici, která má komponenty s atributy 'a' a 'b'.
*/