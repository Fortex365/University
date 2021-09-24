;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 9, Prototypy 1
;;;;

#|

DOKUMENTACE
-----------

Objektové rozšíření Lispu založené na prototypovém přístupu. S objekty se 
komunikuje zásadně posíláním zpráv. Nové objekty se vytvářejí klonováním
existujících a automaticky se stávají jejich přímými potomky.

Objekty mají ve slotech hodnoty nebo metody. Zprávy zasílané objektům musí mít
stejné jméno jako některý ze slotů objektu nebo nějakého jeho předka. Pokud je
ve slotu hodnota, je výsledkem zaslání zprávy objektu tato hodnota (parametry
zprávy se ignorují). Je-li ve slotu metoda, je výsledkem zaslání zprávy hodnota
vrácená metodou (spuštěnou s argumenty zprávy).

Pro sloty používáme název "field", abychom se vyhli konfliktu s lispovými 
funkcemi.

Syntax zasílání zprávy:

(send object message &optional arg1 &rest args)

object:   objekt
message:  zpráva (symbol)
arg1:     první argument (nepovinný)
args      další argumenty ve tvaru střídajících se názvů (začínajících
          dvojtečkou) a hodnot: :name1 val1 :name2 val2 ...

Metoda je funkce s lambda-seznamem (self arg1 &rest args)
Parametr self obsahuje příjemce zprávy, tj. objekt, který zprávu dostal.
Parametr arg1 je sice v metodě povinný, ale při posílání zprávy nemusí být využit.
args je stejného tvaru jako dříve. Nejjednodušší způsob definice metody je napsat 
ji takto:

(lambda (self arg1 &key)
  ... )

Tím se ignorují další argumenty. arg1 je vždy třeba napsat, i když zpráva 
nemá parametr.

(O významu klíčového slova &key a dalších viz text přednášku 1 z minulého semestru)

Základním objektem je objekt uložený v globální proměnné *object*. Ostatní
objekty se vytvářejí jeho klonováním. Další prototypy se typicky také umisťují
do globálních proměnných.

Druhým základním objektem je objekt *nihil*. Představuje neexistující hodnotu.

Poznámka k principu zapouzdření: všechny sloty objektů jsou veřejné, tj. uživatel
může objektu poslat libovolnou zprávu, která je jménem slotu objektu nebo jeho
předka. Princip zapouzdření je ovšem respektován, protože k objektům se
přistupuje pouze zasíláním zpráv (takže např. je možné změnit vnitřní reprezentaci
objektu).

Zprávy objektu *object*
-----------------------

super        Vrací bezprostředního předka objektu.
set-super superobj    
             Nastaví bezprostředního předka příjemce na superobj.
name         Název objektu. Pro účely lepší orientace.
set-name     Nastavení názvu objektu.
clone        Vytvoří nový objekt naklonováním příjemce. Nový objekt má pouze slot
             super, nastavený na příjemce zprávy.
add field-name :value value
             Přidá slot daného názvu s hodnotou. Název je textový řetězec psaný velkými
             písmeny. Jako název slotu se vytvoří symbol téhož jména.
             Pokud hodnota není metoda, přidá i příslušný setter.
is-nihil     Vrací, zda je příjemce totožný s objektem *nihil* 
equals obj   Vrací, zda je příjemce totožný s objektem obj.
is obj       Vrací, zda je příjemce totožný s objektem obj nebo je jeho potomkem.

|#

;; Zkrácení dlouhých seznamů při tisku, například v listeneru.
(setf *print-length* 10) ;v tisknutém seznamu bude max 10 prvků
(setf *print-level* 5)   ;seznamy se tisknou max. do hloubky 5
(setf *print-circle* t)  ;žádný objekt v seznamu se netiskne víckrát, nahrazuje se 
                         ;značkou (mj. brání zacyklení při tisku kruhových seznamů)

#|
V dalším budeme pracovat s plisty, o kterých jsme mluvili minulý semestr.
Připomenu. Jsou to seznamy střídajících se
názvů a hodnot. Například: (x 10 y 20 color :blue). K práci s plisty slouží funkce
getf, kterou lze použít i s makrem setf:

