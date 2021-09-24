(defvar *lbm-width* 250)
(defvar *lbm-height* 250)

(defun lbm-black-bitmap ()
  (lambda (x y)
    (declare (ignore x y))
    nil))

(defun lbm-bitmap-from-array (arr)
  (lambda (x y)
    (aref arr x y)))

(defun lbm-bit (lbm x y)
  (funcall lbm x y))

(defun lbm-bits (lbm)
  (let ((result (make-array (list *lbm-width* *lbm-height*))))
    (dotimes (y *lbm-width*)
      (dotimes (x *lbm-height*)
        (setf (aref result x y)
              (lbm-bit lbm x y))))
    result))

(defun lbm-not (lbm)
  (lambda (x y)
    (not (lbm-bit lbm x y))))

(defun lbm-and-2 (lbm1 lbm2)
  (lambda (x y)
    (and (lbm-bit lbm1 x y)
         (lbm-bit lbm2 x y))))

(defun lbm-or-2 (lbm1 lbm2)
  (lambda (x y)
    (or (lbm-bit lbm1 x y)
        (lbm-bit lbm2 x y))))

(defun lbm-and (lbm1 &rest bitmaps)
  (reduce #'lbm-and-2 bitmaps :initial-value lbm1))

(defun lbm-or (lbm1 &rest bitmaps)
  (reduce #'lbm-or-2 bitmaps :initial-value lbm1))

(defun lbm-shift (lbm dx dy)
  (lambda (x y)
    (let ((old-x (- x dx))
          (old-y (- y dy)))
      (if (and (< -1 old-x *lbm-width*)
               (< -1 old-y *lbm-height*))
          (lbm-bit lbm old-x old-y)
        nil))))

(defun lbm-diff (lbm1 lbm2)
  (lbm-and lbm1 (lbm-not lbm2)))

(defun lbm-top-edge (lbm)
  (lbm-diff lbm (lbm-shift lbm 0 5)))

(defun lbm-edges (lbm)
  (lbm-or (lbm-diff lbm (lbm-shift lbm 0 5))
          (lbm-diff lbm (lbm-shift lbm 0 -5))
          (lbm-diff lbm (lbm-shift lbm 5 0))
          (lbm-diff lbm (lbm-shift lbm -5 0))))

#|
(setf v (display-bitmap-viewer))

;; Otevřít v prohlížeči obrázek
(setf ljj (lbm-bitmap-from-array (bitmap-viewer-bitmap v)))
(setf edges (lbm-edges ljj))
(set-bitmap-viewer-bitmap v (lbm-bits edges))

|#

(defun bm-edges-test (bm)
  (bm-bits (bm-edges bm)) 
  nil)

(defun lbm-edges-test (lbm)
  (lbm-bits (lbm-edges lbm)) 
  nil)

#|

;; Porovnání:

(time (bm-edges-test jj))

(time (lbm-edges-test ljj))

|#