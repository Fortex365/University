;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11_polygon-canvas.lisp - příklad k přednášce 11
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 08_polygon-canvas.lisp, pouze 
upravený na knihovnu 11.lisp.

|#

(defclass polygon-canvas (abstract-picture)
  ())

(defmethod canvas-polygon ((c polygon-canvas))
  (first (items c)))

(defmethod canvas-background ((c polygon-canvas))
  (second (items c)))

(defmethod solidp ((c polygon-canvas))
  t)

(defun make-canvas ()
  (let ((result (make-instance 'abstract-polygon :color :light-blue :filledp t)))
    (do-set-items result
                  '((0 0) (200 0) (200 150) (0 150)))
    result))
                
(defmethod initialize-instance :after ((c polygon-canvas) &key)
  (do-set-items c (list (make-instance 'polygon :closedp nil)
                        (make-canvas))))

(defmethod ev-change :after ((c polygon-canvas) sender)
  (send-event c 'ev-poly-change))

(defmethod mouse-down :after ((c polygon-canvas) (button (eql :left)) where)
  (setf (items (canvas-polygon c))
        (cons where (items (canvas-polygon c)))))



#|

(setf w (make-instance 'window :shape (make-instance 'polygon-canvas)))

(setf (filledp (canvas-polygon (shape w))) t)
(setf (color (canvas-polygon (shape w))) :brown)
|#
