;;
;; Lukáš Netřeba
;;
;; Kontextová nabídka objektu, rozšíření třídy window
;;
;; Potřebné načtené soubory v tomto pořadí:
;; knihovna micro-graphics, 08.lisp, 05_bounds.lisp, 08_textshapes.lisp 

;;
;; Definice třídy
(defclass menu-window (window)
  ((selected-object :initform nil)
   (context-object :initform nil)))

;;
;; Vlastnosti 

(defmethod selected-object ((mw menu-window))
  "Metoda, ktera cte, ktery objekt v okne ma zobrazovat svoji kontextovou nabidku."
  (slot-value mw 'selected-object))

(defmethod set-selected-object ((mw menu-window) object)
  "Metoda, ktera zapisuje do slotu okna, ktery objekt v okne zobrazuje svoji kontextovou nabidku."
  (unless (or (typep object 'shape) (eql object nil))
    (error "Selected-object type must be shape."))
  (setf (slot-value mw 'selected-object) object))

(defmethod context-object ((mw menu-window))
  "Metoda, ktera cte ze slotu okna zobrazovanou kontextovou nabidku zvoleneho objektu."
  (slot-value mw 'context-object))

(defmethod set-context-object ((mw menu-window) object)
  "Metoda, ktera zapisuje do slotu okna zobrazovanou kontextovou nabidku zvoleneho objektu."
  (unless (or (typep object 'picture) (eql object nil))
    (error "Context-object type must be picture."))
  (setf (slot-value mw 'context-object) object))

#|
TEST - Základní objekt v okně.
(setf c (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 50) :blue) 50) t))
(setf w (make-instance 'menu-window))
(set-shape w c)

|#

;;
;; Události (right click, zobrazení kontextové nabídky)

(defmethod mouse-down-no-shape ((mw menu-window) button position)
  "Metoda, ktera zajisti, ze kdyz se klikne mimo  objekt, zmizi kontextova nabidka predesle zvoleneho objektu. (Prvni verze nastavi nil, pote by to bylo okno a otevřelo kontext. nab. pro okno)"
  (call-next-method)
  (when (eql button :right) ;Pro kontext. nabídku
    (set-selected-object mw nil) ;Prozatím, poté zde bude kontextová nabídka pro okno.
    (when (context-object mw)
      (progn (changing mw)
        (set-shape mw (previous-shape-of-window mw))
        (set-context-object mw nil)
        (change mw)))))

(defmethod ev-mouse-down ((mw menu-window) sender clicked button position)
  "Metoda, ktera zajisti, ze kdyz se klikne do objektu, nastaví oknu selected-object kliknutý objekt a zobrazí kontextovou nabídku pro něj."
  (call-next-method)
  (when (and (eql button :right) (typep clicked 'shape)) ;Pro zobr. kontext nabídky.
    (set-selected-object mw clicked)
    (make-context-object mw clicked position)))


;;
;; Vytvoření kontextové nabídky pro selected-object,
; bude to picture složený z jednotlivých text-shapů.

(defun get-all-slot-properties-of-object (object)
  "K objektu vraci ve forme seznamu řetězce vsech jeho vlastnosti vcetne jejich hodnot."
  (let ((properties-list (mapcar #'slot-definition-name (class-slots (class-of object))))
        (result '()))
    (dolist (property properties-list)
      (push (string-append property "\: " (write-to-string (apply property (list object)))) result))
    result))

#|
TEST:
(get-all-slot-properties-of-object (make-instance 'circle))
|#

(defun make-textshape-of-each-property (list)
  "Vytvoří seznam textshapu, ktere se pozicove nachazi pod sebou, kazdy jeden textshape obsahuje jednu vlastnost a jeji hodnotu."
  (let ((y-mov 45)
        (result '()))
    (dolist (item list)
      (push (move (set-text (make-instance 'text-shape) item) 10 y-mov) result)
      (setf y-mov (+ y-mov 15)))
    result))

(defmethod make-context-object ((mw menu-window) object position)
  "Vytvoří picture ve kterém jsou textshapy jednotlivých vlastností objektu, tento picture (kontextovou nabídku) dočasně zabalí do dalšího picture se všemi objekty (vlastnost shape) okna. Po zrušení kontextové nabídky zase vrátí původní obsah shape okna. (O toto se stará mouse-down-no-shape)"
  (let ((pic-text-shapes (make-instance 'picture))
        (text-shapes-list (make-textshape-of-each-property (get-all-slot-properties-of-object object)))
        (temporary-mw-shape (make-instance 'picture)))
    (set-items pic-text-shapes text-shapes-list)
    (move pic-text-shapes (x position) (y position))
    (set-context-object mw pic-text-shapes)
    (set-items temporary-mw-shape (list pic-text-shapes (shape mw)))
    (changing mw)
    (set-shape mw temporary-mw-shape)
    (change mw)
    mw))

(defmethod previous-shape-of-window ((mw menu-window))
  "Vrátí původní shape, který se v okně nacházel, než se zobrazila kontextová nabídka."
  (second (items (shape mw))))

#|
(defmethod shape ((mw menu-window))
  (call-next-method)
  (when (and (context-object mw) (selected-object mw))
    (second (items (slot-value mw 'shape)))))
|#










    
  


  