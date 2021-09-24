;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 12_highlight_mixins.lisp
;;;;
;;;; Příklad mixinů
;;;;
;;;; Je třeba načíst knihovnu micro-graphics a soubor 11.lisp
;;;;

#|
Typické vlastnosti mixinů:

- nemají přímé instance
- volají a částečně implementují metody, které patří jiným třídám (zde to jsou metody
  send-event, add-event, items, color, mouse-down, (setf items))

Účelem mixinů je přimícháním k jiným třídám pomocí vícenásobné dědičnosti přidat nějakou 
novou funkčnost.
|#

;;;
;;; Třídy highlight-item-mixin a highlight-container-mixin, které společně 
;;; přidávají k objektům možnost označování.
;;;
;;; highlight-item-mixin je třeba přimíchat ke třídám 
;;; grafických objektů, highlight-container-mixin ke třídám objektů, které je 
;;; obsahují (obvykle picture)
;;;

(defvar *highlight-color* :limegreen)

(defclass highlight-item-mixin ()
  ((highlightedp :initform nil :accessor highlightedp)))

;; Tohoto triku si povšimněte... změna barvy, aniž by byla uložená ve slotu.
(defmethod color :around ((shape highlight-item-mixin))
  (if (highlightedp shape)
      *highlight-color*
    (call-next-method)))

(defmethod (setf highlightedp) :around (value (shape highlight-item-mixin))
  (with-change shape
    (call-next-method)))

(defmethod (setf highlightedp) :after (value (shape highlight-item-mixin))
  (when value
    (send-event shape 'ev-highlight)))

(defmethod mouse-down :after ((shape highlight-item-mixin) button where)
    (setf (highlightedp shape) t))

(defclass highlight-container-mixin ()
  ())

(defmethod do-set-items :after ((shape highlight-container-mixin) items)
  (broadcast shape (lambda (item) (add-event item 'ev-highlight 'ev-highlight))))

(defmethod ev-highlight ((shape highlight-container-mixin) sender)
  (dolist (item (items shape))
    (when (and (typep item 'highlight-item-mixin)
               (not (eql item sender))
               (highlightedp item))
      ;; Toto generuje zbytečně moc hlášení změn. Lze optimalizovat:
      (setf (highlightedp item) nil))))

;;;
;;; přimíchání:
;;;

(defclass highlight-circle (highlight-item-mixin circle)
  ())

(defclass highlight-polygon (highlight-item-mixin polygon)
  ())

(defclass highlight-container-picture (highlight-container-mixin picture)
  ())

#|

;; Test:

(setf p
      (make-instance 'highlight-container-picture
                     :items (list (make-instance 'highlight-circle 
                                                 :center-x 50
                                                 :center-y 50
                                                 :radius 40
                                                 :filledp t)
                                  (make-instance 'highlight-polygon
                                                 :items '((20 120) (80 120) (80 180) (20 180))
                                                 :filledp t)
                                  (make-instance 'highlight-polygon
                                                 :items '((100 10) (180 10) (140 90))
                                                 :filledp t)
                                  (make-instance 'highlight-circle 
                                                 :center-x 140
                                                 :center-y 150
                                                 :radius 40
                                                 :filledp t))))


(make-instance 'window :shape p)
|#

