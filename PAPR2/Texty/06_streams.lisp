;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Paradigmata programování 2
;;;;
;;;; Přednáška 6, Líné vyhodnocování, přísliby a proudy
;;;;

#|

První verze příslibů. Zakomentováno, aby nebyly warningy

|#

#|

;; První verze konstrukce příslibu:
(defmacro delay (expr)
  `(lambda () ,expr))

;; Vynucení výpočtu schovaného v příslibu:
(defun force (promise)
  (funcall promise))

#|
;; Tady se nic nepočítá, jen se budoucí výpočet
;; uloží do příslibu:
(setf p (delay (progn (print "Počítám...")
                 (+ 1 2))))

;; Vynucení výpočtu:
(force p)
(force p)
(force p)

|#

|#

#|
Vylepšení příslibů, aby se výpočet provedl jen poprvé.

Příslib je seznam s touto strukturou:

(promise validp val fun)
- promise: symbol promise
- validp: zda je zapamatovaná hodnota validní. Pokud ano, nemusí se volat funkce.
- val: zapamatovaná hodnota
- fun: funkce na výpočet hodnoty

|#

;; pomocná funkce
(defun make-promise (fun)
  (list 'promise nil nil fun))

;; konstruktor příslibu
(defmacro delay (expr)
  `(make-promise (lambda () ,expr)))

;; interní selektor
(defun validp (promise)
  (second promise))

;; Vynucení hodnoty. Pokud je už zapamatovaná, jen se vrátí, jinak
;; se nejdřív vypočítá.
(defun force (promise)
  (unless (validp promise)
    (setf (third promise) (funcall (fourth promise))
          (second promise) t))
  (third promise))

#|
Když vyzkoušíte testy z předchozí verze, bude se teď tisknout
jen poprvé.
|#

(defun invalidate (promise)
  (setf (second promise) nil))


#|
Proud (stream) je
- buď prázdný proud, což je symbol nil
- nebo pár, jehož cdr je příslib proudu

Podobně jako u seznamů funkcí cons konstruujeme proud operátorem
cons-stream. Je to ovšem makro, protože jako druhý argument 
chceme dát výraz po jehož vyhodnocení vznikne pokračování proudu.
Do cdr páru se uloží pouze příslib, takže ke zjištění, jak proud 
pokračuje, je třeba použít force. Až v ten moment se provede výpočet.

|#


(defmacro cons-stream (a b)
  `(cons ,a (delay ,b)))

(defun stream-car (s)
  (car s))

;; stream-cdr provede pomocí force výpočet pokračování proudu.
(defun stream-cdr (s)
  (force (cdr s)))

#|

Pomocné funkce

|#
;; Převod seznamu na proud
(defun list-to-stream (list)
  (if (null list)
      '()
    (cons-stream (car list) (list-to-stream (cdr list)))))

#|
(setf s (list-to-stream '(1 2 3 4)))
(stream-car s)
(setf s (stream-cdr s))
(stream-car s)
(setf s (stream-cdr s))
(stream-car s)
;; ... atd, takhle to můžete zkoušet i u dalších příkladů
|#

;; Zakrytí symbolu stream, aby se dal použít (jinak by došlo k chybě,
;; protože je v Lispu už použit; nemusíte se tím ale trápit).
(shadow '(stream))

;; Analogie funkce list, ale napsaná jako makro, aby se zachovalo
;; líné vyhodnocování
(defmacro stream (&rest exprs)
  (if (null exprs)
      '()
    `(cons-stream ,(car exprs) (stream ,@(cdr exprs)))))

#|
(stream 1 2 3 4)
|#

#|
Následují funkce velmi podobné funkcím pro seznamy
|#

(defun stream-length (s)
  (if (null s)
      0
    (1+ (stream-length (stream-cdr s)))))

;; Jako mapcar, ale pracuje i s nekonečným proudem! (ale jen s jedním argumentem)
(defun stream-mapcar-1 (fun s)
  (unless (null s)
    (cons-stream
     (funcall fun (stream-car s))
     (stream-mapcar-1 fun (stream-cdr s)))))
