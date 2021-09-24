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
        (change mw))))
  (when (eql button :left) 
    (set-selected-object mw nil) 
    (when (context-object mw)
      (progn (changing mw)
        (set-shape mw (previous-shape-of-window mw))
        (set-context-object mw nil)
        (change mw)))))

(defmethod ev-mouse-down ((mw menu-window) sender clicked button position)
  "Metoda, ktera zajisti, ze kdyz se klikne do objektu, nastaví oknu selected-object kliknutý objekt a zobrazí kontextovou nabídku pro něj."
  (call-next-method)
  (when (and (eql button :right) (typep clicked 'shape)) ;Zobrazování kontext. nabídky
    (if (typep clicked 'text-shape)
        nil
      (when (not (and (selected-object mw) (context-object mw)))
        (progn (set-selected-object mw clicked) (make-context-object mw clicked position)))))
  (when (and (eql button :left) (typep clicked 'text-shape)) ;Pro akci v kontext. nabídce
    (let* ((text (text clicked))
           (property-list (cond ((pointp (selected-object mw)) (slot-properties (get-point)))
                             ((polygonp (selected-object mw)) (slot-properties (get-polygon)))
                             ((circlep (selected-object mw)) (slot-properties (get-circle)))
                             ((picturep (selected-object mw)) (slot-properties (get-picture)))
                             ((eql nil (selected-object mw)) nil)
                             (t (error "Undefined object type."))))
           (setter (setter-name (find-property-name text property-list))))
      (when setter
        (let* ((input (multiple-value-list (capi:prompt-for-value "Zadejte novou hodnotu.")))
               (newvalue (first input))
               (stoppedp (second input)))
          (when stoppedp
            (progn 
              (changing mw)
              (apply setter (list (selected-object mw) newvalue)) ;Po aplikování vlastnosti se kontext. okno zavře
              (set-shape mw (previous-shape-of-window mw))
              (set-selected-object mw nil)
              (set-context-object mw nil)
              (change mw))))))))
      
(defun find-property-name (text property-list)
  "K retezci z textshapu ve tvaru VLASTNOST: HODNOTA prohleda seznam z konstanty *setable-shape-constant*, kde uzivatel muze napsat vsechny vlastnosti, ktere maji jit nastavovat clickem."
  (let ((result '()))
    (dolist (item property-list)
      (when (string-include item text)
        (setf result (string-include item text))))
    result))

(defun string-include (string1 string2)
  (let* ((string1 (string string1)) (length1 (length string1)))
    (if (zerop length1)
        nil 
        (labels ((sub (s)
                   (cond
                    ((> length1 (length s)) nil)
                    ((string= string1 s :end2 (length string1)) string1)
                    (t (sub (subseq s 1))))))
          (sub (string string2))))))

(defun setter-name (prop)
  (values (find-symbol (format nil "SET-~a" prop))))


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


(defmethod shape ((mw menu-window))
  (if (and (context-object mw) (selected-object mw))
      (second (items (slot-value mw 'shape)))
    (slot-value mw 'shape)))

;;
;; Globální konstanta

;Pozn. názvy vlastností udávejte velkými písmeny!

(defvar *setable-properties-constant* '((point ("X" "Y" "PHI" "COLOR" "THICKNESS" "FILLEDP"))
                            (circle ("RADIUS" "CENTER" "COLOR" "THICKNESS" "FILLEDP"))
                            (picture ("ITEMS"))
                            (polygon ("ITEMS" "COLOR" "CLOSEDP" "FILLEDP")))) 

;;
;; Predikát

(defun pointp (point)
  (typep point 'point))

(defun circlep (circle)
  (typep circle 'circle))

(defun picturep (pic)
  (typep pic 'picture))

(defun polygonp (p)
  (typep p 'polygon))

;;
;; Přístup

(defun get-point ()
  (first *setable-properties-constant*))

(defun get-circle ()
  (second *setable-properties-constant*))

(defun get-picture ()
  (third *setable-properties-constant*))

(defun get-polygon ()
  (fourth *setable-properties-constant*))

;; Jména vlastností slotu v seznamu

(defun slot-properties (setable-properties-constant)
  (second setable-properties-constant))










    
  


  