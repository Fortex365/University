;;
;; Musí být načteny předchozí soubory
;; 05_bounds.lisp, 08.lisp, text-shape.lisp, micro-graphics novější verze
;;
;; Autor: Lukáš Netřeba
;;

;;
;; Třída

(defclass inspector-window (window)
  ((inspected-window :initform nil)
   (inspected-object :initform nil)))

;;
;; Vlastnosti

(defmethod set-inspected-window ((ins-w inspector-window) inspected-window)
  "Nastavuje vlastnost prohlíženého okna prohlížeče."
  (unless (or (typep inspected-window 'inspected-window) (eql inspected-window nil))
    (error "Inspected window must be instance type of inspected-window."))
    (changing ins-w)
    (setf (slot-value ins-w 'inspected-window) inspected-window)
    (set-delegate inspected-window ins-w)
    (do-inspect-inspected-window ins-w (inspected-window ins-w))
    (change ins-w)
    ins-w)

(defmethod inspected-window ((ins-w inspector-window))
  "Vrací právě prohlížené okno prohlížeče"
  (slot-value ins-w 'inspected-window))

(defmethod inspected-object ((ins-w inspector-window))
  "Vrací právě prohlížený objekt z prohlíženého okna v prohlížeči"
  (slot-value ins-w 'inspected-object))

;;
;; Inicializace

(defmethod initialize-instance ((ins-w inspector-window) &key)
  (call-next-method)
  (add-event ins-w 'ev-double-click 'ev-double-click)
  ins-w)
  
;;
;; Zpětná volání double-click

(defmethod install-callbacks ((ins-w inspector-window))
  (call-next-method)
  (install-double-click-callback ins-w)
  ins-w)

(defmethod install-double-click-callback ((ins-w inspector-window))
  (mg:set-callback (slot-value ins-w 'mg-window)
                   :double-click (lambda (mgw button x y)
                                   (declare (ignore mgw))
                                   (window-double-click
                                    ins-w
                                    button
                                    (move (make-instance 'point) x y))))
  ins-w)

(defmethod window-double-click ((ins-w inspector-window) button position)
  (let ((shape (find-clicked-shape ins-w position)))
    (if shape (double-click-inside-shape ins-w shape button position)
      (double-click-no-shape ins-w button position))))


(defmethod double-click-no-shape ((ins-w inspector-window) button position)
  ins-w)

(defmethod double-click-inside-shape ((ins-w inspector-window) shape button position)
  (ev-double-click ins-w shape button position))
           
;;
;; Události 

(defmethod ev-double-click ((ins-w inspector-window) shape button position)
  (let* ((text (text shape))
         (property-list (cond ((pointp (inspected-object ins-w)) (slot-properties (get-point)))
                             ((polygonp (inspected-object ins-w)) (slot-properties (get-polygon)))
                             ((circlep (inspected-object ins-w)) (slot-properties (get-circle)))
                             ((picturep (inspected-object ins-w)) (slot-properties (get-picture)))
                             ((eql nil (inspected-object ins-w)) nil)
                             (t (error "Undefined object type."))))
         (setter (setter-name (find-property-name text property-list))))
    (when setter ;Pokud vlastnost existuje, povolíme vstup nové hodnoty pro její změnu.
      (let* ((input (multiple-value-list (capi:prompt-for-value "Zadejte novou hodnotu.")))
             (newvalue (first input))
             (stoppedp (second input)))
        (when stoppedp
          (progn
            (changing ins-w)
            (apply setter (list (inspected-object ins-w) newvalue)) ;Provedeme změny, refresh.
            (do-inspect-clicked-object ins-w (inspected-object ins-w) (inspected-object ins-w) button position)
            (change ins-w)))))))

(defun find-property-name (text property-list)
  "K retezci z textshapu ve tvaru VLASTNOST: HODNOTA prohleda seznam z konstanty *shape-constant*, kde uzivatel muze napsat vsechny vlastnosti, ktere maji jit nastavovat double-clickem."
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


(defmethod ev-change ((ins-w inspector-window) sender)
  (call-next-method)
  (when (inspected-object ins-w)
    (refresh-inspected-obj ins-w (inspected-object ins-w))))

(defmethod refresh-inspected-obj ((ins-w inspector-window) obj)
  "Prohledne objekt, ktery byl zmenen za behu kdyz byl prave prohlizeny prohlizecem."
  (changing ins-w)
  (setf (slot-value ins-w 'inspected-object) obj)
  (let ((pic (make-instance 'picture))
        (ins (make-instance 'text-shape)) 
        (text-shapes-list (make-textshape-of-each-property (get-all-slot-properties-of-object obj))))
    (set-items pic
               (push (move (set-text ins (format nil "INSPECTED OBJECT: ~a" obj)) 10 30) text-shapes-list))
    (set-shape ins-w pic)
    (change ins-w))
  ins-w)
                        
;;
;; Prohlížení objektu 

(defmethod do-inspect-clicked-object ((ins-w inspector-window) sender clicked button position)
  "Prohledne objekt do ktereho se puvodne kliklo a zjisti o nem vsechny dostupne informace, ty zobrazi v inspektoru."
  (changing ins-w)
  (setf (slot-value ins-w 'inspected-object) clicked)
  (let ((pic (make-instance 'picture))
        (ins (make-instance 'text-shape)) ;Hlavička prohlíženého objektu 
        (text-shapes-list (make-textshape-of-each-property (get-all-slot-properties-of-object clicked)))) ;List textshapů obsahující vlastnosti a hodnoty
    (set-items pic
               (push (move (set-text ins (format nil "INSPECTED OBJECT: ~a" clicked)) 10 30) text-shapes-list))
    (set-shape ins-w pic)
    (change ins-w))
  ins-w)

(defun get-all-slot-properties-of-object (object)
  "K objektu vraci ve forme seznamu řetězce vsech jeho vlastnosti vcetne jejich hodnot."
  (let ((properties-list (mapcar #'slot-definition-name (class-slots (class-of object))))
        (result '()))
    (dolist (property properties-list)
      (push (string-append property "\: " (write-to-string (apply property (list object)))) result))
    result))

#|
TEST NÁZVŮ SLOTŮ OBJEKTU 

(setf pt (make-instance 'point))
(get-all-slot-properties-of-object pt)
|#

(defun make-textshape-of-each-property (list)
  (let ((y-mov 45)
        (result '()))
    (dolist (item list)
      (push (move (set-text (make-instance 'text-shape) item) 10 y-mov) result)
      (setf y-mov (+ y-mov 15)))
    result))


#|
TEST OBSAHU VLASTNOSTÍ OBJEKTU (KROMĚ NÁZVU) V TEXTSHAPE PODSEBOU

(setf testprop (make-textshape-of-each-property (get-all-slot-properties-of-object pt)))
(setf pic (set-items (make-instance 'picture) testprop))
(setf window (make-instance 'window))
(set-shape window pic)
|#

;; 
;; Prohlížení prohlíženého okna 

(defmethod do-inspect-inspected-window ((ins-w inspector-window) inspected-window)
  "Zobrazi vsechny informace o prohlizenem oknu v inspektoru."
  (let ((ts (make-instance 'text-shape)))
    (set-text ts (format nil "INSPECTED WINDOW: ~a 
BACKGROUND: ~a 
CHANGE-LEVEL: ~a 
SHAPE: ~a 
DELEGATE: ~a 
MG-WINDOW: ~a 
EVENTS: ~a" (inspected-window ins-w)
                         (background inspected-window)
                         (change-level inspected-window)
                         (shape inspected-window)
                         (delegate inspected-window)
                         (slot-value inspected-window 'mg-window)
                         (events inspected-window)))
    (move ts 10 30)
    (set-shape ins-w ts))
  ins-w)


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


;;
;; TESTY INSPEKTOR WINDOW

#|
(setf c (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 50) :blue) 50) t))
(setf c2 (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 100) :red) 50) t))

(setf pic2 (set-items (make-instance 'picture) (list c c2)))
(setf iw (set-background (set-shape (make-instance 'inspected-window) pic2) :lightgrey))

(setf ins-w (make-instance 'inspector-window))
(set-inspected-window ins-w iw)

(set-color c :purple)
(set-color c2 :yellow)
(set-color c :red)
(set-color c2 :green)

(set-delegate iw nil)
(set-delegate iw ins-w)
|#


;; 
;; Třída inspected-window (prohlížená)

(defclass inspected-window (window)
  ())

;;
;; Inicializace, beze změny

(defmethod initialize-instance ((iw inspected-window) &key)
  (call-next-method)
  iw)

;;
;; Práce s myší

(defmethod solidp ((iw inspected-window))
  nil)

(defmethod mouse-down-no-shape ((iw inspected-window) button position)
  "Když se v inspected-window klikne mimo objekty v inspektoru se zobrazí informace o celém okně."
  (call-next-method)
  (when (typep (delegate iw) 'inspector-window)
    (progn
      (setf (slot-value (delegate iw) 'inspected-object) nil)
      (do-inspect-inspected-window (delegate iw) (inspected-window (delegate iw))))))

;;
;; Události  

(defmethod ev-mouse-down ((iw inspected-window) sender clicked button position)
  "Když se klikne v inspected-window na objekt, prohlédne se v inspektoru."
  (call-next-method)
  (when (and (eql button :left) (typep clicked 'shape))
    (when (typep (delegate iw) 'inspector-window)
      (do-inspect-clicked-object (delegate iw) sender clicked button position))))

(defmethod ev-change ((iw inspected-window) sender)
  (call-next-method)
  (when (typep (delegate iw) 'inspector-window)
    (send-event (delegate iw) 'ev-change)))


  



