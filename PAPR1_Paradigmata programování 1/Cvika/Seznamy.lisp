; 1
(defun point-distance (A B)
  (sqrt (+ (expt (- (point-x A) (point-x B)) 2)
           (expt (- (point-y A) (point-y B)) 2))))

(defun right-triangle-p (pt1 pt2 pt3)
  (let ((a (point-distance pt1 pt2))
        (b (point-distance pt2 pt3))
        (c (point-distance pt1 pt3)))
    (and (> (+ a b) c)
         (> (+ a c) b)
         (> (+ b c) a))))
; 2
(defun op-vertex (pt1 pt2)
  (point (+ (point-x pt1) (point-x pt2))
         (+ (point-y pt1) (point-x pt2))))

; 3 a 4?
(defun fraction (n d)
  (let ((div (gcd n d)))
    (cons (/ n div) (/ d div))))

(defun numer (frac)
  (car frac))

(defun denom (frac)
  (cdr frac))

(defun frac-+ (x y)
  (fraction (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(defun frac-- (x y)
  (fraction (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(defun frac-* (x y)
  (fraction (* (numer x) (numer y))
            (* (denom x) (denom y))))

(defun frac-/ (x y)
  (fraction (* (numer x) (denom y))
            (* (numer y) (denom x))))

(defun frac-equal-p (x y)
  (and (= (numer x) (numer y))
       (= (denom x) (denom y))))

; 5
(defun interval (lower-bound upper-bound)
  (cons lower-bound upper-bound))

(defun number-in-interval-p (number interval)
  (and (>= number (car interval))
       (<= number (cdr interval))))

(defun interval-intersection (interval-1 interval-2)
  (or (and (>= (car interval-1) (car interval-2))
           (<= (car interval-1) (cdr interval-2)))
      (and (>= (cdr interval-1) (car interval-2))
           (<= (cdr interval-1) (cdr interval-2)))))

; 6
(defun proper-list-p (list)
  (if (atom list)
      (eq nil list)
    (proper-list-p (cdr list))))

(defun proper-list-p-2 (list)
  (if (not (consp list))
      (eq nil list)
    (proper-list-p-2 (cdr list))))

; 7
(defun my-make-list (length elem)
  (if (= length 0)
      ()
    (cons elem (my-make-list (- length 1) elem))))

(defun my-make-list-iter (length elem)
  (my-make-list-iter-help (- length 1) elem (cons elem ())))

(defun my-make-list-iter-help (length elem ir)
  (if (= length 0) 
      ir    
    (my-make-list-iter-help (- length 1) elem (cons elem ir))))

; 8
(defun make-ar-seq-list (first step length)
  (if (= length 0)
      ()
    (cons first (make-ar-seq-list (+ first step) step (- length 1)))))

; 9
(defun make-ar-seq-list-iter (first step length)
  (let ((last (+ first (* step (- length 1))))) 
    (make-ar-seq-list-iter-help (- last step) step (- length 1) (cons last ()))))

(defun make-ar-seq-list-iter-help (last step length ir)
  (if (zerop length)
      ir
    (make-ar-seq-list-iter-help (- last step) step (- length 1) (cons last ir))))

; 10
(defun make-geom-seq-list (first quotient length)
    (if (= length 0)
      ()
      (cons first (make-geom-seq-list (* first quotient) quotient (- length 1)))))

; 11
(defun make-geom-seq-list-iter (first quotient length)
  (let ((last (* first (expt quotient (- length 1)))))
    (make-geom-seq-list-iter-help (/ last quotient) quotient (- length 1) (cons last ()))))

(defun make-geom-seq-list-iter-help (last quotient length ir)
  (if (zerop length)
      ir
    (make-geom-seq-list-iter-help (/ last quotient) quotient (- length 1) (cons last ir))))






