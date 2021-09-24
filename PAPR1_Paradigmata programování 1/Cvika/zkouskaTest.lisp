;1
(defun my-signum (a)
  (cond ((> a 0) 1)
        ((< a 0) -1)
        (t 0)))
;;;;;;;;;;;;;;;;;;;;;;

;2
(defun point (x y)
  (cons x y))
(defun point-x (pt)
  (car pt))
(defun point-y (pt)
  (cdr pt))

(defun my-triangle-center (v1 v2 v3)
  (point (/ (+ (point-x v1) (point-x v2) (point-x v3)) 3)
         (/ (+ (point-y v1) (point-y v2) (point-y v3)) 3)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;3
(defun sum-digits (number)
  (let ((last-digit (rem number 10)))
    (if (zerop number)
        0
      (+ last-digit (sum-digits (floor number 10))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;4 
(cons (cons 'b 'c) 'a)
;;;;;;;;;;;;;;;;;;;;;;;

;5
(defun even-elements (list)
  (cond ((null list) '())
        ((evenp (car list)) (cons (car list)
                                  (even-elements (cdr list))))
        (t (even-elements (cdr list)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;6
(defun my-find-f (list finding)
  (cond ((eql (car list) finding) finding)
        ((null list) nil)
        (t (my-find-f (cdr list) finding))))

(defun my-set-interselection (list1 list2)
  (cond ((or (null list1) (null list2) '())
        ((my-find-f list2 (car list1)) 
         (cons (car list1) (my-set-interselection (cdr list1) list2)))
        (t (my-set-interselection (cdr list1) list2))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;7 
;; dodelat
(defun my-set-interselection-gen (list1 &rest rest)
  (cond ((null list1) '())
        ((and (my-find-f (car rest) (car list1)) (my-set-interselection-gen list1 (cdr rest)))
         (cons (car list1) (my-set-interselection-gen (cdr list1) rest)))
        (t (my-set-interselection-gen (cdr list1) rest))))

