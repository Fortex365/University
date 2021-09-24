;FUNKCE POWER-ITER prepsana pomoci LABELS
(defun nth-power (a n)
  (labels ((iter (a n ir)
             (cond ((zerop n) ir)
                   (t (iter a (- 1 n) (* ir a))))))
  (cond ((zerop n) 1)
        ((= n 1) a)
        (t (iter a n 1)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FUNKCE MY-MAKE-LIST prepsana pomoci LABELS
(defun my-make-list-iter (length elem)
  (my-make-list-iter-help (- length 1) elem (cons elem ())))

(defun my-make-list-iter-help (length elem ir)
  (if (= length 0) 
      ir    
    (my-make-list-iter-help (- length 1) elem (cons elem ir))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-make-list (length elem)
  (labels ((iter (length elem ir)
             (if (= lenght 0)
                 ir
               (iter (- length 1) elem (cons elem ir)))))
    (iter (- lenghth 1) elem (cons elem ()))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(divide-by-2 (list 4 2 8) => (2 1 4) napsat pomoci MAPCAR

(defun divide-by-2-mapcar (list)
  (mapcar #'divide2 list))

(defun divide2 (a)
  (/ a 2))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(sum-pair (list (cons 2 2) (cons 3 2))) => '(4 5)
(defun sum-pair-mapcar (list)
  (mapcar #'sum-pair list))

(defun sum-pairs (list list2)
  (cons (+ (car list) (cdr list)) (+ (car list) (cdr list))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(my-lenght (list 1 2 3)) => 3
(defun my-lenght (list)
  (foldr #'lenght list))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

