;(1)
(defmacro setf-2 (expr1 expr2 arg)
  (let ((eval-val (gensym)))
    `(let ((,eval-val ,arg))
       (setf ,expr1 ,eval-val)
       (setf ,expr2 ,eval-val))))

;(2)
(let ((result (list 1 2 3)))
  (setf (car result) (cddr result))
  result)

;Na místo (car result) => 1
;Nastav (cddr result) => (3)
;Návratová hodnota => ((3) 2 3)

;(3)
(let ((x 'y))
  (let ((x 'z))
     (lambda () x)))

;V klasickém Scheme si anonymní funkce lambda najde vazbu v předkovi (let ((x 'z))) a hodnotou vazby symbolu x bude 'z
;Ve Scheme s dynamickými vazbami by skončil chybou, protože chybí nad výrazem (defvar x 0), pokud by však tam bylo učiněno, tak oba dva lety zastiňují vazbu původní x = 0, a lambda by našla hodnotu symbolu také x = z

;(4)
(defun lpm-lighten (lbm factor)
  (lambda (x y)
    (cond (((minusp factor) "Záporný factor"))
          ((> (+ (lpm-bit lbm x y) factor) 1) 1)
          ((<= (+ (lbm-bit lbm x y) factor) 1) (+ (lbm-bit lbm x y) factor)))))

;(5)
(defun zero-ones-stream ()
  (stream-cons 0 (stream-cons 1 (zero-ones-stream))))

;(6) Jaká bude normální forma výrazu Y(lambda (x) y), neboli Y(f)

;Z toho nám vznikne (lambda (x) y) Y(lambda (x) y), neboli f Y(f)
;Za parametr prvního výrazu x se dosazuje "Y(f)", a vyhodnocuje se tělo této lambdy "y"
;Jelikož "nové x" nebylo použito, výsledkem je opět "y", což je hledaná normální forma

;Jenom přepis Y-kombinátoru
(lambda (f)
  (funcall (lambda (x)
             (funcall f (funcall x x)))
           (lambda (x)
             (funcall f (funcall x x)))))

;Jinak Lf.(Lx.(f (x x)) Lx.(f (x x)), tedy jinačí zápis


 




     
