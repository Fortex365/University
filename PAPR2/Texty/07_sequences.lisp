(defun mem (seq index) 
  (funcall seq index))

(defmacro seq (ind expr)
  `(lambda (,ind) ,expr))

(defun seq-+ (seq1 seq2)
  (seq n (+ (mem seq1 n) (mem seq2 n))))

(defun seq-map (fun seq)
  (seq n (funcall fun (mem seq n))))

#|
(seq-map #'sqrt (seq-+ (seq-map (lambda (x) (expt x 2)) a)
                       (seq-map (lambda (x) (expt x 2)) b)))

(seq n (sqrt (+ (expt (mem a n) 2)
                (expt (mem b n) 2))))
|#

(defun seq-members (seq count)
  (let ((result (make-array count)))
    (dotimes (i count)
      (setf (aref result i) (mem seq i)))
    result))