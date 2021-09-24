;(elist zapouždený-seznam avg-value)
(defun elist (&rest elements)
  (list 'elist
        (copy-list elements)
        nil))

(defun elist-contents (elist)
  (second elist))

(defun list-average (list)
  (/ (apply #'+ list) 
     (if (null list) 1 (length list))))

(defun elist-average (elist)
  (unless (third elist)
    (setf (third elist) (list-average (elist-contents elist))))
  (third elist))

(defun elist-add-val (value elist cons)
  (setf (third elist) nil)
  (setf (second elist) 
        (add-val (value (elist-contents elist)) cons))
  value)

(defun elist-delete-cons (cons elist)
  (setf (third elist) nil)
  (setf (second elist)
        (delete-cons cons (elist-contents elist)))
  elist)

;Přidejte do struktury zapouzdřeného seznamu složky elist-min a elist-max
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
  elist)

(defun elist-delete-cons (cons elist)
  (setf (third elist) nil)
  (setf (fourth elist) nil)
  (setf (fifth elist) nil)
  (setf (second elist)
        (delete-cons cons (elist-contents elist)))
  elist)

;Udělejte totéž ale za pomocí příslibů.
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
  






