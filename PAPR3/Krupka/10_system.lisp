;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 10_system.lisp - Prototypy: všechno je objekt
;;;;

#|

Interpret úplného důsledně objektového prototypového jazyka. Všechny prvky
prvního řádu v jazyce (first-order elements) jsou objekty a veškeré výpočty
probíhají prostřednictvím zasílání zpráv.

Soubor vznikl úpravou souboru 09.lisp. V dokumentaci jsou zde uvedeny jen nové 
informace. Pro zbytek se podívejte do 09.lisp.

Tento soubor obsahuje definice základů jazyka. Další definice jsou v souborech
10_externals.lisp a 10_basics.lisp. V posledně jmenovaném souboru jsou i příklady.

Soubor občas používá operátory Lispu, které neznáte (makro case, funkci compile).
Najděte si je ve standardu.

Soubory načítejte v pořadí:

1. 10_system.lisp
2. 10_externals.lisp
3. 10_basics.lisp

|#

#|

Dokumentace je zatím neúplná. Na podrobnosti se zeptejte cvičícího.


Základy
=======

Máme tři základní objekty:

object: prototyp všech objektů
nihil:  objekt reprezentující chybějící hodnotu
lobby:  globální prostředí, do slotů ukládáme objekty, které mají být globálně 
        přístupné. Je to výchozí příjemce zpráv

Při interpretaci programu je vždy stanoven aktuální (defaultní) příjemce zpráv.
Výchozím aktuálním příjemcem je lobby. Jemu jsou určeny zprávy, které nemají
explicitně stanoveného příjemce.

Program se skládá z výrazů popisujících zasílání zpráv.


Příklady
========

Literály
--------

"TEXT"
100 
Jsou to inline objekty, jsou přímo součástí zdrojového kódu. Jsou to
"externí objekty", tj. nejsou reprezentovány seznamy, ale jinými
strukturami Lispu. Naprogramovány jsou až v souboru 10_externals.lisp



Atomické zaslání zprávy
-----------------------

Lispový symbol. Např:

lobby
Aktuálnímu příjemci se pošle zpráva lobby bez parametrů (unární zpráva). 
V objektu lobby je slot lobby přítomen a obsahuje lobby. Výsledkem 
zaslání zprávy objektu lobby je tedy lobby.

object
Aktuálnímu příjemci se pošle zpráva object bez parametrů. V objektu lobby 
je slot object přítomen a obsahuje objekt object. Výsledkem zaslání zprávy 
objektu lobby je tedy object.

nihil
Podobně.


Složené zaslání zprávy
----------------------

[object add "NAME" :value "OBJECT"]
Vyhodnotí první prvek (symbol object). To je unární zpráva, takže (viz výše)
výsledkem je objekt object. Tomu se pak pošle zpráva add s parametry rovnými 
literálům "NAME" a "OBJECT"



Inline objekty
--------------

Kromě literálů jsou to standardní objekty napsané pomocí { a }.

{}
Datový objekt bez explicitních slotů. Implicitně je mu vždy dodán slot super
a nastaven na aktuálního příjemce.

{(a b)}
Datový objekt se sloty a, b (a implicitním super nastaveným na aktuálního
příjemce)

{(arg1 else) arg1}
Datový objekt se sloty arg1, else a implicitním super nastaveným na
aktuálního příjemce. Dále má objekt kód arg1. Jde tedy o metodu. Při vytažení
ze slotu se metoda spustí. Musí být použity argumenty arg1 a else.
Kód se vyhodnocuje v kontextu tohoto objektu, tedy aktuálním příjemcem je objekt.
Proto výsledkem bude hodnota parametru arg1.

Předkem metody (slot super) je tedy vždy aktuální příjemce v čase vyhodnocování
{}-výrazu. Tím jsou realizována lexikální prostředí a jejich dědičnost!


|#

#|

TERMINOLOGIE
============

OBJEKT            je libovolná hodnota jazyka. Objekty se dělí na 
                  DATOVÉ a METODY. Všechny objekty (kromě primitiv) mají sloty.
