(defun test1 (a)
  (setf a 2))

(defun test2 (a) 
  (test1 a)
  a)
;Co bude hodnotou výrazu (test2 1)? 

;Výsledek bude pouze vrácená hodnota z test2 tedy jednička, protože
;v těle funkce test1 makro setf nepoužívá místo, navíc test1 je FUNKCE, KTERÁ PŘI APLIKACI VYTVÁŘÍ NOVÉ PROSTŘEDÍ.
;Takže jakákoliv hodnota se kterou je funkce volána, bude navázána na jej parametr, setf neudělá nic jiného, než že ho ZMĚNÍ, V TOM PROSTŘEDÍ, NIKOLIV V GLOBÁLNÍM.

(defun test3 (a)
  (setf (car a) 2))

(defun test4 (a)
  (test3 a)
  a)

;Co bude hodnotou výrazu (test4 (list 1))?
;V těle funkce test4 se volá funkce test3, kde pro použití makra setf se používá místo (car a)
;které následně upraví tuto hodnotu na 2 a funkce test4 tento výsledek ještě vrátí.
;Vlastně sáhneme do caru z daného seznamu a změníme jeho hodnotu na pevně danou dvojku. Výsledek (2)


;Přidání na konec seznamu je symbol nil na pozici třetího argumentu funkce add-val
(defun add-val (item list place)
  (if (eql place nil)
      (setf list (append list (list item)))
    (let ((list-minus-place (remov place list)))
      (setf list (append (append list-minus-place (list item))
                         place)))))

(defun remov (which-list from-list)
  (cond ((null which-list) from-list)
        ((car which-list) (progn (remove (car which-list) from-list) 
                            (remov (cdr which-list) from-list)))))

(defun delete-cons (item list)
  (setf list (remove item list)))

(defun (setf delete-cons) (list-now list)
  (setf list list-now))


 


