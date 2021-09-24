;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; ZdrojovĂ˝ soubor k uÄŤebnĂ­mu textu M. Krupka: ObjektovĂ© programovĂˇnĂ­
;;;;
;;;; Kapitola 2, ZapouzdĹ™enĂ­
;;;;

#| 
PĹ™ed naÄŤtenĂ­m souboru naÄŤtÄ›te knihovnu micro-graphics
Pokud pĹ™i naÄŤĂ­tĂˇnĂ­ (kompilaci) dojde k chybÄ› 
"Reader cannot find package MG",
znamenĂˇ to, Ĺľe knihovna micro-graphics nenĂ­ naÄŤtenĂˇ.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída point
;;;

(defclass point () 
  ((x :initform 0) 
   (y :initform 0)
   (color :initform :black) 
   (thickness :initform 1)))


;;;
;;; Vlastnosti x, y, r, phi
;;;

(defmethod x ((point point))
  (slot-value point 'x))

(defmethod y ((point point))
  (slot-value point 'y))

(defmethod set-x ((point point) value)
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (setf (slot-value point 'x) value)
  point)

(defmethod set-y ((point point) value)
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (setf (slot-value point 'y) value)
  point)

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
  (set-x point (* r (cos phi)))
  (set-y point (* r (sin phi)))
  point)

(defmethod set-r ((point point) value) 
  (set-r-phi point value (phi point)))

(defmethod set-phi ((point point) value) 
  (set-r-phi point (r point) value))


;;;
;;; Vlastnosti související s kreslením color, thickness
;;;

(defmethod color ((pt point)) 
  (slot-value pt 'color)) 

(defmethod set-color ((pt point) value) 
  (setf (slot-value pt 'color) value)
  pt) 

(defmethod thickness ((pt point)) 
  (slot-value pt 'thickness)) 

(defmethod set-thickness ((pt point) value) 
  (setf (slot-value pt 'thickness) value)
  pt)

;;;
;;; Kreslení
;;;

;; U bodu kreslíme kruh s poloměrem rovným thickness

(defmethod set-mg-params ((pt point) mg-window) 
  (mg:set-param mg-window :foreground (color pt)) 
  (mg:set-param mg-window :filledp t)
  pt)

(defmethod do-draw ((pt point) mg-window) 
  (mg:draw-circle mg-window 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)

(defmethod draw ((pt point) mg-window)
  (set-mg-params pt mg-window)
  (do-draw pt mg-window))

;;
;; Geometrická transformace
;;

(defmethod move ((pt point) dx dy)
  (set-x pt (+ (x pt) dx))
  (set-y pt (+ (y pt) dy))
  pt)

(defmethod rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-phi pt (+ (phi pt) angle))
    (move pt cx cy)
    pt))

(defmethod scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-r pt (* (r pt) coeff))
    (move pt cx cy)
    pt))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída circle
;;;

(defclass circle () 
  ((center :initform (make-instance 'point)) 
   (radius :initform 1)
   (color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)))

#|
(defmethod to-ellipse ((cic circle))
  (let ((el (make-instance 'ellipse)))
    (set-center el (center cic))
    (set-radius el (radius cic))))
|#


;;;
;;; Základní vlastnosti
;;;

(defmethod radius ((c circle))
  (slot-value c 'radius))

(defmethod set-radius ((c circle) value)
  (when (< value 0)
    (error "Circle radius should be a non-negative number"))
  (setf (slot-value c 'radius) value)
  c)

(defmethod center ((c circle))
  (slot-value c 'center))


;;;
;;; Vlastnosti související s kreslením
;;;

(defmethod color ((c circle))
  (slot-value c 'color))

(defmethod set-color ((c circle) value)
  (setf (slot-value c 'color) value)
  c)

(defmethod thickness ((c circle))
  (slot-value c 'thickness))

(defmethod set-thickness ((c circle) value)
  (setf (slot-value c 'thickness) value)
  c)

(defmethod filledp ((c circle))
  (slot-value c 'filledp))

(defmethod set-filledp ((c circle) value)
  (setf (slot-value c 'filledp) value)
  c)



;;;
;;; Kreslení
;;;

(defmethod set-mg-params ((c circle) mg-window)
  (mg:set-param mg-window :foreground (color c))
  (mg:set-param mg-window :thickness (thickness c))
  (mg:set-param mg-window :filledp (filledp c))
  c)

(defmethod do-draw ((c circle) mg-window)
  (mg:draw-circle mg-window
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)

(defmethod draw ((c circle) mg-window)
  (set-mg-params c (mg-window mg-window))
  (do-draw c (mg-window mg-window)))

;Kreslení bullseye, by Krupka
(defun make-bulls-eye (x y radius count)
  (let ((result (make-instance 'picture))
        (items '())
        (step (/ radius count))
        (blackp t)
        circle)
    (dotimes (i count)
      (setf circle (set-filledp
                    (set-color
                     (set-radius (make-instance 'circle)
                                 (- radius (* i step)))
                     (if blackp :black :light-blue))
                    t))
      (set-y (set-x (center circle) x) y)
      (setf items (cons circle items) blackp (not blackp)))
    (set-items result items)))

;;
;; Geometrická transformace
;;

(defmethod move ((c circle) dx dy)
  (move (center c) dx dy)
  c)

(defmethod rotate ((c circle) angle center)
  (rotate (center c) angle center)
  c)

(defmethod scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (set-radius c (* (radius c) coeff))
  c)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída picture
;;;

(defclass picture ()
  ((items :initform '())))


;;;
;;; Vlastnost items
;;;

(defmethod check-item ((pic picture) item)
  (unless (or (typep item 'point) 
              (typep item 'circle) 
              (typep item 'picture)
              (typep item 'empty-shape))
    (error "Invalid picture element type."))
  pic)

(defmethod check-items ((pic picture) items)
  (dolist (item items)
    (check-item pic item))
  pic)

(defmethod items ((pic picture)) 
  (copy-list (slot-value pic 'items)))

(defmethod set-items ((pic picture) value) 
  (check-items pic value)
  (setf (slot-value pic 'items) (copy-list value))
  pic)

(defmethod draw ((pic picture) mg-window)
  (dolist (item (reverse (items pic)))
    (draw item mg-window))
  pic)

;;
;; Geometrická transformace
;;

(defmethod move ((pic picture) dx dy)
  (dolist (item (items pic))
    (move item dx dy))
  pic)

(defmethod rotate ((pic picture) angle center)
  (dolist (item (items pic))
    (rotate item angle center))
  pic)

(defmethod scale ((pic picture) coeff center)
  (dolist (item (items pic))
    (scale item coeff center))
  pic)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída window
;;;

(defclass window ()
  ((mg-window :initform (mg:display-window))
   (shape :initform nil)
   (background :initform :white)))


;;;
;;; Vlastnosti
;;;

(defmethod mg-window ((window window))
  (slot-value window 'mg-window))

(defmethod shape ((w window))
  (slot-value w 'shape))

(defmethod set-shape ((w window) shape)
  (setf (slot-value w 'shape) shape)
  w)

(defmethod background ((w window))
  (slot-value w 'background))

(defmethod set-background ((w window) color)
  (setf (slot-value w 'background) color)
  w)


;;;
;;; Vykreslování
;;;

(defmethod redraw ((window window))
  (let ((mgw (mg-window window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window) mgw)))
  window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Ukol prvni POLYGON
;;;;;;;;;;;;;;;;;;;;
(defclass polygon ()
  ((items :initform '())
   (color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (closedp :initform t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Vlastnosti slotu polygonu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod items ((p polygon))
  (copy-list (slot-value p 'items)))

(defmethod set-items ((p polygon) value)
  (check-items p value)
  (setf (slot-value p 'items) value)
  p)

(defmethod check-item ((p polygon) item)
  (unless (or (typep item 'point) 
              (typep item 'circle) 
              (typep item 'picture)
              (typep item 'empty-shape)
              (typep item 'full-shape))
    (error "Invalid picture element type."))
  p)

(defmethod check-items ((p polygon) items)
  (dolist (item items)
    (check-item p item))
  p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Vlastnosti spojené s kreslením
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod set-color ((p polygon) c)
  (setf (slot-value p 'color) c))

(defmethod color ((p polygon))
  (slot-value p 'color))

(defmethod set-thickness ((p polygon) value)
  (setf (slot-value p 'thickness) value))

(defmethod thickness ((p polygon))
  (slot-value p 'thickness))

(defmethod set-filledp ((p polygon) value)
  (setf (slot-value p 'filledp) value))

(defmethod filledp ((p polygon))
  (slot-value p 'filledp))

(defmethod set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value))

(defmethod closedp ((p polygon))
  (slot-value p 'closedp))

;;;;;;;;;;;;;;;;;;;;;;;;
;Vykreslování polygonu
;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod set-mg-params ((p polygon) mg-window)
    (mg:set-param mg-window :foreground (color p))
    (mg:set-param mg-window :thickness (thickness p))
    (mg:set-param mg-window :filledp (filledp p))
    (mg:set-param mg-window :closedp (closedp p))
  p)

(defmethod draw ((p polygon) mg-window)
  (set-mg-params p (mg-window mg-window))
  (do-draw p (mg-window mg-window)))

(defmethod do-draw ((p polygon) mg-window)
  (let ((lst (items p)))
    (mg:draw-polygon mg-window (points-to-list-cords lst)))
  p)

;Jelikoz do knihovny mg:draw-polygon je syntax (mg:draw-polygon window (ptx pty pt2x pt2y ...)
(defun points-to-list-cords (list)
  (if (null list)
      '()
    (append (list (x (car list)) (y (car list)))
            (points-to-list-cords (cdr list)))))



;;
;; Geometrické transformace
;;

(defmethod move ((poly polygon) dx dy)
  (dolist (item (items poly))
    (move item dx dy))
  poly)

(defmethod rotate ((poly polygon) angle center)
  (dolist (item (items poly))
    (rotate item angle center))
  poly)

(defmethod scale ((poly polygon) coeff center)
  (dolist (item (items poly))
    (scale item coeff center))
  poly)
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Třída empty-shape
;;;;;;;;;;;;;;;;;;;;

(defclass empty-shape ()
  ())

(defmethod draw ((es empty-shape) mg-window)
  es)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Třída full-shape
;;;;;;;;;;;;;;;;;;;

(defclass full-shape ()
  ((color :initform :white)))

(defmethod set-color ((fs full-shape) color)
  (setf (slot-value fs 'color) color))

(defmethod color ((fs full-shape))
  (slot-value fs 'color))

(defmethod set-mg-params ((fs full-shape) mg-window)
  (mg:set-param mg-window :background (color fs))
  fs)

(defmethod draw ((fs full-shape) mg-window)
  (set-mg-params fs (mg-window mg-window))
  (mg:clear (mg-window mg-window))
  fs)


;Kresleni polygonu test
#|
(setf w (make-instance 'window))
(setf p (make-instance 'polygon))
(setf pt (make-instance 'point))
(set-x pt 128)
(set-y pt 80)
(setf pt2 (make-instance 'point))
(set-x pt2 168)
(set-x pt2 80)
(setf pt3 (make-instance 'point))
(set-x pt3 168)
(set-x pt3 120)
(setf pt4 (make-instance 'point))¨
(set-x pt4 128)
(set-y pt4 120)
(setf body (list pt pt2 pt3 pt4))
(set-items p body)
(set-color p :blue)
(set-thickness p 10)
(set-shape w p)
(draw p w)
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Třída ellipse
;;;;;;;;;;;;;;;;;
(defclass ellipse ()
  ((focal-point1 :initform (make-instance 'point))
   (focal-point2 :initform (make-instance 'point))
   (center :initform (make-instance 'point))
   (excent :initform 0)
   (color :initform :blue)
   (thickness :initform 1)
   (filledp :initform nil)
   (A :initform (make-instance 'point))
   (C :initform (make-instance 'point))))

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


(defmethod current-center ((ell ellipse))
  (set-center ell)
  (slot-value ell 'center))


(defmethod point-to-list ((pt point))
  (list (slot-value pt 'x) (slot-value pt 'y)))

;;;;;;;;;;;;;;;;;
(defmethod set-center ((ell ellipse))
  (set-x (slot-value ell 'center) 
               (/ (+ (x (slot-value ell 'focal-point1)) (x (slot-value ell 'focal-point2))) 2))
  (set-y (slot-value ell 'center) 
                (/ (+ (y (slot-value ell 'focal-point1)) (y (slot-value ell 'focal-point2))) 2)))



(defmethod set-excentricity ((ell ellipse))
  (setf (slot-value ell 'excent) (point-distance (slot-value ell 'center) (slot-value ell 'focal-point1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Věci spojené s kreslením
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod set-color ((el ellipse) color)
  (setf (slot-value el 'color) color))

(defmethod set-thickness ((el ellipse) th)
  (setf (slot-value el 'thickness) th))

(defmethod set-filledp ((el ellipse) p)
  (setf (slot-value el 'filledp) p))

(defmethod color ((el ellipse))
  (slot-value el 'color))

(defmethod thickness ((el ellipse))
  (slot-value el 'thickness))

(defmethod filledp ((el ellipse))
  (slot-value el 'filledp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Věci s vykreslováním ellipse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#|

neexistuje mg:draw-ellipse v knihovně micro-graphics

(defmethod mg-set-params ((el ellipse) mg-window)
  (mg:set-param mg-window :foreground (color el))
  (mg:set-param mg-window :thickness (thickness el))
  (mg:set-param mg-window :filledp (filledp el)))

(defmethod draw ((el ellipse) mg-window)
  (let ((mgw (mg-window mg-window)))
    (mg-set-params el mgw)
    (mg:draw-ellipse mgw (center el) 
                     (major-semiaxis el) (minor-semiaxis el)
                     (radius el))))
|#

(defun make-regular-polygon (n)
  (let ((angle (/ (* pi 2) n))
        (items '()))
    (dotimes (i n)
      (setf items 
            (cons (set-r-phi (make-instance 'point) 1 (* i angle))
                        items)))
    (reverse items)))









