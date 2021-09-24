;Je nějaký rozdíl mezi funkcí my-if a speciálním operátorem if?
(defun my-if (a b c)
  (if a b c))
;Rozdíl je. (if 1 2 (/ 1 0)) a (my-if 1 2 (/ 1 0)) tak v případě speciálního operátoru nedojde k chybě. V případě funkce dojde chybě, protože se vyhodnocují argumenty funkce a jejich hodnoty se navazují na parametry té funkce.

;Napište funkci power2 na výpočet druhé mocniny zadaného čísla.
(defun power2 (a)
  (* a a))

;Napište funkce power3, power4, power5 na další mocniny
(defun power3 (a)
  (* a (power2 a)))

(defun power4 (a)
  (* a (power3 a)))

(defun power5 (a)
  (* a (power4 a)))

;Napište funkci hypotenuse, která vypočítá z délek odvěsen trojúhelníka délku přepony
(defun hypotenuse (a b)
  (sqrt (+ (power2 a) (power2 b))))

;Napište funkci absolute-value, která vypočítá absolutní hodnotu zadaného čísla
(defun my-abs (a)
  (if (>= a 0) a (* a -1)))
;Pokud je číslo kladné, vrátíme ho.
;Pokud číslo není kladné, vrátíme ho vynásobeným -1

;Definujte funkci signum, která vrátí 1 pro kladné číslo, 0 pro číslo 0, -1 pro záporné číslo. V lispu funkce taková už je, jmenuje se sgn.
(defun my-signum (a)
  (cond ((= a 0) 0)
        ((> a 0) 1)
        (t -1)))

;Napište funkci minimum, která ze zadaných čísel vrátí to menší. (V lispu je funkce min, max)
;Zadání je hrozně obecné, poukazuje na libovolný počet argumentů. Pro jednoduchost v této lekci si vystačíme pro dvě čísla. 
(defun my-minimum (a b)
  (if (< a b) a b))

(defun my-maximum (a b)
  (if (> a b) a b))

;Napište funkci my-positivep, která je predikát, tedy vrací logickou hodnotu t, pokud je číslo kladné, nil pokud není.
(defun my-positivep (a)
  (> a 0))
;Obdobně napište funkci my-negativep.
(defun my-negativep (a)
  (< a 0))
;V lispu už takovéhle predikátové funkce jsou, jmenují se minusp a plusp.

;Máme funkci point-distance, která však nepoužívá již napsanou funkci hypotenuse napravte to.
(defun point-distance (A-x A-y B-x B-y)
  (let ((x-leg (- A-x B-x))
        (y-leg (- A-y B-y)))
    (sqrt (+ (* x-leg x-leg) (* y-leg y-leg)))))

(defun point-distance-hypotenuse (A-x A-y B-x B-y)
  (let ((x-leg (- A-x B-x))
        (y-leg (- A-y B-y)))
    (hypotenuse x-leg y-leg)))

;Pokud čísla a, b, c jsou délkami stran trojúhelníka, pak splňují trojúhelníkové nerovnosti
(defun trianglep (a b c)
  (and (> c (+ a b)) 
       (> a (+ b c)) 
       (> b (+ c a))))
;Naopak, pokud kladná čísla a, b, c splňují tyto nerovnosti, pak mohou být délkami stran trojúhelníka. 
;Napište funkci trianglep, která vrátí logickou hodnotu "zadaná tři čísla mohou být délkami stran trojúhelníka"
(defun trianglep2 (a b c)
  (let ((x (> c (+ a b)))
        (y (> a (+ b c)))
        (z (> b (+ c a))))
    (and x y z)))

;Obsah trojúhelníka o stranách délek a, b, c lze vypočítat pomocí Heronova vzorce viz. lecture2
;Napište funkci heron se třemi parametry, která pomocí Heronova vzorce vypočítá obsah trojúhelníka zadaného délkami stran.
(defun heron (a b c)
  (let ((s (/ (+ a b c) 2)))
    (sqrt (* s (- s a) (- s b) (- s c)))))

;Napište funkci heron-cart, která pomocí Heronova vzorce vypočítá obsah trojúhelníka zadaného body v kartézských souřadnicích.
(defun heron-cart (A-x A-y B-x B-y C-x C-y)
  (let* ((side1 (point-distance-hypotenuse A-x A-y B-x B-y)) ;je potreba si udelat vzdalenosti bodu mezi 'A' 'B'
        (side2 (point-distance-hypotenuse B-x B-y C-x C-y))  ;mezi 'B' a 'C'
        (side3 (point-distance-hypotenuse A-x A-y C-x C-y))  ;mezi 'A' 'C'
        (s (/ (+ side1 side2 side3) 2)))
    (sqrt (* s (- s side1) (- s side2) (- s side3)))))