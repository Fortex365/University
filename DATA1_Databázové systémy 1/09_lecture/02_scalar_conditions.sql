/*
'true' a 'false' jsou literály
*/

SELECT true AS result;
SELECT false AS result;

/*
Podmínky jsou skalární výrazy s hodnotou typu boolean.
*/

SELECT 1 = 1 AS result;

SELECT NOT ( 1 = 1 ) AS result;

SELECT ( 1 = 1 ) AND ( 'a' = 'a' ) AS result;

/*
Operátory porovnávání:
<, >, =, <=, >=, <>


Priorita logických operátorů:
NOT	(negace)
AND	(konjunkce)
OR	(disjunkce)

Aritmetické operátory mají větší prioritu než operátory porovnávání.
Operátory porovnávání mají větší prioritu než logické operátory.
*/

-- Výraz:
SELECT NOT 1 + 1 = 2 OR 2 = 2 AS result; 

-- Znamená:
SELECT ( NOT ( ( 1 + 1 ) = 2 ) ) OR ( 2 = 2 ) AS result; 

