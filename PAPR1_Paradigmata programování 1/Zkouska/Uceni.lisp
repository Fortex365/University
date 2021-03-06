 ;Jaký je rozdíl mezi rekurzivní funkcí a rekurzivním výpočetním procesem?
;Rekurzivní funkce volá sama sebe ve svém těle funkce.
;Rekurzivní výpočetní proces se dá poznat podle běhu programu. Že se aplikuje rekurzivní funkce v dalším průchodu.

;Existuje rekurzivní funkce, která nikdy negeneruje rekurzivní výpočetní proces?
(defun something (n)
  (if (<= n 0)
      (print "IDK")
    (something (1- n))))

;Existuje nerekurzivní funkce, která generuje rekurzivní výpočetní proces?
(defun jedna (a)
  (dva a))

(defun dva (a)
  (jedna a))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun primep (a)
  (cond ((< a 2) nil)                           ;cokoliv menší než 2 není prvočíslo
        ((or (= a 2) (= a 3)) t)               ;dvojka a trojka je prvočíslo
        ((zerop (rem a 2)) nil)                ;jestlize zbytek po deleni a dvema je 0 pote neni prvocislo
        (t (primep-help a 3))))

(defun primep-help (a test)
  (cond ((> test (/ a 2)) t)                      ;jestlize test je vetsi nez a/2, pak je prvocislo
        ((zerop (rem a test)) nil)                 ;pokud zbytek po deleni a s testem je 0 tak neni prvocislo
        (t (primep-help a (+ 2 test)))))       ;zkusime s testem o 2 vyssi


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun perfectp (number)
  (= number (perfect-help number
                          (if (evenp number)     ;sude number
                                      (/ number 2)      ;tested bude number/2
                                    (/ (+ 1 number) 2)) ;jinak (number+1)/2
                           0)))                         ;ir 0

(defun perfect-help (number test ir)
  (cond ((<= test 0) ir)                                               ;kdyz test bude uz 0 vysledek je ir
        ((dividep test number)                                     ;pokud number deli test potom
         (perfect-help number (- 1 test) (+ ir test)))      ;number test-1 ir+test jinak
        (t (perfect-help number (- 1 test) ir))))              ;number test-1 ir

