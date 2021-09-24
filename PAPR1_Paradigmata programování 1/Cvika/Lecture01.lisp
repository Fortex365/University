;Kolik prvků mají tyto složené výrazy?
;(((((1))))), (1 1), ((1 1)), (((1 1))), ((3 3 3) (1))
;1 prvek,     2 prvky, 1 prvek, 1 prvek, 2 prvky

;Přepište do prefixové notace 7*(1+5*8) / 3*(2,51-2,34)

(/ (* 7 (+ 1 (* 5 8))) (* 3 (- 2.51 2.34)))

;Přepišt do prefixové notace 5+14/3+(2-(3-(6-4/3))) / (1-2/3)*(2-6)
(/ (+ 5 14/3 (- 2 (- 3 (- 6 4/3)))) (* (- 1 2/3) (- 2 6)))

;Jaký je rozdíl mezi funkcí a speciálním operátorem/makrem?
;Funkce se liší ve vyhodnocovacím procesu, řídí se přesně podle vyhodnocovacího procesu. 
;Narozdíl speciální operátor/makro se tímto vyhodnocovacím procesem neřídí, řídí se totiž vlastními pravidly.

;Proč musí být setf speciální operátor?
;Musí, protože kdyby nebyl, jeho první argument by se vyhodnocoval a došlo  by k chybě. Že na tento symbol neexistuje žádná vazba. 
;Vyjímkou vyhodnocovacího procesu tohoto operátoru je přesně to, že jeho první argument nevyhodnocuje. Vyhodnocuje až ten druhý.
;Jinak bychom nebyli schopni na symbol a navázat hodnotu 5. (setf a 5)

;Napište výraz, jehož vyhodnocením ověříme, že if není funkce.
(if (< 0 1) t (/ 1 0))
;Pokud by if byl funkce, poté by vyhodnocoval všechny argumenty dle vyhodnocovacího procesu. U posledního argumentu (/ 1 0) by ztroskotal a vyhodil chybu.
;Tento případ nenastane, protože operátor if se opět řídí svými pravidly vyhodnocováním, ke všemu tzv. zkráceným vyhodnocováním. 
;Pokud 0 < 1 což je pravda, vyhodí jako výsledek druhý argument, což je t. A třetí argument se vůbec nesnažil vyhodnotit. Vyhodnotil by ho pouze pokud 0 > 1 a tento výraz by zavedl if do nepravdivé větve. Poté by if skončil chybovou hláškou divide-by-zero.

;Co je hodnotou následujícíh výrazů?
t, nil, (if 1 2 3)

;Výraz t se vyhodnocuje sám na sebe, jediná vyjímka, že se vyhodnocuje stejně jako číslo. Výsledek je tedy opět t.
;Stejně tak výraz nil.
;Výraz (if 1 2 3) se vyhodnotí na 2jku, protože podmínka 1 je jednoduchá a platí sama o sobě, 1 je 1nička. Proto vyhodnotí druhý argument.