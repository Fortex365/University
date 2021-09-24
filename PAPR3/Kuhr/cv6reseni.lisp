(defun darken-color (color)
  (let ((color-spec (color:get-color-spec color))) 
    (color:make-hsv (color:color-hue color-spec) 
                    (color:color-saturation color-spec)
                    (/ (color:color-value color-spec) 2))))

;; pozadovana trida pro divne okno

(defclass my-window (window)
  ())

(defmethod ev-change ((w my-window) shape)
  (set-background w (darken-color (color shape)))
  (call-next-method))


;; upravy existujicich trid

(defmethod set-window ((c circle) w)
  (call-next-method)
  (set-window (center c) w)
  c)

;; neni pak potreba v abstract-picture
(defmethod set-window ((cs compound-shape) w)
  (call-next-method)
  (send-to-items cs 'set-window w))

;; predefinovani existujici metody
(defmethod do-set-items ((cs compound-shape) value)
  (setf (slot-value cs 'items) (copy-list value))
  (send-to-items cs 'set-window (window cs)))


#|
(setf w (make-instance 'my-window))
(setf sq (make-instance 'polygon))
(set-items sq (list (set-x (set-y (make-instance 'point) 100) 100)
                      (set-x (set-y (make-instance 'point) 100) 200)
                      (set-x (set-y (make-instance 'point) 150) 200)
                      (set-x (set-y (make-instance 'point) 150) 100)))
(set-shape w sq)
(set-background w :white)
(set-color sq :yellow)
(set-color sq :red)
(set-filledp sq t)
(set-filledp sq nil)

(move (first (items sq)) 10 0)
(redraw w)

(setf tri (make-instance 'polygon))
(set-items tri (list (set-x (set-y (make-instance 'point) 100) 90)
                      (set-x (set-y (make-instance 'point) 100) 210)
                      (set-x (set-y (make-instance 'point) 50) 150)))
(set-color tri :red)
(set-filledp tri t)
(set-shape w tri)

(setf p (make-instance 'picture))
(set-items p (list tri sq))
(set-shape w p)
(move tri 0 20)

(move p 0 20)

|#