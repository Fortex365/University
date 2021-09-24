(defvar *bm-height* 250)
(defvar *bm-width* 250)

(defun bm-black-bitmap ()
  (make-array (list *bm-width* *bm-height*) 
              :initial-element nil))

(defun bm-bitmap-from-array (array)
  array)

(defun bm-bit (bm x y)
  (aref bm x y))

(defun bm-bits (bm)
  bm)

(defun (setf bm-bit) (value bm x y)
  (setf (aref bm x y) value))

(defun bm-not (bm)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (not (bm-bit bm x y)))))
    result))

(defun bm-and-2 (bm1 bm2)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (and (bm-bit bm1 x y) (bm-bit bm2 x y)))))
    result))

(defun bm-or-2 (bm1 bm2)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (or (bm-bit bm1 x y) (bm-bit bm2 x y)))))
    result))

#|
(defun foldr (fun list init)
  (if (null list)
      init
    (funcall fun (car list) (foldr fun (cdr list) init))))
|#


(defun bm-and (bm1 &rest bitmaps)
  (reduce #'bm-and-2 bitmaps :initial-value bm1))

(defun bm-or (bm1 &rest bitmaps)
  (reduce #'bm-or-2 bitmaps :initial-value bm1))

(defun bm-shift (bm dx dy)
  (let ((result (bm-black-bitmap)))
    (dotimes (y *bm-height*)
      (dotimes (x *bm-width*)
        (setf (bm-bit result x y)
              (if (and (< -1 (- x dx) *bm-width*)
                       (< -1 (- y dy) *bm-height*))
                  (bm-bit bm (- x dx) (- y dy))
                nil))))
    result))


(defun bm-diff (bm1 bm2)
  (bm-and bm1 (bm-not bm2)))

(defun bm-top-edge (bm)
  (bm-diff bm (bm-shift bm 0 5)))

(defun bm-edges (bm)
  (bm-or (bm-diff bm (bm-shift bm 0 5))
         (bm-diff bm (bm-shift bm 0 -5))
         (bm-diff bm (bm-shift bm 5 0))
         (bm-diff bm (bm-shift bm -5 0))))

#|

;; Testy
;; Načtěte soubor bitmap-viewer.lisp

(setf v (display-bitmap-viewer))

;; Načíst obrázek do okna (tlačítkem Open...)

(setf jj (bm-bitmap-from-array (bitmap-viewer-bitmap v)))
(setf shift (bm-shift jj 0 -10))
(set-bitmap-viewer-bitmap v (bm-bits shift))
(setf shift (bm-shift jj 0 10))
(setf shift (bm-shift jj 10 0))
(setf shift (bm-shift jj -10 0))
(setf edge (bm-top-edge jj))
(set-bitmap-viewer-bitmap v (bm-bits edge))
(setf edges (bm-edges jj))
(set-bitmap-viewer-bitmap v edges)

|#

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