;; Author: Lukáš Netřeba
;; Date: 26.6.2021
;;
;; Hiddable-compound-shape.
;;
;; Assignment: Make a inharitor class of compound-shape which in addition will
;; represent which objects should be visible.
;; We expect that this class would understand messages as other shapes.
;; Make a simple UI for testing purposes in the window class. 
;;
;; Dependencies in this order::
;; library micro-graphics, 08.lisp, 05_bounds.lisp, 08_text-shape.lisp 

(load (current-pathname "micro-graphics V2/load.lisp"))
(load (current-pathname "Krupka/08.lisp"))
(load (current-pathname "Krupka/05_bounds.lisp"))
(load (current-pathname "Krupka/08_text-shape.lisp"))

;;
;; Class definition
(defclass hiddable-picture (picture)
  ((hiddable-items :initform '())))

;; Slot accesors
(defmethod hiddable-items ((hp hiddable-picture))
  "Getter method, which returns a list of logic values to corresponding items if they should be shown or hidden."
  (copy-list (slot-value hp 'hiddable-items)))

(defmethod set-hiddable-items ((hp hiddable-picture) value)
  "Setter method, which checks if the input list is of logical values."
  (check-hitems hp value)
  (changing hp)
  (do-set-hitems hp value)
  (change hp)
  hp)

;;
;; Methods used for setting hiddable-items
(defmethod check-hitems ((hp hiddable-picture) hitem-list)
  "Calls a method which iterates on each hitem of hitem-list"
  (do-check-hitems hp hitem-list))

(defmethod do-check-hitems ((hp hiddable-picture) hitem-list)
  "On each hitem of hitem-list checks if is valid"
  (dolist (hitem hitem-list)
    (check-hitem hp hitem))
  hp)

(defmethod check-hitem ((hp hiddable-picture) hitem)
  "Validation method for hitems, allowed t or nil"
  (unless (or (eql hitem nil) (eql hitem t))
    (error "Invalid hiddable-item element type."))
  hp)

(defmethod do-set-hitems ((hp hiddable-picture) value)
  "Method which sets the new hitem-list to slot after check."
  (setf (slot-value hp 'hiddable-items) (copy-list value)))

#|
TEST1:
(setf h (make-instance 'hiddable-picture))
->Adds new slot hiddable-items

TEST2:
(setf c (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 50) :blue) 50) t))
(setf ci (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 120) :red) 50) t))
(set-items h (list c (make-instance 'point) ci))

(set-hiddable-items h (list c (make-instance 'point) ci))
(set-hiddable-items h (list nil nil t))
->Allows us to only add list to hiddable-items with only type of t (as for true) or nil (as for false)

|#

; Pravděpodobně tohle není potřeba, kdyžtak smazat
(defmethod send-to-hiddable-items ((hp hiddable-picture) 
			  message
			  &rest arguments)
  (dolist (hitem (hiddable-items hp))
    (apply message hitem arguments))
  hp)

;;
;; Drawing
(defmethod draw ((hp hiddable-picture) mg-window)
  "Method maps to an item its draw state if it should be shown or hidden and sends and calls possible-draw to it."
  (let* ((items-list (items hp))
        (hitems-list (hiddable-items hp))
        (items-with-its-draw-state-list (mapcar #'list items-list hitems-list)))
    (dolist (item (reverse items-with-its-draw-state-list))
      (possible-draw hp item mg-window))
      hp))

#|
TEST3 (requires TEST2 to be executed):
(mapcar #'list (items h) (hiddable-items h))
->See the output.
|#

(defmethod possible-draw ((hp hiddable-picture) wrapped-item mg-window)
  "Method which draws only those items which state is nil in hiddable-items"
  (when (eql (second wrapped-item) nil)
    (draw (first wrapped-item) mg-window))
  hp)

#|
TEST4:
(setf w (make-instance 'window))
(set-shape w h)
->In h we have visible blue circle, visible basic inicialized point, and hidden red circle just underneath the blue one
|#


;;
;; Environment for UI
(defvar *w* (make-instance 'window))
(let ((ts (make-instance 'text-shape))
      (hp (make-hp))
      (hp-ui (make-instance 'picture)))
  (move ts 20 20)
  (set-text ts "Edit hitems")
  (set-items hp-ui (list ts hp))
  (set-shape *w* hp-ui))

(defun make-hp ()
  "Function which makes basic "
  (let ((hp (make-instance 'hiddable-picture)))
    (set-items hp
     (list (make-circle 100 100 :blue 50 t)
           (make-instance 'point) 
           (make-circle 100 170 :red 50 t)))
    (set-hiddable-items hp
                '(nil nil t))
    hp))

(defun make-circle (x y color radius filledp)
  (let ((c (make-instance 'circle)))
    (set-filledp (set-radius (set-color (move c x y) color) radius) filledp)
    c))
;;
;; Eventy

(defmethod ev-mouse-down ((w window) sender clicked button position)
  (when (typep clicked 'text-shape)
    (edit-hiddable-items w sender clicked button position)))

(defmethod edit-hiddable-items ((w window) sender clicked button position)
  (let* ((input (multiple-value-list (capi:prompt-for-value "Enter new hiddable-items list")))
         (newvalue (first input))
         (stoppedp (second input)))
    (when stoppedp 
      (progn (changing w)
        (
  

