(defmacro defcfun (name lambda-list &body body)
  (let ((count (gensym "COUNT")))
    `(let ((, count 0))

       (defun ,name ,lambda-list
         (incf ,count)
         ,@body)

       (defun ,(cc-name name) ()
         ,count)

       (defun ,(reset-cc-name name) ()
         (setf ,count 0)))))

(defun cc-name (name)
  (intern (format nil "~a-CC" name)))

(defun reset-cc-name (name)
  (intern (format nil "~a-RESET-CC" name))) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro defmemfun (name (var) &body body)
  (let ((mem-sym (gensym "MEM"))
        (pair-sym (gensym "RES")))
    `(let ((,mem-sym '()))
       
       (defun ,name (,var)
         (let ((,pair-sym (find ,var ,mem-sym :key #'car)))
           (unless ,pair-sym
             (setf ,pair-sym (cons ,var (progn ,@body)))
             (setf ,mem-sym (cons ,pair-sym ,mem-sym)))
           (cdr ,pair-sym))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro myincf (elem &optional (times 1))
  `(setf ,elem (+ ,elem ,times)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro my-swap (a b)
  (let ((prvni (gensym))
    (druhy (gensym)))
    `(let ((,prvni ,a)
           (,druhy ,b))
       (progn (setf a ,druhy) (setf b ,prvni)))))

(defmacro swap-z-tabule (a b)
  (let ((tmp (gensym)))
    `(progn 
       (setf ,tmp ,a)
       (setf ,a ,b)
       (setf ,b ,tmp))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun make-point (x y)
  (lambda (what &optional val)
    (cond ((eql what 'car) x)
          ((eql what 'cdr) y)
          ((eql what 'set-x) (setf x val))
          ((eql what 'set-y) (setf y val)))))
   
(defun get-x-coord (a)
  (funcall a 'car))

(defun get-y-coord (a)
  (funcall a 'cdr))

(defun set-x (c val)
  (funcall c 'set-x val))

(defun set-y (c val)
  (funcall c 'set-y val))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun point-distance (A B)
  (sqrt (+ 
         (expt (- (get-x-coord A) (get-x-coord B)) 2) 
         (expt (- (get-y-coord A) (get-y-coord B)) 2))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun make-circle (A r)
  (lambda (what &optional val)
    (cond ((eql what 'center) A)
          ((eql what 'radius) r)
          ((eql what 'set-radius) (setf r val)))))

(defun get-center (circle)
  (funcall circle 'center))

(defun get-radius (circle)
  (funcall circle 'radius))

(defun set-radius (circle r)
  (funcall circle 'set-radius r))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun circle-area (circle)
  (* 2 pi (expt (get-radius circle) 2)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun move (A x+ y+)
  (make-point (+ (get-x-coord A) x+)
              (+ (get-y-coord A) y+)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun val (&optional (arg 0))
  (declare (special a))
  (if (= arg 0) a (setf a arg)))  

  