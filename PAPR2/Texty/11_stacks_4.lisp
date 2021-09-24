;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; 11_stacks_4.lisp - Zásobníkové programování
;;;
;;; Jazyk pro myšlený zásobníkový stroj.
;;; fáze 4 - interpretace vloženého Scheme
;;;
;;; Předchozí soubory musí být načteny.


#|
Do programu pro náš stroj bude možné vkládat výrazy jazyka Scheme.
Ty budeme za běhu programu překládat do jazyka stroje a vykonávat.
(Primitivní Just In Time Compilation, kterou známe z Javy, .NET atd.)
|#

;; Atomické výrazy Scheme jsou tytéž jako hodnoty našeho jazyka:
;; čísla a symboly (které nejsou slova).
;; Složený výraz Scheme je neprázdný seznam, který není procedura.

(defun schemep (elem)
  (and (consp elem) (not (procedurep elem))))

;; Můžeme tedy doplnit naši funkci exec-step:

(setf dspec:*redefinition-action* :quiet)

(defun exec-step ()
  (let ((elem (pop *exec*)))
    (cond ((wordp elem) (exec-word elem))
          ((symbolp elem) (exec-symbol elem))
          ((procedurep elem) (exec-proc elem))
          ((schemep elem) (compile-scheme elem))
          (t (push elem *rslt*)))))

(setf dspec:*redefinition-action* :warn)

;; Účelem tohoto souboru je definovat funkci compile-scheme
;; Zavedeme čtyři spec. operátory (jako v prosinci)

(defun compile-scheme (expr)
  (let ((op (car expr))
        (args (cdr expr)))                            
    (cond ((eql op 'quote) (compile-quote args))         
          ((eql op 'if) (compile-if args))           
          ((eql op 'define) (compile-define args))       
          ((eql op 'lambda) (compile-lambda (car args) (cdr args)))   
          (t (compile-application expr)))))

(defun compile-quote (args)
  (push (car args) *exec*)
  (push :noexec *exec*))

;; Podvýrazy se zkompilují příště
(defun compile-if (args)
  (let ((condition (pop args))
        (then (pop args))
        (else (pop args)))
    (setf *exec*
          (append (list condition :if then :then else :else)
                  *exec*))))

(defun compile-define (args)
  (let ((var (pop args))
        (expr (pop args)))
    (setf *exec*
          (append (list expr :noexec var :bind)
                  *exec*))))

;; U lambda-výrazu bez parametrů ytvoříme novou proceduru a pomocí 
;; :noexec potlačíme její spuštění. 
;; U výrazu s parametry vytvoříme lambda-výraz bez prvního parametru
;; s upraveným tělem. 
(defun compile-lambda (params body)
  (if (null params)
      (progn (push (cons '%proc body) *exec*)
        (push :noexec *exec*))
    (push `(lambda ,(cdr params)
             :noexec ,(car params) :bind
             ,@body
             :unbind)
          *exec*)))

(defun compile-application (expr)
  (push :exec *exec*)
  (setf *exec* (revappend expr *exec*)))

#|

;; Pečlivě všechno otestujeme.

;; quote

(execute '((quote a)))
(execute '('(1 2 3)))


;; if:

(execute '((if 't 1 2)))
(execute '((if 'nil 1 2)))

;; define

(execute '((define five 5)))
(execute '(five))
(execute '((define t 't)))
(execute '((define nil 'nil)))

(execute '((if t 1 2)))
(execute '((if nil 1 2)))

;; lambda

(execute '((lambda () a b c))) 
(execute '((lambda (a) a b c)))
(execute '((lambda (a b) a b c)))

;; aplikace:

(execute '((+ 1 2)))
(execute '((if (= 1 2) 3 4)))

;; Zátěžový test:
(execute '((define fact (lambda (n)
                          (if (= n 0)
                              1
                            (* n (fact (- n 1))))))))

(execute '((fact 5)))

|#