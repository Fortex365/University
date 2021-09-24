;(1) Výrazy lambda-kalkulu, určete které jsou normální formy a hlavové normální formy

;Normální forma - Výraz, který nelze dále redukovat. Protože jako žádný svůj podvýraz neobsahuje redex.
;Hlavová normální forma - Výraz, který v tomto bodě vyhodnocení nechceme dále redukovat je proměnná,
;abstrakce, aplikace jejíž hlava je HNF, která není abstrakce.

;(a) - x
;NF + HNF

;(b) - (x y)
;NF + HNF

;(c) - (lambda (x) x)
;NF + HNF

;(d) - (lambda (x) y)
;NF + HNF

;(e) - (x (lambda (x) x))
;NF + HNF

;(f) - ((lambda (x) x) y)
;Ani jedno

;(g) - ((lambda (x y) x) y)
;Ani jedno

;(h) - (x ((lambda (x) x) y))
;HNF

;(i) - (lambda (x) ((lambda (y) x) z))
;HNF

;(j) - ((lambda (x y) y x) ((lambda (z) z z) y))
;Ani jedno¨

;(k) - (((lambda (x y) x) y) ((lambda (v) v v) (lambda (w) w w)))
;Ani jedno



;(2) Výrazy, které v předešlé úloze nejsou normální formy, redukujte na normální formy.
;Výrazy a-e jsou HNF, ale také už jsou NF, tak není co redukovat.

;(h) - (x ((lambda (x) x) y)) z HNF
;Redukce (x y), dostáváme NF + HNF

;(i) - (lambda (x) ((lambda (y) x) z)) z HNF
;Redukce (lambda (x) x), dostáváme NF + HNF



;(3) Totéž udělejte pro HNF, a to jak aplikativním modelem vyhodnocováním tak normálním modelem vyhodnocování.
;Totéž udělat = výrazy, které nejsou HNF redukovat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Aplikativní model vyhodnocování
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Pokud je výraz E hlavová normální forma, vyhodnocení končí, výsledkem je výraz E
;Pokud není, je výraz E aplikace. Vyhodnotíme jeho hlavu, E s novou hlavou označíme F
;Pokud je F hlavová normální forma, končíme a výsledkem je F
;Jinak je hlava výrazu F abstrakce. Vyhodnotíme její argument, F s novým argumentem označíme G.
;Pak provedeme redukci výrazu G a pokračujeme od začátku s novým výrazem.
;----------------------------------------------------------------------------------------------------------------

;(f) - ((lambda (x) x) y)
;Výraz není HNF
;Tedy je výraz aplikace, vyhodnotíme jeho hlavu (lambda (x) x)
;Tato hlava je HNF, končíme a výsledkem je (lambda (x) x)

;(g) - ((lambda (x y) x) y)
;Výraz není HNF
;Tedy je výraz aplikace, vyhodnotíme jeho hlavu (lambda (x y) x)
;Tato hlava je HNF, končíme a výsledkem je (lambda (x y) x)

;(j) - ((lambda (x y) y x) ((lambda (z) z z) y))
;Výraz není HNF
;Aplikace, vyhodnotíme její hlavu (lambda (x y) y x)
;Tato hlava je HNF, končíme a výsledkem je (lambda (x y) y x)

;(k) - (((lambda (x y) x) y) ((lambda (v) v v) (lambda (w) w w)))
;Výraz není HNF
;Aplikace, vyhodnotíme její hlavu ((lambda (x y) x) y)
;Její hlava není HNF, nekončíme
;Poté je hlava výrazu abstrakce, vyhodnotíme její argument "y" a označení si výrazu
;Pak provedeme redukci tohoto výrazu (lambda (xy y) xy) a pokračujeme s novým výrazem.
;Tento nový výraz je HNF, vyhodnocování končí.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Normální model vyhodnocení
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Pokud je E hlavová normální forma, redukce končí a výsledek je E
;Pokud není, je to aplikace. Vyhodnotíme její hlavu, E s novou hlavou označíme F
;Pokud je F hlavová normální forma, končíme a výsledkem je F
;Jinak je hlava abstrakce. Provedeme redukci a pokračujeme od prvního bodu
;-------------------------------------------------------------------------------------------

;(f) - ((lambda (x) x) y)
;Výraz není HNF, vyhodnocení nekončí
;Je to aplikace, vyhodnotíme její hlavu (lambda (x) x)
;Tento výraz je HNF, vyhodnocení tím končí (lambda (x) x)

;(g) - ((lambda (x y) x) y)
;Výraz není HNF, pokračujem
;Je to aplikace, vyhodnotíme její hlavu (lambda (x y) x)
;Hlava je HNF, končíme a výsledkem je (lambda (x y) x)

;(j) - ((lambda (x y) y x) ((lambda (z) z z) y))
;Výraz není HNF, pokračujem
;Je to aplikace, vyhodnotíme její hlavu (lambda (x y) y x)
;Hlava je HNF, končíme s výsledkem (lambda (x y) y x)

;(k) - (((lambda (x y) x) y) ((lambda (v) v v) (lambda (w) w w)))
;Není HNF, jdem dál
;Výraz je aplikace, vyhodnotíme její hlavu ((lambda (x y) x) y)
;Její hlava není HNF
;Jinak je hlava abstrakce. Provedeme redukci (lambda (xy yy) xy) a pokračujeme dál.
;Výraz je HNF, končíme a výsledkem je (lambda (xy yy) xy)

















