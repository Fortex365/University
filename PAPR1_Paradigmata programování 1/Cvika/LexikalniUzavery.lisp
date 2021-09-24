;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(funcall (lambda (x) (funcall x 10)) (lambda (x) 20))

;vysledkem bude 20

;prvni anonymni funkce lambda (x) (funcall x 10) vola druhou anonymni funkci, s argumentem 10 
;druha anonymni funkce volana s argumentem 10 vraci hodnotu dvacet, proto aplikace
;volani prvni anonymni funkce na druhou, vrati vysledek 20



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;přepište výraz (let ((x a)) telo)
;tak, aby neobsahoval speciální operátory let, let* a přitom si zachoval týž
;(hlavní i vedlejší) efekt.
(defun my-let (x a)
  (funcall (lambda (x) x) a))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scale-list (list factor)
  (labels ((prod (x) (* x factor)))
    (my-mapcar #'prod list)))

(defun my-mapcar (fun list)
  (if (null list)
      '()
    (cons (funcall fun (car list))
          (my-mapcar fun (cdr list)))))
;Jaka vznikaji prostredi pri aplikace funkce scale-list-my-mapcar?
;1) (scale-list '(1 2) 2) se vytvori nove prostredi, jehoz predkem bude globalni prostredi
;2)toto nove prostredi, se navazou hodnoty argumentu list = (1 2); factor = 2
;3)makro labels vytvori nove prostredi, na argument prod = #<>
;4)tělo labels, má mapcar který si vytváří svoje prostředí s argumenty fun = #<>; list = (1 2)
;5)vznika nove prostredi mapcaru fun, jeho predkem je prostredi labels, argument je x = 1
;6)vznika druhe nove prostedi mapcaru fun, jeho predkem je prostredi labels, argument je list = nil; fun = #<>, predkem je globalni prostredi
;7)vyhodnoti se telo mapcaru s argumenty 2 a nil, vraci (cons 2 nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;4;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scale-list-my-mapcar-2 (list factor)
  (my-mapcar (lambda (x) (* x factor))
          list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pomoci funkce accumulate napište funkci, která vrátí největší prvek dané číselné posloupnosti ohraničený zadanými indexy
(defun accumulate (seq from to combiner null-val)
  (if (< to from)
      null-val
    (funcall combiner
             (mem seq from)
             (accumulate seq (1+ from) to combiner null-val))))

(defun posl-max (seq from to)
  (accumulate seq from to (lambda (x) (< (+ x 1) (x))) 0))
;nejvetsi prvek z dane ciselne posloupnosti, je na takovem indexu ze na zadnem dalsim indexu se nenachazi prvek vetsi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;6;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;7;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;8;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fib (n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (t (+ (fib (- n 2)) (fib (- n 1))))))

;dodelat 5, 6, 7 a 8