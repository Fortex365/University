;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; 11_stacks_2.lisp - Zásobníkové programování
;;;
;;; Jazyk pro myšlený zásobníkový stroj.
;;; fáze 2 - vazby
;;;
;;; Předchozí soubor musí být načten.

;;
;; Slovník vazeb
;;

(defvar *bnd*)
(setf *bnd* `((pi . ,pi)))

(define-word :noexec (lambda ()
                       (when (wordp (car *exec*))
                         (error "Word cannot go to the rslt stack."))
                       (push (pop *exec*) *rslt*)))

(define-word :bind
             (lambda ()
               (dict-push (pop *rslt*) (pop *rslt*) *bnd*)))

(define-word :unbind
             (lambda () (pop *bnd*)))

;;
;; Vykonání symbolu
;;

(defun exec-symbol (sym)
  (push (dict-find sym *bnd*) 
        *rslt*))

;;
;; Spuštění programu
;;

;; Nové verze funkcí exec-step a execute
;; Nastavujeme proměnnou dspec:*redefinition-action*, abychom
;; potlačili warning o předefinování funkce z jiného souboru.
;; Nemusíte to řešit, ale můžete zkusit dát nastavení pryč, vyhodnotit
;; první soubor a pak zase tento soubor.
;; (proměnná je definována v LispWorks, není to standardní Common Lisp!)

(setf dspec:*redefinition-action* :quiet)

;; Jeden krok:
(defun exec-step ()
  (let ((elem (pop *exec*)))
    (cond ((wordp elem) (exec-word elem))
          ((symbolp elem) (exec-symbol elem))
          (t (push elem *rslt*)))))

(setf dspec:*redefinition-action* :warn)

#|

(execute '(3 :noexec x :bind 4 :noexec y :bind y x y :+ :unbind :unbind))

;; obsah kruhu daného poloměru:
(define-word :carea
             '(:dup :* pi :*))

(execute '(10 :carea))


ÚLOHY
-----

5. Definujte slovo :avgn na výpočet aritmetického průměru n čísel.
   n je na vrcholu zásobníku, čísla jsou pod ním:
   (a1 ... an n -- průměr čísel a1 ... an)


(define-word :+n '(:dup 0 := :if :drop 1 :then :dup 1 :- :+n :+ :else))

(define-word :avgn '(:dup :+n :swap :/))

(execute '(5 :avgn))
|#

