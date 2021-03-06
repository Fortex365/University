(defmacro my-when (condition &body expressions)
  `(if ,condition (progn ,@expressions) nil))
;Napište makro awhen, které je obdobou makra when, ale v jeho těle je proměnná it navázána na hodnotu podmínky:
;> (awhen (cdr '(a b))
;          (print it)
;          nil)

;(B)
;NIL
(defmacro awhen (condition &body expressions)    
    `(let ((it ,condition))
       (if it (progn ,@expressions) nil)))


(defmacro awhen-2 (condition &body expressions)
  `(let ((it ,condition))
     (when it ,@expressions)))
    
;Odhadněte a pak vyzkoušejte, na co expandují následující výrazy:
;(my-and)
;(my-and a)
;(my-and a b)
;(my-and a b c)

(defmacro my-and (&body forms)
  (if forms 
      `(when ,(car forms) (my-and ,@(cdr forms)))
    t))

;První expanduje na t
;Druhy expanduje na (when a (my-and))
;Třetí expanduje na (when a (my-and b))
;Čtvrtý expanduje na (when a (my-and b c))

;Vylepšete makro my-and tak, aby místo t vracelo hodnotu posledního výrazu.
;Pro výraz (my-and) by mělo stále vracet t. (Lze to udělat velmi jednoduše
;pomocí &optional-parametru.

;Napište makro my-or pro libovolný počet argumentů.
(defmacro my-or (&body forms)
  (if forms
      `(if ,(car forms) t (my-or ,@(cdr forms)))
    nil))

;Vysvětlete poslední uvedenou verzi makra whenv.
(defmacro whenv (condition &body body)
  `(whenv-help ,condition (lambda () ,@body)))

(defun whenv-help (condval bodyfun)
  (when condval 
    (funcall bodyfun)
    condval))

; Přepište podobným způsobem makro test-number.
(defmacro testnumber (number minus zero plus)
  (let ((value (gensym)))
    `(let ((,value ,number))
       (cond ((< ,value 0) ,minus)
             ((= ,value 0) ,zero)
             ((> ,value 0) ,plus)))))

(defmacro test-number (number minus zero plus)
  `(test-number-help ,number 
                     (lambda () ,minus)
                     (lambda () ,zero)
                     (lambda () ,plus)))

(defun test-number-help (numberval minusval zeroval plusval)
  (cond ((= numberval 0) (funcall zeroval))
        ((> numberval 0) (funcall plusval))
        ((< numberval 0) (funcall minusval))))
;Rozhodněte,zda v následující implementaci makra prog1 dochází k problému zabrání symbolu.
;Pokud ano, uveďte příklad, pokud ne, zdůvodněte
(defmacro myprog (form &body forms)
  `(let ((result ,form)
         (fun (lambda () ,@forms)))
         result))

(let ((result '(5 10)))
               (myprog (cdr result) (print result)))

(let ((result '(5 10)))
  (let ((result (cdr result)) ;(10)
        (fun (lambda () (print result)))) ;Closure which print (5 10)
    result))

;Zabrání symbolu result, fun
;(let ((result 1)) (myprog 2 3))

;Rozhodněte,zda v následující implementaci makra prog1 dochází k problému zabrání symbolu. 
;Pokud ano, uveďte příklad, pokud ne, zdůvodněte.
(defmacro myprog1 (form &body forms)
  `(let ((result ,form)
     (bresult (progn ,@forms)))
  result))

;Nezabírá v result je (10) v bresult je (5 10)

; Operátor test by měl vytisknout svůj nevyhodnocený argument i jeho hodnotu a tuto hodnotu vrátit i jako výsledek.
(defmacro test (arg)
  (let ((result (gensym)))
      (princ "Vyhodnocovany vyraz: ") (princ arg) (terpri)
      `(let ((,result ,arg))
         (progn 
           (princ "Hodnota vyrazu: ") (princ ,result) (terpri)
           ,result))))
        
(defmacro test2 (&whole whole arg)
  (format t "~%Vyhodnocovaný výraz: ~s " whole)
  (let ((result (gensym "VYSLEDEK")))
    `(let ((,result ,arg))
       (progn
         (terpri)
         (princ "Hodnota výrazu: ")
         (princ ,result)
         (terpri)
         ,result))))
;Pokud je to možné, deﬁnujte operátor jako funkci. Pokud to možné není, zdůvodněte to a deﬁnujte jej jako makro. 
;Nepůjde (test (+ 1 2)) by vyhodnotil argument na 3 a to by byl parametr funkce. Tudíž bychom nikdy nezískali (+ 1 2) pro tisk.




;Jak víme, makro dolist prochází prvky seznamu. 
;Napište makro doatoms, které podobně prochází všechny atomy ve struktuře tečkových párů.




;Napište makro all-cond, které pracuje podobně jako makro cond, ale vyhodnotí všechny větve, jejichž podmínka je splněna.

(defmacro all-cond (&body body)
  (let ((arg (gensym)))
    `(let ((,arg (car ,body)))
       (progn (if (first ,arg) 
                  (second ,arg)
                noů)
         (all-cond (cdr ,@body))))))

;((< 1 2) (print 1))
;((> 1 2) (print 2))
;((= 1 1) (print 3))
;((= 1 2) (print 4))

;Při vstupu (all-cond arg)
;Bude náš argument zabalen v seznamu takto (arg1 arg2 ... argn)
;Když si vezmeme arg1 dostaneme ((< 1 2) (print 1))
;Stačí vzít z toho seznamu car a otestovat ho jako podmínku či (< 1 2) a pokud ano, tak vyhodnotíme (print 1)



;Napište makro alias sloužící k deﬁnici nového jména zadaného operátoru (např. kvůli zkrácení dlouhého názvu).
;Například po vyhodnocení výrazu

(defmacro my-alias (new-name prev-name)
  `(defmacro ,new-name (&rest args)
     `(,',prev-name ,@args)))




    