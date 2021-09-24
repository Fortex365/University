(defun member-t (x list test)
  (cond ((null list) nil)
        ((funcall test x (car list)) "Prvek se nachází.")
        (t (member-t x (cdr list) test))))

(defun my-mapcar (fun list)
  (if (null list)
      '()
    (cons (funcall fun (car list))
          (my-mapcar fun (cdr list)))))
