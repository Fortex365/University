;;; kod z prednasky

;; class POINT

(defclass point ()
  ((x :initform 0)
   (y :initform 0)))

(defmethod r ((point point))
  (let ((x (slot-value point 'x))
        (y (slot-value point 'y)))
    (sqrt (+ (* x x) (* y y)))))

(defmethod phi ((point point))
  (let ((x (slot-value point 'x))
        (y (slot-value point 'y)))
    (cond ((> x 0) (atan (/ y x)))
          ((< x 0) (+ pi (atan (/ y x))))
          (t (* (signum y) (/ pi 2))))))

(defmethod set-r-phi ((point point) r phi)
  (setf (slot-value point 'x) (* r (cos phi))
        (slot-value point 'y) (* r (sin phi)))
  point)

(defmethod set-r ((point point) r)
  (set-r-phi point r (phi point)))

(defmethod set-phi ((point point) phi)
  (set-r-phi point (r point) phi))


;; class CIRCLE

(defclass circle ()
  ((center :initform (make-instance 'point))
   (radius :initform 1)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRVNI CVICENI OBJEKTOVE ORIENTOVANEHO PROGRAMOVANI V LISPU
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;class triangle

(defclass triangle ()
  ((vortexA :initform (make-instance 'point))
   (vortexB :initform (make-instance 'point))
   (vortexC :initform (make-instance 'point))
   (lineAB :initform 0)
   (lineBC :initform 0)
   (lineCA :initform 0)
   (base-center :initform (make-instance 'point))))

(defmethod set-vertex-A ((tr triangle) pt)
  (setf (slot-value tr 'vortexA) pt))

(defmethod set-vertex-B ((tr triangle) pt)
  (setf (slot-value tr 'vortexB) pt))

(defmethod set-vertex-C ((tr triangle) pt)
  (setf (slot-value tr 'vortexC) pt))



;Usecka
(defun line (pt pt2)
  (point-distance pt pt2))

;Spocita vsechny delky usecek daneho trojuhelniku a nastavi jejich hodnoty v objektu trojuhelnik
(defmethod line-count ((tr triangle))
  (setf (slot-value tr 'lineAB) (line (slot-value tr 'vortexA) (slot-value tr 'vortexB)))
  (setf (slot-value tr 'lineBC) (line (slot-value tr 'vortexB) (slot-value tr 'vortexC)))
  (setf (slot-value tr 'lineCA) (line (slot-value tr 'vortexC) (slot-value tr 'vortexA))))

(defun s-count (a b c)
  (/ (+ a b c) 2))

;Obsah trojuhelnika pomoci heronova vzorce
(defmethod triangle-area ((tr triangle))
  (let ((s (s-count (slot-value tr 'lineAB) (slot-value tr 'lineBC) (slot-value tr 'lineCA))))
        (sqrt
         (*
          (- s (slot-value tr 'lineAB)) (- s (slot-value tr 'lineBC)) (- s (slot-value tr 'lineCA)) s))))

(defmethod vertices ((tr triangle))
  (list (point-to-list (slot-value tr 'vortexA))
        (point-to-list (slot-value tr 'vortexB))
        (point-to-list (slot-value tr 'vortexC))))
¨
;Vypocita stredovy bod zakladny, tedy mezi vrcholovymi body A a B
(defmethod base-center ((tr triangle))
  (set-point-x (slot-value tr 'base-center)
               (/ (+ (get-point-x (slot-value tr 'vortexA)) (get-point-x (slot-value tr 'vortexB))) 2))
  (set-point-y (slot-value tr 'base-center)
               (/ (+ (get-point-y (slot-value tr 'vortexA)) (get-point-y (slot-value tr 'vortexB))) 2)))

(defmethod get-base ((tr triangle))
  (point-to-list (slot-value tr 'base-center)))

(defmethod move-triangle-y-axis ((tr triangle) dy)
  (set-point-y (slot-value tr 'vortexA) (+ (get-point-y (slot-value tr 'vortexA)) dy))
  (set-point-y (slot-value tr 'vortexB) (+ (get-point-y (slot-value tr 'vortexB)) dy))
  (set-point-y (slot-value tr 'vortexC) (+ (get-point-y (slot-value tr 'vortexC)) dy))
  nil)

(defmethod move-triangle-x-axis ((tr triangle) dx)
  (set-point-x (slot-value tr 'vortexA) (+ (get-point-x (slot-value tr 'vortexA)) dx))
  (set-point-x (slot-value tr 'vortexB) (+ (get-point-x (slot-value tr 'vortexB)) dx))
  (set-point-x (slot-value tr 'vortexC) (+ (get-point-x (slot-value tr 'vortexC)) dx))
  nil)

(defmethod move-triangle ((tr triangle) dx dy)
  (move-triangle-x-axis tr dx)
  (move-triangle-y-axis tr dy))

  

;Posune bod o +dx +dy
(defmethod move-point ((pt point) newx newy)
  (setf (slot-value pt 'x) (+ (slot-value pt 'x) newx))
  (setf (slot-value pt 'y) (+ (slot-value pt 'y) newy)))

;Nastavi bod na nove zadane parametry
(defmethod set-point ((pt point) newx newy)
  (setf (slot-value pt 'x) newx)
  (setf (slot-value pt 'y) newy))

;Vrati hodnotu obvodu trojuhelniku
(defmethod triangle-perimeter ((tr triangle))
  (+ (point-distance (slot-value tr 'vortexA) (slot-value tr 'vortexB))
     (point-distance (slot-value tr 'vortexB) (slot-value tr 'vortexC))
     (point-distance (slot-value tr 'vortexC) (slot-value tr 'vortexA))))


;Ellipse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;A a B jsou hlavní vrcholy, C a D vedlejsi vrcholy
(defclass ellipse ()
  ((focal-point1 :initform (make-instance 'point))
   (focal-point2 :initform (make-instance 'point))
   (center :initform (make-instance 'point))
   (excent :initform 0)
   (A :initform (make-instance 'point))
   (B :initform (make-instance 'point))
   (C :initform (make-instance 'point))
   (D :initform (make-instance 'point))))

(defmethod set-focal-pt1 ((ell ellipse) newpoint)
  (setf (slot-value ell 'focal-point1) newpoint))

(defmethod set-focal-pt2 ((ell ellipse) newpoint)
  (setf (slot-value ell 'focal-point2) newpoint))

;Nastavuje hlavni vrchol, pro hlavni poloosu od stredu elipsy
(defmethod set-A ((ell ellipse) newpoint)
  (setf (slot-value ell 'A) newpoint))

;Nastavuje vedlejsi vrchol, pro vedlejsi poloosu od stredu elipsy
(defmethod set-D ((ell ellipse) newpoint)
  (setf (slot-value ell 'D) newpoint))


(defun point-distance (pt1 pt2)
  (sqrt (+ (expt (- (slot-value pt1 'x) (slot-value pt2 'x)) 2)
           (expt (- (slot-value pt1 'y) (slot-value pt2 'y)) 2))))


;Vraci velikost hl. poloosy
(defmethod major-semiaxis ((ell ellipse))
  (point-distance (slot-value ell 'center) (slot-value ell 'A)))

;Vraci velikost vedlejsi poloosy
(defmethod minor-semiaxis ((ell ellipse))
  (point-distance (slot-value ell 'center) (slot-value ell 'D)))

(defmethod set-major-axis  ((ell ellipse) point)
  (setf (slot-value ell 'A) point))

(defmethod set-minor-axis ((ell ellipse) point)
  (setf (slot-value ell 'C) point))


(defmethod current-center ((ell ellipse))
  (set-center ell)
  (slot-value ell 'center))


(defmethod point-to-list ((pt point))
  (list (slot-value pt 'x) (slot-value pt 'y)))

;;;;;;;;;;;;;;
(defmethod get-point-x ((pt point))
  (slot-value pt 'x))

(defmethod get-point-y ((pt point))
  (slot-value pt 'y))

(defmethod set-point-x ((pt point) x)
  (setf (slot-value pt 'x) x))

(defmethod set-point-y ((pt point) y)
  (setf (slot-value pt 'y) y))
;;;;;;;;;;;;;;;;;
(defmethod set-center ((ell ellipse))
  (set-point-x (slot-value ell 'center) 
               (/ (+ (get-point-x (slot-value ell 'focal-point1)) (get-point-x (slot-value ell 'focal-point2))) 2))
  (set-point-y (slot-value ell 'center) 
                (/ (+ (get-point-y (slot-value ell 'focal-point1)) (get-point-y (slot-value ell 'focal-point2))) 2)))



(defmethod set-excentricity ((ell ellipse))
  (setf (slot-value ell 'excent) (point-distance (slot-value ell 'center) (slot-value ell 'focal-point1))))

(defmethod to-ellipse ((c circle))
  (let ((e (make-instance 'ellipse))
        (newfp (make-instance 'point))
        (new-fp2 (make-instance 'point))
        (major (make-instance 'point))
        (minor (make-instance 'point)))
    (set-focal-point1 e (progn (set-x newfp (/ (x (center c)) 2))
                        (set-y newfp (/ (y (center c)) 2))))
    (set-focal-point2 e (progn (set-x new-fp2 (* (x (center c)) 2))
                        (set-y new-fp2 (* (y (center c)) 2))))
    (set-major-axis e (progn (set-x major (- (x (center c)) (radius c)))
                      (set-y major (y (center c)))))
    (set-minor axis e (progn (set-x minor (x (center c)))
                      (set-y minor (- (y center c)))))))
                     
                        
                        
                        
  






















