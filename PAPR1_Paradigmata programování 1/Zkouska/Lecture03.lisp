 ;Podívejte se na definici funkce percentage-2. Ve kterém prostředí se při její aplikaci vyhodnocuje výraz (eql whole t) a ve kterém výraz (/part whole)?
(defun percentage-2 (part whole)
  (let ((whole (if (eql whole t) 10668641 whole)))
    (* (/ part whole) 100.0)))
;Výraz (eql whole t) se vyhodnocuje v prostředí, které vznikne aplikací uživatelské funkce percantage-2 a v prostředí, které vytvořilo let.
;Výraz (/part whole) se vyhodnocuje v prostředí, které vzniklo aplikací uživatelské funkce percantage-2. 

;Jaký je rozdíl mezi rekurzivní funkcí a rekurzivním výpočetním procesem?
;Rekurzivní funkce volá sama sebe ve svém těle funkce.
;Rekurzivní výpočetní proces se dá poznat podle běhu programu. Že se aplikuje rekurzivní funkce v dalším průchodu.

;Existuje rekurzivní funkce, která nikdy negeneruje rekurzivní výpočetní proces?
(defun something (n)
  (if (<= n 0)
      (print "IDK")
    (something (1- n))))

;Existuje nerekurzivní funkce, která generuje rekurzivní výpočetní proces?
(defun jedna (a)
  (dva a))

(defun dva (a)
  (jedna a))

;Obsah elipsy s poloosami a a b je pi*a*b
;Proto jej můžeme vypočítat pomocí následující funkce
(defun ellipse-area0 (a b)
  (* pi a b))

;Když a=b je elipsa kružnicí. Upravte funkci tak, aby druhý argument stačilo zadat t. Napište to co nejvíce způsoby, jeden z nich by měl být rekurzivní.
(defun ellipse-area1 (a b)
  (if (eql b t)
      (ellipse-area1 a a)
    (ellipse-area1 a b)))

(defun ellipse-area2 (a b)
  (if (= a b)
      (ellipse-area2 a a)
    (ellipse-area2 a b)))

(defun ellipse-area3 (a b)
  (if (eql b t)
      (let ((x a))
        (ellipse-area3 a x))))

;Lze funkci squarep napsat jinak, než je zapsáno v textu?
(defun squarep (n)
  (= (power2 (round (sqrt n))) n))

(defun power2 (a)
  (expt a 2))
;Možná ano, ale nenapadá mě druhý způsob, tento způsob se mi líbí nejvíce. 

;Napište funkci my-gcd, která vypočte největší společný dělitel zadaných dvou přirozených čísel.
(defun my-gcd (a b)
  (if (= b 0) a
    (let ((c (rem a b)))
      (my-gcd b c))))

;Napište funkci heron-sqrt, která metodou postupných aproximací vypočítá odmocninu ze zadaného čísla se zadanou přesností. Více viz. lecture03
(defun my-function (x a)
  (/ (+ x (/ a x)) 2))

(defun approxp (a b epsilon)
  (<= (abs (- a b)) epsilon)) ;rozdil 'a' 'b' v absolutni hodnote, pokud je mensi nebo rovny epsilon, znamena to, ze 'a' se blizi k 'b' s toleranci +- epsilon

(defun heron-sqrt (a epsilon)
  (heron-sqrth a 1.0 epsilon))

(defun heron-sqrth (a x epsilon)
  (let ((next (my-function a x))) ;promenna next nam oznacuje hodnotu, ktera se bude menit v zavislosti na poctu prochodu
    (if (approxp next (power2 a) epsilon) 
        next
      (heron-sqrth a next epsilon))))

;Napište hloupou funkci na výpočet součtu prvků intervalu celých čísel
(defun my-sum-interval (from to)
  (if (>= from to) from
    (+ from (my-sum-interval (+ from 1) to))))

;Upravte ji tak, aby generovala iterativní výpočetní proces.
(defun my-sum-interval-iterative (from to)
  (my-sum-interval-iterative-help from to 0))

(defun my-sum-interval-iterative-help (from to ir)
  (if (> from to) ir
    (my-sum-interval-iterative-help (+ from 1) to (+ ir from))))

;Upravte funkci power, tak aby generovala iterativni vypocetni proces.
(defun power (a n)
  (power-help a n 1))

(defun power-help (a n ir)
  (if (= n 0) ir
    (power-help a (- n 1) (* ir a))))

(defun powerlabels (a n)
  (labels ((help (a n ir)
             (if (= n 0) ir
               (help a (- n 1) (* ir a)))))
    (help a n 1)))

;Cislo pi lze s libovolnou presnosti vypocitat pomoci Liebnizovy formule viz. lecture03. Napiste funkci leibniz, ktera vypocte cislo pi/4 s libovolnou presnosti. Napiste rekurzivni a take iterativni verzi teto funkce.
(defun leibniz (a)
  (leibniz-help a 1 1))

(defun leibniz-help (a index denom) ;denom je anglicky nazev pro jmenovatel (to dole ve zlomku :D)
  (cond ((< a index) "0-tá přesnost čísla pí neexistuje")
        ((= a 1) 1)
        ((oddp index) (+ (leibniz-help a (+ 1 index) (+ 2 denom)) (/ 1 denom))) ;pro liche indexy pricita zlomek
        (t (- (leibniz-help a (+ 1 index) (+ 2 denom)) (/ 1 denom)))))          ;pro sude indexy odecita zlomek
