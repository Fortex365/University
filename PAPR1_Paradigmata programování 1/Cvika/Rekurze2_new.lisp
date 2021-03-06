;;;;;;; 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun power2 (n)
  (* n n))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun fast-power-iter-help (a n ir)
  (cond ((= n 1) ir)
        ((evenp n)
         (fast-power-iter-help a (/ n 2) (* ir (power2 a))))
        (t (fast-power-iter-help a (- n 1) (* ir a)))))

(defun fast-power-iter (a n)
  (cond ((zerop n) 1)
        ((= n 1) a)
        (t (fast-power-iter-help a n 1))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dividesp (a b)
  (zerop (mod b a)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;; 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-modulo (a b)
  (if (> b 0) 
      (- a (* (floor (/ a b)) b))
        (- a (* (ceil (/ a b)) b))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;; 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun primep-help (a test)
  (cond ((> test (/ a 2)) t)
        ((zerop (mod a test)) nil)
        (t (primep-help a (+ 2 test)))))

(defun primep (a)
  (cond ((< a 2) nil)
        ((or (= a 2) (= a 3)) t)
        ((zerop (mod a 2)) nil)
        (t (primep-help a 3))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; 6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun perfectp-help (number tested cache)
  (cond ((= tested 0) cache)
        ((dividesp number tested)
         (perfectp-help number (- tested 1) (+ cache tested)))
        (t (perfectp-help number (- tested 1) cache))))

(defun perfectp (number)
  (= (perfectp-help number 
                    (if (evenp number) (/ number 2) (/ (+ 1 number) 2))
                    0) 
     number))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;; 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pascal (a b)
  (cond ((= b 0) 1)
        ((= a b) 1)
        (t (+ (pascal (- a 1) (- b 1))
              (pascal (- a 1) b)))))
;a je ??adek, b je sloupec
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



