;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11_click-circle.lisp - příklad k přednášce 11
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 07_click-circle.lisp, pouze 
upravený na knihovnu 11.lisp.

Třída click-circle. Kolečko po kliknutí levým tlačítkem změní barvu.

|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))

;; Volba :default-initargs přepisuje defaultní hodnotu inicializačního argumentu
;; :filledp na t. Tedy, volání (make-instance 'click-circle) bez uvedení tohoto
;; argumentu má stejný efekt jako (make-instance 'click-circle :filledp t).
(defclass click-circle (circle) 
  ()
  (:default-initargs :filledp t))

;; mouse-down je tady multimetoda, jsou specializované oba argumenty.
;; Druhý z nich je specializovaný pomocí eql-specializéru.
(defmethod mouse-down :after ((circ click-circle) (button (eql :left)) position) 
  (setf (color circ) (random-color)))


#|

(defun make-test-click-circle (&key (center-x 148) (center-y 100))
  (make-instance 'click-circle :radius 45 :center-x center-x :center-y center-y))

(setf w (make-instance 'window :shape (make-test-click-circle)))

(setf (shape w) 
      (make-instance 'picture
                     :items (list (make-test-click-circle :center-x 103 :center-y 55)
                                  (make-test-click-circle :center-x 193 :center-y 55)
                                  (make-test-click-circle :center-x 103 :center-y 145)
                                  (make-test-click-circle :center-x 193 :center-y 145))))

|#