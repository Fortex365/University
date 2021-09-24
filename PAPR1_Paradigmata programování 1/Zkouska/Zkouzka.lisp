;1) Přepište následující výraz odmocnina(cos^2(x) - sin^2 (x))
;(sqrt (- (power2 (cos x)) (power2 (sin x))))

;2) Funkce my-if definovaná takto, má stejný efekt jako speciální operátor if? Zdůvodněte
(defun my-if (x y z)
  (if x y z))
;Nemá. (my-if 1 2 (/ 1 0)) skončí errorem zatímco (if 1 2 (/ 1 0) skončí výsledkem 2. Argumenty funkce jsou vyhodnoceny a poté navázány na symboly. Proto se objeví error
;division-by-zero, ale u speciálního operátoru if ne, protože se k tomuto vyhodnocení ani nedostane, protože 1 platí takže výsledek bude 2


;3)Napište predikát dividesp, který zjistí jestli jedno číslo dělí druhé. Použít můžete aritmetické operace sčítání a odečítání. Například, že první odečtete od druhého čísla.
(defun dividesp (a b)
  (cond ((= b 0) t)
        ((> b 0) (dividesp a (- b a)))))


;5)Co je výsledkem výrazu (car (car (cdr (cdr '((1 . 2) ((3 . 4)) (((5 . 6))))))))
;Jestli obalení více závorek znamená hovno, tak po poslední aplikaci car by měl výsledek být číslo 5.
;Výsledkem je: ((5 . 6))


;4)Napište funkci sum-of-squares-p, která zjistí zda dané číslo je součtem různých čtverců.
;0 = 0^2, 1 = 1^2, 15 = 1^2 + 2^2 + 3^2, 13 = 3^2 + 2^2, 14 = nil

(defun sum-of-squares-p (a)
  (cond ((= a 0) t)
        ((= a 1) t)
        (t (= a (+ (power2 (sum-of-squares-p (- a 1)))
                   (power2 (sum-of-squares-p (- a 2))))))))
;Správně by to prej mělo dělat něco s podmnožinovostí.

(defun power2 (a)
  (* a a))


;6)Napište funkci duplicate-elements, která bude mít výstup následovný
;(duplicate-elements '())
;NIL
;(duplicate-elements 'a)
;(a a)
;(duplicate-elements '(a b c))
;(a a b b c c)

(defun duplicate-elements (x)
  (cond ((eql x nil) nil)
        ((atom x) (list x x))                              ;pokud je to atom
        (t (let ((prvni (list (car x) (car x))))        ;spoji to prvni 2x
             (append prvni (duplhelp (cdr x)))))))     ;prvni spojeni s těmi dalšími

(defun duplhelp (x)
  (let ((pomoc (list (car x) (car x))))          ;spojení prvku 2x
    (cond ((eql x nil) '())                              ;pokud x už bude nil tak '()
          (t (append pomoc (duplhelp (cdr x))))))) ;jinak spojujeme to spojené doposud a k tomu připojujeme další zbytek seznamu

;The správná one
(defun duplicate (x)
  (cond ((eql x nil) nil)
        ((atom x) (list x x))
        (t (let ((prvni (list (car x) (car x))))
             (labels ((duplicatehelp (a)
                        (let ((pomoc (list (car a) (car a))))
                          (cond ((eql a nil) '())
                                (t (append pomoc (duplicatehelp (cdr a))))))))
               (append prvni (duplicatehelp (cdr x))))))))
                 
;7)Napište funkci column, která z daného seznamu vypíše sloupec. Náš seznam reprezentuje obdélník zapsaný např. takto
; a b c
; d e f
; g h i
; j k l
;Kde m jsou řádky, n sloupce. Náš seznam je reprezentovaný takto ((a b c) (d e f) (g h i) (j k l))
;Můžete použít funkce z přednášky např. funkci (nth 2 (a b c d e)) => C
;(Když použil nth, tak i nth-cdr)

(defun column (list a)
  (cond ((= a 0)
         (let ((m 0))
           (list (car (nth m list))
                 (car (nth (+ m 1) list)))))
        (t (let ((m 0))
             (list (car (nthcdr a (nth m list)))
                   (car (nthcdr a (nth (+ m 1) list))))))))


;8) ? 
;9) ?
;10) Přidejte do našeho interpretu scheme funkci sqrt.