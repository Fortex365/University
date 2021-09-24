;Napište funkci last-pair, která k danemému neprázdnému seznamu vrátí jeho poslední pár
(defun last-pair (list)
  (cond ((null list) '())
        ((eql (cdr list) nil) (car list))    ;když v cdr je nil, tak v caru je tedy ten náš poslední pár
        (t (last-pair (cdr list)))))         ;hledá se hlouběji


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci my-copy-list, která k danému seznamu vrátí jeho kopii, tedy seznam seznam z nově vytvořených párů, ale obsahující týž prvky.
(defun my-copy-list (list)
  (cond ((null list) ())
        (t (cons (car list) (my-copy-list (cdr list))))))   ;vytváříme nový seznam tak, že consujeme to co je v car s tím, co je v cdr... 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište predikát equal-list-p, který zjistí, zda dané dva seznamy obsahují týtež prvky (porovnané predikátem eql) ve stejném pořadí.
(defun equal-list-p (list1 list2)
  (if (and (null list1) (null list2))                                                   ;když jsou oba prázdné tak jsou shodné
      t
    (cond ((eql (car list1) (car list2)) (equal-list-p (cdr list1) (cdr list2)))        ;když jejich cary jsou shodné, zkontrolujeme jejich cdr
          (t nil))))                                                                    ;jinak vždycky pravdivá větev podmínka t, poté nil jako nejsou shodné


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci my-remove, která vypustí ze seznamu všechny výskyty daného prvku
(defun my-remove (remove list)
  (if (null list)
      ()
    (cond ((eql remove (car list)) (my-remove remove (cdr list)))    ;jestli v caru je výskyt našeho remove, tak ho jednoduše ignorujeme a pokračujeme dál v seznamu 
          (t (cons (car list) (my-remove remove (cdr list)))))))     ;když není třeba výskyt odstranit, prostě se překopíruje obsah původního seznamu do nového


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci my-remove, která k danému seznamu vrátí seznam vzniklý nahrazením jeho nthcdr prázdný seznam.
(defun remove-nthcdr (n list)
  (if (zerop n)
      (cons () (cdr list))           ;pro případ, že bychom chtěli odstranit nultý prvek, tak ho nahradíme () neboli nil a spojením zbytku listu
    (cons (car list) (remove-nthcdr (1- n) (cdr list))))) ;v jiném případě překopírováváme list

;Jak je vidno, je zde funkce 1- je to kvůli tomu, že nelze psát (-1 n) protože by došlo k podtečení rozsahu, správný zápis je (- n 1)                                ;Rozdíl funguje tak, že "od čeho odečítáme" "co odčítáme"
;(defun 1- (a) (- a 1))   tato funkce v lispu už je                  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci each-other, která k danému seznamu vrátí seznam prvků se sudým indexem.
(defun each-other (list)
  (each-other-help list 1))                        ;je potřeba nová funkce s indexem

(defun each-other-help (list index)
  (cond ((null list) nil)                           ;pokud je list prázdný tak nil
        ((oddp index) (each-other-help (cdr list) (+ 1 index)))                 ;pokud je index lichý tak pošleme do dalšího průchodu cdr listu a index++
        (t (cons (car list) (each-other-help (cdr list) (+ 1 index))))))         ;sudé indexy consujeme s car listem a zbytkem listu přičemž index++



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci fib-list, která vrátí seznam zadané délky, jehož n-tý prvek bude roven n-tému Fibonacciho číslu.
(defun fib (n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (t (+ (fib (- n 1)) (fib (- n 2))))))

(defun fib-list (n)
  (cond ((= n 0) nil)
        (t (cons (fib n) (fib-list (1- n))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fib-list2 (n)
  (labels ((fib (n)
             (cond ((= n 0) 0)
                   ((= n 1) 1)
                   (t (+ (fib (1- n)) (fib (- n 2)))))))
    (cond ((= n 0) nil)
          (t (cons (fib n) (fib-list2 (1- n)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci factorials, která vrátí seznam zadané délky, jehož n-tý prvek bude mít hodnotu n!
(defun fact (n)
  (cond ((= n 0) 1)
        (t (* n (fact (1- n))))))

(defun factorials (n)
  (cond ((= n 0) nil)
        (t (cons (fact n) (factorials (1- n))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun factorials2 (n)
  (labels ((fact (n)
             (cond ((= n 0) 1)
                   (t (* n (fact (1- n)))))))
    (cond ((= n 0) nil)
          (t (cons (fact n) (factorials (1- n)))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci list-tail, která k danému seznamu vrátí seznam všech jeho konců včetně vstupního seznamu a prázdného seznamu
(defun list-tail (list)
  (cond ((null list) '())                         ;prázdný seznam je výsledek pouze nil
        ((eql (cdr list) nil) (list list nil))    ;zobrazuje ostatní podseznamy
        (t (cons list (list-tail (cdr list))))))  ;cons původního listu s těmi dalšími menšími


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci list-sum, která vrátí součet všech prvků daného seznamu 
(defun sum-list (list)
  (cond ((null list) nil)
        ((eql (cdr list) nil) (+ (car list) 0))   ;ukončující podmínka rekurze, pokud následující člen v seznamu je nil, poté k caru přičteme neutrální prvek sčítání
        (t (+ (car list) (sum-list (cdr list)))))) ;jinak sčítáme aktuální číslo s tím zbytkem...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci subtract-lists-2, která vypočítá rozdíl dvou stejně dlouhých seznamů chápaných jako vektory
(defun subtract-lists-2 (list1 list2)
  (cond ((or (null list1) (null list2)) nil)                         ;pokud jeden je prázdný, nelze dělat rozdíl
        ((not (eql (length list1) (length list2))) nil)              ;pokud rozměry vektoru nesouhlasí, nelze dělat rozdíl
        ((and (eql (cdr list1) nil) (eql (cdr list2) nil))           ;když u obou v cdr je nil, tak potom poslední krok rekurze je (+ (car l1) (car l2))
         (cons (- (car list1) (car list2)) ()))
        (t (cons (- (car list1) (car list2)) (subtract-lists-2 (cdr list1) (cdr list2))))))  ;jinak rozdíl carů, s tím zbytkem v dalším průchodu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci scalar-product, která vrátí skalární součin dvou stejně dlouhých seznamů chápaných jako vektory
(defun scalar-product (list1 list2)
  (cond ((or (null list1) (null list2)) nil)                        ;pokud jeden je prázdný, nelze dělat skalární součit vektorů
        ((not (eql (length list1) (length list2))) nil)             ;pokud rozměry vektoru nesouhlasí, nelze dělat skalární součit vektorů
        ((and (eql (cdr list1) nil) (eql (cdr list2) nil))
         (* (car list1) (car list2)))                               ;když v cdr listu1 a listu2 je nil tak konec rekurze je car listu1 vynásoben car listem2
         (t (+ (* (car list1) (car list2)) (scalar-product (cdr list1) (cdr list2)))))) ;součet (násobku car list1 s car list2) a hlubším průchodem rekurze


;Napište funkci vector-length, která vrátí délku vektoru zadaného seznamem
(defun vector-length (list)
  (cond ((null list) nil)
        (t (length list))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci my-remove-duplicates, která z daného seznamu vypustí duplicitní výskyty. Na pořadí prvků výsledku nezáleží, takže toto je jen jedna možnost
(defun is-present (a list)
  (cond ((null list) nil)
        ((eql a (car list)) t)
        (t (is-present a (cdr list)))))

(defun my-rem-dups (a list)
    (cond ((null list) nil)
          ((and (eql a (car list)) (is-present a (cdr list))) (my-rem-dups a (cdr list)))
          ((not (eql a (car list))) (cons (car list) (my-rem-dups a (cdr list))))
          (t (cons a (my-rem-dups a (cdr list))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci my-union, která ke dvěma seznamám představujícím množiny vrátí jejich sjednoducení.
(defun my-union (list1 list2)
  (cond ((null list1) list2)
        ((null list2) list1)
        ((and (null list1) (null list2)) nil)
        (t (append list1 list2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Následující predikát equal-sets-p zjišťuje, zda jsou si dvě množiny rovny
(defun mem (x list)
  (cond ((null list) ())                 ;v prázdném listu není
        ((eql (car list) x) list)         ;porovnava prvni prvek listu s x, pokud tam je, vrací list
        (t (mem x (cdr list)))))       ;hleda se hlouběji, pokud tam doteď nebyl

(defun included (list1 list2)
  (cond ((null list1) t)                                                        ;prázdný list je určitě součástí toho druhého
        ((mem (car list1) list2) (included (cdr list1) list2))       ;pokud je prvek listu1 v listu2 tak, se hleda hlouběji zbytek prvků listu1 v listu2
        (t nil)))                                                                    ;jinak tam samozřejmě není

(defun equal-sets-p (list1 list2)
  (and (included list1 list2) (included list2 list1)))                ;aby si množiny musely být rovny, musí jedna obsahovat druhou a naopak



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci flatten, která "rozpustí" podseznamy daného seznamu (ze zápisu seznamu vymaže všechny závorky kromě první a poslední
(defun flatten (l)
  (cond ((null l) nil)
        ((atom (car l)) (cons (car l) (flatten (cdr l)))) ;jestli je to atom tak ho consneme s tím zbytkem
        (t (append (flatten (car l)) (flatten (cdr l)))))) ;když je to složený výraz tak ho appendmeme s vyhlazením caru a s vyhlazením cdr