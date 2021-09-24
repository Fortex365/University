;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Paradigmata programování 2
;;;;
;;;; Přednáška 2, Makra
;;;; Interpret Scheme s makry
;;;;

#|

Interpret Scheme z minulého semestru s přidanými makry.

|#


#|

Jak interpret pracuje s makry
-----------------------------

Interpret si musí pamatovat všechna makra. Konkrétně, pro každé makro si musí
pamatovat jeho název a expanzní proceduru. Proto zavádíme globální proměnnou
*macros*, ve které je uložen seznam, jehož prvky popisují jednotlivá makra.
Popis každého makra je dán párem, v jehož car je název makra (symbol) a v cdr
jeho expanzní procedura. Seznam je na začátku prázdný.

Interpret musí proti předchozí verzi umět
1. Umožnit uživateli definovat nové makro (tj. poskytnout mu nový speciální
   operátor, který údaje o novém makru zapíše do proměnné *macros*).
2. Umět vyhodnotit seznam, jehož prvním prvkem je název makra (tj. poznat,
   že je to název makra, spustit příslušnou expanzní proceduru a expandované
   makro dát znovu vyhodnotit).

Podrobnosti o proměnné *macros* a uvedených dvou bodech jsou níže.

Ze zdrojového kódu jsou odstraněny některé vysvětlující komentáře z předchozí 
verze, aby bylo snadnější soustředit se na makra.

|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vstupní bod: funkce ss-eval
;;

;; symbol t reprezentuje globální prostředí
(defun ss-eval (expr)
  (ss-eval-env expr t))

(defun ss-eval-env (expr env)       
  (if (compound-expr-p expr)        
      (eval-compound-expr expr env) 
    (eval-atom expr env)))

(defun compound-expr-p (expr)
  (consp expr))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Prostředí
;;

