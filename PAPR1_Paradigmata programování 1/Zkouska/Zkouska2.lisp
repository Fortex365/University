;1) Co je hodnotou výrazu (car ''())?
;(car (quote (quote nil)))
;Prvni quote je funkce, jejiž argument je (quote nil).
;Druhy quote se nevyhodnocuje, protoze je soucasti prvniho quote.
;Vyhodnocenim prvniho quote (se tedy nic "nestane") tedy (quote (quote nil)) popř. ''() je výsledek => (QUOTE NIL)
;Z čehož (car (QUOTE NIL)) je zřejmý => QUOTE

;2)Funkce my-if definována takto:
(defun my-if (x y z)
  (if x y z))
;Má funkce stejný efekt jako speciální operátor if? Zdůvodněte.

;Nemá stejný efekt. Vyhodnocenm (my-if 1 2 (/ 1 0)) dojde k chybě divison-by-zero.
;U výrazu (if 1 2 (/ 1 0)) k chybě nedojde. Vyhodnocuje se jinak, speciálně, proto speciální operátor, má svá pravidla vyhodnocování.
;U funkce se prvně argumenty funkce vyhodnotí, aby se poté jejich hodnoty mohly navázat na parametry funkce. Parametry funkce jsou (x y z)

;3)Napište predikát dividesp, který zjistí, zda jedno zadané celé číslo dělí druhé. Z aritmetických operací můžete použít pouze součet a rozdíl, funkce by tedy mohla například první číslo od druhého odečítat.
;(dividesp 3 6)
;t
;(dividesp 3 3)
;t
;(dividesp 4 6)
;nil
;(dividesú 4 2)
;nil

(defun dividesp (a b)
  (cond ((= b 0) t)
        ((> b 0) (dividesp a (- b a)))))

;4)Napište predikát sum-of-squares-p, který zjistí, zda je zadané nezáporné celé číslo součtem druhých mocnin celých čísel ze zadaného seznamu. Každé číslo seznamu je použito nejvýše jednou. Příklady:
;(sum-of-squares-p 0 '(1 2 3))
;nil
;(sum-of-squares-p 1 '(1 2 3))
;t
;(sum-of-squares-p 16 '(1 2 3))
;nil
;(sum-of-squares-p 5 '(1 2 3))
;t
;(Platí 0 = 0^2; 1 = 1^2; 5 = 1^2 + 2^2; Číslo 16 takto zapsat nelze.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tohle asi správně nebude, protože to testuje 1, nebo 1 s 2, nebo 1 s 2 s 3, ale ne kombinace jako 1 s 3; 2; 2 s 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sum-of-squares-p (n list)
  (cond ((null list) nil)
        ((= n (power2-sum (first-nth list n 0 (length list)))))
        (t (sum-of-squares-help n list 1 (length list)))))

(defun sum-of-squares-help (n list k len)
  (cond ((= k len) nil)
        ((= n (power2-sum (first-nth list n k len))) t)
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;5) Napište hodnotu výrazu
(car (car (cdr (cdr '((a . b) ((c . d)) (((e . f))))))))
;=> ((e . f))

;6)Napište funkci each-nth, která pro daný seznam a číslo n > 0 vrátí seznam obsahující každý n-tý prvek původního seznamu (počínaje nultým). Příklady:
;(each-nth '(1 2 3 4 5 6 7 8) 2)
;(1 3 5 7)
;(each-nth '(1 2 3 4 5 6 7 8) 3)
;(1 4 7)

(defun each-nth (list n)
  (cond ((null list) nil)
        ((= n 0) list)
        (t (each-help list n 0 (length list)))))

(defun each-help (list n k len)
  (if (> k len)
      nil
    (cons (nth k list) (each-help list n (+ k n) len))))

;7)Obdelníkovou tabulku čísel s m řádky a n sloupci můžeme reprezentovat seznamem délky m, jehož prvky jsou seznamy čísel délky n. Každý takový podseznam reprezentuje jeden řádek tabulky. Například seznam ((a b c) (d e f) (g h i) (j k l)) reprezentuje tabulku
;a b c
;d e f
;g h i
;j k l

;Napište funkci column, která takto zadané tabulce ve formě seznamu vrátí její sloupec zadaného indexu:
;(column '((a b c) (d e f) (g h i) (j k l)) 0)
;(a d g j)
;(column '((a b c) (d e f) (g h i) (j k l)) 2)
;(c f i j)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Vypisuje včetně NIL nakonci
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun column (list n)
  (cond ((null list) nil)
        (t (column-help list n 0 (length list)))))
        
(defun column-help (list n k len)
  (if  (> k len)
      '()
    (cons (nth n (car list)) (column-help (cdr list) n (1+ k) len))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;8)Napište funkci seq-map, která vrátí posloupnost, jejíž prvky vznikly aplikací zadané funkce na prvky zadané posloupnosti (aplikovaná funkce je prvním argumentem, posloupnost druhým). Posloupnosti reprezentujeme jako na přednášce funkcemi. Příklad (s použítím funkce print-sequence z přednášky):
;(display-sequence (seq-map (lambda (x) (+ x 1)) #'power2))
;1, 2, 5, 10, 17, 26, 37, 50, 65, 82, 101, 122, 145, 170, 197, 226, 257, 290, 325, 326, ...

;9)Napište funkci tree-height, která vrátí výšku zadaného stromu. Strom je reprezentován abstraktní datovou strukturou se selektroy node-value a node-children

;10)Napite predikát increasing-seq-p, který zjistí, zda prvních k členů zadané posloupnosti roste, tj. zda každý člen je větší než předchozí. Posloupnost je jako obvykle zadána funkcí, číslo k je druhým argumentem predikátu.
;(increasing-seq-p #'power2 100)
;t
;(increasing-seq-p #'- 100)
;nil
;(increasing-seq-p (lambda (n) (- (* 10 n) (power2 n))) 7)
;nil

                   


