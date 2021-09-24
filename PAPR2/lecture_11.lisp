#|

ÚLOHY
-----

1. Definujte slovo :hyp na výpočet délky přepony pravoúhlého 
   trojúhelníka z délek odvěsen:
   (a b -- c)

2. Definujte slovo :discr na výpočet diskriminantu kvadratické rovnice:
   (a b c -- diskriminant)

3. Definujte jako slova logické operace: :not, :and, :or.

4. Definujte slovo :+n na součet n čísel. n je na vrcholu zásobníku,
   čísla pod ním:
   (a1 ... an n -- a1 + ... + an)
|#

#|
(define-word :sqrt (lambda ()
                     (push (sqrt (pop *rslt*)) *rslt*)))

(define-word :power2 (lambda ()
                       (push (power (pop *rslt*) 2) *rlst*)))

popřípadě jednoduše (define-word :power2 '(:dup :*))


(define-word :hyp '(:power2 :swap :power2 :+ :sqrt))

(define-word :discrb2 '(:drop :power2 :swap :drop))                ;'(:swap :power2 :swap)

(define-word :discr4ac '(:swap :drop 4 :* :*))                          ;'(4 :* :swap :drop :*)

(define-word :discr '(:discrb2 :discr4ac :- :sqrt))


(define-word :not (lambda ()
                    (push (not (pop *exec*)) *rslt*)))

(define-word :and (lambda ()
                    (push (and (pop *exec*)
                               (pop *exec*))
                          *rslt*)))

(define-word :or (lambda ()
                   (push (or (pop *exec*)
                             (pop *exec*))
                             *rslt*)))

(define-word :+n '(:dup 0 := :if :drop 0 :then :drop :dup 1 :- :+n :+ :else))

(execute '(5 :+n))
|#


#|
5. Definujte slovo :findif

(define-word :listcar (lambda ()
                         (push (car (pop *rslt*)) *rslt*)))

(define-word :listcdr (lambda ()
                        (push (cdr (pop *rslt*)) *rslt*)))

(define-word :null? (lambda ()
                      (push (null (pop *rslt*)) *rslt*)))

(define-word :nil (lambda ()
                    (push nil *rslt*)))

(define-word :find '(:noexec (%proc :noexec list :bind :noexec predicate :bind
                                      list :null? :if :nil :then 
                                      predicate list :listcar := :if list :listcar :then 
                                      predicate list :listcdr :findif :else 
                                      :else
                                      :unbind 
                                      :unbind)
                       :noexec find :bind))
|#


#|
(define-word :avgn '(:dup :+n :swap :/))

(define-word :/ (lambda ()
                  (let ((jmenovatel (pop *rslt*))
                        (citatel (pop *rlst)))
                    (push (/ citatel jmenovatel) *rslt*))))

|#