;; konstruktor make-env vytváří prostředí ze seznamu vazeb (párů) a předka
(defun make-env (bindings parent)
  (list 'env bindings parent))

;; konstruktor  make-env-sv vytváří prostředí ze seznamu symbolů, seznamu hodnot 
;; a předka
(defun make-env-sv (symbols values parent)
  (make-env (mapcar #'cons symbols values)
            parent))


;; selektory
;; get-env překládá symbol t na globální prostředí
(defun get-env (spec)
  (if (eql spec t) (initial-env) spec))

(defun env-bindings (env)
  (cadr (get-env env)))

(defun env-parent (env)
  (caddr (get-env env)))

;; přidání vazby k prostředí
(defun add-binding (env symbol value)
  (make-env (cons (cons symbol value) (env-bindings env))
            (env-parent env)))

;; globální (počáteční) prostředí
(let ((env (make-env (list (cons 'zero 0) (cons '+ #'+) (cons '- #'-)
                           (cons '* #'*) (cons '= #'=)
                           (cons 'cons #'cons)
                           (cons 'list #'list))         ;kvůli makrům
                     nil)))

  (defun initial-env ()
    env)

  (defun set-initial-env (value)
    (setf env value)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Hodnota symbolu v prostředí
;;

;; hledání vazby symbolu symbol-binding-1 hledá jen v daném prostředí,
;; symbol-binding i v předcích
;; úprava s funkcí find
(defun symbol-binding-1 (symbol env)
  (find symbol (env-bindings env) :key #'car))

(defun symbol-binding (symbol env)
  (let ((bnd (symbol-binding-1 symbol env)))
    (if (consp bnd)
        bnd
      (symbol-binding symbol (env-parent env)))))

;; hodnota symbolu v prostředí: nejprve se najde jeho vazba a pak pomocí
;; cdr její hodnota
(defun sym-value (symbol env)
  (cdr (symbol-binding symbol env)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Makra
;;

;; Definice proměnné *macros*. Proměnná obsahuje seznam párů, každý pár je
;; tvaru (name . exp-proc), kde name je název makra (symbol) a exp-proc jeho
;; expanzní procedura, napsaná samozřejmě v našem Scheme.
(defvar *macros*)

;; Seznam je na začátku prázdný:
(setf *macros* '())

#|
Přístupové funkce (selektory a mutátor) k seznamu maker.
|#

;; Vrátí expanzní proceduru k danému makru. Parametr mac je název makra, tj.
;; symbol. Vrátí nil, pokud makro neexistuje (cdr z nil je nil, nikoli chyba
;; jako ve Scheme).
(defun expansion-proc (mac)
  (cdr (find mac *macros* :key #'car)))

;; Predikát, který zjistí, zda daný symbol je název makra. Jelikož cokoli
;; kromě nil znamená pravdu, můžeme prostě zavolat funkci expansion-proc.
(defun macrop (sym)
  (expansion-proc sym))

;; Funkce add-macro přidává makro k seznamu maker v proměnné *macros*. Jde o
;; vedlejší efekt (obsah proměnné *macros* se mění). Makro je zadáno názvem
;; (parametr mac) a expanzní procedurou (parametr expansion-procedure).
(defun add-macro (mac expansion-procedure)
  (setf *macros* (cons (cons mac expansion-procedure)
                       *macros*)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vyhodnocení atomů
;;

(defun eval-atom (atom env) 
  (if (symbolp atom)        
      (sym-value atom env)  
    atom))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vyhodnocení složených výrazů
;;

;; Funkce eval-compound-expr je rozšířená o práci s makry. Realizuje dva nahoře 
;; uvedené body: možnost definice makra a vyhodnocení výrazu, jehož první prvek 
;; je název makra.

(defun eval-compound-expr (expr env)
  (let ((op (car expr))
        (args (cdr expr)))                            
    (cond ((eql op 'quote) (eval-quote args))         
          ((eql op 'if) (eval-if args env))           
          ((eql op 'define) (eval-define args))       
          ((eql op 'lambda) (eval-lambda args env))   
          ;; Nový speciální operátor define-macro, pomocí něhož uživatel 
          ;; definuje makra. Má tři argumenty stejně jako operátor defmacro
          ;; v Lispu. Funkce eval-define-macro je definována dole.
          ((eql op 'define-macro) (eval-define-macro args))
          ;; Vyhodnocení výrazu s makrem. Na test, zda je první prvek 
          ;; vyhodnocovaného výrazu název makra, používáme výše definovaný
          ;; predikát macrop. Pokud je, vyhodnocujeme makro-výraz ve funkci
          ;; eval-macro (definovaná dole).
          ((macrop op) (eval-macro op args env))                
          (t (eval-application op args env)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Aplikace procedury
;;

;; procedura vzniklá vyhodnocením operátoru se aplikuje na hodnoty vzniklé
;; vyhodnocením argumentů:
(defun eval-application (op args env)
  (apply-proc (ss-eval-env op env)
              (eval-list-elements args env)))

(defun eval-list-elements (list env)
  (mapcar (lambda (el) (ss-eval-env el env))
          list))

(defun apply-proc (proc args)      
  (if (primitivep proc)            
      (apply-primitive proc args)  
    (apply-user-proc proc args)))

(defun primitivep (proc)
  (functionp proc))

(defun apply-primitive (proc args) 
  (apply proc args))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Uživatelsky definované procedury
;;

;; konstruktor:
(defun make-proc (params body env)
  (list 'proc params body env))

;; selektory:
(defun proc-params (proc)
  (cadr proc))

(defun proc-body (proc)
  (caddr proc))

(defun proc-env (proc)
  (cadddr proc))

;; vahodnocení lambda-výrazu znamená vytvoření procedury:
(defun eval-lambda (args env)
  (make-proc (car args) (cadr args) env))

;; aplikace uživatelské procedury přesně podle vyhodnocovacího procesu:
(defun apply-user-proc (proc args)
  (ss-eval-env (proc-body proc)
               (make-env-sv (proc-params proc) 
                            args
                            (proc-env proc))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Speciální operátory quote, if, define
;;

(defun eval-quote (args) 
  (car args))

(defun eval-if (args env)             
  (if (ss-eval-env (car args) env)    
      (ss-eval-env (cadr args) env)   
    (ss-eval-env (caddr args) env)))

(defun eval-define (args) 
  (set-initial-env        
   (add-binding t (car args) (ss-eval (cadr args))))
  (car args))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Speciální operátor define-macro a vyhodnocení makra
;;

;; Funkce na vyhodnocení výrazu se spec. operátorem define-macro. Argumenty 
;; operátoru jsou stejné jako v defmacro v Lispu. Tedy:
;; (first args): název makra
;; (second args): seznam parametrů expanzní procedury
;; (third args): tělo expanzní procedury
;; Funkce přidá nové makro do seznamu *macros* funkcí add-macro, kterou jsme
;; definovali nahoře.
;; Expanzní proceduru vytvoříme funkcí make-proc, která byla přítomna už v
;; původním interpretu.
(defun eval-define-macro (args)
  (add-macro (first args)
             (make-proc (second args) (third args) (initial-env))))

;; Funkce eval-macro vyhodnotí makro-výraz přesně tak, jak se makra mají
;; vyhodnocovat: nejprve se výraz expanduje a pak se výsledek expanze
;; vyhodnotí. Parametry jsou název makra (mac), seznam argumentů makra (args)
;; a prostředí, ve kterém se výraz vyhodnocuje. Makro se expanduje funkcí
;; expand-macro, která je napsaná dole.
(defun eval-macro (mac args env)
  (ss-eval-env (expand-macro mac args) env))

;; Funkce expand-macro expanduje makro dané názvem a seznamem argumentů.
;; Používá funkci expansion-proc, kterou jsme napsali nahoře a která k danému
;; názvu makra vrací jeho expanzní proceduru. Dále používá funkci 
;; apply-user-proc z původní verze interpretu. Funkce aplikuje expanzní 
;; proceduru (expanzní procedura je uživatelská procedura) na argumenty makra.
(defun expand-macro (mac args)
  (apply-user-proc (expansion-proc mac) args))




#|

;; Testy:

;; Můžete každý řádek zkopírovat do Listeneru a vyhodnotit, nebo
;; vyhodnocovat přímo tady pomocí F8.

(ss-eval 1)
(ss-eval '(if 1 2 3))
(ss-eval 'zero)
(ss-eval '(define a 10))
(ss-eval 'a)

;; Problém (vyřešit na cvičení):
(ss-eval 'x)

(ss-eval '(define fact (lambda (n)
                         (if (= n 0)
                             1
                           (* n (fact (- n 1)))))))
                         
(ss-eval '(fact 5))

|#

#|

;; Testy na makra:
*macros*
(ss-eval '(define-macro impl (a b) (list 'if a b ''t)))
;; (proč musí být u symbolu t dva apostrofy? jak to napravit?)
*macros*
(expansion-proc 'impl)
(expand-macro 'impl '(a b))
(ss-eval '(impl 1 2))
(ss-eval '(impl 'nil 2))
(ss-eval '(impl 2 'nil))
;; (proč musí být u symbolu nil apostrof? jak to napravit?)

|#