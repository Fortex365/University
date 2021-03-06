;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; 11_stacks_1.lisp - Zásobníkové programování
;;;
;;; Jazyk pro myšlený zásobníkový stroj.
;;; fáze 1 - základy
;;;

;;
;; Hlavní zásobníky
;;

;; Zásobník výsledků (hodnot, datový zásobník) 
;; a vykonávací (programový) zásobník
(defvar *rslt*)
(defvar *exec*)

;; Slovník je zásobník párů (klíč . hodnota)
;; práce se slovníky:

(defun dict-find (key dict)
  (let ((pair (find key dict :key #'car)))
    (unless pair (error "Key not found in dictionary: ~s" key))
    (cdr pair)))

(defmacro dict-push (key val dict)
  `(push (cons ,key ,val) ,dict))

;; Slovník definic slov. Každá definice je pár (slovo . kód).
;; Kód je buď lispová funkce (vestavěné slovo), nebo kód našeho jazyka
;; v seznamu (uživatelsky definované slovo).

(defvar *words*)
(setf *words* '())


;; 
;; Slova
;;

(defun wordp (el)
  (keywordp el))

(defun word-code (w)
  (dict-find w *words*))

;; Vykonání slova (je-li na vrcholu programového zásobníku)
(defun exec-word (word)
  (let ((code (word-code word))) 
    (if (functionp code)
        (built-in-exec code)
      (user-exec code))))

(defun built-in-exec (fun)
  (funcall fun))

(defun user-exec (uc)
  (setf *exec* (append uc *exec*)))


;;
;; Základní vestavěná slova:
;;

(setf *words*
      (list ;; (a b -- součet a + b)
            (cons :+ 
                  (lambda () 
                    (push (+ (pop *rslt*) (pop *rslt*)) *rslt*)))
            ;; (a b -- rozdíl a - b)
            (cons :-
                  (lambda ()
                    (let ((arg (pop *rslt*)))
                      (push (- (pop *rslt*) arg) *rslt*))))
            ;; (a b -- součin a * b)
            (cons :* 
                  (lambda () 
                       (push (* (pop *rslt*) (pop *rslt*)) *rslt*)))
            ;; (a b -- podíl a / b)
            (cons :/ 
                  (lambda ()
                    (let ((arg (pop *rslt*)))
                      (push (/ (pop *rslt*) arg) *rslt*))))
            ;; (a b -- log. hodnota a = b)
            (cons := 
                  (lambda () 
                    (push (= (pop *rslt*) (pop *rslt*)) *rslt*)))))

;; Další vytvoříme pomocí funkce define-word
(defun define-word (name code)
  (dict-push name code *words*))

;; (a b -- b a) 
(define-word :swap (lambda ()
                     (rotatef (first *rslt*) (second *rslt*))))

;; (a b c -- b c a) 
(define-word :rot (lambda ()
                     (rotatef (third *rslt*) (second *rslt*) (first *rslt*))))

;; (a -- )
(define-word :drop (lambda ()
                     (pop *rslt*)))

;; (a -- a a)
(define-word :dup (lambda ()
                    (push (car *rslt*) *rslt*)))

;; (a b -- a b a)
(define-word :over (lambda ()
                     (push (second *rslt*) *rslt*)))

;; Slovo :if pracuje tak, že upravuje vrchol zásobníku exec
;; Používá další pomocná slova 
;; Použití viz testy dole
(define-word :if (lambda ()
                   (unless (pop *rslt*)
                     (push :find-then-else *exec*))))

(define-word :then (lambda ()
                     (push :find-then-else *exec*)))

(define-word :else (lambda ()))

(define-word :find-then-else (lambda ()
                               (unless (find (pop *exec*) '(:then :else))
                                 (push :find-then-else *exec*))))

                          
;;
;; Spuštění programu.
;;

;; Jeden krok
(defun exec-step ()
  (let ((elem (pop *exec*)))
    (if (wordp elem) 
        (exec-word elem)
      (push elem *rslt*))))

;; Celý program
;; Nové vazby na proměnné *rslt* a *exec* vytvářím, aby byl
;; obsah hezky vidět v krokovači LispWorks a aby se globální
;; zásobníky neměnily.
(defun execute (code)
  (let ((*rslt* '())
        (*exec* code))
    (loop while *exec*
          do (exec-step))
    (pop *rslt*)))


#|

;; Výrazy je dobré vyhodnocovat v Listeneru a ne tady přes F8.
;; Když se rekurzivní výraz zacyklí, je pak snadné ho zastavit tlačítkem Break.

(execute '(1))
(execute '(1 2 :+ 4 :*))

(execute '(1 2 :swap :drop)

;; Výpočet 4*(4 + 5):
(execute '(4 5 :over :+ :*))

(execute '(0 1 := :if 2 5 :* :then 2 10 :* :else))
(execute '(1 1 := :if 2 5 :* :then 2 10 :* :else))

(define-word :fact
             '(:dup 0 := :if :drop 1 :then :dup 1 :- :fact :* :else))

(execute '(5 :fact))

;; pomůcka: rotace opačným směrem.
(define-word :rot- '(:rot :rot))

;; n-té Fibonacciho číslo počínaje n = 1

(define-word :fib '(0 1 :rot :xfib))

(define-word :xfib
             '(:dup 1 := :if :drop :swap :drop :then 
               :rot- :dup :rot :+ :rot 1 :- :xfib :else))

(execute '(5 :fib))

ÚLOHY
-----

1. Definujte slovo :hyp na výpočet délky přepony pravoúhlého 
   trojúhelníka z délek odvěsen:
   (a b -- c)

2. Definujte slovo :discr na výpočet diskriminantu kvadratické rovnice:
   (a b c -- diskriminant)

3. Definujte jako slova logické operace: :not, :and, :or.

4. Definujte slovo :+n na součet n čísel. n je na vrcholu zásobníku,
   čísla pod ním:
   (a1 ... an n -- a1 + ... + an)
|#

#|
(define-word :hyp (lambda ()
                    (let ((a (pop *exec*))
                          (b (pop *exec*)))
                      (push (+ (power a 2)
                               (power b 2)) 
                            *rslt*))))

(define-word :discr (lambda ()
                      (let ((a (pop *exec*))
                            (b (pop *exec*))
                            (c (pop *exec*)))
                        (push (sqrt (- (power b 2)
                                       (* 4 a c)))
                              *rslt*))))

(define-word :not (lambda ()
                    (push (not (pop *exec*)) *rslt*)))

(define-word :and (lambda ()
                    (push (and (pop *exec*)
                               (pop *exec*))
                          *rslt*)))

(define-word :or (lambda ()
                   (push (or (pop *exec*)
                             (pop *exec*))
                             *rslt*)))

(define-word :+n '(:dup 0 := :if :drop 1 :then :dup 1 :- :+n :+ :else))

(execute '(5 :+n))
|#
