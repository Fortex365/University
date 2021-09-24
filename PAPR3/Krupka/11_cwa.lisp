;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11_cwa.lisp - příklad k přednášce 11
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 08_cwa.lisp, pouze 
upravený na knihovnu 11.lisp.

Třída circle-with-arrow. 
Jednoduchá ukázka použití objektu jako tlačítka a události ev-mouse-down.

Kromě standardních souborů vyžaduje načíst soubor 11_click-circle.lisp

|#

;; Doufám, že oceníte toto zjednodušení:
(defun make-arrow (color)
  (make-instance 'polygon
                 :filledp t :closedp t :color color
                 :items '((0 -30) (0 -15) (30 -15) (30 15) (0 15) (0 30) (-30 0))))

(defun cwa-items ()
  (list (make-instance 'click-circle :radius 40 :filledp t :center-xy '(148 60))
        (move (rotate (make-arrow :blue)
                      (/ pi 2)
                      (make-instance 'point))
              148
              150)))

(defclass abstract-cwa (abstract-picture)
  ())

(defmethod initialize-instance :after ((pic abstract-cwa) &key)
  (do-set-items pic (cwa-items)))

(defmethod cwa-circle ((p abstract-cwa))
  (first (items p)))

(defmethod cwa-arrow ((p abstract-cwa))
  (second (items p)))

;; První možnost řešení události ev-mouse-down u šipky:
(defclass circle-with-arrow-1 (abstract-cwa)
  ())

(defmethod ev-mouse-down :before ((p circle-with-arrow-1) sender origin button position)
  (when (eql sender (cwa-arrow p))
    (move (cwa-circle p) 0 -10)))

;; Druhá možnost řešení události ev-mouse-down u šipky:
(defclass circle-with-arrow-2 (abstract-cwa)
  ())

(defmethod initialize-instance :after ((cwa circle-with-arrow-2) &key)
  (add-event (cwa-arrow cwa) 'ev-mouse-down 'ev-arrow-click))

(defmethod ev-arrow-click ((cwa circle-with-arrow-2) sender origin button position)
  (move (cwa-circle cwa) 0 -10)
  (send-event cwa 'ev-mouse-down origin button position))


#|
;; Příklady fungují stejně na obě možnosti:

(setf cwa (make-instance 'circle-with-arrow-1))
;;nebo
(setf cwa (make-instance 'circle-with-arrow-2))

(setf w (make-instance 'window :shape cwa))
;;(klikat lze na šipku i kolečko)

(setf pic (make-instance 'picture 
                         :items (list (make-instance 'circle-with-arrow-1)
                                      (move (make-instance 'circle-with-arrow-2) -100 0)
                                      (move (make-instance 'circle-with-arrow-2)  100 0))))

(setf (shape w) pic)
|#