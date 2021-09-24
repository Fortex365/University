;Napište predikát right-triangle-p, který podobně jako z druhého cvičení, zjistí zda zadaný trojúhelník je pravoúhlý. Predikát bude akceptovat jeho argumenty vrcholy trojúhelníka jako body.
(defun hypotenuse (a b)
  (sqrt (+ (power2 a) (power2 b))))

(defun power2 (a)
  (* a a))

(defun point-distance-hypotenuse (A-x A-y B-x B-y)
  (let ((x-leg (- A-x B-x))
        (y-leg (- A-y B-y)))
    (hypotenuse x-leg y-leg)))

(defun point (a b)
  (cons a b))

(defun point-x (a)
  (car a))

(defun point-y (a)
  (cdr a))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun right-trinagle-p (v1 v2 v3)
  (let ((side1 (point-distance-hypotenuse (point-x v1) (point-y v1) (point-x v2) (point-y v2)))
        (side2 (point-distance-hypotenuse (point-x v2) (point-y v2) (point-x v3) (point-y v3)))
        (side3 (point-distance-hypotenuse (point-x v1) (point-y v1) (point-x v3) (point-y v3))))
    (and (> side3 (+ side1 side2)) (> side2 (+ side1 side3)) (> side1 (+ side2 side3)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci op-vertex, která k bodům A a B najde bod C tak, že bod B je středem úsečky a vrcholy A a C.
(defun op-vertex (A-x A-y C-x C-y)
  (let ((leg-x (/ (+ A-x C-x) 2))
        (leg-y (/ (+ A-y C-y) 2)))
    (point leg-x leg-y)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci na rozdíl a podíl zlomků:
(defun fraction (x y)
  (cons x y))

(defun numero (x) ;jako number, ale tenhle nazev v lispu nelze pouzit, tak numero :D
  (car x))

(defun denom (x)
  (cdr x))

(defun fraction+ (x y)
  (fraction (+ (* (numero x) (denom y))       ;citatel
               (* (numero y) (denom x)))
            (* (denom x) (denom y))))         ;jmenovatel

(defun frac* (x y)
  (fraction (* (numero x) (numero y))        ;citatel
            (* (denom x) (denom y))))        ;jmenovatel

(defun frac-equal-p (x y)                    ;a/b = c/d je totez jako ad=cb
  (= (* (numero x) (denom y))
     (* (numero y) (denom x))))

(defun frac-denom-equal-p (x y)
  (= (denom x) (denom y)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun frac- (x y)
  (if (frac-denom-equal-p x y)                        ;pokud se zlomky rovnaji lze je odcitat
      (fraction (- (numero x) (numero y))             ;odecteme citatele
                (denom x))                            ;jmenovatel zustava stejny
    nil))                                             ;kdyz jsou rozdilne neresim

(defun frac/ (x y)
  (fraction (* (numero x) (denom y))                  ;podil zlomku je jako nasobit prevracenym zlomkem
            (* (denom x) (numero y))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Navrhněte abstraktní datovou strukturu reprezentující uzavřené intervaly reálných čísel. Konstruktor s názvem interval bude mít dva argumenty: dolní a horní konec nového intervalu. Selektory se budou jmenovat lower-bound a upper-bound. Dále napište predikát number-in-interval-p, který zjistí, zda je dané číslo prvkem daného intervalu a funkci interval-intersection, která vrátí interval, jenž je průnikem zadanýchdvou intervalů, nebo nil pokud je jejich průnik prázdný.

(defun interval (down up)
  (cons down up))

(defun low-bound (interval)
  (car interval))

(defun upper-bound (interval)
  (cdr interval))

(defun number-in-interval-p (number inter)
  (let ((spodni (low-bound inter))
        (horni (upper-bound inter)))
    (if (<= spodni horni)
        (cond ((= number spodni) t)
              (t (number-in-interval-p number (interval (+ 1 spodni) horni))))
      nil)))

(defun interval-intersection (inter1 inter2)
  (let ((novy-spodni 
         (if (> (low-bound inter1) (low-bound inter2))     ;vetsi z nich nam bude tvorit novy pocatek intervalu
             (low-bound inter1) 
           (low-bound inter2)))
        (novy-horni 
         (if (< (upper-bound inter1) (upper-bound inter2)) ;mensi z nich nam bude tvorit novy vrsek intervalu
             (upper-bound inter1) 
           (upper-bound inter2))))
    (interval novy-spodni novy-horni)))                    ;sestrojeni noveho intervalu, jako pruniku dvou predeslych
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište výraz jehož vyhodnocením vznikne struktura znázorněná krabičkovým znázorněním na tomto obrázku: viz lecture05 příklad 6
(let ((x (cons 3 4)))
  (cons 1 (cons x (cons x 2))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište iterativní verzi funkce my-make-list
(defun my-make-list (elem length)
  (if (= length 0)
      ()
    (cons elem (my-make-list elem (- length 1)))))

;Iterativní verze my-make-list-iter
(defun my-make-list-iter (elem length)
  (my-make-list-iterhelp elem length (cons elem ())))

(defun my-make-list-iterhelp (elem length ir)
  (if (= length 0) 
      ir
    (cons elem (my-make-list-iterhelp elem (- length 1) (cons elem ir)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište predikát proper-list-p, který zjistí, zda jeho argument je čistý seznam.
(defun properp (list)
  (if (not (consp list))               ;když list není listem
      (eql nil list)                   ;tak porovnává nil s listem, když není tak nil, když je tak t
    (properp (cdr list))))     ;jinak hledá hlouběji
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci make-ar-seq-list, která vytvoří aritmetickou posloupnost se zadaným prvním členem, diferencí a počtem členů.
(defun make-ar-seq-list (a diff length)
  (if (= length 0)
      ()
    (cons a (make-ar-seq-list (+ a diff) diff (- length 1))))) ;consujeme začátek s dalším a+diff s tím, že diff zůstává stejný jenom délka je length-1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište iterativní verzi make-ar-seq-list
(defun make-ar-seq-list-iterative (a diff length)
  (let ((last (+ a (* diff (- length 1)))))                ;vytvoříme si poslední člen což je a+(diff*length-1) ... length-1 protože indexujeme od 0
    (make-ar-seq-list-iterative-help (- last diff) diff (- length 1) (cons last ())))) ;jelikož je to iterativní, jdeme odzadu tedy předposlední člen, předpředposlední člen proto  ... předposlední člen je (- last diff) v prvním průchodu, diff zůstává stejná, length-1 klasika

(defun make-ar-seq-list-iterative-help (a diff length ir) ;pro další průchody
  (if (= length 0)
      ir
    (make-ar-seq-list-iterative-help (- a diff) diff (- length 1) (cons a ir))))


(defun make-ar-seq-it (a diff length)
  (let ((last (+ a (* diff (1- length)))))
    (labels ((iterative (a diff len ir)
               (if (= len 0)
                   ir
                 (iterative (- a diff) diff (1- len) (cons a ir)))))
      (iterative (- last diff) diff (1- length) (cons last ())))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci make-geom-seq-list, která vytvoří geometrickou posloupnost se zadaným prvním členem, diferencí a počtem členů.
(defun make-geom-seq-list (a q length)
  (if (= length 0)
      ()
    (cons a (make-geom-seq-list (* a q) q (- length 1)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci make-geom-seq-list-iterative
(defun make-geom-seq-list-iterative (a q length)
  (let ((last (* a (expt q (1- length)))))
    (make-geom-seq-list-iterative-help (/ last q) q (1- length) (cons last ()))))

(defun make-geom-seq-list-iterative-help (a q length ir)
  (if (= length 0)
      ir
    (make-geom-seq-list-iterative-help (/ a q) q (1- length) (cons a ir))))


(defun make-geom-seq-it (a q length)
  (let ((last (* a (expt q (1- length)))))
    (labels ((iterative (a q len ir)
               (if (= len 0)
                   ir
                 (iterative (/ a q) q (1- len) (cons a ir)))))
      (iterative (/ last q) q (1- length) (cons last ())))))




