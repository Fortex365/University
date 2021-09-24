;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Paradigmata programování 2
;;;;
;;;; Přednáška 9, Normální vyhodnocovací model 2
;;;; Interpret líného Scheme, druhá verze - možnost používat jména
;;;;

(defvar *use-names* nil)

#|
S nastavením *use-names* na nil se interpret chová stejně jako minule.
Pokud chceme, aby používal jména (říkám jim "speciální jména"), 
nastavíme proměnnou na ne-nil:

(setf *use-names* t)

Přidávat nová speciální jména můžeme makrem defname:

(defname IDENTITY (lambda (x) x))

V interpretu jsou definována speciální jména jako IF, TRUE, FALSE, 
CAR, CDR, CONS, SUCC, PRED, ZERO, Y-COMB, +, <=, NATURALS.

Dále je možné pro přirozené číslo použít přímo číslo. 

Interpret se také snaží k výslednému výrazu nalézt zpětně jméno, to se
mu ale vždycky nepodaří.

Podrobnosti dole.
|#


#|
Všechny zakomentované testy si vyzkoušejte (F8)
|#

;; Začátek je stejný jako minule, rozdíly začínají u funkce ls-eval

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
;;           Default je ls-eval
;;
;; Navíc proti minulé verzi lze ve výrazech lze používat jména.
;; To je třeba nastavit proměnnou *use-names* na něco jiného než nil.
;; Funkce ls-eval a ls-force-normal také mají druhý nepovinný parametr, 
;; kterým můžeme také určit, zda mají pracovat se jmény. 
;; Default: hodnota proměnné *use-names*.
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
  (let ((new-head (ls-eval (appl-head app) nil nil)))
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


#|
Funkce ls-eval
--------------

Vyhodnocení výrazu podle normálního vyhodnocovacího modelu.

Úprava proti minulé verzi: pokud je nastaveno *use-names* na ne-nil
funkce nejprve nahradí jména výrazů výrazy. Pak provede redukci jako 
dříve a nakonec nahradí výrazy zpátky jmény.

Má taky nepovinný parametr, ve kterém to lze zadat.

K práci se jmény používá nové funkce expand-names a replace-by-names.
Ty jsou naprogramované dole.

|#

(defun ls-eval (expr &optional (curryp t) (use-names *use-names*))
  (let ((result expr))
    (when use-names (setf result (expand-names result)))
    (when curryp (setf result (curry result)))
    (unless (hnfp result) 
      (setf result (ls-eval (eval-appl-normal result) nil nil)))
    (when use-names (setf result (replace-by-names result)))
    result))

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

;; Práce se jmény:
#|
(setf *use-names* t)
|#

;; U některých testů interpret jméno nerozpozná.

(ls-eval '(lambda (x y) x))
(ls-eval '(lambda (d) d))
(ls-eval 'FALSE)
(ls-eval '(FALSE x))
(ls-eval '(if TRUE x y))
(ls-eval '(if FALSE x y))
(ls-eval '(CONS x y))
(ls-eval '(CAR (CONS x y)))
(ls-eval '(CDR (CONS x y)))
(ls-eval 0)
(ls-eval 1)
(ls-eval '(ZERO? 0))
(ls-eval '(ZERO? 1))
(ls-eval '(CAR 1))

(ls-eval '(PRED 5))
(ls-eval '(PRED 3))
(ls-eval '(PRED 1))
(ls-eval '(PRED 0))

(ls-eval '(SUCC 0))
(ls-eval '(SUCC 10))

(ls-eval '(+ 1 1))
(ls-eval '(+ 1 0))
(ls-eval '(+ 0 1))
(ls-eval '(+ 3 4))
;; Proč to trvá tak dlouho?
(ls-eval '(+ 100 100))

(ls-eval '(<= 0 0))
(ls-eval '(<= 0 5))
(ls-eval '(<= 5 0))
(ls-eval '(<= 5 10))
(ls-eval '(<= 10 5))

(ls-eval '(NATURALS 1))
(ls-eval '(CAR (NATURALS 1)))
(ls-eval '(CAR (CDR (NATURALS 1))))
(ls-eval '(CAR (CDR (CDR (NATURALS 1)))))
|#

;; Zda je výraz v normální formě (tj. jsou expandovány všechny podvýrazy).
;; Použije se v ls-force
(defun nfp (expr)
  (cond ((variablep expr) t)
        ((applicationp expr) (and (hnfp expr) (every #'nfp (appl-list expr))))
        ((abstractionp expr) (nfp (abstr-body expr)))))

#|
(nfp 'x)
(nfp '(lambda (x) y))
(nfp '(x y))
(nfp '((lambda (x y) y) x))
(nfp '(((lambda (x) (x x)) a)
        ((lambda (x) (x x)) b)))
(nfp '((lambda (x) (x x))
        (lambda (x) (x x))))

(nfp '(x ((lambda (x y) y) x)))

|#

#|

Funkce ls-force
---------------

Jiný vyhodnocovací model, redukují se úplně všechny podvýrazy.

Třetí, kompromisní vyhodnocovací model by byl aplikativní 
vyhodnocovací model. Ten nevyhodnocuje těla abstrakcí.
To je model používaný ve většině jazyků. Zkuste ho naprogramovat
(funkce ls-applicative-eval).

|#

(defun force-appl (appl)
  (make-application (ls-force (appl-head appl) nil nil)
                    (mapcar (lambda (expr) 
                              (ls-force expr nil nil))
                            (appl-args appl))))

(defun force-abstr (abstr)
  (make-abstraction (abstr-params abstr)
                    (ls-force (abstr-body abstr) nil nil)))

(defun force-expr (expr)
  (cond ((variablep expr) expr)
        ((applicationp expr) (force-appl expr))
        ((abstractionp expr) (force-abstr expr))))

(defun ls-force (expr &optional (curryp t) (use-names *use-names*))
  (let ((result expr))
    (when curryp (setf result (curry result)))
    (when use-names (setf result (expand-names result)))
    (unless (nfp result) 
      (setf result (ls-force (force-expr result) nil nil)))
    (when use-names (setf result (replace-by-names result)))
    result))

#|

(ls-force '(lambda (x) ((lambda (y) (y y)) x)))

#|
(setf *use-names* t)
|#

(ls-force 1)

;; Toto všechno zhavaruje. Proč?
(ls-force '(+ 0 0))

(ls-force '(+ 1 1))
(ls-force '(+ 1 0))
(ls-force '(+ 0 1))
(ls-force '(+ 3 4))
(ls-force '(+ 100 100))

|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Práce se jmény
;;
;; Proměnná *special-names*, makro defname
;; Funkce expand-names a replace-by-names
;;

#|

První novinka proti minulé verzi
--------------------------------

Každý výraz lze označit jménem. Nemusíme tak například psát výraz
(lambda (p c a) (p c a)), stačí použít jeho jméno IF. To by mělo hezky
zpřehlednit vyhodnocované výrazy.

Jména výrazů mohou být
- lispové symboly (to jsou tzv. *speciální jména*)
- lispová čísla
- pro úplnost se jako jména chápou isamotné výrazy (pokud nemají speciální
  jméno, ani to nejsou čísla)

Zjištění výrazu z jeho jména budeme říkat expanze jména. Ta se provádí
funkcí expand-names.

|#

;; Speciální jména a jejich výrazy ukládáme do globální proměnné.
(defvar *special-names*)
(setf *special-names* '((TRUE . (lambda (x y) x))
                        (FALSE . (lambda (x y) y))
                        (IF . (lambda (p c a) (p c a)))
                        (Y-COMB . (lambda (f) ((lambda (x) (f (x x)))
                                               (lambda (x) (f (x x))))))))

;; Přidání speciálního jména makrem defname:

(defun define-name (name val)
  ;; Pushnew je jako push, ale pokud prvek v seznamu už je, tak se
  ;; nahradí. Tak se dají předefinovat už definovaná jména.
  (pushnew (cons name val) *special-names* :key #'car))

;; defname je makro, aby uživatel nemusel název ani hodnotu kvotovat.
(defmacro defname (name val)
  `(define-name ',name ',val))

#|
Budeme potřebovat funkce na práci se dvěma typy výrazů:
páry a čísly.
|#

;; Konstruktor páru
(defun make-pair-expr (car cdr)
  ;; Redukcí se automaticky zařídí přejmenování parametru z, pokud
  ;; bude třeba.
  (ls-eval `((lambda (x y z) (z x y))
             ,car 
             ,cdr)
           t
           nil))

#|
(make-pair-expr '(lambda (x) x) '(lambda (y) y))
(make-pair-expr '(lambda (x) (x z)) '(lambda (y) (y z)))
|#

;; Typový predikát na pár
(defun pair-expr-p (expr)
  (and (abstractionp expr)
       (let ((param (abstr-param expr))
             (body (abstr-body expr)))
         (and (applicationp body)
              (eql (appl-head body) param)
              (null (cdddr body))
              (not (find param (expr-free-vars (appl-args body))))))))

#|
(pair-expr-p 'x)
(pair-expr-p '(x y))
(pair-expr-p (make-pair-expr 'x 'y)))
(pair-expr-p (make-pair-expr 'z 'z))
(pair-expr-p (expand-number 2))
|#

;; Selektory páru:
(defun pair-expr-car (pair-expr)
  (first (appl-args (abstr-body pair-expr))))

(defun pair-expr-cdr (pair-expr)
  (second (appl-args (abstr-body pair-expr))))

#|
(pair-expr-car (ls-eval '(cons x y)))
(pair-expr-cdr (ls-eval '(cons x y)))
|#

;; Konstruktor čísla:
(defun make-number (n)
  (curry (if (= n 0)
             (make-abstraction '(x) 'x)
           (make-pair-expr '(lambda (x y) y) 
                           (make-number (- n 1))))))

#|

Expanze jmen ve výrazech: funkce expand-names

|#


;; Expanze symbolu. Pokud symbol není speciálním jménem, je to proměnná.
;; Proto pokud symbol nenajdeme jako speciální jméno, vrátíme jej beze změny:
(defun expand-symbol (symbol)
  (let ((pair (assoc symbol *special-names*)))
    (if pair (cdr pair) symbol)))

#|
(expand-symbol 'IF)
|#

;; Expanze čísla jakožto jména:
(defun expand-number (number)
  (make-number number))

#|
(expand-number 2)
|#

;; Expanze jména. (Ve třetí větvi vracíme vstupní výraz, protože
;; byl svým vlastním jménem.)
(defun expand-name (expr)
  (cond ((symbolp expr) (curry (expand-symbol expr)))
        ((integerp expr) (expand-number expr))
        (t expr)))

#|
(expand-name 'TRUE)
(expand-name 1)
(expand-name 'x)
(expand-name '(lambda (x y) z))
|#

(defun expand-names-var (var)
  var)

(defun expand-names-abstr (abstr)
  (make-abstraction (abstr-params abstr)
                    (expand-names (abstr-body abstr))))

(defun expand-names-appl (appl)
  (mapcar #'expand-names
          (appl-list appl)))

(defun expand-names (expr)
  (let ((expanded (expand-name expr)))
    (cond ((variablep expanded) (expand-names-var expanded))
          ((abstractionp expanded) (expand-names-abstr expanded))
          ((applicationp expanded) (expand-names-appl expanded)))))



#|

Další novinka proti minulé verzi interpretu
-------------------------------------------

Hledání jména zadaného výrazu. 

|#

#|

Nejprve je třeba napsat funkci, která zjišťuje,
zda jsou výrazy syntakticky totožné, čili zda se liší jen názvy parametrů
v abstrakcích.

Bude to funkce equivalentp.

|#

;; Jsou dvě proměnné ekvivalentní?
(defun equivalent-vars-p (var1 var2)
  (eql var1 var2))

;; Jsou dvě abstrakce ekvivalentní? Jsou, pokud mají stejný počet
;; parametrů a jejich těla jsou ekvivalentní poté, co všechny
;; parametry druhé abstrakce přejmenujeme na parametry první abstrakce.
(defun equivalent-abstrs-p (abstr1 abstr2)
  (and (= (length (abstr-params abstr1)) (length (abstr-params abstr2)))
       (equivalentp (abstr-body abstr1)
                    (expr-subst (abstr-params abstr1) 
                                (abstr-params abstr2)
                                (abstr-body abstr2)))))

;; Jsou dvě aplikace ekvivalentní? Jsou, pokud mají stejný počet prvků
;; a pokud jsou odpovídající si prvky ekvivalentní.
;; (Funkci every si najděte ve standardu.)
(defun equivalent-applications-p (appl1 appl2)
  (every #'equivalentp (appl-list appl1) (appl-list appl2)))

;; Jsou dva výrazy ekvivalentní?
(defun equivalentp (expr1 expr2)
  (cond ((and (variablep expr1) (variablep expr2))
         (equivalent-vars-p expr1 expr2))
        ((and (abstractionp expr1) (abstractionp expr2)) 
         (equivalent-abstrs-p (curry expr1) (curry expr2)))
        ((and (applicationp expr1) (applicationp expr2))
         (equivalent-applications-p expr1 expr2))
        (t nil)))

(defun special-name-p (name)
  (and (symbolp name)
       (assoc name *special-names*)))

(defun find-special-name (expr)
  (let ((pair (rassoc expr *special-names* :test #'equivalentp)))
    (if pair (car pair) expr)))

(defun true-expr-p (expr)
  (equivalentp expr '(lambda (x y) x)))

(defun false-expr-p (expr)
  (equivalentp expr '(lambda (x y) y)))

#|
(true-expr-p (expand-name 'TRUE))
(true-expr-p (expand-name 'FALSE))
(true-expr-p '(lambda (a b) a))
(true-expr-p '(lambda (a b) b))
(false-expr-p (expand-name 'TRUE))
(false-expr-p (expand-name 'FALSE))
(false-expr-p '(lambda (a b) a))
(false-expr-p '(lambda (a b) b))
|#

(defun find-number-name (expr &optional (orig-expr expr) (add 0))
  (cond ((equivalentp expr '(lambda (x) x)) add)
        ((and (pair-expr-p expr) (false-expr-p (pair-expr-car expr)))
         (find-number-name (pair-expr-cdr expr) orig-expr (+ add 1)))
        (t orig-expr)))

#|
(find-number-name '(lambda (x) x))
|#

(defun find-expr-name (expr)
  (find-special-name (find-number-name expr)))

(defun replace-by-names-appl (appl)
  (make-application (replace-by-names (appl-head appl))
                    (mapcar #'replace-by-names (appl-args appl))))

(defun replace-by-names-abstr (abstr)
  (make-abstraction (abstr-params abstr)
                    (replace-by-names (abstr-body abstr)))) 

(defun replace-by-names (expr)
  (let ((res (find-expr-name expr)))
    (cond ((or (symbolp res) (numberp res)) res)
          ((abstractionp res) (replace-by-names-abstr res))
          ((applicationp res) (replace-by-names-appl res)))))


;; Definice speciálních jmen:
;; (testy jsou nahoře za funkcemi ls-eval a ls-force)

(defname CONS (lambda (x y z) (z x y)))
(defname CAR (lambda (c) (c TRUE)))
(defname CDR (lambda (c) (c FALSE)))

(defname ZERO? (lambda (x) (x TRUE)))
(defname PRED (lambda (n) (CDR n)))
(defname SUCC (lambda (n) (CONS FALSE n)))

(defname %+ (lambda (fun a b)
              (IF (ZERO? b) a (fun (SUCC a) (PRED b)))))
(defname + (Y-COMB %+))

(defname %<= (lambda (fun a b)
               (if (ZERO? a)
                   TRUE
                 (if (ZERO? b)
                     FALSE
                   (fun (PRED a) (PRED b))))))
(defname <= (Y-COMB %<=))

;; nekonečný seznam:
(defname %NATURALS (lambda (fun from)
                     (CONS from (fun (SUCC from)))))
(defname NATURALS (Y-COMB %NATURALS))

