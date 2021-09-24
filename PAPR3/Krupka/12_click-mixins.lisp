;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 12_click_mixins.lisp
;;;;
;;;; Další příklady mixinů a dynamických aspektů CLOSu (změna třídy instance)
;;;; Příklady z přednášky. Vyhodnocujte postupně jednotlivé výrazy a příklady v komentářích.
;;;;
;;;; Jsou to jen zábavné příklady, ale dobře ukazují, jak mixiny jakožto asi nejzajímavější
;;;; varianta vícenásobné dědičnosti fungují ... pro případné praktické použití
;;;;
;;;;
;;;; Je třeba načíst knihovnu micro-graphics a soubor 11.lisp
;;;;

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))

(defclass click-1-mixin ()
  ())

(defmethod mouse-down :after ((shape click-1-mixin) button where)
  (setf (color shape) (random-color)))

(defclass click-1-circle (click-1-mixin circle)
  ())

#|
(setf shape (make-instance 'click-1-circle 
                           :filledp t 
                           :center-xy '(122 100)
                           :radius 15))

(setf w (make-instance 'window :shape shape))

;; Okno nezavírejte, další třídy budeme ukazovat stále na objektu shape.
|#

(defclass click-2-mixin ()
  ())

(defmethod mouse-down :after ((shape click-2-mixin) button where)
  (move shape (- (random 40) 20) (- (random 40) 20)))

(defclass click-2-circle (click-2-mixin circle)
  ())

#|
;; Změna třídy instance generickou funkcí change-class.
;; Základní metody ubírají a přidávají patřičné sloty:

(change-class shape 'click-2-circle)
|#

(defclass click-1-2-circle (click-1-mixin click-2-mixin circle)
  ())

#|
(change-class shape 'click-1-2-circle)
|#

(defclass click-3-mixin ()
  ())

(defmethod mouse-down :after ((shape click-3-mixin) (button (eql :left)) where)
  (scale shape 11/10 (make-instance 'point :x 122 :y 100)))

(defmethod mouse-down :after ((shape click-3-mixin) (button (eql :right)) where)
  (scale shape 10/11 (make-instance 'point :x 122 :y 100)))

(defclass click-3-circle (click-3-mixin circle)
  ())

#|
(change-class shape 'click-3-circle)
|#

(defclass click-1-2-3-circle (click-1-mixin click-2-mixin click-3-mixin circle)
  ())

#|
(change-class shape 'click-1-2-3-circle)
|#

(defclass click-4-mixin ()
  ())

(defmethod mouse-down :around ((shape click-4-mixin) button where)
  (when (yes-or-no-p "Opravdu?")
    (call-next-method)))

(defclass click-1-2-3-4-circle (click-1-mixin click-2-mixin click-3-mixin
                                              click-4-mixin circle)
  ())

#|
(change-class shape 'click-1-2-3-4-circle)
|#

#|
Nyní ukážeme, že definované mixiny lze bez problémů přimíchat k jiným
třídám (v tomhle případě k třídě star, jež je potomkem třídy polygon).
|#

(defvar *golden-cut* (/ (- (sqrt 5) 1) 2))

(defun star-points ()
  (let ((result '())
        (origin (make-instance 'point)))
    (dotimes (i 5)
      (let ((pt1 (make-instance 'point :x 0 :y -1))
            ;; Vnitřní a vnější pětiúhelník mají délky stran v poměru
            ;; 1 minus zlatý řez
            (pt2 (make-instance 'point :x 0 :y (- 1 *golden-cut*))))
        (rotate pt1 (* pi 2/5 i) origin)
        (rotate pt2 (* pi 2/5 (+ i 2)) origin)
        (setf result (cons pt1 (cons pt2 result)))))
    result))

(defclass star (polygon) 
  ()
  (:default-initargs :closedp t))

(defmethod initialize-instance :after ((star star) &key)
  (setf (items star) (star-points)))

#|
Funkce change-class volá funkci update-instance-for-different-class. Zde máme
šanci udělat vhodné inicializace. První parametr je stará verze instance, druhý nová.
Většinou je třeba (jako zde) napsat multimetodu:
|#
(defmethod update-instance-for-different-class :after ((old circle) (new star) &rest initargs)
  (setf (items new) (star-points))
  (scale new (radius old) (make-instance 'point))
  (move new (x (center old)) (y (center old))))

;;Změna třídy z hvězdy na kruh je trošku složitější:
(defmethod update-instance-for-different-class :after ((old star) (new circle) &rest initargs)
  ;;Střed hvězdy je v těžišti (máme 10 vrcholů, proto dělíme 10):
  (let ((new-center (make-instance 'point
                                   :x (/ (apply '+ (mapcar 'x (items old))) 10)
                                   :y (/ (apply '+ (mapcar 'y (items old))) 10)
                                   :delegate new)))
    ;;Při změně třídy se initialize-instance nevolá, proto nastavujeme manuálně střed:
    (setf (slot-value new 'center) new-center
          ;;Vzdálenost bodů (definováno v 11.lisp)
          ;;(První vrchol je dál od středu):
          (radius new) (point-dist new-center (first (items old))))))

(defclass click-1-2-3-4-star (click-1-mixin click-2-mixin click-3-mixin
                                            click-4-mixin star)
  ())

#|
(change-class shape 'click-1-2-3-4-star)
(change-class shape 'click-1-2-3-4-circle)
|#

