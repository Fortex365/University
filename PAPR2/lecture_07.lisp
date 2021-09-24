;(1)
(setf fn-list (list nil nil nil))
(dotimes (x 3)
    (setf (nth x fn-list) (lambda () x)))
(mapcar #'funcall fn-list)
;V každé iteraci (maker dotimes, dolist) se nevytváří nové prostředí kde se zvyšuje řídící proměnná

;(2)
;Když neplatí zároveň, že v obou bitmapách je zároveň 0 a zároveň 1
;Jednoduše pixel v obou bitmapách nesmí mít stejnou barvu
(defun bm-xor (bm1 bm2)
  (bm-not (bm-and (bm-not (bm-and bm1 bm2))
            (bm-and (bm-not bm1) (bm-not bm2)))))

(defun bm-xor-dotimes (bm1 bm2)
  (let (result ((bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-weight*)
        (setf (bm-bit result x y)
              (not (and (not (and (bm-bit bm1 x y) (bm-bit bm2 x y)))
                        (and (not (bm-bit bm1 x y)) (not (bm-bit bm2 x y))))))))
    result))

(defun lbm-xor (bm1 bm2)
  (lbm-not (lbm-and (lbm-not (lbm-and bm1 bm2))
            (lbm-and (lbm-not bm1) (lbm-not bm2)))))

;(3)
(defun bm-top-edge-ndestructive (bm)
  (bm-diff (bm-copy bm) (bm-shift (bm-copy bm) 0 5)))
;Funkce se stane nedestruktivní protože nebude modifikovat svojí vstupní bitmapu. Zato bude modifikovat návratové bitmapy z bm-copy, které budou před modifikací totožné s bitmapou vstupní.

;(4)
(defun bm-edges-ndestructive (bm)
  (bm-or (bm-top-edge-ndestructive bm)
         (bm-diff (bm-copy bm) (bm-shift (bm-copy bm) 0 -5)) 
         (bm-diff (bm-copy bm) (bm-shift (bm-copy bm) 5 0)) 
         (bm-diff (bm-copy bm) (bm-shift (bm-copy bm) -5 0))))


;(7)
(defun bm-rectangle (tl-x tl-y br-x br-y)
  (let ((result (bm-black-bitmap)))
    (dotimes (tl-x br-x)
      (dotimes (tl-y br-y)
        (setf (bm-bit result tl-y tl-y) t)))
  result))

;tl-x = topleft x, tl-y = topright y
;br-x = bottomright x, br-y bottomright y

;Jestli todle teda je "implementace jako průnik polorovin"

(defun lbm-rectangle (tl-x tl-y br-x br-y)
  (lambda (x y)
    (let ((result (lbm-black-bitmap)))
      (dotimes (tl-x br-x)
        (dotimes (tl-y br-y)
          (setf (lbm-bit result tl-x tl-y) t)))
      result)))