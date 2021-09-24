;; Author: Lukáš Netřeba
;; Date: 26.6.2021
;;
;; Hiddable-compound-shape, as an extencion for compound-shape.
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
(defclass hiddable-compound-shape (compound-shape)
  ((hiddable-items :initform '())))


;; Slot accesors
(defmethod hiddable-items ((hcs hiddable-compound-shape))
  "Getter method, which returns a list of logic values to corresponding items if they should be shown or hidden."
  (copy-list (slot-value hcs 'hiddable-items)))

(defmethod set-hiddable-items ((hcs hiddable-compound-shape) value)
  "Setter method, which checks if the input list is of logical values."
  (check-hitems hcs value)
  (changing hcs)
  (do-set-hitems hcs value)
  (change hcs)
  hcs)


;;
;; Methods used for setting hiddable-items
(defmethod check-hitems ((hcs hiddable-compound-shape) hitem-list)
  "Calls a method which iterates on each hitem of hitem-list"
  (do-check-hitems hcs hitem-list))

(defmethod do-check-hitems ((hcs hiddable-compound-shape) hitem-list)
  "On each hitem of hitem-list checks if is valid"
  (dolist (hitem hitem-list)
    (check-hitem hcs hitem))
  hcs)

(defmethod check-hitem ((hcs hiddable-compound-shape) hitem)
  "Validation method for hitems, allowed t or nil"
  (unless (or (eql hitem nil) (eql hitem t))
    (error "Invalid hiddable-item element type."))
  hcs)

(defmethod do-set-hitems ((hcs hiddable-compound-shape) value)
  "Method which sets the new hitem-list to slot after check."
  (setf (slot-value hcs 'hiddable-items) (copy-list value)))


;; Methods to override compound-shape methods 
;; to be able to draw hiddable-compound-shape
;; since compound-shape is an abstract class

(defmethod check-items ((hcs hiddable-compound-shape) item-list)
  (do-check-items hcs item-list))

(defmethod check-item ((hcs hiddable-compound-shape) item)
  (unless (typep item 'shape)
    (error "Invalid picture element type."))
  hcs)


#|
TEST1:
(setf h (make-instance 'hiddable-compound-shape))
->Adds new slot hiddable-items

TEST2:
(setf c (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 50) :blue) 50) t))
(setf ci (set-filledp
         (set-radius (set-color (move (make-instance 'circle) 100 120) :red) 50) t))
(set-items h (list c (make-instance 'point) ci))
->Allows us to add shapes in list to items slot.

(set-hiddable-items h (list c (make-instance 'point) ci))
(set-hiddable-items h (list nil nil t))
->Allows us to only add list to hiddable-items with only type of t (as for true) or nil (as for false)

|#

; Pravděpodobně tohle není potřeba, kdyžtak smazat
(defmethod send-to-hiddable-items ((hcs hiddable-compound-shape) 
			  message
			  &rest arguments)
  (dolist (hitem (hiddable-items hcs))
    (apply message hitem arguments))
  hcs)


;;
;; Drawing
(defmethod draw ((hcs hiddable-compound-shape) mg-window)
  "Method maps to an item its draw state if it should be shown or hidden and sends and calls possible-draw to it."
  (let* ((items-list (items hcs))
        (hitems-list (hiddable-items hcs))
        (items-with-its-draw-state-list (mapcar #'list items-list hitems-list)))
    (dolist (item (reverse items-with-its-draw-state-list))
      (possible-draw hcs item mg-window))
      hcs))

#|
TEST3 (requires TEST2 to be executed):
(mapcar #'list (items h) (hiddable-items h))
->See the output.
|#

(defmethod possible-draw ((hcs hiddable-compound-shape) wrapped-item mg-window)
  "Method which draws only those items which state is nil in hiddable-items"
  (when (eql (second wrapped-item) nil)
    (draw (first wrapped-item) mg-window))
  hcs)

#|
TEST4:
(setf w (make-instance 'window))
(set-shape w h)
->In h we have visible blue circle, visible basic inicialized point, and hidden red circle just underneath the blue one
|#


;;
;; Mouse
(defmethod solidp ((hcs hiddable-compound-shape))
  nil)

(defmethod solid-subshapes ((hcs hiddable-compound-shape))
  (mapcan 'solid-shapes (items hcs)))

(defmethod contains-point-p ((hcs hiddable-compound-shape) point)
  (find-if (lambda (item)
	     (contains-point-p item point))
	   (items hcs)))


;;
;; Environment for UI
(defvar *w* (make-instance 'window))
(let ((ts (make-instance 'text-shape))
      (hcs (make-hcs))
      (hcs-ui (make-instance 'picture)))
  (move ts 20 20)
  (set-text ts "Edit hitems")
  (set-items hcs-ui (list ts hcs))
  (set-shape *w* hcs-ui))

(defun make-hcs ()
  "Function which makes basic "
  (let ((hcs (make-instance 'hiddable-compound-shape)))
    (set-items hcs
     (list (set-filledp (set-radius (set-color (move (make-instance 'circle) 100 100) :blue) 50) t)
           (make-instance 'point) 
           (set-filledp (set-radius (set-color (move (make-instance 'circle) 100 170) :red) 50) t)))
    (set-hiddable-items hcs
                '(nil nil t))
    hcs))

;;
;; Events
(defmethod ev-mouse-down ((w window)


  