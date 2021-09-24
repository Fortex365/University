(defun printing-fact (n)
  (if (= n 0)
      1
    (progn (princ "printing-fact aplikovan na ")
      (princ n)
      (terpri)
      (* n (printing-fact (- n 1)))
      (princ "printing-fact vratil hodnotu ")
      (terpri))))
;je potreba vracet mezivysledky z rekurzivni aplikace za printingfact vratil hodnotu pote odsadit raddek

(defun printing-fact1 (n)
  (if (= n 0)
      1
    (progn (princ "printing-fact aplikovan na ")
      (princ n)
      (terpri)
      (let (result n)
        (princ "printing-fact vratil hodnotu ")
        (* n (printing-fact1 (- n 1)))
        (terpri) result))))