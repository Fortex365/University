(defclass polygon-window (abstract-window)
  ())

(defmethod initialize-instance ((w polygon-window) &key)
  (call-next-method)
  (do-set-shape w (make-instance 'polygon))
  w)

(defmethod window-mouse-down ((w polygon-window) button position)
  (when (eq button :left)
    (set-items (shape w) (cons position (items (shape w)))))
  (when (eq button :right)
    (set-items (shape w) '()))
  w)


#|
(setf w (make-instance 'polygon-window))

|#