(defun dividep (a b)
  (= (rem b a) 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pascal (n k)
  (cond ((= k 0) 1)                                     ;nulty index na radku je cislo 1
        ((= n k) 1)                                       ;pokud n nad k plati n=k tak cislo je 1
        (t (+ (pascal (- n 1) (- k 1))              ;soucet n-1 na predchozim radku k-1 predchozi cislo na radku
              (pascal (- n 1) k)))))                   ;s cislem n-1 na predchozim radku s cislem indexu k
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-rem (number divisor)
  (if (> divisor 0)
      (- number (* (floor (/ number divisor)) divisor)) ;true větev
    (- number (* (ceiling (/ number divisor)) divisor)))) ;false if větev
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište predikát proper-list-p, který zjistí, zda jeho argument je čistý seznam.
(defun properp (list)
  (if (not (consp list))               ;když list není listem
      (eql nil list)                   ;tak porovnává nil s listem, když není tak nil, když je tak t
    (properp (cdr list))))     ;jinak hledá hlouběji
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci list-tail, která k danému seznamu vrátí seznam všech jeho konců včetně vstupního seznamu a prázdného seznamu
(defun list-tail (list)
  (cond ((null list) '())                         ;prázdný seznam je výsledek pouze nil
        ((eql (cdr list) nil) (list list ()))    ;zobrazuje ostatní podseznamy
        (t (cons list (list-tail (cdr list))))))  ;cons původního listu s těmi dalšími menšími

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci flatten, která "rozpustí" podseznamy daného seznamu (ze zápisu seznamu vymaže všechny závorky kromě první a poslední
(defun flatten (l)
  (cond ((null l) nil)
        ((atom (car l)) (cons (car l) (flatten (cdr l)))) ;jestli je to atom tak ho consneme s tím zbytkem
        (t (append (flatten (car l)) (flatten (cdr l)))))) ;když je to složený výraz tak ho appendmeme s vyhlazením caru a s vyhlazením cdr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Následující predikát equal-sets-p zjišťuje, zda jsou si dvě množiny rovny
(defun mem (x list)
  (cond ((null list) ())                 ;v prázdném listu není
        ((eql (car list) x) list)         ;porovnava prvni prvek listu s x, pokud tam je, vrací list
        (t (mem x (cdr list)))))       ;hleda se hlouběji, pokud tam doteď nebyl

(defun included (list1 list2)
  (cond ((null list1) t)                                                        ;prázdný list je určitě součástí toho druhého
        ((member (car list1) list2) (included (cdr list1) list2))       ;pokud je prvek listu1 v listu2 tak, se hleda hlouběji zbytek prvků listu1 v listu2
        (t nil)))                                                                    ;jinak tam samozřejmě není

(defun equal-sets-p (list1 list2)
  (and (included list1 list2) (included list2 list1)))                ;aby si množiny musely být rovny, musí jedna obsahovat druhou a naopak
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci my-remove-duplicates, která z daného seznamu vypustí duplicitní výskyty. Na pořadí prvků výsledku nezáleží, takže toto je jen jedna možnost
(defun is-present (a list)
  (cond ((null list) nil)
        ((eql a (car list)) t)
        (t (is-present a (cdr list)))))

(defun my-rem-dups (a list)
    (cond ((null list) nil)
          ((and (eql a (car list)) (is-present a (cdr list)))
           (my-rem-dups a (cdr list)))                                                                       ;Prvek 'a' se opakuje víckrát v listu
          ((not (eql a (car list)))
           (cons (car list) (my-rem-dups a (cdr list))))                                                 ;Prvek 'a' je jiný než ten který chceme odstranit
          (t (cons (car list) (my-rem-dups a (cdr list))))))                                           ;Prvek 'a' se NEopakuje v listu 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sum-of-squares-p (n list)
  (cond ((null list) nil)
        ((= n (power2-sum (first-nth list n 0 (length list)))))
        (t (sum-of-squares-help n list 1 (length list)))))

(defun sum-of-squares-help (n list k len)
  (cond ((= n (power2-sum (first-nth list n k len))) t)
        (t (= n (sum-of-squares-help n list (1+ k) len)))))

(defun power2-sum (list)
  (cond ((null list) nil)
        (t (+ (power2 (car list))
              (power2-sum (cdr list))))))

(defun power2 (a)
  (* a a))

(defun first-nth (list n k len)
  (if (> k len)
      nil
    (cons (car list) (first-nth (cdr list) n (1+ k) len))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun each-nth (list n)
  (cond ((null list) nil)
        ((= n 0) list)
        (t (each-help list n 0 (length list)))))

(defun each-help (list n k len)
  (if (> k len)
      '()
    (cons (nth k list) (each-help list n (+ k n) len))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun column (list n)
  (cond ((null list) nil)
        (t (column-help list n 0 (length list)))))
        
(defun column-help (list n k len)
  (if  (> k len)
      '()
     (cons (nth n (car list)) (column-help (cdr list) n (1+ k) len))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun elementp (elem list)
  (cond ((null list) nil)
        ((eql elem (car list)) t)
        (t (elementp elem (cdr list)))))

(defun intersection-2 (a b)
  (cond ((null a) nil)
        ((elementp (car a) b) (cons (car a) (intersection-2 (cdr a) b)))
        (t (itersection-2 (cdr a) b))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun intersection (a &rest rest)
  (if (null rest) a
    (apply #'intersection (intersection-2 a (car rest))
           (cdr rest))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun f ()
  (function f))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(car ''())
(car (quote (quote nil)))
;=> quote
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(funcall #'cons #'cons #'cons)
;=> (#'cons . #'cons)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tree-height (root-node)
  (if (null (node-children root-node)) 0
    (+ (apply #'max (mapcar #'tree-height (node-children root-node))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tree-findp (x node)
  (cond ((null node) nil)
        ((eql x (node-value node)) t)
        (t (eql x (node-value (tree-findp x (nodechildren node)))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                   