DATOVÝ OBJEKT     je objekt bez kódu. Je to buď STANDARDNÍ OBJEKT, nebo EXTERNÍ
                  OBJEKT.
STANDARDNÍ OBJEKT je seznam (object nil . names-and-values) tak, jak ho známe
                  z minulé verze.

METODA            je objekt určený k vyhodnocení. Pokud je ve slotu, místo vrácení
                  se spustí. Metoda je vždy buď STANDARDNÍ METODA nebo PRIMITIVUM.
STANDARDNÍ METODA je seznam (object code . names-and-values), kde code není nil.
METODA OBJEKTU    je metoda, která je uložena ve slotu datového objektu. Pokud je
                  metoda standardní, má mezi sloty slot owner, jehož hodnotou je 
                  onen datový objekt.

INLINE OBJEKT     je objekt, který vznikl načtením ze zdrojového textu. Buď pomocí
                  {}-syntaxe, nebo jako LITERÁL (o {}-syntaxi viz níže).

EXTERNÍ OBJEKT    je libovolný objekt kromě standardního a metody.
LITERÁL           je externí objekt vzniklý přímo načtením ze zdrojového textu.
                  Typicky je to číslo nebo řetězec.
PRIMITIVUM        je lispová funkce. Musí mít lambda-seznam (self arg1 &key ...).

|#

#|

PROGRAM A JEHO VYHODNOCENÍ
==========================

Program se skládá z VÝRAZŮ.

VÝRAZ             je buď ZASLÁNÍ ZPRÁVY nebo INLINE OBJEKT.
ZASLÁNÍ ZPRÁVY    je buď ATOMICKÉ nebo SLOŽENÉ.
ATOMICKÉ ZZ       lispový symbol. Jde o unární zprávu (bez parametru), zašle se
                  aktuálnímu (implicitnímu) příjemci.
SLOŽENÉ ZZ        syntax jako minule.
INLINE OBJEKT     buď {}-syntaxí, nebo LITERÁL
{}-SYNTAX         {sloty kód1 kód2 ...}. sloty je seznam symbolů, při vytvoření 
                  objektu se mu dodají jako datové sloty. kód1, kód2 atd. jsou
                  výrazy. 

|#



;; Zkrácení dlouhých seznamů při tisku, například v listeneru.
(setf *print-length* 10) ;v tisknutém seznamu bude max 10 prvků
(setf *print-level* 5)   ;seznamy se tisknou max. do hloubky 5
(setf *print-circle* t)  ;žádný objekt v seznamu se netiskne víckrát, nahrazuje se 
                         ;značkou (mj. brání zacyklení při tisku kruhových seznamů)

#|

Práce s objekty a jejich sloty

|#

;; Proměnnou *nihil* potřebujeme ve field-value. Základní objekty jinak definujeme
;; později.
(defvar *nihil*)

;; Proměnnou *lobby* také potřebujeme dříve:
(defvar *lobby*)

;; Pomocné funkce pro práci s plistem slotů a hodnot objektu.
;; Na rozdíl od verze v souboru 09.lisp jsou napsány jako metody, abychom 
;; je mohli definovat i pro jiné reprezentace objektů.
;; Využíváme možnosti Lispu, v němž i typ list a další vestavěné typy
;; jsou třídy a lze tedy pro ně psát metody. (Jde o tzv. system-class,
;; instance nejsou "standardní", nemají sloty a nevytvářejí se pomocí 
;; make-instance, nicméně lze pro ně psát metody.)

;; Pomocná funkce, vrací plist slotů a hodnot objektu.
(defmethod object-plist ((obj list))
  (cddr obj))

;; Pomocná funkce, nastavuje plist slotů a hodnot objektu.
(defmethod set-object-plist ((obj list) new-plist)
  (setf (cddr obj) new-plist))

;; Pomocné funkce, vrací resp. nastavují kód objektu.
(defmethod object-code ((obj list))
  (second obj))

(defmethod set-object-code ((obj list) code)
  (setf (second obj) code))

