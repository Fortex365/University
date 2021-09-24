(defun dividep (a b)
  (= (rem b a) 0)) ;pokud Áčko dělí Bčko bezezbytku

(defun dividep2 (a b)
  (cond ((= b 0) t)
        ((> b 0) (dividep2 a (- b a)))))
;Bez použití zbytku po dělení.

(defun my-rem (number divisor)
  (if (> divisor 0)
      (- number (* (floor (/ number divisor)) divisor))
    (- number (* (ceiling (/ number divisor)) divisor))))

(defun dividep-my-rem (a b)
  (= (my-rem b a) 0))                         ;prepis dividep s pouziti funkce my-rem

(defun primep (a)
  (cond ((< a 2) nil)                           ;cokoliv menší než 2 není prvočíslo
        ((or (= a 2) (= a 3)) t)               ;dvojka a trojka je prvočíslo
        ((zerop (rem a 2)) nil)                ;jestlize zbytek po deleni a dvema je 0 pote neni prvocislo
        (t (primep-help a 3))))

(defun primep-help (a test)
  (cond ((> test (/ a 2)) t)                      ;jestlize test je vetsi nez a/2, pak je prvocislo
        ((zerop (rem a test)) nil)                ;pokud zbytek po deleni a s testem je 0 tak neni prvocislo
        (t (primep-help a (+ 2 test)))))       ;zkusime s testem o 2 vyssi


(defun perfectp (number)
  (= number (perfect-help number (if (evenp number)     ;sude number
                                      (/ number 2)      ;tested bude number/2
                                    (/ (+ 1 number) 2)) ;jinak (number+1)/2
                           0)))                         ;ir 0

(defun perfect-help (number test ir)
  (cond ((= test 0) ir)                                               ;kdyz test bude uz 0 vysledek je ir
        ((dividep test number)                                     ;pokud number deli test potom
         (perfect-help number (- 1 test) (+ ir test)))      ;number test-1 ir+test jinak
        (t (perfect-help number (- 1 test) ir))))              ;number test-1 ir


(defun pascal (n k)
  (cond ((= k 0) 1)                                     ;nulty index na radku je cislo 1
        ((= n k) 1)                                       ;pokud n nad k plati n=k tak cislo je 1
        (t (+ (pascal (- n 1) (- k 1))              ;soucet n-1 na predchozim radku k-1 predchozi cislo na radku
              (pascal (- n 1) k)))))                   ;s cislem n-1 na predchozim radku s cislem indexu k


        