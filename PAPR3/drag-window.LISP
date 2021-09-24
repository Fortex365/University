(load (current-pathname "Krupka/11_load.lisp"))

(defclass drag-window (window)
  ((clicked :initform nil :reader clicked)))

(defmethod install-callbacks :after ((dw drag-window))
  (install-mouse-up-callback dw)
  (install-mouse-move-callback dw)
  dw)

(defmethod (setf clicked) :before (shape (dw drag-window))
  (unless (or (typep shape 'shape) 
              (eql shape nil))
    (error "Something went wrong..")))

(defmethod (setf clicked) (shape (dw drag-window))
  (setf (slot-value dw 'clicked) shape))

(defmethod install-mouse-up-callback ((dw drag-window))
  (mg:set-callback 
   (slot-value dw 'mg-window)
                   :mouse-up (lambda (mgw button x y)
                               (declare (ignore mgw))
                               (window-mouse-up
                                       dw
                                       button
                                       (make-instance 'point :x x :y y))))
  dw)

(defmethod install-mouse-move-callback ((dw drag-window))
  (mg:set-callback 
   (slot-value dw 'mg-window)
   :mouse-move (lambda (mgw button x y)
                 (declare (ignore mgw))
                 (window-mouse-move
                         dw
                         button
                         (make-instance 'point :x x :y y))))
  dw)

(defmethod window-mouse-up ((dw drag-window) button position)
  (setf (clicked dw) nil))

(defmethod window-mouse-move ((dw drag-window) button position)
  (if (and (clicked dw) (eql button :left))
      (mouse-move-inside-shape dw (clicked dw) button position)))

(defmethod mouse-move-inside-shape ((dw drag-window) (shape circle) button position)
  (move shape (- (x position) (x (center shape))) (- (y position) (y (center shape)))))

(defmethod mouse-move-inside-shape ((dw drag-window) (shape point) button position)
  (move shape (- (x position) (x shape)) (- (y position) (y shape))))

(defmethod mouse-move-inside-shape ((dw drag-window) (shape polygon) button position)
  (broadcast shape (lambda (item) (mouse-move-inside-shape dw item button position))))

(defmethod mouse-down-inside-shape :after ((dw drag-window) shape button position)
  (setf (clicked dw) shape))

#|
TESTS:

(make-instance 'drag-window :shape (make-instance 'circle :radius 50 :center-x 100 :center-y 100
                                                  :filledp t))
(make-instance 'drag-window :shape (make-instance 'polygon :filledp nil :closedp nil :thickness 4 :color :blue :items
                                                  '((200 73) (215 67) (222 71) (230 68) (240 77) (300 20) (350 47))))

(make-instance 'drag-window :shape (make-instance 'point :x 100 :y 100 :thickness 20 :color :red))

(make-instance 'drag-window :shape (make-instance 'picture :items
                                                  (list (make-instance 'circle :radius 50 :center-x 150 :center-y 150 :filledp t :color :red)
                                                        (make-instance 'circle :radius 50 :center-x 100 :center-y 100 :filledp t :color :blue))))
|#