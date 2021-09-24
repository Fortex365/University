(defmacro my-when (condition &rest expression)
  `(if ,condition (progn ,@expression) nil))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Definujte macro and-2 a or-2

(defmacro and-2 (expr expr2)
  ;;(if a b nil)
  `(if ,expr ,expr2 nil)) 

(defmacro or-2 (expr expr2)
  ;;(if a a b)
  `(if ,expr ,expr ,expr2))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište makro if-zero, které má stejnou syntax jako if, ale místo podmínky očekává číslo.
;Pokud je číslo nula, vyhodnotí se první větev, jinak se vyhodnotí druhá:

(defmacro if-zero (x y z)
  `(if (zerop ,x) ,y ,z))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Makro unless v Lispu pracuje stejně jako makro when, ale výrazy vyhodnotí,
;když daná podmínka není splněna:

(defmacro my-unless (condition &rest expression)
  ;;Pokud v restu bude (c d) pak ,@expression nám rozbalí
  ;;Do stavu (condition c d)
  `(if ,condition nil (progn ,@expression)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište následující verzi makra when: Makro whenb akceptuje navíc proti
;makru when jako svůj první argument symbol. Na něj bude v těle makra
;navázán výsledek vyhodnocení podmínky.

(defmacro whenb (stored condition &rest expressions)
  `(if ,condition (let ((,stored ,condition))
                    (progn ,@expressions)) nil)) 

(defmacro whenb2 (stored condition &rest expr)
  `(let ((,stored ,condition))
     (if ,stored (progn ,@expr) nil)))

;Napište makro reverse-progn, které pracuje stejně jako speciální operátor
;progn (obdoba schemovského begin), ale výrazy vyhodnocuje v opačném
;pořadí:
(defmacro reverse-progn (&rest expressions)
  `(progn ,@(reverse expressions)))



