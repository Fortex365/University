;; class EXTENDED-PICTURE (version 1)

(defclass extended-picture (picture)
  ((propagate-color-p :initform nil)))

(defmethod propagate-color-p ((ep extended-picture))
  (slot-value ep 'propagate-color-p))

(defmethod set-propagate-color-p ((ep extended-picture) value)
  (setf (slot-value ep 'propagate-color-p) value)
  ep)

(defmethod set-color ((ep extended-picture) value)
  (if (propagate-color-p ep)
      (dolist (item (items ep))
        (set-color item value)))
  (call-next-method))

;; class EXTENDED-PICTURE (version 2)

(defclass extended-picture2 (picture)
  ((propagate-color-p :initform nil)))

(defmethod propagate-color-p ((ep extended-picture2))
  (slot-value ep 'propagate-color-p))

(defmethod set-propagate-color-p ((ep extended-picture2) value)
  (setf (slot-value ep 'propagate-color-p) value)
  ep)

(defmethod draw ((ep extended-picture2) mgw)
  (if (propagate-color-p ep)
      (dolist (item (reverse (items ep)))
        (let ((original-color (color item)))
          (set-color item (color ep)) 
          (draw item mgw)
          (set-color item original-color))
        ep)
    (call-next-method)))


;; tests
#|
(setf w (make-instance 'window))
(setf sq (make-instance 'polygon))
(set-items sq (list (set-x (set-y (make-instance 'point) 100) 100)
                      (set-x (set-y (make-instance 'point) 100) 200)
                      (set-x (set-y (make-instance 'point) 150) 200)
                      (set-x (set-y (make-instance 'point) 150) 100)))
(set-color sq :yellow)
(set-filledp sq t)
(set-shape w sq)
(redraw w)

(setf tri (make-instance 'polygon))
(set-items tri (list (set-x (set-y (make-instance 'point) 100) 90)
                      (set-x (set-y (make-instance 'point) 100) 210)
                      (set-x (set-y (make-instance 'point) 50) 150)))
(set-color tri :red)
(set-filledp tri t)
(set-shape w tri)
(redraw w)

(setf ep (make-instance 'extended-picture))
(set-items ep (list tri sq))
(set-shape w ep)
(set-color ep :green)
(redraw w)

(propagate-color-p ep)
(set-propagate-color-p ep t)

(set-color ep :green)
(redraw w)

(set-propagate-color-p ep nil)
(redraw w)


(setf ep2 (make-instance 'extended-picture2))
(set-items ep2 (list tri sq))
(set-color sq :yellow)
(set-color tri :red)
(set-shape w ep2)
(redraw w)

(set-propagate-color-p ep2 t)
(propagate-color-p ep2)
(redraw w)

(set-color ep2 :green)
(redraw w)
(set-propagate-color-p ep2 nil)
(redraw w)
|#