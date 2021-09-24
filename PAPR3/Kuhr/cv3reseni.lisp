;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 3, Polymorfismus
;;;;

#|
Před načtením souboru načtěte knihovnu micro-graphics
Pokud při načítání (kompilaci) dojde k chybě
"Reader cannot find package MG",
znamená to, že knihovna micro-graphics není načtená.
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
;;; Vlastnosti související s kreslením: color, thickness
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

;;; pridane metody

(defmethod deep-copy ((pt point))
  (let ((out (make-instance 'point)))
    (set-x out (x pt))
    (set-y out (y pt))
    (set-color out (color pt))
    (set-thickness out (thickness pt))
    out))

;;;
;;; Kreslení
;;;

;; U bodu kreslíme kruh s poloměrem rovným thickness

(defmethod set-mg-params ((pt point) mgw) 
  (mg:set-param mgw :foreground (color pt)) 
  (mg:set-param mgw :filledp t)
  pt)

(defmethod do-draw ((pt point) mgw) 
  (mg:draw-circle mgw 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)

(defmethod draw ((pt point) mgw)
  (set-mg-params pt mgw)
  (do-draw pt mgw))


;;;
;;; Geometrické transformace
;;;

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

;;; pridane vlastnosti

(defmethod min-x ((c circle))
  (- (x (center c)) (radius c)))

(defmethod max-x ((c circle))
  (+ (x (center c)) (radius c)))

(defmethod min-y ((c circle))
  (- (y (center c)) (radius c)))

(defmethod max-y ((c circle))
  (+ (y (center c)) (radius c)))

;;; pridane  metody

(defmethod deep-copy ((c circle))
  (let ((out (make-instance 'circle)))
    (move (center out) (x (center c)) (y (center c)))
    (set-color out (color c))
    (set-radius out (radius c))
    (set-thickness out (thickness c))
    (set-filledp out (filledp c))
    out))

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
  (set-mg-params c mg-window)
  (do-draw c mg-window))


;;;
;;; Geometrické transformace
;;;

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
              (typep item 'polygon)
              (typep item 'picture))
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

;;; pridane vlastnosti

(defmethod min-x ((pic picture))
  (apply #'min (mapcar #'min-x (items pic))))

(defmethod max-x ((pic picture))
  (apply #'max (mapcar #'max-x (items pic))))

(defmethod min-y ((pic picture))
  (apply #'min (mapcar #'min-y (items pic))))

(defmethod max-y ((pic picture))
  (apply #'max (mapcar #'max-y (items pic))))

;;; pridane metody

(defmethod deep-copy ((pic picture))
  (set-items (make-instance 'picture) 
             (mapcar #'deep-copy (items pic))))

(defmethod set-filledp ((pic picture) val)
  (mapcar (lambda (x) (set-filledp x val)) (items pic))
  pic)

(defmethod set-color ((pic picture) val)
  (mapcar (lambda (x) (set-color x val)) (items pic))
  pic)

;;;
;;; Kreslení
;;;

(defmethod draw ((pic picture) mg-window)
  (dolist (item (reverse (items pic)))
    (draw item mg-window))
  pic)


;;;
;;; Geometrické transformace
;;;

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
;;; Třída polygon
;;;

(defclass polygon ()
  ((items :initform '())
   (color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (closedp :initform t)))


;;;
;;; Vlastnost items
;;;

(defmethod check-item ((poly polygon) item)
  (unless (typep item 'point) 
    (error "Items of polygon should be points."))
  poly)

(defmethod check-items ((poly polygon) items)
  (dolist (item items)
    (check-item poly item))
  poly)

(defmethod items ((poly polygon)) 
  (copy-list (slot-value poly 'items)))

(defmethod set-items ((poly polygon) value) 
  (check-items poly value)
  (setf (slot-value poly 'items) (copy-list value))
  poly)


;;;
;;; Vlastnosti pro kreslení
;;;

(defmethod color ((p polygon))
  (slot-value p 'color))

(defmethod set-color ((p polygon) value)
  (setf (slot-value p 'color) value)
  p)

(defmethod thickness ((p polygon))
  (slot-value p 'thickness))

(defmethod set-thickness ((p polygon) value)
  (setf (slot-value p 'thickness) value)
  p)

(defmethod closedp ((p polygon))
  (slot-value p 'closedp))

(defmethod set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value)
  p)

(defmethod filledp ((p polygon))
  (slot-value p 'filledp))

(defmethod set-filledp ((p polygon) value)
  (setf (slot-value p 'filledp) value)
  p)

;;; pridane vlastnosti

(defmethod min-x ((p polygon))
  (apply #'min (mapcar #'x (items p))))

(defmethod max-x ((p polygon))
  (apply #'max (mapcar #'x (items p))))

(defmethod min-y ((p polygon))
  (apply #'min (mapcar #'y (items p))))

(defmethod max-y ((p polygon))
  (apply #'max (mapcar #'y (items p))))

;;; pridane metody

(defmethod deep-copy ((p polygon))
  (let ((out (make-instance 'polygon)))
    (set-items out (mapcar #'deep-copy (items p)))
    (set-color out (color p))
    (set-thickness out (thickness p))
    (set-closedp out (closedp p))
    (set-filledp out (filledp p))
    out))

;;; 
;;; Kreslení
;;;

(defmethod set-mg-params ((poly polygon) mg-window) 
  (mg:set-param  mg-window :foreground (color poly)) 
  (mg:set-param  mg-window :thickness (thickness poly)) 
  (mg:set-param  mg-window :filledp (filledp poly))
  (mg:set-param  mg-window :closedp (closedp poly))
  poly)

(defmethod polygon-coordinates ((p polygon))
  (let (coordinates)
    (dolist (point (reverse (items p)))
      (setf coordinates (cons (y point) coordinates)
            coordinates (cons (x point) coordinates)))
    coordinates))

(defmethod do-draw ((poly polygon) mg-window) 
  (mg:draw-polygon mg-window 
                   (polygon-coordinates poly))
  poly)

(defmethod draw ((poly polygon) mg-window) 
  (set-mg-params poly mg-window) 
  (do-draw poly mg-window))


;;;
;;; Geometrické transformace
;;;

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
  (let ((mgw (slot-value window 'mg-window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window) mgw)))
  window)


;; funkce make-regular-polygon
(defun make-regular-polygon (n)
  (let ((angle (/ (* 2 pi) n))
        (items ()))
    (dotimes (i n)
      (setf items (cons
                   (set-r-phi (make-instance 'point) 1 (* i angle))
                   items)))
    (set-items (make-instance 'polygon) 
               (reverse items))))

;; funkce make-bulls-eye-circle
(defun make-bulls-eye-circle (x y radius count) 
  (let ((result (make-instance 'picture))
        (items '())
        (step (/ radius count))
        (blackp t)
        circle)
    (dotimes (i count)
      (setf circle (make-instance 'circle))
      (set-filledp circle t)
      (set-color circle (if blackp :black :light-blue))
      (set-radius circle (- radius (* i step))) 
      (move circle x y)
      (setf items (cons circle items)
            blackp (not blackp))) 
    (set-items result items)))

;; funkce make-bulls-eye-rp
(defun make-bulls-eye-rp (n x y radius count) 
  (let ((result (make-instance 'picture))
        (items '())
        (step (/ radius count))
        (blackp t)
        polygon)
    (dotimes (i count)
      (setf polygon (make-regular-polygon n))
      (set-filledp polygon t)
      (set-color polygon (if blackp :black :light-blue))
      (scale polygon (- radius (* i step)) (make-instance 'point)) 
      (move polygon x y)
      (setf items (cons polygon items)
            blackp (not blackp))) 
    (set-items result items)))

;; funkce make-bulls-eye-general
(defun make-bulls-eye-general (shape count) 
  (let* ((result (make-instance 'picture))
        (items '())
        (radius (max (- (max-x shape) (min-x shape))
                     (- (max-y shape) (min-y shape))))
        (center (move (make-instance 'point)
                      (/ (+ (min-x shape) (max-x shape)) 2)
                      (/ (+ (min-y shape) (max-y shape)) 2)))
        (step (/ radius count))
        (blackp t)
        item)
    (dotimes (i count)
      (setf item (deep-copy shape))
      (set-filledp item t)
      (set-color item (if blackp :black :light-blue))
      (scale item (/ (- radius (* i step)) radius) center) 
      (setf items (cons item items)
            blackp (not blackp))) 
    (set-items result items)))


;; testy
#|
(setf rp (make-regular-polygon 8))
(setf w (make-instance 'window))
(set-shape w rp)

(scale rp 100 (make-instance 'point))
(move rp 200 200)

(redraw w)

(setf bec (make-bulls-eye-circle 200 200 100 5))
(set-shape w bec)
(redraw w)

(setf berp (make-bulls-eye-rp 5 200 200 100 5))
(set-shape w berp)
(redraw w)

(min-x rp)
(copy rp)

(set-shape w (make-bulls-eye-general rp 10))
(setf cir (move (set-radius (make-instance 'circle) 100) 200 200))
(set-shape w (make-bulls-eye-general cir 10))
(setf p (set-items (make-instance 'polygon)
                   (list (move (make-instance 'point) 100 100)
                         (move (make-instance 'point) 100 200)
                         (move (make-instance 'point) 200 200)
                         (move (make-instance 'point) 200 100)
                         (move (make-instance 'point) 150 50))))
(set-shape w (make-bulls-eye-general p 10))
(setf pic (set-items (make-instance 'picture)
                     (list (move (set-radius (make-instance 'circle) 100) 150 200)
                           (move (set-radius (make-instance 'circle) 100) 250 200))))
(set-shape w (make-bulls-eye-general pic 10))
(redraw w)
|#

