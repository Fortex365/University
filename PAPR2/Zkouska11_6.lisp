;(1)Napište makro my-defun, které se chová podobně jako defun, které navíc do globálního prostředí na symbol nastaví poslední vypočítanou hodnotu
(defmacro my-def (name params &body body)
  `(defun ,name ,params (setf ,name ,@body)))


;(2)V této definici prog1, zabírá něco symbol, pokud jo, uveďte příklad, pokud ne odůvodněte
(defmacro my-prog1 (arg &body args)
  `(let ((result ,arg)
         (bresult (progn ,@args)))
     result))

(let ((result '(5 10)))
               (my-prog1 (cdr result) (print result)))

;Přepsaná expanze
(let ((result '(5 10)))
  (let ((result (cdr result))
        (bresult (progn (print result)))) ;result se bude hledat v předchozím '(5 10), nikdy né letu, které ještě nevytvořilo nové vazby
    result)) ;(10)

;> (5 10)
;> (10)
;Nezabírá symbol.


;(3) Vytvořte datovou stukturu bod se selektory, konstruktor, mutátory, reprezentujte ji pomoci uzávěrů
(defun make-point (x y)
  (lambda (what &optional val)
    (cond ((eql what 'x) x)
          ((eql what 'y) y)
          ((eql what 'set-x) (setf x val))
          ((eql what 'set-y) (setf y val)))))

(defun x (point)
  (funcall point 'x))

(defun y (point)
  (funcall point 'y))

(defun set-x (point val)
  (funcall point 'set-x val))

(defun set-y (point val)
  (funcall point 'set-y val))

;(4) Nakreslete krabičkévé znázornění tohoto výrazu
(let ((result (list 1 2 3 4 5)))
      (setf (car result) (setf (cdr result) result)))

;Po vyhodnocení (setf (cdr result) result) vznikne vlastne z 1->2->3->4->5->nil výraz *1->* (jednička odkazujícím svým cdr sama na sebe)
;Po vyhodnocení výrazu (setf (car result) na *1->* vznikne přihrádka [car, cdr] jejíž cdr odkazuje samo na sebe, jejíž car odkazuje sám na sebe

;(5) Vytvořte proud, kde se střídají jedničky a nuly
(defun stream-zero-one ()
  (stream-cons 0 (stream-cons 1 (stream-zero-one))))

;(6) Definujte v našel intepretu slovo :pow (execute '(2 3 :pow)) => 8

;(define-word :pow '(:noexec (%proc :noexec expt :bind
;                                   :noexec num :bind
;                                   expt 0 := :if :drop 1 :* :then
;                                   :drop num :dup expt 1 :- pow :* :else
;                                   :unbind
;                                   :unbind)
;                    :noexec pow :bind))
