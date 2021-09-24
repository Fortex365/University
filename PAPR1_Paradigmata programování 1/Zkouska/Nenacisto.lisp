;Zkouška nanečisto
;Úkol 1
(defun sign (a)
  (cond ((> a 0) 1)
        ((< a 0) -1)
        (t 0)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point (a b)
  (cons a b))

(defun pointx (a)
  (car a))

(defun pointy (a)
  (cdr a))

(defun triangle (a b c)
  (cons (cons a b) c))

(defun v1 (a)
  (caar a))

(defun v2 (a)
  (cdar a))

(defun v3 (a)
  (cadr a))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Úkol 2
(defun triangle-center (triangle)
  (point 
   (/ (+ (pointx (v1 triangle)) (pointx (v2 triangle)) (pointx (v3 triangle))) 3)
   (/ (+ (pointy (v1 triangle)) (pointy (v2 triangle)) (pointy (v3 triangle))) 3)))
;Úkol 3
(defun sum-digits (a)
  (if (< a 10)
      a
    (+ (rem a 10) (sum-digits (floor a 10)))))
;Úkol 4
(let ((x (cons 'B 'C)))
  (cons x (cons x 'A)))
;Úkol 5     
(defun even-elements (list)
  (cond ((null list) nil)
        ((evenp (car list)) (cons (car list) (even-elements (cdr list))))
        (t (even-elements (cdr list)))))
;Úkol 6
(defun my-set-intersection2 (list1 list2)
  (cond ((null list1) t)
        ((eql (car list1) (car list2)) (cons (car list1) (my-set-intersection2 (cdr list1) (cdr list2))))
         (t (my-set-intersection2 (cdr list1) (cdr list2)))))
;Úkol 7
(defun my-set-intersection (list &rest rest)
  (reduce #'my-set-intersection2 rest list))

;K úkolu 7 je potřeba funkce foldr, která je definovaná takto:
(defun foldr (fun list init)
  (if (null list)
      init
    (funcall fun (car list) (foldr fun (cdr list) init))))
