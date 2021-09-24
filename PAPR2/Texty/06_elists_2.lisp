(defun elist (&rest elements)
  (let ((result (list 'elist
                      (copy-list elements)
                      nil)))
    (setf (third result)
          (delay (list-average (elist-contents result))))
    result))

(defun elist-contents (elist)
  (second elist))

(defun (setf elist-contents) (val elist)
  (setf (second elist) val))

(defun elist-avg-promise (elist)
  (third elist))

(defun elist-average (elist)
  (force (elist-avg-promise elist)))

(defun elist-add-val (value elist cons)
  (invalidate (elist-avg-promise elist))
  (setf (elist-contents elist) 
        (add-val value (elist-contents elist) cons))
  value)

(defun elist-delete-cons (cons elist)
  (invalidate (elist-avg-promise elist))
  (setf (elist-contents elist)
        (delete-cons cons (elist-contents elist)))
  (car cons))