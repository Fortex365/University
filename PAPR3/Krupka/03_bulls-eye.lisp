;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 03_bulls-eye.lisp - příklad k přednášce 3. Polymorfismus
;;;;

(defun make-bulls-eye (x y radius count)
  (move (scale (set-items (make-instance 'picture)
                          (make-be-items count))
               (/ radius count)
               (make-instance 'point))
        x
        y))

(defun make-be-items (count &optional (ir '()))
  (if (zerop count)
      ir
    (make-be-items (1- count) 
                   (cons (make-be-item count (oddp count)) ir))))

(defun make-be-item (radius blackp)
  (set-filledp 
   (set-color 
    (set-radius (make-instance 'circle) radius)
    (if blackp :black :light-blue))
   t))


#|
(setf w (make-instance 'window))
(set-shape w (make-bulls-eye 100 100 50 1))
(redraw w)
(set-shape w (make-bulls-eye 100 100 50 2))
(redraw w)
(set-shape w (make-bulls-eye 100 100 50 5))
(redraw w)
|#


