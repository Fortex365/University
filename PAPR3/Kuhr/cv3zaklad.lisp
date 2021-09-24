

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída point
;;;

(defclass point () 
  ((x :initform 0) 
   (y :initform 0)
   (color :initform :black) 
   (thickness :initform 1) 
   (window :initform nil)))


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
;;; Geometrická transformace
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
;;; Geometrická transformace
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


;;;
;;; Kreslení
;;;

(defmethod draw ((pic picture) mg-window)
  (dolist (item (reverse (items pic)))
    (draw item mg-window))
  pic)


;;;
;;; Geometrická transformace
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


;;; 
;;; Kreslení
;;;

(defmethod set-mg-params ((poly polygon) mg-window) 
  (mg:set-param mg-window :foreground (color poly)) 
  (mg:set-param mg-window :thickness (thickness poly)) 
  (mg:set-param mg-window :filledp (filledp poly))
  (mg:set-param mg-window :closedp (closedp poly))
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
;;; Geometrická transformace
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

(defmethod mg-window ((w window))
  (slot-value w 'mg-window))











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Třída triangle
;;

(defclass triangle ()
  ((vertexA :initform (make-instance 'point))
   (vertexB :initform (make-instance 'point))
   (vertexC :initform (make-instance 'point))
   (filledp :initform nil)
   (closedp :initform t)
   (thickness :initform 1)
   (color :initform :red)))

(defmethod set-vertex-A ((tr triangle) pt)
  (setf (slot-value tr 'vertexA) pt))

(defmethod set-vertex-B ((tr triangle) pt)
  (setf (slot-value tr 'vertexB) pt))

(defmethod set-vertex-C ((tr triangle) pt)
  (setf (slot-value tr 'vertexC) pt))

(defmethod vertexA ((tr triangle))
  (slot-value tr 'vertexA))

(defmethod vertexB ((tr triangle))
  (slot-value tr 'vertexB))

(defmethod vertexC ((tr triangle))
  (slot-value tr 'vertexC))

(defmethod point-to-list ((pt point))
  (list (slot-value pt 'x) (slot-value pt 'y)))

(defmethod vertices ((tr triangle))
  (append (point-to-list (vertexA tr))
                (point-to-list (vertexB tr))
                (point-to-list (vertexC tr))))

;;
;; Geometricka transformace
;;

(defmethod move ((tr triangle) dx dy)
  (move (vertexA tr) dx dy)
  (move (vertexB tr) dx dy)
  (move (vertexC tr) dx dy)
  tr)

(defmethod rotate ((tr triangle) angle center)
  (rotate (vertexA tr) angle center)
  (rotate (vertexB tr) angle center)
  (rotate (vertexC tr) angle center)
  tr)

(defmethod scale ((tr triangle) coeff center)
  (scale (vertexA tr) coeff center)
  (scale (vertexB tr) coeff center)
  (scale (vertexC tr) coeff center)
  tr)

;;
;; Kresleni
;;

(defmethod set-mg-param ((tr triangle) mg-window)
  (mg:set-param mg-window :foreground (color tr))
  (mg:set-param mg-window :filledp (filledp tr))
  (mg:set-param mg-window :closedp (closedp tr))
  (mg:set-param mg-window :thickness (thickness tr))
  tr)

(defmethod draw ((tr triangle) mg-window)
  (set-mg-param tr mg-window)
  (mg:draw-polygon mg-window (vertices tr))
  tr)

;;
;; Vlastnosti spojene s kreslenim
;;

(defmethod set-color ((tr triangle) color)
  (setf (slot-value tr 'color) color))

(defmethod set-thickness ((tr triangle) val)
  (setf (slot-value tr 'thickness) val))

(defmethod set-filledp ((tr triangle) p)
  (setf (slot-value tr 'filledp) p))

(defmethod set-closedp ((tr triangle) p)
  (setf (slot-value tr 'closedp) p))

(defmethod color ((tr triangle))
  (slot-value tr 'color))

(defmethod thickness ((tr triangle))
  (slot-value tr 'thickness))

(defmethod filledp ((tr triangle))
  (slot-value tr 'filledp))

(defmethod closedp ((tr triangle))
  (slot-value tr 'closedp))







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Vykreslování
;;;

(defmethod redraw ((window window))
  (let ((mgw (slot-value window 'mg-window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window) mgw)))
  window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;
;; Metody pro speciální obrazce
;;

(defun make-regular-polygon (n radius)
  (let ((angle (/ (* pi 2) n))
        (items '())
        (pol (make-instance 'polygon)))
    (dotimes (i n)
      (setf items 
            (cons (set-r-phi (make-instance 'point) radius (* i angle))
                        items)))
    (reverse items)
    (set-items pol items)
    pol))

(defun make-blue-square ()
  (let ((p (make-instance 'polygon)))
    (set-items
     (set-color (set-thickness p 10) :blue)
     (list (move (make-instance 'point) 50 50)
           (move (make-instance 'point) 100 50)
           (move (make-instance 'point) 100 100)
           (move (make-instance 'point) 50 100)))))

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Třída empty-shape
;;

(defclass empty-shape ()
  ())

(defmethod draw ((es empty-shape) mg-window)
  es)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Třída full-shape
;;

(defclass full-shape ()
  ((color :initform :skyblue)))

(defmethod set-color ((fs full-shape) color)
  (setf (slot-value fs 'color) color))

(defmethod color ((fs full-shape))
  (slot-value fs 'color))

(defmethod set-mg-params ((fs full-shape) mg-window)
  (mg:set-param mg-window :background (color fs))
  fs)

(defmethod draw ((fs full-shape) mg-window)
  (set-mg-params fs mg-window)
  (mg:clear mg-window)
  fs)

(defmethod draw2 ((fs full-shape) mg-window)
  (let ((orig-color (color mg-window)))
    (set-mg-params fs mg-window)
    (mg:clear mg-window)
    (mg:set-param mg-window :background orig-color))
  fs)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Třída ellipse
;;

(defclass ellipse ()
  ((fp1 :initform (make-instance 'point))
   (fp2 :initform (make-instance 'point))
   (major :initform (make-instance 'point))
   (minor :initform (make-instance 'point))
   (color :initform :blue)
   (thickness :initform 1)
   (filledp :initform nil)))

;
; Práce se sloty
;

(defmethod fp1 ((e ellipse))
  (slot-value e 'fp1))

(defmethod fp2 ((e ellipse))
  (slot-value e 'fp2))

(defmethod major ((e ellipse))
  (slot-value e 'major))

(defmethod minor ((e ellipse))
  (slot-value e 'minor))

(defmethod set-fp1 ((e ellipse) val)
  (setf (slot-value e 'fp1) val))

(defmethod set-fp2 ((e ellipse) val)
  (setf (slot-value e 'fp2) val))

(defmethod set-major ((e ellipse) val)
  (setf (slot-value e 'major) val))

(defmethod set-minor ((e ellipse) val)
  (setf (slot-value e 'minor) val))

;
; Vlastnosti související s kreslením
;

(defmethod color ((e ellipse))
  (slot-value e 'color))

(defmethod thickness ((e ellipse))
  (slot-value e 'thickness))

(defmethod filledp ((e ellipse))
  (slot-value e 'filledp))

(defmethod set-color ((e ellipse) c)
  (setf (slot-value e 'color) c))

(defmethod set-thickness ((e ellipse) num)
  (setf (slot-value e 'thickness) num))

(defmethod set-filledp ((e ellipse) p)
  (setf (slot-value e 'filledp) p))

;
; Vlastnosti ellipsy
;

(defmethod center ((e ellipse))
  (let ((center (make-instance 'point)))
    (set-x center (/ (+ (x (fp1 e)) (x (fp2 e))) 2))
    (set-y center (/ (+ (y (fp1 e)) (y (fp2 e))) 2))
    center))

(defun pt-distance (pt pt2)
  (sqrt (+ (expt (- (x pt) (x pt2)) 2)
           (expt (- (y pt) (y pt2)) 2))))

(defmethod excentricity ((e ellipse))
  (pt-distance (fp1 e) (center e)))

;
; Geometrická transformace
;

(defmethod move ((e ellipse) dx dy)
  (move (fp1 e) dx dy)
  (move (fp2 e) dx dy)
  (move (major e) dx dy)
  (move (minor e) dx dy)
  e)

(defmethod rotate ((e ellipse) angle center)
  (rotate (fp1 e) angle center)
  (rotate (fp2 e) angle center)
  (rotate (major e) angle center)
  (rotate (minor e) angle center)
  e)

(defmethod scale ((e ellipse) coeff point)
  (scale (fp1 e) coeff point)
  (scale (fp2 e) coeff point)
  (scale (major e) coeff point)
  (scale (minor e) coeff point)
  e)

;
; Kreslení
;

(defmethod set-mg-params ((e ellipse) mg-window)
  (mg:set-param mg-window :foreground (color e))
  (mg:set-param mg-window :thickness (thickness e))
  (mg:set-param mg-window :filledp (filledp e))
  e)

(defmethod draw ((e ellipse) mg-window)
  (let ((fpx (x (fp1 e)))
        (fpy (y (fp1 e)))
        (fp2x (x (fp2 e)))
        (fp2y (y (fp2 e))))
    (set-mg-params e mg-window)
    (mg:draw-ellipse mg-window fpx fpy fp2x fp2y (phi (major e))))
  e)

#|
(progn (set-fp1 ell (move (make-instance 'point) 100 300))
               (set-fp2 ell (move (make-instance 'point) 160 300))
               (set-major ell (move (make-instance 'point) 50 100))
               (set-minor ell (move (make-instance 'point) 130 50)))
|#