#|
(stream-mapcar-1 #'1+ (stream 1 2 3 4 5))
(setf s
      (stream-mapcar-1 (lambda (x)
                         (format t "~%Výpočet pro hodnotu ~s " x)
                         (1+ x))
                       (stream 1 2 3 4 5)))

(stream-car s)
(setf s (stream-cdr s))
(stream-car s)
(setf s (stream-cdr s))
(stream-car s)
|#

;; Převod proudu na seznam. max-count lze nastavit, abychom se 
;; vyhnuli zacyklení u nekonečného proudu.
(defun stream-to-list (stream &optional max-count)
  (if (or (null stream)
          (eql max-count 0))
      '()
    (cons (stream-car stream) 
          (stream-to-list (stream-cdr stream)
                          (when max-count (- max-count 1))))))

;; Nekonečný proud jedniček
(defun ones ()
  (cons-stream 1 (ones)))

#|
(stream-to-list (ones) 20)
|#

;; Nekonečný proud přirozených čísel
(defun naturals (&optional (from 0))
  (cons-stream from (naturals (1+ from))))

#|
(stream-to-list (naturals) 20)
|#

;; nekonečný proud mocnin dvojky
(defun pow2 ()
  (labels ((iter (n)
             (cons-stream n (iter (* 2 n)))))
    (iter 1)))

#|
(stream-to-list (pow2) 20)
|#

;; Oblíbená Fibonacciho posloupnost poprvé
(defun fib1 ()
  (labels ((iter (n1 n2)
             (cons-stream n2 (iter n2 (+ n1 n2)))))
    (cons-stream 0 (iter 0 1))))

#|
(stream-to-list (fib1) 20)
|#

#|
Další příklady bez komentářů
|#

(defun stream-each-other (stream)
  (when stream
    (let ((car (stream-car stream))
          (cdr (stream-cdr stream)))
      (if cdr
          (cons-stream car (stream-each-other (stream-cdr cdr)))
        (cons-stream car nil)))))

(defun stream-squares (stream)
  (stream-mapcar-1 (lambda (x) (* x x))
                   stream))

(defun squares ()
  (stream-squares (naturals)))

#|
(stream-to-list (squares) 20)
|#

(defun stream-remove-if (test stream)
  (cond ((null stream) '())
        ((funcall test (stream-car stream))
         (stream-remove-if test (stream-cdr stream)))
        (t (cons-stream (stream-car stream) 
                        (stream-remove-if test (stream-cdr stream))))))

(defun even-naturals ()
  (stream-remove-if #'oddp (naturals)))

#|

(stream-to-list (even-naturals) 50)
 
|#

(defun stream-mapcar (fun &rest strs)
  (when (car strs)
    (cons-stream (apply fun (mapcar #'stream-car strs))
                 (apply #'stream-mapcar fun (mapcar #'stream-cdr strs)))))

;; Fungovalo by toto s klasickými seznamy (kdybychom omezili délku)?
(defun fib2 ()
  (let (result)
    (setf result (cons-stream 
                  0
                  (cons-stream
                   1
                   (stream-mapcar #'+ result (stream-cdr result)))))))

;; Prvočísla:
(defun dividesp (m n)
  (= (rem n m) 0))

(defun sieve (stream)
  (let ((car (stream-car stream))
        (cdr (stream-cdr stream)))
    (cons-stream car
                 (sieve (stream-remove-if (lambda (n)
                                            (dividesp car n))
                                          cdr)))))

(defun eratosthenes ()
  (sieve (naturals 2)))

;; Duplicity

(defun stream-remove-duplicates (stream)
  (when stream
    (let ((car (stream-car stream)))
      (cons-stream car
                   (stream-remove-duplicates 
                    (stream-remove car stream))))))

;; Racionální čísla:

(defun positive-rationals ()
  (labels ((pr (numerator denominator)
             (cons-stream (/ numerator denominator)
                          (if (= numerator denominator)
                              (pr 1 (1+ denominator))
                            (pr (1+ numerator) denominator)))))
    (stream-remove-duplicates (pr 1 1))))


;; Proudy jako iterátory:

(defun make-stream-iterator (stream)
  (let ((s stream))
    (lambda ()
      (prog1 (stream-car s)
        (setf s (stream-cdr s))))))

(defun next (iterator)
  (funcall iterator))