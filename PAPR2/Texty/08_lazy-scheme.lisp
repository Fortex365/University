;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Paradigmata programování 2
;;;;
;;;; Přednáška 8, Normální vyhodnocovací model
;;;; Interpret líného Scheme, první verze
;;;;

#|
Všechny zakomentované testy si vyzkoušejte (F8)
|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Výrazy
;;
;; Výrazy jsou proměnné, abstrakce, aplikace.
;;

;; Proměnná je prostě lispový symbol, programujeme jen typový predikát.
(defun variablep (expr)
  (symbolp expr))

#|
(variablep 'x)
|#

;; Abstrakce je lambda-výraz. Má parametry (seznam symbolů) a tělo.
;; (rozdíl proti čistému teoretickému modelu, kde byl parametr vždy jeden).

;; Typový predikát
(defun abstractionp (expr)
  (and (listp expr)
       (eql (car expr) 'lambda)))

#|
(abstractionp 'x)
(abstractionp '(lambda (x) y))
(abstractionp '(lambda (x y z) y))
|#

;; Selektory

(defun abstr-params (abs)
  (second abs))

;; Vrácení prvního parametru abstrakce. Po provedení curryingu (viz dál)
;; můžeme předpokládat, že abstrakce mají přesně jeden parametr.
;; (pro jistotu to testujeme a vyvoláme chybu, pokud to neplatí)
(defun abstr-param (abs)
  (when (cdr (abstr-params abs))
    (error "Abstraction not curried."))
  (first (abstr-params abs)))

(defun abstr-body (abs)
  (third abs))

;; Konstruktor
(defun make-abstraction (parameters body)
  `(lambda ,parameters ,body))

#|
(make-abstraction '(x y) '(x y))
(abstr-params '(lambda (x y) (x y)))
(abstr-param '(lambda (x y) (x y)))
(abstr-param '(lambda (x) (x y)))
|#

;; Aplikace je libovolný seznam výrazů, který není abstrakce.
;; Má hlavu a argumenty (rozdíl proti čistému teoretickému modelu,
;; kde byl argument vždy jeden).

;; Konstruktor:
(defun make-application (head args)
  (when (null args)
    (error "Application should have at least one argument."))
  (cons head args))

;; Selektory:

(defun appl-head (appl)
  (car appl))

(defun appl-args (appl)
  (cdr appl))

(defun appl-list (appl)
  appl)

;; Typový predikát:
(defun applicationp (expr)
  (and (consp expr)
       (not (abstractionp expr))))

;; Funkce curry: abstrakci s více parametry převede na abstrakci s jedním
;; parametrem, která má v těle abstrakci (viz přednášku).
;; Dále sama sebe aplikuje na tělo abstrakce.
;;
;; U aplikace se rekurzivně zavolá na hlavu a všechny parametry.
;; (v minulé verzi to nedělala, což vedlo k chybám)
;; 
;; U proměnných nedělá nic.
;;
;; V interpretu tento převod děláme hned na začátku, abychom pak
;; mohli předpokládat, že každá abstrakce má jeden parametr.

;; Pomocná funkce, už ví, že parametr je abstrakce.
(defun curry-abstr (abstr)
  (let ((params (abstr-params abstr)))
    (if (null (cdr params))
        (make-abstraction (abstr-params abstr)
                          (curry (abstr-body abstr)))
      (make-abstraction (list (car params))
                        (curry (make-abstraction (cdr params) 
                                                 (abstr-body abstr)))))))

;; Pomocná funkce, už ví, že parametr je aplikace.
(defun curry-appl (appl)
  (make-application (curry (appl-head appl))
                    (mapcar #'curry (appl-args appl))))

(defun curry (expr)
  (cond ((abstractionp expr) (curry-abstr expr))
        ((applicationp expr) (curry-appl expr))
        (t expr)))
    
#|

(curry '(a b))
(curry '(lambda (x) (x y)))
(curry '(lambda (x y) (x y)))
(curry '(lambda (x y z) (x y)))
(curry '(lambda (x y) (lambda (z u) (x y))))

(curry '((lambda (p c a) (p c a)) (lambda (x y) x) x y))

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Volné proměnné ve výrazech: funkce expr-free-vars
;;

#|
Pojem volné proměnné by měl být intuitivně jasný. Definici najdete v textu
k přednášce.

Funkce expr-free-vars vrací seznam volných proměnných daného výrazu.

Následující pomocné funkce hledají seznam volných proměnných proměnné, 
aplikace a abstrakce
|#

(defun var-free-vars (var)
  (list var))

#|

Funkce remove-duplicates a mapcan si můžete najít ve standardu. Stručně:

remove-duplicates odstraní ze seznamu duplicitní hodnoty:

(remove-duplicates '(1 2 1 3 3 2 4 2))

mapcan funguje jako mapcar, ale výsledné hodnoty spojí jako seznamy:

(mapcar #'reverse '((1 2 3) (4 5 6) (7 8 9 10)))
(mapcan #'reverse '((1 2 3) (4 5 6) (7 8 9 10)))

|#

(defun appl-free-vars (appl)
  (remove-duplicates (mapcan #'expr-free-vars (appl-list appl))))

(defun abstr-free-vars (abstr)
  (remove (abstr-param abstr) 
          (expr-free-vars (abstr-body abstr))))

(defun expr-free-vars (expr)
  (cond ((variablep expr) (var-free-vars expr))
        ((applicationp expr) (appl-free-vars expr))
        ((abstractionp expr) (abstr-free-vars expr))))

#|
(expr-free-vars '((lambda (x) (x y z))
                  u))
|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Přejmenování parametru v abstrakci. 
;;
;; (Potřebujeme, abychom se vyhnuli kolizi symbolů)
;;

;; K danému parametru najde nový jedinečný symbol s podobným jménem:
(defun renamed-param (param)
  (gensym (symbol-name param)))

#|
(renamed-param 'a)
|#

;; Přejmenuje parametr abstrakce.
;; Pomocná funkce pro funkci rename-param
;; Používá funkci expr-subst, která je definovaná dále,
(defun rename-param-1 (abstr)
  (let ((new (renamed-param (abstr-param abstr))))
    (make-abstraction (list new)
                      (expr-subst new (abstr-param abstr) (abstr-body abstr)))))

;; Pokud parametr abstrakce je prvkem daného seznamu, přejmenuje ho.
(defun rename-param (abstr symbol-list)
  (if (find (abstr-param abstr) symbol-list)
      (rename-param-1 abstr)
    abstr))
      

#|
(rename-param '(lambda (y) 
                  ((x y) (y z) (lambda (y) y)))
               '(y z))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Substituce volných proměnných daného výrazu danými hodnotami: 
;; funkce expr-subst
;;
;; Tato funkce i tři pomocné funkce mají lambda-seznam (val var expr), kde
;; - val je nová hodnota dosazená místo proměnné
;; - var proměnná, místo které se hodnota dosazuje
;; - expr výraz, ve kterém se to děje

(defun var-subst (val var orig-var)
  (if (eql orig-var var)
      val
    orig-var))

(defun appl-subst (val var appl)
  (make-application (expr-subst val var (appl-head appl))
                    (mapcar (lambda (subexpr)
                              (expr-subst val var subexpr))
                            (appl-args appl))))

#|
Substituce v abstrakci (lambda-výrazu) je principiálně jednoduchá.
Je prostě třeba substituovat v jejím těle všechny volné výskyty symbolu.

Situaci ale komplikuje, že někdy je třeba v abstrakci přejmenovat
parametr, aby se nedostal nesprávný výsledek.

Příklad, který je uveden i dole:
Při substituci výrazu y za proměnnou x ve výrazu (lambda (y) (y x))
je třeba nejdřív přejmenovat parametr y. Prostým nahrazením bychom
dostali nesprávný výsledek (lambda (y) (y y)). Správný výsledek je
např. (lambda (z) (z y)).

Pravidlo: parametr abstrakce je třeba přejmenovat, pokud se nachází
mezi volnými proměnnými dosazovaného výrazu.
|# 

(defun abstr-subst (val var abstr)
  (if (eql var (abstr-param abstr))
      abstr
    (let ((new-abstr (rename-param abstr (expr-free-vars val))))
      (make-abstraction (abstr-params new-abstr)
                        (expr-subst val var (abstr-body new-abstr))))))

#|

val:  nová hodnota
var:  proměnná, která se nahradí novou hodnotou
expr: výraz, ve kterém se náhrada provede

|#
(defun expr-subst (val var expr)
  (cond ((variablep expr) (var-subst val var expr))
        ((applicationp expr) (appl-subst val var expr))
        ((abstractionp expr) (abstr-subst val var expr))))

#|

(expr-subst 'y 'x 'x)
(expr-subst 'y 'x 'z)
(expr-subst 'y 'x '(x z x))
(expr-subst 'y 'x '(lambda (z) (z x)))
(expr-subst 'y 'x '(lambda (x) (z x)))
(expr-subst 'y 'x '(lambda (y) (y x)))
(expr-subst '(x y) 'x '((lambda (x) (x x))
                        (lambda (y) (x y))))

|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vstupní body interpretu: funkce ls-eval, ls-force, ls-repl
;;
;; ls-eval:  vyhodnocení výrazu podle normálního vyhodnocovacího modelu.
;;           Vyhodnocuje tedy až na hlavovou normální formu.
;;          
;; ls-force-normal: vyhodnocení výrazů i všech podvýrazů. Redukuje až na 
;;           normální formu. Ovšem líným vyhodnocováním, takže by se neměl
;;           zbytečně zacyklit.
;;
;; ls-repl:  spustí repl líného Scheme. Jako nepovinný argument lze zadat
;;           zvolený vyhodnocovací model (funkci ls-eval nebo ls-force). 
;;           Default je ls-eval. 
;;

#|
Beta-redukce. Jako parametry máme hlavu a argumenty. Hlava je určitě abstrakce 
(tj. lambda-výraz). Počet argumentů může být i větší než 1 (což je nedůslednost 
tohoto interpretu). Pak je výsledkem stále aplikace.
Viz příklady pod funkcí.
|#
(defun beta-reduction (head args)
  (let ((res (expr-subst (car args) (abstr-param head) (abstr-body head))))
    (if (cdr args)
        (make-application res (cdr args))
      res)))

#|
(beta-reduction '(lambda (x) x)
                '(a))

;; Tady je víc než jeden argument (zůstane aplikace):
(beta-reduction '(lambda (x) (x y))
                '(a b))

;; S přejmenováním parametru:

(beta-reduction '(lambda (x) (lambda (y) (x y)))
                '(y z))

|#

#|

Funkce ls-eval
--------------

Vyhodnocení výrazu podle normálního vyhodnocovacího modelu.

|#

#|
Jeden krok vyhodnocení aplikace normálním vyhodnocovacím modelem. 
Funkce se nejdřív podívá na hlavu (první prvek)
a vyhodnotí ji (normálním modelem). Pokud je výsledkem abstrakce,
lze provést beta-redukci. Jinak ne a změní se jen to, že je hlava
vyhodnocená.
|#

(defun eval-appl-normal (app)
  (let ((new-head (ls-eval (appl-head app) nil)))
    (if (abstractionp new-head)
        (beta-reduction new-head (appl-args app))
      (make-application new-head (appl-args app)))))

#|
Zjišťujeme, zda je výraz tzv. hlavová normální forma (head normal form), 
tedy výraz, který už nechceme redukovat.
|#
(defun hnfp (expr)
  (or (variablep expr)
      (abstractionp expr)
      (and (not (abstractionp (appl-head expr)))
           (hnfp (appl-head expr)))))

#|
(hnfp 'x)
(hnfp '(lambda (x) y))
(hnfp '(x y))
(hnfp '((lambda (x y) y) x))
(hnfp '(((lambda (x) (x x)) a)
        ((lambda (x) (x x)) b)))
(hnfp '((lambda (x) (x x))
        (lambda (x) (x x))))

(hnfp '(x ((lambda (x y) y) x)))
|#

(defun ls-eval (expr &optional (curryp t))
  (when curryp (setf expr (curry expr)))
  (if (hnfp expr) 
      expr
    (ls-eval (eval-appl-normal expr))))

#|

;; Symbol se nevyhodnocuje, tj, jeho vyhodnocením je on sám.
(ls-eval 'x)
;; Aplikace by se mohla vyhodnocovat, ale první prvek (hlava) by se musel
;; vyhodnotit na abstrakci (lambda-výraz).
(ls-eval '(x y))

;; Obyčejné dosazení:
(ls-eval '((lambda (x) (x y)) z))
;; Dosazení x za x:
(ls-eval '((lambda (x) (x y)) x))
;; Dosazení y za x:
(ls-eval '((lambda (x) (x y)) y))

;; Dále používáme currying

;; Tady se musí přejmenovávat parametry:
(ls-eval '((lambda (x y) (x y)) y))
(ls-eval '((lambda (x y) (x y)) y z))
(ls-eval '((lambda (x y z) (z x y)) z z))
(ls-eval '((lambda (x y z) (z x y)) y z))

;; Dosazení a za x, y zůstává
(ls-eval '((lambda (x y) (x y)) a))
;; Dosazení a za x, b za y. c zůstává.
(ls-eval '((lambda (x y) (x y)) a b c))

;; Bylo nutné zredukovat hlavu, ale výsledek (a a) není abstrakce,
;; takže další redukce se neprovedla:
(ls-eval '(((lambda (x) (x x)) a)
           ((lambda (x) (x x)) b)))

;; Toto se zacyklí:
(ls-eval '((lambda (x) (x x))
           (lambda (x) (x x))))

;; Tohle vedlo v minulé verzi k chybě 
;; se jmény by to bylo (if TRUE x y):
(ls-eval '((lambda (p c a) (p c a))
           (lambda (x y) x)
           x
           y))

|#

    
#|

Funkce ls-force-normal
----------------------

Jiný vyhodnocovací model, používá normální vyhodnocovací model,
ale snaží se redukovat úplně všechny podvýrazy. Tedy: nehledá
hlavovou normální formu, ale normální formu. 
(netestován)

Další, kompromisní vyhodnocovací model by byl aplikativní 
vyhodnocovací model. Ten sice hledá jen hlavovou nf, ale vyhodnocuje
argumenty aplikací.
To je model používaný ve většině jazyků. Zkuste ho naprogramovat
(funkce ls-applicative-eval).

|#

#|
Zjistí, zda je výraz normální forma, tj. že neobsahuje žádný redex
(netestováno)
|#

(defun nfp (expr)
  (or (variablep expr)
      (and (abstractionp expr) (nfp (abstr-body expr)))
      (and (not (abstractionp (appl-head expr)))
           (every #'nfp (appl-list expr)))))


(defun force-appl (appl)
  (make-application (ls-force-normal (appl-head appl) nil)
                    (mapcar (lambda (arg)
                              (ls-force-normal arg nil))
                            (appl-args appl))))

(defun force-abstr (abstr)
  (make-abstraction (abstr-params abstr)
                    (ls-force-normal (abstr-body abstr) nil)))

(defun force-expr (expr)
  (cond ((variablep expr) expr)
        ((applicationp expr) (force-appl expr))
        ((abstractionp expr) (force-abstr expr))))

(defun ls-force-normal (expr &optional (curryp t))
  (when curryp (setf expr (curry expr)))
  (if (nfp expr)
      expr
    (force-expr expr)))

#|

(ls-force-normal '(lambda (x) ((lambda (y) (y y)) x)))

|#

#|

Spuštění replu.

|#
(defun ls-repl (&optional (eval-model #'ls-eval))
  (loop (format t "~%~%> ")
        (princ (funcall eval-model (prog1 (read) (fresh-line))))))