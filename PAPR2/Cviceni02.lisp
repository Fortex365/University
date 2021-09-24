(defun my-plus (&rest rest)
  (foldr #'my-plus2 0 rest))

(defun my-plus2 (a b)
  (+ a b))

(defun foldr (fun init list)
  (if (null list)
       init
       (funcall fun (car list) (foldr fun init (cdr list)))))