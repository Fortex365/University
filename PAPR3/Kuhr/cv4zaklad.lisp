;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; ZdrojovĂ˝ soubor k pĹ™edmÄ›tu Paradigmata programovĂˇnĂ­ 3
;;;;
;;;; PĹ™ednĂˇĹˇka 4, DÄ›diÄŤnost
;;;;

#|
PĹ™ed naÄŤtenĂ­m souboru naÄŤtÄ›te knihovnu micro-graphics
Pokud pĹ™i naÄŤĂ­tĂˇnĂ­ (kompilaci) dojde k chybÄ›
"Reader cannot find package MG",
znamenĂˇ to, Ĺľe knihovna micro-graphics nenĂ­ naÄŤtenĂˇ.
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da shape
;;;

#|
ObecnĂˇ tĹ™Ă­da vĹˇech grafickĂ˝ch objektĹŻ. Definuje a ÄŤĂˇsteÄŤnÄ› implementuje
to, co majĂ­ spoleÄŤnĂ©: vlastnosti souvisejĂ­cĂ­ s kreslenĂ­m (color, thickness,
filledp), geometrickĂ© transformace, kreslenĂ­.
|#

(defclass shape ()
  ((color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)))


;;;
;;; Vlastnosti souvisejĂ­cĂ­ s kreslenĂ­m
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
;;; KreslenĂ­
;;;

;;Pracujeme prĂˇvÄ› s tÄ›mi vlastnostmi, kterĂ© jsou ve tĹ™Ă­dÄ› definovĂˇny.
(defmethod set-mg-params ((shape shape) mgw) 
  (mg:set-param mgw :foreground (color shape))
  (mg:set-param mgw :filledp (filledp shape))
  (mg:set-param mgw :thickness (thickness shape))
  shape)

(defmethod do-draw ((shape shape) mgw) 
  shape)

;; ZĂˇkladnĂ­ chovĂˇnĂ­ pro kaĹľdĂ˝ grafickĂ˝ objekt
(defmethod draw ((shape shape) mgw)
  (set-mg-params shape mgw)
  (do-draw shape mgw))


;;;
;;; GeometrickĂ© transformace
;;;

#|
Ve tĹ™Ă­dÄ› shape nenĂ­ definovĂˇna ĹľĂˇdnĂˇ geometrie objektĹŻ, tak je sprĂˇvnĂ©,
kdyĹľ transformace nedÄ›lajĂ­ nic.
|#

(defmethod move ((shape shape) dx dy)
  shape)

(defmethod rotate ((shape shape) angle center)
  shape)

(defmethod scale ((shape shape) coeff center)
  shape)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da point
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
;;; KreslenĂ­
;;;

;; NastavenĂ­ parametrĹŻ je netypickĂ© - mÄ›nĂ­me nastavenĂ­ parametru :filledp
;; ze zdÄ›dÄ›nĂ© metody, protoĹľe bod kreslĂ­me jako koleÄŤko
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
;;; GeometrickĂ© transformace
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
;;; TĹ™Ă­da circle
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
;;; KreslenĂ­
;;;

(defmethod do-draw ((c circle) mg-window)
  (mg:draw-circle mg-window
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)


;;;
;;; GeometrickĂ© transformace
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
;;; TĹ™Ă­da compound-shape
;;;

#|
TĹ™Ă­da compound-shape slouĹľĂ­ jako pĹ™edek sloĹľenĂ˝ch grafickĂ˝ch objektĹŻ, tedy 
tÄ›ch, co majĂ­ vlastnost items.

NepĹ™edpoklĂˇdĂˇme vytvĂˇĹ™enĂ­ pĹ™Ă­mĂ˝ch instancĂ­. PrĂˇce s vlastnostĂ­ items je
pĹ™ipravena, ale je zaĹ™Ă­zeno, aby items neĹˇlo nastavit (metoda check-items
konÄŤĂ­ chybou) ani ÄŤĂ­st (slot items nenĂ­ inicializovĂˇn).

PodrobnĂ© vysvÄ›tlenĂ­, proÄŤ to dÄ›lĂˇme takto, je v textu.
|#

(defclass compound-shape (shape)
  (items))


;;;
;;; PrĂˇce s items
;;;

(defmethod items ((shape compound-shape)) 
  (copy-list (slot-value shape 'items)))

;; PomocnĂˇ zprĂˇva, posĂ­lĂˇ danou zprĂˇvu s danĂ˝mi argumenty vĹˇem prvkĹŻm
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
;;; GeometrickĂ© transformace
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
;;; TĹ™Ă­da picture
;;;

(defclass picture (compound-shape)
  ((items :initform '())))


;;;
;;; PrĂˇce s items
;;;

(defmethod check-item ((p picture) item)
  (unless (typep item 'shape)
    (error "Items of picture must be shapes.")))

(defmethod check-items ((p picture) items)
  (do-check-items p items))


;;;
;;; KreslenĂ­
;;;

(defmethod draw ((pic picture) mg-window)
  (dolist (item (reverse (items pic)))
    (draw item mg-window))
  pic)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da polygon
;;;

#|
Proti tĹ™Ă­dÄ› shape obsahuje polygon novou grafickou vlastnost: closedp.
MusĂ­me ji tedy definovat (novĂ˝ slot, pĹ™Ă­stupovĂ© metody, doplnÄ›nĂ­ do 
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
;;; PrĂˇce s items
;;;

(defmethod check-item ((p polygon) item)
  (unless (typep item 'point)
    (error "Items of polygon must be points.")))

(defmethod check-items ((p polygon) items)
  (do-check-items p items))


;;;
;;; KreslenĂ­
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
;;; TĹ™Ă­da window
;;;

#|
TĹ™Ă­da zĹŻstĂˇvĂˇ beze zmÄ›ny.
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

;
;1) triangle potomkem polygon
;


;
;2) empty-shape a full-shape potomky shape
;

;
;3) triangle s konzistentním stavem items
;


;
;4) Třída ellipse a vztah k circle
;


;
; Nové metody všem třídám left, top, right, bottom. Jak je definovat pro třídu 
; shape?
; Moct vynechat pro třídu ellipse.
;


;
; Třída extended-picture, potomkem třídy picture s vlastností propagate-color-p. 
; Její pravdivá hodnota, obrázek při přijetí zprávy set-color nastaví tuto barvu
; všem svým podobrázkům.
;