;; Zjištění, zda je hodnota metoda:

;; Obecná hodnota není metoda:
(defmethod methodp (value)
  nil)

;; Primitivum (lispová funkce) je metoda:
(defmethod methodp ((value function))
  t)

;; Seznam je metoda, pokud má kód:
(defmethod methodp ((value list))
  (object-code value))

#|
Práce se sloty. K přístupu používají object-plist a set-object-plist, takže
nejsou závislé na reprezentaci objektu.
|#

;; Funkce field-value
;; Zjištění hodnoty slotu field. Pokud není slot nalezen v objektu obj, pokračuje
;; rekurzivně v hledání v předcích. Pokud není slot nalezen nikde, vyvolá chybu.
;; *field-not-found* může být libovolná hodnota, o které si jsme jisti,
;; že je jedinečná (nemůže být prvkem slotu).
;; Zde používáme funkci gensym, která vytváří zbrusu nový symbol.

(defvar *field-not-found* (gensym "FIELD-NOT-FOUND"))

(defun field-value-1 (obj field)
  (getf (object-plist obj) field *field-not-found*))

(defun super-object (obj)
  (field-value-1 obj 'super))

(defun field-value (obj field)
  (let ((result (field-value-1 obj field))
        (super (super-object obj)))
    (cond ((not (eql result *field-not-found*)) result)
          ((not (eql super *nihil*)) (field-value super field))
          (t (error "Field ~s not found." field)))))

;; Nastavování hodnoty slotu. Nastavuje se přímo v objektu obj, takže se 
;; slot předka přepíše. Neexistuje-li, slot se vytvoří.
;; Je-li value standardní metoda a objekt je datový,
;; nastaví metodě slot owner.
(defun set-field-value (obj field value)
  (let ((plist (object-plist obj)))
    (setf (getf plist field) value)
    (set-object-plist obj plist))
  (when (and (methodp value) (listp value) (not (methodp obj)))
    (set-field-value value 'owner obj))
  obj)

;; Zjištění názvu slotu objektu (tj. symbolu) na základě řetězce
;; nebo symbolu.
;; Lispová funkce intern vyrábí symbol z jeho textového názvu 
;; (jímž může být řetězec nebo symbol)
(defun field-name (field-name-str)
  (intern (format nil "~a" field-name-str)))

(defun setter-name (field-name-str)
  (intern (format nil "SET-~a" field-name-str)))

#|
(field-name "FIELD")
(field-name :field)
(setter-name "FIELD")
(setter-name 'field)
|#

;; Nastavení hodnot více slotů. fields-and-values je seznam názvů slotů
;; (mohou být dány i řetězcem) a hodnot.
(defun set-field-values (obj fields-and-values)
  (when fields-and-values
    (set-field-value obj (field-name (first fields-and-values)) (second fields-and-values))
    (set-field-values obj (cddr fields-and-values))))

;; Vytvoří metodu (primitivum) pro nastavení slotu jménem field-name-str (řetězec)
;; Je to metoda s argumenty self (příjemce) a arg1, což je nastavovaná hodnota
(defun setter-method (field-name-str)
  (lambda (self arg1 &key)
    (set-field-value self (field-name field-name-str) arg1)))

;; Přidání setter-slotu pro slot daného názvu
(defun add-setter-field (obj field-name-str)
  (set-field-value obj
                   (setter-name field-name-str)
                   (setter-method field-name-str)))

;; Funkce add-field a remove-field jsou současně primitiva

;; Přidání slotu do objektu s hodnotou. Pokud není hodnotou metoda,
;; přidá i setter. 
(defun add-field (obj field-name-str &key (value *nihil*))
  (set-field-value obj (field-name field-name-str) value)
  (unless (methodp value)
    (add-setter-field obj field-name-str))
  obj)

;; odstranění slotu z objektu včetně setteru
(defun remove-field (obj field-name-str &key)
  (let ((plist (object-plist obj)))
    (remf plist (field-name field-name-str))
    (remf plist (setter-name field-name-str))
    (set-object-plist obj plist)
    obj))

#|

Posílání zpráv

|#

(defun plist-prop-names (plist)
  (when plist
    (cons (car plist) (plist-prop-names (cddr plist)))))

#|
(plist-prop-names '(1 2 3 4 5 6 7 8 9))
(plist-prop-names '(1 2 3 4 5 6 7 8 9 10))
|#

;; Vrátí název slotu metody pro první argument. Slot se pozná tak,
;; že jeho název začíná na "ARG1". Pokud takový slot nenajde, vrátí symbol arg1. 
(defun arg1-field (method)
  (let ((prop (find-if (lambda (prop)
                         (eql (search "ARG1" (symbol-name prop)) 0))
                       (plist-prop-names (object-plist method)))))
    (if prop prop 'ARG1)))

#|
(arg1-field '(object nil arg1 1 arg2 2 arg3 3)) 
(arg1-field '(object nil arg2 2 arg3 3))
(arg1-field '(object nil arg2 2 arg3 3 arg1-test 4))
|#

;; Inicializace metody před jejím voláním. Sloty metody se nastaví na
;; argumenty volání
(defun init-method-slots (method arg1-field arg1 args)
  (when arg1                                  ;volána s prvním argumentem
    (set-field-value method arg1-field arg1))
  (set-field-values method args))   ;nastavení slotů pro další argumenty

(defun call-standard-method (method self arg1 &rest args)
  (let ((clone (clone-object method))) ;naklonujeme metodu
    ;; jde-li o metodu v datovém objektu, nastavíme self.
    ;; pozor, i taková metoda může být zavolána následkem
    ;; poslání zprávy metodě: sama je umístěna v lobby (takže
    ;; v datovém objektu), ale byla zavolána následkem
    ;; poslání zprávy metodě, která je potomkem lobby.
    ;; proto také testujeme, není-li self metoda
    (unless (or (eql (field-value clone 'owner) *nihil*)
                (methodp self))
      (set-field-value clone 'self self))
    ;; Nastavení slotů naklonované metody na argumenty:
    (init-method-slots clone (arg1-field method) arg1 args)
    (evaluate (object-code clone) clone)))      ;a to podstatné: vyhodnocení kódu metody
                                                ;v připravené metodě

;; Posílání zpráv. 
(defun send (receiver message
                      &optional arg1 
                      &rest args)
  (let ((value (field-value receiver message)))
    (cond ((functionp value) (apply value receiver arg1 args)) ;primitivum
          ((methodp value) (apply 'call-standard-method value receiver arg1 args))
          (t value))))

(defun evaluate-send-code (code object)
  ;; code je tvaru (send obj message arg1 :name1 val1 :name2 val2 ...)
  ;; hodnoty obj, arg1, val1, val2 ... vyhodnotíme a pak zavoláme send
  ;; využijeme toho, že symboly :xxx jsou keywords
  (let ((obj (second code))
        (message (third code))
        (args-and-names (cdddr code)))
    (apply 'send (evaluate obj object)
                 message
                 (mapcar (lambda (elem)
                           (if (keywordp elem)
                               elem
                             (evaluate elem object)))
                         args-and-names))))

(defun evaluate-code-list (code object)
  (let ((last *nihil*))
    ;; code je (code [ ... ] [ ... ] ...)
    (dolist (c (rest code))
      (setf last (evaluate c object)))
    last))

(defun make-inline-object (spec object)
  (let ((result (make-object))
        (slots (second spec))
        (code (third spec)))
    (dolist (slot slots)
      (add-field result slot :value *nihil*))
    (set-object-code result code)
    (set-field-value result 'super object)
    result))

(defun code-type (code)
  (cond ((symbolp code)                :message)         ;zpráva
        ((not (listp code))            :literal)         ;číslo, řetězec, ...
        ((eql (first code) 'send)      :send)            ;[ ... ]
        ((eql (first code) 'inline)    :inline)          ;{ ... }
        ((eql (first code) 'lambda)    :primitive)       ;(lambda (...) ...)
        ((eql (first code) 'function)  :primitive)       ;(function f) neboli #'f 
        ((eql (first code) 'code)      :code)            ;kód stand. metody
        (t (error "Code of unknown type: ~s." code))))

(defun evaluate (code &optional (object *lobby*)) ;object: aktuální příjemce
  (ecase (code-type code)
    (:message (send object code))
    (:literal code)
    (:send (evaluate-send-code code object))
    (:inline (make-inline-object code object))
    (:primitive (compile nil code))
    (:code (evaluate-code-list code object))))

#|

Základní objekty

|#

;; Objekt object
(defvar *object*)
(setf *object* (list 'object nil))

(add-field *object* "ADD" :value #'add-field)
(add-field *object* "REMOVE" :value #'remove-field)

;; Vytvoření objektu:
(defun make-object ()
  (list 'object nil 'super *object*))

(defun clone-object (object)
  (let ((result (make-object)))
    ;; Důležité pořadí! Aby, pokud jde o metodu, add-field
    ;; nenastavovalo owner
    (set-object-code result (object-code object))
    (add-field result "SUPER" :value object)
    result))

(setf *nihil* (make-object))

(add-field *object* "SUPER" :value *nihil*)

(setf *lobby* (make-object))

(add-field *lobby* "LOBBY" :value *lobby*)
(add-field *lobby* "OBJECT" :value *object*)
(add-field *lobby* "NIHIL" :value *nihil*)

(add-field *lobby* "OWNER" :value *nihil*)
(add-field *lobby* "SELF" :value *nihil*)




#|
Tady končí základní definice systému.
|#


#|

Syntax pro posílání zpráv

Pokud vás tato část zajímá, podívejte se nejdřív do souboru 09_syntax.lisp,
ve kterém je to mnohem jednodušší.

|#

;; Výrazy na horní úrovni se načtou takto: (evaluate načtený-výraz)
;; Vnořené výrazy už jenom jako: načtený-výraz
;; Zařídí to tato dynamická proměnná:
(defvar *top-level-code-p*)
(setf *top-level-code-p* t)

;; Modifikace syntaxe Lispu, aby rozuměl hranatým závorkám.
;; výraz [obj message x y z ...] se přečte jako (send obj message x y z ...),
;; kde vnitřní podvýrazy se rekurzivně opět přečtou readerem
;; Je ale třeba vyhodnocovat v Listeneru, F8 apod. na tyto výrazy nefunguje.
(defun left-brack-reader (stream char)
  (declare (ignore char))
  (let ((result (cons 'send 
                      (let ((*top-level-code-p* nil))
                        (read-delimited-list #\] stream t)))))
    (if *top-level-code-p*
        (list 'evaluate (list 'quote result))
      result)))

(set-macro-character #\[ 'left-brack-reader)

(defun right-paren-reader (stream char)
  (declare (ignore stream))
  (error "Non-balanced ~s encountered." char))

(set-macro-character #\] 'right-paren-reader)

;; Složené závorky 
;; načtou se jako inline objekt:
;; {(a b c) [ .. ] [ .. ]} -> (inline (a b c) (code [ .. ] [ .. ]))
(defun left-brace-reader (stream char)
  (declare (ignore char))
  (let ((list (let ((*top-level-code-p* nil))
                (read-delimited-list #\} stream t)))
        result)
    (setf result
          (list 'inline 
                (first list)                          ;seznam slotů
                (when (rest list)
                  (cons 'code (rest list)))))         ;kód
    (if *top-level-code-p*
        (list 'evaluate (list 'quote result))
      result)))

(set-macro-character #\{ 'left-brace-reader)

(set-macro-character #\} 'right-paren-reader)

#|
;; Testy čtení (vyhodnocovat v Listeneru)
'[a b]
'[[a b] c {() d [e {(f) g h}]}]
|#


;; Hack, aby editor rozuměl hranatým a složeným závorkám
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\[ #\{) 2)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\] #\}) 3)
