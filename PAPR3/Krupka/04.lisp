;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k předmětu Paradigmata programování 3
;;;;
;;;; Přednáška 4, Dědičnost
;;;;

#|
Před načtením souboru načtěte knihovnu micro-graphics
Pokud při načítání (kompilaci) dojde k chybě
"Reader cannot find package MG",
znamená to, že knihovna micro-graphics není načtená.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída shape
;;;

#|
Obecná třída všech grafických objektů. Definuje a částečně implementuje
to, co mají společné: vlastnosti související s kreslením (color, thickness,
filledp), geometrické transformace, kreslení.
|#

(defclass shape ()
  ((color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)))


;;;
;;; Vlastnosti související s kreslením
;;;

(defmethod color ((shape shape)) 
  (slot-value shape 'color))

(defmethod set-color ((shape shape) value) 
  (setf (slot-value shape 'color) value)
  shape)

(defmethod thickness ((shape shape)) 
  (slot-value shape 'thickness)) 

(defmethod set-thickness ((shape shape) value) 
  (setf (slot-value shape 'thickness) value)
  shape) 

(defmethod filledp ((shape shape))
  (slot-value shape 'filledp))

(defmethod set-filledp ((shape shape) value)
  (setf (slot-value shape 'filledp) value)
  shape)


;;;
;;; Kreslení
;;;

;;Pracujeme právě s těmi vlastnostmi, které jsou ve třídě definovány.
(defmethod set-mg-params ((shape shape) mgw) 
  (mg:set-param mgw :foreground (color shape))
  (mg:set-param mgw :filledp (filledp shape))
  (mg:set-param mgw :thickness (thickness shape))
  shape)

(defmethod do-draw ((shape shape) mgw) 
  shape)

;; Základní chování pro každý grafický objekt
(defmethod draw ((shape shape) mgw)
  (set-mg-params shape mgw)
  (do-draw shape mgw))


;;;
;;; Geometrické transformace
;;;

#|
Ve třídě shape není definována žádná geometrie objektů, tak je správné,
když transformace nedělají nic.
|#

(defmethod move ((shape shape) dx dy)
  shape)

(defmethod rotate ((shape shape) angle center)
  shape)

(defmethod scale ((shape shape) coeff center)
  shape)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída point
;;;

(defclass point (shape) 
  ((x :initform 0) 
   (y :initform 0)))


;;;
;;; Geometrie
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
  (setf (slot-value point 'x) (* r (cos phi)) 
        (slot-value point 'y) (* r (sin phi))) 
  point)

(defmethod set-r ((point point) value) 
  (set-r-phi point value (phi point)))

(defmethod set-phi ((point point) value) 
  (set-r-phi point (r point) value))


;;;
;;; Kreslení
;;;

;; Nastavení parametrů je netypické - měníme nastavení parametru :filledp
;; ze zděděné metody, protože bod kreslíme jako kolečko
(defmethod set-mg-params ((pt point) mgw)
  (call-next-method)
  (mg:set-param mgw :filledp t)
  pt)

(defmethod do-draw ((pt point) mgw) 
  (mg:draw-circle mgw 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída circle
;;;

(defclass circle (shape) 
  ((center :initform (make-instance 'point)) 
   (radius :initform 1)))


;;;
;;; Geometrie
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
;;; Kreslení
;;;

(defmethod do-draw ((c circle) mg-window)
  (mg:draw-circle mg-window
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída compound-shape
;;;

#|
Třída compound-shape slouží jako předek složených grafických objektů, tedy 
těch, co mají vlastnost items.

Nepředpokládáme vytváření přímých instancí.
|#

(defclass compound-shape (shape)
  (items))


;;;
;;; Práce s items
;;;

(defmethod items ((shape compound-shape)) 
  (copy-list (slot-value shape 'items)))

;; Pomocná zpráva, posílá danou zprávu s danými argumenty všem prvkům
(defmethod send-to-items ((shape compound-shape) 
			  message
			  &rest arguments)
  (dolist (item (items shape))
    (apply message item arguments))
  shape)

(defmethod check-item ((shape compound-shape) item)
  (error "Method check-item of compound-shape must be rewritten."))

(defmethod do-check-items ((shape compound-shape) item-list)
  (dolist (item item-list)
    (check-item shape item))
  shape)

(defmethod check-items ((shape compound-shape) item-list)
  (error "Method check-items of compound-shape must be rewritten.")
  shape)

(defmethod set-items ((shape compound-shape) value)
  (check-items shape value)
  (setf (slot-value shape 'items) (copy-list value))
  shape)


;;;
;;; Geometrické transformace
;;;

(defmethod move ((shape compound-shape) dx dy)
  (send-to-items shape 'move dx dy)
  shape)

(defmethod rotate ((shape compound-shape) angle center)
  (send-to-items shape 'rotate angle center)
  shape)

(defmethod scale ((shape compound-shape) coeff center)
  (send-to-items shape 'scale coeff center)
  shape)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída picture
;;;

(defclass picture (compound-shape)
  ((items :initform '())))


;;;
;;; Práce s items
;;;

(defmethod check-item ((p picture) item)
  (unless (typep item 'shape)
    (error "Items of picture must be shapes.")))

(defmethod check-items ((p picture) items)
  (do-check-items p items))


;;;
;;; Kreslení
;;;

(defmethod draw ((pic picture) mg-window)
  (dolist (item (reverse (items pic)))
    (draw item mg-window))
  pic)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída polygon
;;;

#|
Proti třídě shape obsahuje polygon novou grafickou vlastnost: closedp.
Musíme ji tedy definovat (nový slot, přístupové metody, doplnění do 
set-mg-params).
|#

(defclass polygon (compound-shape)
  ((items :initform '())
   (closedp :initform t)))

(defmethod closedp ((p polygon))
  (slot-value p 'closedp))

(defmethod set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value)
  p)


;;;
;;; Práce s items
;;;

(defmethod check-item ((p polygon) item)
  (unless (typep item 'point)
    (error "Items of polygon must be points.")))

(defmethod check-items ((p polygon) items)
  (do-check-items p items))


;;;
;;; Kreslení
;;;

(defmethod set-mg-params ((p polygon) mgw) 
  (call-next-method)
  (mg:set-param mgw :closedp (closedp p))
  p)

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

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Třída window
;;;

#|
Třída zůstává beze změny.
|#

(defclass window ()
  ((mg-window :initform (mg:display-window))
   (shape :initform nil)
   (background :initform :white)))

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

(defmethod redraw ((window window))
  (let ((mgw (slot-value window 'mg-window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window) mgw)))
  window)

;;;;;;;;;;;;;;;;;;
;;Class triangle 
;;;;;;;;;;;;;;;;;;
(defclass triangle (polygon)
  ())

(defmethod verticeA ((tr triangle))
  (first (items tr)))

(defmethod verticeB ((tr triangle))
  (second (items tr)))

(defmethod verticeC ((tr triangle))
  (third (items tr)))

(defmethod set-verticeA ((tr triangle) pt)
  (setf (first (items tr)) pt))

(defmethod set-verticeB ((tr triangle) pt)
  (setf (second (items tr)) pt))

(defmethod set-verticeC ((tr triangle) pt)
  (setf (third (items tr)) pt))



;;;;;;;;;;;;;;;;;;;;;
;;Třída empty-shape
;;;;;;;;;;;;;;;;;;;;;
(defclass empty-shape (shape)
  ())

(defmethod draw ((es empty-shape) mgw)
  es)


;;;;;;;;;;;;;;;;;;;;;
;;Třída full-shape
;;;;;;;;;;;;;;;;;;;;;
(defclass full-shape (shape)
  ((newcolor :initform :white)))

(defmethod draw ((fs full-shape) mgw)
  (set-mg-params fs mgw)
  (do-draw fs mgw))

(defmethod do-draw ((fs full-shape) mgw)
  (mg:set-param :background (color fs))
  (mg:clear))

(defmethod color ((fs full-shape))
  (slot-value fs 'newcolor))

(defmethod set-color ((fs full-shape) color)
  (setf (slot-value fs 'newcolor) color))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Třída triangle znova, zamezení nekonzistentnímu stavu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Je redefined, vyhodí warning

(defclass triangle (polygon)
  ())

(defmethod verticeA ((tr triangle))
  (first (items tr)))

(defmethod verticeB ((tr triangle))
  (second (items tr)))

(defmethod verticeC ((tr triangle))
  (third (items tr)))

(defmethod set-verticeA ((tr triangle) pt)
  (setf (first (items tr)) pt))

(defmethod set-verticeB ((tr triangle) pt)
  (setf (second (items tr)) pt))

(defmethod set-verticeC ((tr triangle) pt)
  (setf (third (items tr)) pt))

(defmethod set-items ((tr triangle) items)
  (if (= (length items) 3)
      (call-next-method tr items)
    (error "Cannot set less or more than 3 points for triangle vertices")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Vztah ellipse a circle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tyto třídy by měly být disjuktní, nemají společného nic
;Obě dvě jako potomky třídy shape, circle už tak je

(defclass ellipse (shape)
  ((fp1 :initform (make-instance 'point))
  (fp2 :initform (make-instance 'point))
  (major :initform (make-instance 'point))
  (minor :initform (make-instance 'point))))

(defmethod focal-point1 ((ell ellipse))
  (slot-value ell 'fp1))

(defmethod focal-point2 ((ell ellipse))
  (slot-value ell 'fp2))

(defmethod major-semiaxis ((ell ellipse))
  (slot-value ell 'major))

(defmethod minor-semiaxis ((ell ellipse))
  (slot-value ell 'minor))

(defmethod set-focal-point1 ((ell ellipse) pt)
  (setf (slot-value ell 'fp1) pt))

(defmethod set-focal-point2 ((ell ellipse) pt)
  (setf (slot-value ell 'fp2) pt))

(defmethod set-major-semiaxis ((ell ellipse) pt)
  (setf (slot-value ell 'major) pt))

(defmethod set-minor-semiaxis ((ell ellipse) pt)
  (setf (slot-value ell 'minor) pt))

;Kreslení ellipse s knihovnou mg neumím, ale musí se přepsat metody draw, do-draw a mg-set-params stačí volat call-next-method. 

;Geometrická transformace move, scale, rotate bude třeba aplikovat na všechny sloty ellipsy, kdy transformace půjde na jednotlivé body

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;left, top, right, bottom
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Třída shape nemá tyto geometrické vlastnosti, proto nic neudělá
(defmethod left ((s shape))
  s)

(defmethod top ((s shape)) 
  s)

(defmethod right ((s shape))
  s)

(defmethod bottom ((s shape))
  s)

;Bod je kreslený jako circle se středem bodu a poloměrem thickness bodu
;Otázkou je, co se má vracet, osobně bych nevracel nic, protože bod má svoje left, right, bottom a top jen jedno a to je tentýž bod.
(defmethod left ((p point))
 p)

(defmethod top ((p point))
  p)

(defmethod right ((p point))
  p)

(defmethod bottom ((p point))
  p)

;Třída circle má už tyto vlastnosti
(defmethod left ((c circle))
  (let ((r (make-instance 'point)))
    (set-x r (- (x (center c)) (radius c)))
    (set-y r (y (center c)))
    r))

(defmethod right ((c circle))
  (let ((r (make-instance 'point)))
    (set-x r (+ (x (center c)) (radius c)))
    (set-y r (y (center c)))
    r))

(defmethod top ((c circle))
  (let ((r (make-instance 'point)))
    (set-x r (x (center c)))
    (set-y r (- (y (center c)) (radius c)))
    r))

(defmethod bottom ((c circle))
  (let ((r (make-instance 'point)))
    (set-x r (x (center c)))
    (set-y r (+ (y (center c)) (radius c)))
    r))

;U ellipse je to major a minor semiaxis, akorát jsou dva body co reprezentují účeku hlavní a vedlejší a my máme jen jeden bod, od středu, tak na druhé straně od středu je druhý
(defmethod left ((ell ellipse))
  (major-semiaxis ell))

(defmethod top ((ell ellipse))
  (minor-semiaxis ell))

(defmethod right ((ell ellipse))
  (let ((r (make-instance 'point)))
    (set-x r (+ (x (center ell)) (point-distance (center ell) (major-semiaxis ell))))
    (set-y r (y (center ell)))
  r))

(defmethod bottom ((ell ellipse))
  (let ((r (make-instance 'point)))
    (set-x r (x (center ell)))
    (set-y r (+ (y (center ell)) (point-distance (center ell) (minor-semiaxis ell))))
    r))

(defmethod center ((ell ellipse))
  (let ((c (make-instance 'point)))
    (set-x c (/ (+ (x (focal-point1 ell)) (x (focal-point2 ell))) 2))
    (set-y c (/ (+ (y (focal-point1 ell)) (y (focal-point2 ell))) 2))
    c))

(defun point-distance (pt1 pt2)
  (sqrt (+ (expt (- (x pt1) (x pt2)) 2)
           (expt (- (y pt1) (y pt2)) 2))))


;; class EXTENDED-PICTURE (version 1), nefunguje intuitivně

(defclass extended-picture (picture)
  ((propagate-color-p :initform nil)))

(defmethod propagate-color-p ((ep extended-picture))
  (slot-value ep 'propagate-color-p))

(defmethod set-propagate-color-p ((ep extended-picture) value)
  (setf (slot-value ep 'propagate-color-p) value)
  ep)

(defmethod set-color ((ep extended-picture) value)
  (if (propagate-color-p ep)
      (dolist (item (items ep))
        (set-color item value)))
  (call-next-method))

;; class EXTENDED-PICTURE (version 2)

(defclass extended-picture2 (picture)
  ((propagate-color-p :initform nil)))

(defmethod propagate-color-p ((ep extended-picture2))
  (slot-value ep 'propagate-color-p))

(defmethod set-propagate-color-p ((ep extended-picture2) value)
  (setf (slot-value ep 'propagate-color-p) value)
  ep)

(defmethod draw ((ep extended-picture2) mgw)
  (if (propagate-color-p ep)
      (dolist (item (reverse (items ep)))
        (let ((original-color (color item)))
          (set-color item (color ep)) 
          (draw item mgw)
          (set-color item original-color))
        ep)
    (call-next-method)))


;; tests
#|
(setf w (make-instance 'window))
(setf sq (make-instance 'polygon))
(set-items sq (list (set-x (set-y (make-instance 'point) 100) 100)
                      (set-x (set-y (make-instance 'point) 100) 200)
                      (set-x (set-y (make-instance 'point) 150) 200)
                      (set-x (set-y (make-instance 'point) 150) 100)))
(set-color sq :yellow)
(set-filledp sq t)
(set-shape w sq)
(redraw w)

(setf tri (make-instance 'polygon))
(set-items tri (list (set-x (set-y (make-instance 'point) 100) 90)
                      (set-x (set-y (make-instance 'point) 100) 210)
                      (set-x (set-y (make-instance 'point) 50) 150)))
(set-color tri :red)
(set-filledp tri t)
(set-shape w tri)
(redraw w)

(setf ep (make-instance 'extended-picture))
(set-items ep (list tri sq))
(set-shape w ep)
(set-color ep :green)
(redraw w)

(propagate-color-p ep)
(set-propagate-color-p ep t)

(set-color ep :green)
(redraw w)

(set-propagate-color-p ep nil)
(redraw w)


(setf ep2 (make-instance 'extended-picture2))
(set-items ep2 (list tri sq))
(set-color sq :yellow)
(set-color tri :red)
(set-shape w ep2)
(redraw w)

(set-propagate-color-p ep2 t)
(propagate-color-p ep2)
(redraw w)

(set-color ep2 :green)
(redraw w)
(set-propagate-color-p ep2 nil)
(redraw w)
|#



