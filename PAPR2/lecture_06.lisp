;(1)Přidejte do struktury zapouzdřeného seznamu složky elist-min a elist-max
;(elist zapouzdřený-seznam avg-value min-value max-value)
;Nové zapouzdřené seznamy vypadají tedy takto
(defun elist (&rest elements)
  (list 'elist
        (copy-list elements) 
        nil ;avg-value
        nil ;min-value
        nil)) ;max-value

(defun elist-contents (elist)
  (second elist))


(defun elist-avarage (elist)
  (unless (third elist)
    (setf (third elist) (list-avarage (elist-contents elist))))
  (third elist))

(defun list-average (list)
  (/ (apply #'+ list) 
     (if (null list) 1 (length list))))


(defun elist-min (elist)
  (unless (fourth elist)
    (setf (fourth elist) (list-min (elist-contents elist))))
  (fourth elist))

(defun elist-max (elist)
  (unless (fifth elist)
    (setf (fifth elist) (list-max (elist-contents elist)))
    (fifth elist)))


(defun list-max (list)
  (apply #'max list))

(defun list-min (list)
  (apply #'min list))


(defun elist-add-val (value elist cons)
  (setf (third elist) nil)
  (setf (fourth elist) nil)
  (setf (fifth elist) nil)
  (setf (second elist)
        (add-val value (elist-contents elist)))
  value)

(defun add-val (val list)
  (push val list)
  list)

(defun elist-delete-cons (cons elist)
  (setf (third elist) nil)
  (setf (fourth elist) nil)
  (setf (fifth elist) nil)
  (setf (second elist)
        (delete-cons cons (elist-contents elist)))
  elist)

(defun delete-cons (cons list)
  (remove cons list))


;(2)Udělejte totéž ale za pomocí příslibů.
;(promise validp val fun)
;(elist zapouzdřený-seznam (promise validp val-avg fun) (promise validp val-min fun) (promise validp val-max fun))

(defun make-promise (fun)
  (list 'promise nil nil fun))

(defmacro delay (expr)
  `(make-promise (lambda () ,expr)))

(defun validp (promise)
  (second promise))

(defun force (promise)
  (unless (validp promise)
    (setf (third promise) (funcall (fourth promise))
          (second promise) t)
    (third promise)))

(defun invalidate (promise)
  (setf (second promise) nil))

;Nové zapouzdřené seznamy s přísliby jsou tedy takto
(defun elist (&rest elements)
  (let ((result (list 'elist (copy-list elements) nil nil nil)))
    (setf (third result)
          (delay (list-avarage (elist-contents result))))
    (setf (fourth result)
          (delay (list-min (elist-contents result))))
    (setf (fifth result)
          (delay (list-max (elist-contents result))))
    result))

(defun elist-contents (elist)
  (second elist))

(defun (setf elist-contents) (val elist)
  (setf (second elist) val))

(defun elist-avg-promise (elist)
  (third elist))

(defun elist-min-promise (elist)
  (fourth elist))

(defun elist-max-promise (elist)
  (fifth elist))

(defun elist-avarage (elist)
  (force (elist-avg-promise elist)))

(defun elist-minimum (elist)
  (force (elist-min-promise elist)))

(defun elist-maximum (elist)
  (force (elist-max-promise elist)))

(defun elist-add-val (value elist cons)
  (invalidate (elist-avg-promise elist))
  (invalidate (elist-min-promise elist))
  (invalidate (elist-max-promise elist))
  (setf (elist-contents elist)
        (add-val value (elist-contents elist) cons))
  value)

(defun elist-delete-cons (cons elist)
  (invalidate (elist-avg-promise elist))
  (invalidate (elist-min-promise elist))
  (invalidate (elist-max-promise elist))
  (setf (elist-contents elist)
        (delete-cons cons (elist-contents elist)))
  (car cons))

(defun list-min (list)
  (apply #'min list))

(defun list-max (list)
  (apply #'max list))

;(3)Nešlo by konstuktor elist na konci druhé části 2 zjednodušit takto?
(defun elist (&rest elements)
  (let ((result (list 'elist
                      (copy-list elements)
                      (delay (elist-avarage result)))))
    result))

;Nešlo, snažili bychom se vytvořit proměnou result ve tvaru (elist zapouzdřený-seznam val-avg), kdy val-avg
;by měl být příslib výpočtu průměrné hodnoty, která sama ale používá nevypočítaný result. 

;(4) Přidejte do struktury elist mutátor vlastní volby udělejte to pro obě varianty (z části 1 a 2). Měl by ovlivnit min, max a avg ze seznamu.
(defun elist-contents-mut1 (elist &rest elements)
  (setf (second elist) (copy-list elements))
  (setf (third elist) nil 
        (fourth elist) nil
        (fifth elist) nil))

(defun elist-contents-mut2 (elist &rest elements)
  (setf (second elist) (copy-list elements))
  (setf (third elist) (invalidate (third elist))
        (fourth elist) (invalidate (fourth elist))
        (fifth elist) (invalidate (fifth elist))))
        
;(5)Napište výraz, který vrátí nekonečný proud v němž se budou střídat čísla 0 a 1
(defmacro stream-cons (a b)
  `(cons ,a (delay ,b)))

(defun stream-car (s)
  (car s))

(defun stream-cdr (s)
  (force (cdr s)))

(shadow '(stream))

(defmacro stream (&rest expr)
  (if (null expr)
      '()
    `(stream-cons ,(car expr) (stream ,@(cdr expr)))))

;Tedy takto
(defun zero-one ()
  (stream-cons 0 (stream-cons 1 (zero-one))))

;(6)Napište funkci stream-ref, která k zadanému proudu a indexu vrací příslušný prvek proudu
(defun stream-ref (stream index)
  (if (eql index 0)
      (stream-car stream)
    (stream-ref (stream-cdr stream) (- index 1))))

;(7) Napište funkci stream-each-nth, která k zadanému proudu vrátí proud obsahující každý ntý prvek
(defun stream-end-p (stream)
  (eql (stream-cdr stream) nil))

(defun stream-each-nth (s nth)
  (unless (stream-end-p s)
    (stream (stream-car s)
            (stream-each-nth (stream-cdr-rest s nth) nth))))

(defun stream-cdr-rest (s nth)
  (if (eql nth 1)
      (stream-cdr s)
    (stream-cdr-rest (stream-cdr s) (1- nth))))

;(8) Napište funkci stream-heads která vrací proud jakožto součet prvního prvku a druhého prvku původního proudu, další druhého a třetího prvku atd.
(defun stream-heads (s)
  (unless (stream-end-p s)
    (stream (+ (stream-car s) (car (stream-cdr s))) 
            (+ (stream-car (cdr s)) (car (stream-cdr (cdr s)))))))

(defun sieve (stream) 
  (let ((car (stream-car stream)) 
        (cdr (stream-cdr stream)))
    (cons-stream car 
                 (sieve (stream-remove-if (lambda (n) 
                                                (dividesp car n))
                                              cdr)))))

(defun eratosthenes () 
  (sieve (naturals 2)))

(defun primedoubles (era-stream)
  (let ((car (stream-car era-stream))
        (cdr (stream-car (stream-cdr era-stream))))
    (if (= (- cdr car) 2)
        (stream (cons car cdr) (primedoubles (stream-cdr era-stream)))
      (primedoubles (stream-cdr era-stream)))))