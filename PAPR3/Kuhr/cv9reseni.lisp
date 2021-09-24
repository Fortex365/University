(defvar *shape* (send *object* 'clone))
(send *shape* 'set-name "SHAPE")

(send *shape* 'add "COLOR" :value :black)


(send *shape* 'add "MOVE" :value (lambda (self x &key y) 
                                   (declare (ignore x))
                                   (declare (ignore y))
                                   self))

(send *shape* 'add "ROTATE" :value (lambda (self angle &key center) 
                                     (declare (ignore angle))
                                     (declare (ignore center))
                                     self))

(send *shape* 'add "SCALE" :value (lambda (self coeff &key center) 
                                    (declare (ignore coeff))
                                    (declare (ignore center))
                                    self))


#|
Pozor - prototypy by se menit nemely
Po otestovani vratte *shape* do puvodniho stavu

(send *shape* 'color)
(send *shape* 'set-color :red)
(send *shape* 'color)
(send *shape* 'set-color :black)
(send *shape* 'move 10 :y 20)
|#


(defvar *point* (send *shape* 'clone))
(send *point* 'set-name "POINT")

(send *point* 'add "X" :value 0)
(send *point* 'add "Y" :value 0)

(send *point* 'add "R" :value
      (lambda (self arg1 &key)
        (declare (ignore arg1))
        (let ((x (send self 'x)) 
              (y (send self 'y))) 
          (sqrt (+ (* x x) (* y y))))))

(send *point* 'add "PHI" :value
      (lambda (self arg1 &key)
        (declare (ignore arg1))
        (let ((x (send self 'x)) 
              (y (send self 'y)))
          (cond ((> x 0) (atan (/ y x))) 
                ((< x 0) (+ pi (atan (/ y x)))) 
                (t (* (signum y) (/ pi 2)))))))

(send *point* 'add "SET-R-PHI" :value
      (lambda (self r &key phi) 
        (send self 'set-x (* r (cos phi)))
        (send self 'set-y (* r (sin phi)))))

(send *point* 'add "SET-R" :value
      (lambda (self r &key)
        (send self 'set-r-phi r :phi (send self 'phi))))

(send *point* 'add "SET-PHI" :value
      (lambda (self phi &key)
        (send self 'set-r-phi (send self 'r) :phi phi)))


(send *point* 'add "MOVE" :value (lambda (self x &key y)
                                   (send self 'set-x (+ (send self 'x) x))
                                   (send self 'set-y (+ (send self 'y) y))
                                   self))

(send *point* 'add "ROTATE" :value 
      (lambda (self angle &key center)
        (let ((cx (send center 'x))
              (cy (send center 'y)))
          (send self 'move (- cx) :y (- cy))
          (send self 'set-phi (+ (send self 'phi) angle))
          (send self 'move cx :y cy))))

(send *point* 'add "SCALE" :value 
      (lambda (self coeff &key center)
        (let ((cx (send center 'x))
              (cy (send center 'y)))
          (send self 'move (- cx) :y (- cy))
          (send self 'set-r (* (send self 'r) coeff))
          (send self 'move cx :y cy))))

#|
(setf p1 (send *point* 'clone))
(setf p2 (send *point* 'clone))
(send p1 'set-x 10)
(send p1 'set-y 20)
(send p2 'move 3 :y 4)

(send p2 'set-color :red)

(send p1 'set-y 0)
(send p1 'r)
(send p1 'phi)
(send p1 'r (send p1 'set-r-phi 20 :phi (/ pi 2)))
(send p1 'phi)
(send p1 'r (send p1 'set-r 10))
(send p1 'x)
(send p1 'y)
(send p1 'phi (send p1 'set-phi (* 2 pi)))

(send p1 'move 2 :y 3)
(send p1 'x)
(send p1 'y)

(send p2 'set-x 10)
(send p2 'set-y 10)
(send (send p2 'rotate (/ pi 2)
            :center (send (send (send *point* 'clone) 'set-x 5) 'set-y 5))
      'scale 2 :center (send (send *point* 'clone) 'move 0 :y 5))
(send p2 'x)
(send p2 'y)
|#


(defvar *circle* (send *shape* 'clone))
(send *circle* 'set-name "CIRCLE")

(send *circle* 'add "RADIUS" :value 1)

#|
; toto je nehezky hack, spise se proste spolehejte na rozum uzivatele 
; tohoto experimentalniho prototypoveho systemu :-)
(send *circle* 'add "SET-RADIUS" :value 
      (lambda (self arg1 &key)
        (if (<= arg1 0) (error "Polomer musi byt kladny. ")
          (set-field-value self (field-name "RADIUS") arg1))
        self))
|#

(send *circle* 'add "CENTER" :value (send *point* 'clone))

#|
; opet neni nutne, ale ani tak obludne jako u set-radius
; jen to trochu komplikuje redefinici clone
(send *circle* 'remove "SET-CENTER")
|#

; nutne upravit, aby byly ruzne kruhy nezavisle
(send *circle* 'add "CLONE" :value 
      (lambda (self arg1 &key)
        (declare (ignore arg1))
        (let ((result (send (make-object) 'set-super self)) 
              (center (send (send self 'center) 'clone)))
              (send result 'set-center center))))

#|
(send *circle* 'add "CLONE" :value 
      (lambda (self arg1 &key)
        (declare (ignore arg1))
        (let ((result (send (make-object) 'set-super self)) 
              (center (send (send self 'center) 'clone)))
          (set-field-value result (field-name "CENTER") center)
          result)))
|#


(send *circle* 'add "MOVE" :value 
      (lambda (self x &key y)
        (send (send self 'center) 'move x :y y)
        self))

(send *circle* 'add "ROTATE" :value 
      (lambda (self angle &key center)
        (send (send self 'center) 'rotate angle :center center)
        self))

(send *circle* 'add "SCALE" :value 
      (lambda (self coeff &key center)
        (send (send self 'center) 'scale coeff :center center)
        (send self 'set-radius (* coeff (send self 'radius)))))

#|
(setf c1 (send *circle* 'clone))
(setf c2 (send *circle* 'clone))

(send c1 'set-radius 10)
(send c1 'radius)
(send c1 'set-radius 1)
(send c1 'radius)

(send c1 'move 10 :y 20)
(send (send c1 'center) 'x)
(send (send c1 'center) 'y)
(send (send c2 'center) 'x)
(send (send c2 'center) 'y)

(send (send (send c2 'center) 'set-x 10) 'set-y 10)
(send c2 'set-radius 5)

(send (send c2 'rotate (/ pi 2)
            :center (send (send (send *point* 'clone) 'set-x 5) 'set-y 5))
      'scale 2 :center (send (send *point* 'clone) 'move 0 :y 5))

(send (send c2 'center) 'x)
(send (send c2 'center) 'y)
(send c2 'radius)

|#

