;; class POINT

(defclass point ()
  ((x :initform 0)
   (y :initform 0)))

(defmethod r ((point point))
  (let ((x (slot-value point 'x))
        (y (slot-value point 'y)))
    (sqrt (+ (* x x) (* y y)))))

(defmethod phi ((point point))
  (let ((x (slot-value point 'x))
        (y (slot-value point 'y)))
    (cond ((> x 0) (atan (/ y x)))
          ((< x 0) (+ pi (atan (/ y x))))
          (t (* (signum y) (/ pi 2))))))

(defmethod set-r-phi ((point point) r phi)
  (setf (slot-value point 'x) (* r (cos phi))
        (slot-value point 'y) (* r (sin phi)))
  point)

(defmethod set-r ((point point) r)
  (set-r-phi point r (phi point)))

(defmethod set-phi ((point point) phi)
  (set-r-phi point (r point) phi))

(defmethod move ((point point) dx dy)
  (setf (slot-value point 'x) (+ dx (slot-value point 'x))
        (slot-value point 'y) (+ dy (slot-value point 'y)))
  point)

(defmethod rotate ((point point) center angle)
  (let ((cx (slot-value center 'x))
        (cy (slot-value center 'y)))
    (move point (- cx) (- cy))
    (set-phi point (+ (phi point) angle))
    (move point cx cy)
    point))

;; class CIRCLE

(defclass circle ()
  ((center :initform (make-instance 'point))
   (radius :initform 1)))

;; class TRIANGLE

(defclass triangle ()
  ((vertexA :initform (make-instance 'point))
   (vertexB :initform (move (make-instance 'point) 1 0))
   (vertexC :initform (move (make-instance 'point) 0 1))))

(defmethod vertices ((triangle triangle))
  (list (slot-value triangle 'vertexA)
        (slot-value triangle 'vertexB)
        (slot-value triangle 'vertexC)))

(defmethod segment-lengths ((triangle triangle))
  (list (distance (slot-value triangle 'vertexA) (slot-value triangle 'vertexB))
        (distance (slot-value triangle 'vertexB) (slot-value triangle 'vertexC))
        (distance (slot-value triangle 'vertexC) (slot-value triangle 'vertexA))))

(defmethod circumference ((triangle triangle))
  (apply #'+ (segment-lengths triangle)))

(defmethod area ((triangle triangle))
  (let ((s (/ (circumference triangle) 2)))
    (sqrt (apply #'* s (mapcar (lambda (x) (- s x)) (segment-lengths triangle))))))

(defmethod center ((triangle triangle))
  (let ((x (/ (apply #'+ (mapcar (lambda (v) (slot-value v 'x)) (vertices triangle))) 3))
        (y (/ (apply #'+ (mapcar (lambda (v) (slot-value v 'y)) (vertices triangle))) 3)))
    (move (make-instance 'point) x y)))

(defmethod is-right-p ((triangle triangle))
  (let ((sorted-seg-len (sort (segment-lengths triangle) #'<))
        (na2 (lambda (x) (* x x))))
    (< (abs (- (+ (funcall na2 (first sorted-seg-len))
                  (funcall na2 (second sorted-seg-len)))
               (funcall na2 (third sorted-seg-len))))
       0.001)))

(defmethod move ((triangle triangle) dx dy)
  (mapcar (lambda (v) (move v dx dy)) (vertices triangle))
  triangle)

(defmethod rotate ((triangle triangle) center angle)
  (mapcar (lambda (v) (rotate v center angle)) (vertices triangle))
  triangle)

;; functions

(defun distance (pointA pointB)
  (let ((vx (- (slot-value pointA 'x)
               (slot-value pointB 'x)))
        (vy (- (slot-value pointA 'y)
               (slot-value pointB 'y))))
    (sqrt (+ (* vx vx) (* vy vy)))))


;; tests

#|
(setf a (make-instance 'point))
(move a 0 1)
(setf b (make-instance 'point))
(move b 5 -5)
(distance a b)

(setf tri (make-instance 'triangle))
(vertices tri)
(segment-lengths tri)
(circumference tri)
(area tri)
(center tri)
(is-right-p tri)
(move tri 3 4)
(rotate tri a (/ pi 2))
|#

