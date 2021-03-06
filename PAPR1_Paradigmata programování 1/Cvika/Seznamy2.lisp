;;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;blbě
(defun last-pair (list)
    (nthcdr (1- (length list)) list))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-copy-list (list)
  (if (zerop (length list))
      ()
    (cons (car list) (my-copy-list (cdr list)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;blbě
(defun equal-lists-p (list1 list2)
  (cond ((and (zerop (length list1))
              (zerop (length list2)))
              t)
        ((eql (car list1) (car list2))
         (equal-lists-p (cdr list1) (cdr list2)))
        (t nil)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-remove (remove list)
  (cond ((null list) nil)
        ((eql remove (car list))
         (my-remove remove (cdr list)))
        (t (cons (car list) (my-remove remove (cdr list))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun remove-nthcdr (n list)
  (if (zerop n)
      (cons () (cdr list))
    (cons (car list) (remove-nthcdr (1- n) (cdr list)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun each-other (list)
  (each-other-help list 0))

(defun each-other-help (list i)
  (cond ((null list) ())
        ((oddp i) (each-other-help (cdr list) (1+ i)))
        (t (cons (car list) (each-other-help (cdr list) (1+ i))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fact (number)
  (cond ((zerop number) 1)
        ((= 1 number) 1)
        (t (fact-help number 1))))

(defun fact-help (number iter)
  (if (= number 1)
      iter
    (fact-help (1- number) (* iter number))))

(defun factorials (number)
  (factorials-help number 0))

(defun factorials-help (number i)
  (if (= i number)
      ()
    (cons (fact i) (factorials-help number (1+ i)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 8 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fib-list (number)
  (fib-list-help number 1 1))

(defun fib-list-help (number n m)
  (if (zerop number)
      ()
    (cons n (fib-list-help (1- number) m (+ n m)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun list-tails (list)
  (list-tail-help list (length list)))

(defun list-tail-help (list i)
  (if (< i 0)
      ()
    (cons list (list-tail-help (cdr list) (1- i)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 10 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun list-sum (list)
  (if (= 1 (length list))
      (car list)
    (+ (car list) (list-sum (cdr list)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 11 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun subtract-lists-2 (list1 list2)
  (cond ((not (= (length list1) (length list2))) nil)
        ((zerop (length list1)) nil)
        (t (cons (- (car list1) (car list2))
                 (subtract-lists-2 (cdr list1) (cdr list2))))))
;divny vysledek
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 12 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scalar-product (list1 list2)
  (cond ((not (= (length list1) (length list2))) nil)
        ((= 1 (length list1)) (* (car list1) (car list2)))
        (t (+ (* (car list1) (car list2)) (scalar-product (cdr list1)
                                                          (cdr list2))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 13 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun vector-lengt (vector)
  (vector-length-iter vector 0))

(defun vector-length-iter (vector iter)
  (if (zerop (length vector))
      (sqrt iter)
    (vector-length-iter (cdr vector) (+ iter (expt (car vector) 2))))) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 14 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun is-present (find list)
  (if (null list)
      nil
    (is-present-help find list)))

(defun is-present-help (find list)
  (cond ((null list) nil)
        ((eql (car list) find) t)
        (t (is-present-help find (cdr list)))))

(defun my-remove-duplicates (list)
  (cond ((null list) ())
        ((is-present (car list) (cdr list)) (my-remove-duplicates (cdr list)))
        (t (cons (car list) (my-remove-duplicates (cdr list))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 15 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-union (list1 list2)
  (reverse (remove-duplicates (reverse (append list1 list2)))))
; append, reverse, remove-duplicates jsem psali v ramci seznami 1 a 2
; pouzil jsem jenom jiz existujici funkce pro lepsi prenositelnost
; v pripade problemu nemam problem predelat do samostatne fungujici verze
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 16 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-subsetp (list1 list2)
  (or (null list1)
      (and (elementp (car list1) list2)
           (my-subsetp (cdr list1) list2))))

(defun equal-sets-p (list1 list2)
  (and (my-subsetp list1 list2) (my-subsetp list2 list1)))

(defun equal-sets-p-2 (list1 list2)
  (equal-lists-p list1 list2))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; 17 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun flatten (list)
  (flatten-iter (cddr list) (caar list) (car list)))

(defun flatten-iter (list element ir)
  (cond ((and (null list) (null element)) ir)
        ((listp element) (flatten-iter (cdr list) (car list) (append ir element)))
        (t (flatten-iter (cdr list) (car list) (append ir (cons element ()))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