(setf point (list 'x 10 'y 20 'color :blue)) => (x 10 y 20 color :blue)
(getf point 'y) => 20
(getf point 'z) => nil
(getf point 'z :not-found) => :not-found
(setf (getf point 'x) 15) => 15
(getf point 'x) => 15
(setf (getf point 'z) 30) => 30
(getf point 'z) => 30
point => (z 30 x 15 y 20 color :blue)

#|

|#
Zpět k objektům. 
Objekt je seznam (object nil . plist), kde object je symbol OBJECT, plist je plist
slotů objektu. Nil na druhém místě je kvůli snadnějšímu prohlížení v inspektoru 
jako plist. Později tam místo nil dáme něco užitečnějšího.
|#

#|

Práce s objekty a jejich sloty

|#

;; Proměnnou *nihil* potřebujeme ve field-value. Základní objekty jinak definujeme
;; později.
(defvar *nihil*)

;; Pomocná funkce, vrací plist slotů a hodnot objektu.
(defun object-plist (obj)
  (cddr obj))

;; Pomocná funkce, nastavuje plist slotů a hodnot objektu.
(defun set-object-plist (obj new-plist)
  (setf (cddr obj) new-plist))

;; Zjištění, zda je hodnota metoda:
(defun methodp (value)
  (typep value 'function))

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

;; Nastavování hodnoty slotu. Nastavuje se přímo v objektu obj, takže se slot 
;; předka přepíše. Neexistuje-li, slot se vytvoří.
(defun set-field-value (obj field value)
  (let ((plist (object-plist obj)))
    (setf (getf plist field) value)
    (set-object-plist obj plist))
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

;; Vytvoří metodu pro nastavení slotu jménem field-name-str (řetězec)
;; Je to metoda s argumenty self (příjemce) a arg1, což je nastavovaná hodnota
(defun setter-method (field-name-str)
  (lambda (self arg1 &key)
    (set-field-value self (field-name field-name-str) arg1)))

;; Přidání setter-slotu pro slot daného názvu
(defun add-setter-field (obj field-name-str)
  (set-field-value obj
                   (setter-name field-name-str)
                   (setter-method field-name-str)))

;; Funkce add-field a remove-field jsou současně metody

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

;; Posílání zpráv: funkce send.

(defun send (receiver message &optional arg1  &rest args)
  (let ((value (field-value receiver message)))
    (if (methodp value)
        (apply value receiver arg1 args)
      value)))

#|

Tady končí základní definice systému.

|#

#|

Základní objekty

|#

;; Objekt *object*
(defvar *object*)
(setf *object* (list 'object nil))

;; Vytvoření nového objektu:
(defun make-object ()
  (list 'object nil 'super *object*))

;; Metody pro add a remove jsou dříve definované
;; funkce add-field a remove-field
(add-field *object* "ADD" :value #'add-field)
(add-field *object* "REMOVE" :value #'remove-field)

;; Objekt nihil (proměnná *nihil* už je definována výše)
(setf *nihil* (make-object))

(send *object* 'add "SUPER" :value *nihil*)  ;cyklická dědičnost!
(send *object* 'add "NAME" :value "OBJECT")


#|
(send *object* 'name)
(send *nihil* 'name)
(send *nihil* 'test)
|#

(send *nihil* 'set-name "NIHIL") 
(send *object* 'add "IS-NIHIL" :value nil)
(send *nihil* 'set-is-nihil t)

#|
(send *nihil* 'name)
(send *object* 'is-nihil)
(send *nihil* 'is-nihil)

(send (send *nihil* 'super) 'name)
|#

;; Přidání metod pomocí zprávy add:
(send *object* 'add "CLONE" :value (lambda (self arg1 &key)
                                     (declare (ignore arg1))
                                     (send (make-object) 'set-super self)))

(send *object* 'add "EQUALS" :value (lambda (self arg1 &key)
                                      (eql self arg1)))

(send *object* 'add "IS" :value (lambda (self arg1 &key)
                            (let ((super (send self 'super)))
                              (or (send self 'equals arg1)
                                  (and (not (send super 'is-nihil)) ;ukončení rekurze
                                       (send super 'is arg1))))))

                                       
#|
(send *object* 'equals *object*)
(send *nihil* 'equals *nihil*)
(send *nihil* 'equals *object*)
(setf obj1 (send (send *object* 'clone) 'set-name "NEW-OBJECT"))
(send obj1 'name)
(send obj1 'remove "NAME")
(send obj1 'name)
(send (send *object* 'clone) 'is *object*)
(send *nihil* 'is *nihil*)
(setf obj2 (send *object* 'clone))
(send obj2 'is *object*)
(setf obj3 (send *object* 'clone))
(send obj3 'is obj2)
|#

