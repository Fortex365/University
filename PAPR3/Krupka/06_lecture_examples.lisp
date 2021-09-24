;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 06_lecture_examples.lisp - příklady z přednášky 6. Zpětná volání
;;;;

#|

Soubor obsahuje příklady z 6. přednášky pro snadnější testování.

Nejprve načtěte knihovnu micro-graphics a soubor 05.lisp.

Soubor je nejlepší procházet takto: průběžně čtěte text a když v něm narazíte
na příklad, vyhodnoťte ho v tomto souboru.

Testy jsou zakomentované, jednotlivé jejich výrazy můžete vyhodnocovat přes F8
nebo kopírovat do Listeneru. Nové definice vyhodnocujte přímo v souboru 
(F7 nebo F8).

|#


#|
(setf mgw (mg:display-window))

;; Nastavení callbacku:
(mg:set-callback mgw :display (lambda (mgw)
                                (format t "~%Překresli mě!")))

;; Manipulujte s oknem a dívejte se do standardního výstupu (panel Output).

;; Zrušení callbacku:
(mg:set-callback mgw :display nil)
|#

(defmethod install-display-callback ((w abstract-window)) 
  (mg:set-callback (slot-value w 'mg-window)
                   :display (lambda (mgw)
                              (declare (ignore mgw))
                              (redraw w)))
  w)

(defmethod install-callbacks ((w abstract-window)) 
  (install-display-callback w)
  w)

(defun make-test-circle ()
  (move (set-radius (set-thickness (set-color 
                                    (make-instance 'circle)
                                    :darkslategrey)
                                   5)
                    55)
        148 
        100))

#|

(setf w (set-background
         (set-shape (make-instance 'window)
                    (make-test-circle)) 
         :ghostwhite))

;; Teď se při manipulaci s oknem nic nezobrazuje.
;; Ale nainstalujeme zpětné volání:

(install-callbacks w)

|#

(defmethod initialize-instance ((w abstract-window) &key)
  (call-next-method)
  (install-callbacks w)
  w)

(defmethod invalidate ((w abstract-window))
  (mg:invalidate (slot-value w 'mg-window))
  w)

(defmethod set-background ((w abstract-window) color)
  (setf (slot-value w 'background) color)
  (invalidate w))

(defmethod do-set-shape ((w abstract-window) shape)
  (setf (slot-value w 'shape) shape)
  (invalidate w))

#|

(setf w (make-instance 'window))
(set-background w :blue)
(set-shape w (make-test-circle))

|#

(defclass shape ()
  ((color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (window :initform nil)))

(defmethod window ((s shape))
  (slot-value s 'window))

(defmethod set-window ((s shape) value)
  (setf (slot-value s 'window) value))

(defmethod set-window ((p abstract-picture) w)
  (call-next-method)
  (send-to-items p 'set-window w))

(defmethod do-set-shape ((w abstract-window) s)
  (setf (slot-value w 'shape) s)
  (set-window s w)
  (invalidate w))

(defmethod change ((shape shape))
  (when (window shape)
    (ev-change (window shape) shape))
  shape)

(defmethod ev-change ((w abstract-window) shape)
  (invalidate w))

(defmethod set-color ((shape shape) value) 
  (setf (slot-value shape 'color) value)
  (change shape))

#|

(setf w (make-instance 'window))
(set-shape w (make-test-circle))
(set-color (shape w) :purple)

|#

;; Poslední příklad se mírně liší od příkladu v textu:

(defmethod do-move ((shape shape) dx dy) 
  shape)

(defmethod move ((shape shape) dx dy)
  (do-move shape dx dy)
  (change shape))

(defmethod do-move ((c circle) dx dy) 
  (move (center c) dx dy)
  c)

#|

;; Test pracuje s oknem w z předchozího testu.
;;
;; Nejdřív musíte zrušit starou definici metody move pro kolečko.
;; V souboru 05.lisp klikněte pravým tlačítkem na "defmethod" v definici
;; metody a zvolte "Definitions -> Undefine...".
;;  

(move (shape w) 50 0)

|#