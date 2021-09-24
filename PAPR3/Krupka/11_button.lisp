;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11_button.lisp - příklad k přednášce 11
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 08_button.lisp, pouze 
upravený na knihovnu 11.lisp.

Tlačítko s textem (vlastnost button-text). Po kliknutí levým tlačítkem myši
generuje událost ev-button-click.

Kromě standardních souborů vyžaduje načíst soubory 05_bounds.lisp 
a 11_text-shape.lisp

|#

(defclass button (abstract-picture)
  ())

;; Aby tlačítko dostávalo zprávu mouse-down
(defmethod solidp ((b button))
  t)

(defmethod mouse-down :after ((b button) (mouse-button (eql :left)) position)
  ;; Kromě klasického ev-mouse-down ve zděděné metodě generujeme novou událost
  ;; ev-button-click, pokud se kliklo levým tlačítkem. Událost nemá parametry.
  ;; Druhý parametr má tzv. "eql specializér". Metoda se zavolá jen
  ;; pokud je roven :left
  (send-event b 'ev-button-click))

(defmethod button-text-shape ((b button))
  (first (items b)))

(defmethod button-text ((b button))
  (text (first (items b))))

(defmethod recomp-frame ((b button))
  (setf (items (second (items b))) (but-poly-items b))
  (setf (items (third (items b))) (but-poly-items b)))

(defmethod (setf button-text) (text (b button))
  (setf (text (button-text-shape b)) text)
  (recomp-frame b))

(defmethod but-poly-items ((b button))
  (let ((left (- (left (button-text-shape b)) 5))
        (right (+ (right (button-text-shape b)) 5))
        (top (- (top (button-text-shape b)) 5))
        (bottom (+ (bottom (button-text-shape b)) 5)))
    (mapcar (lambda (x y)
              (make-instance 'point :x x :y y))
            (list left right right left)
            (list top top bottom bottom))))

(defmethod initialize-instance :after ((b button) &key (text "") (x 0) (y 0) (xy (list x y)))
  (do-set-items b (list (make-instance 'text-shape :text text :xy xy)
                        (make-instance 'polygon :closedp t)
                        (make-instance 'polygon :filledp t :color :light-blue)))
  (recomp-frame b))


#|
(defclass test-window (window)
  ())

(defmethod ev-button-click ((w test-window) button)
  (format t "~%Button ~s clicked " button))

(setf w (make-instance 'test-window))

(setf b (make-instance 'button :x 50 :y 50 :text "Hello Universe"))
(add-event b 'ev-button-click 'ev-button-click)
 
(setf (shape w) b)
(setf (button-text b) (format nil "Text~%na~%více~%řádků"))
|#