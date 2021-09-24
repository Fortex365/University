#|
1. Podívejte se na definici funkce percentage-2. Ve kterém prostředí se při
její aplikaci vyhodnocuje výraz (eql whole t) a ve kterém výraz (/ part
whole)?
|#

(defun percentage-2 (part whole)
  (let ((whole (if (eql whole t)
                   10668641
                 whole)))
    (* (/ part whole) 100.0)))

; (eql whole t) v aktualím prostředí "v prostředí programu parcentage-2"
; (/ part whole)? v aktualnim "v prostředí vytvořeném pomocí let" (po vytvoreni prostedi let
; se prostredi "letu" stava aktualni

#|
2. Jaký je rozdíl mezi rekurzivní funkcí a rekurzivním výpočetním procesem?

 Funkce je rekurzivní pokud ve svém kódě obsahuje aplikace seme saba. 
 Pozná se podle podle zdrojového kódu.

Rekurzivní výpočetní proces Výpočetní proces je rekurzivní, když během aplikace funkce dojde znovu k aplikaci
téže funkce.
• je poznat, když program běží
• některá aplikace funkce by k aplikaci téže funkce vést neměla (ukončovací
podmínka)
|#

#|
3. Existuje rekurzivní funkce, která nikdy negeneruje rekurzivní výpočetní proces?
ANO
nějakou blbost jsme vymysleli na tabali fakt se mi na tom uvažovat nechce
|#

#|
4. Existuje nerekurzivní funkce, která generuje rekurzivní výpočetní proces?
ANO
př. volání iterace (doplnit)
|#

#|
5. Obsah elipsy s poloosami a a b je πab.
Proto jej můžeme vypočítat pomocí následující funkce:
|#

(defun ellipse-area (a b)
  (* pi a b))

#|
5. Když a = b, je elipsa kružnicí. Upravte funkci tak, aby v takovém případě
stačilo místo druhého argumentu zadat t. Udělejte to co nejvíce způsoby,
jeden z nich by měl být rekurzivní.
|#

(defun ellipse-area-2 (a b)
  (let ((b (if (eql b t)
              a
            b)))
    (* pi a b)))

(defun ellipse-area-3 (a b)
  (ellipse-area a 
                (if (eql b t)
                    a
                  b)))

(defun ellipse-area-4 (a b)
  (if (eql b t)
      (ellipse-area-4 a a)
    (* pi a b)))

(defun ellipse-area-5 (a b)
  (if (eql b t)
      (* pi a a)
    (* pi a b)))

#|
7. Napište funkci my-gcd (greatest common divisor; funkce gcd už v Lispu je),
která Eukleidovým algoritmem vypočte největší společný dělitel zadaných
dvou přirozených čísel:
CL-USER 1 > (my-gcd 10 15)
5
CL-USER 2 > (my-gcd 5 3)
1
CL-USER 3 > (my-gcd 5 10)
5
CL-USER 4 > (my-gcd 9 24)
3
Jak víme, Eukleidův algoritmus vychází z následujícího poznatku:

 gcd(a, b) =
    a jestliže b = 0
    jinak
    gcd(b, c) jinak (c je zbytek po dělení a : b).

Na zjištění zbytku po dělení použijte funkci rem.
|#

(defun my-gcd (a b)
  (if (= b 0)
      a
    (my-gcd b 
            (rem a b))))

#|
8. Zvolme kladné číslo a. Podobně jako dříve pro funkci cos můžeme metodou
postupných aproximací najít pevný bod funkce f dané předpisem
f(x) = x +
a
x
2
.
Jak víme, pevným bodem bude číslo x, pro které platí f(x) = x.
Zajímavé je, že takovým pevným bodem je číslo √
a. (K ověření stačí dosadit
√
a do vzorečku; vyjde f(
√
a) = √
a.) Metodou postupných aproximací tedy
v případě této funkce f najdeme odmocninu z čísla a.
Napište funkci heron-sqrt, která metodou postupných aproximací vypočítá
odmocninu ze zadaného čísla se zadanou přesností. Přesnost testujte tak, že
přibližné číslo umocníte na druhou a porovnáte s a.
|#

(defun func (x a)
  (/ (+ x (/ a x)) 2))

(defun approx-= (a b epsilon)
  (<= (abs (- a b)) epsilon))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun heron-sqrt (a epsilon)
  (heron-sqrt-iter a 1.0 epsilon))

(defun heron-sqrt-iter (a x epsilon)
  (let ((y (func x a)))
    (if (approx-= a (* y y) epsilon)
        y
      (heron-sqrt-iter a y epsilon))))


#|
9. Napište „hloupou“ funkci na výpočet součtu prvků intervalu celých čísel.
|#

;(defun count-interval (first last step)
; (if (> first last)
;      0
;    (+ first (count-interval (+ step first) last step))))

(defun count-interval (first last)
  (if (> first last)
      0
    (+ first (count-interval (+ 1 first) last))))
#|
10. Upravte ji tak, aby generovala iterativní výpočetní proces.
|#

;(defun count-interval-iterative (first last step)
;  (when (> last first)
;    (count-interval-iterative-help first last step 0)))

;(defun count-interval-iterative-help (first last step ir)
;  (cond ((> first last) ir)
;        (t (count-interval-iterative-help (+ step first) last step
;                                (+ ir first)))))

(defun count-interval-iterative (first last)
  (count-interval-iterative-help first last 0))

(defun count-interval-iterative-help (first last ir)
  (if (> first last)
      ir
    (+ first (count-interval-iterative-help (+ 1 first) last 0))))
#|
11. Upravte funkci power, aby generovala iterativní výpočetní proces.
|#

(defun power-iter (a n)
  (cond ((zerop n) 1)
        ((= n 1) a)
        (t (power-iter-help a n 1))))

(defun power-iter-help (a n ir)
  (cond ((zerop n) ir)
        (t (power-iter-help a (- 1 n)
                            (* ir a)))))


;funkce nth-power zapsana pomoci labels
(defun nth-power (a n)
  (labels ((iter (a n ir)
             (cond ((zerop n) ir)
                   (t (iter a (- 1 n) (* ir a))))))
  (cond ((zerop n) 1)
        ((= n 1) a)
        (t (iter a n 1)))))


#|
12. Číslo π lze s libovolnou přesností vypočítat pomocí Leibnizovy formule:
π
4
= 1 −
1
3
+
1
5
−
1
7
+
1
9
− · · ·
Dosažená přesnost odhadu čísla π
4
je přitom dána posledním přičítaným (odečítaným) zlomkem. Napište funkci leibniz, která vypočítá číslo π se zadanou
přesností. Napište jak obyčejnou, tak iterativní verzi této funkce.
|#

(defun leibniz-iter (n)
  (leibniz-iter-help n 1 1 0))

(defun leibniz-iter-help (n i divisor ir)
  (cond ((> i n) ir)
        ((oddp i) (leibniz-iter-help n (+ 1 i) (+ 2 divisor)
         (+ ir (/ 1 divisor))))
        (t (leibniz-iter-help n (+ 1 i) (+ 2 divisor)
         (- ir (/ 1 divisor))))))
;iterativní verze


;rekurzivní verze
(defun leibniz (n)
  (leibniz-help n 1 1)) 

(defun leibniz-help (n i divisor)
  (cond ((> i n) 0)
        ((oddp i) (+ (leibniz-help n (+ 1 i) (+ 2 divisor)) (/ 1 divisor)))
        (t (- (leibniz-help n (+ 1 i) (+ 2 divisor)) (/ 1 divisor)))))

;oddp je predikat licheho cisla, evenp je predikat sudeho cisla