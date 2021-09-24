;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; ZdrojovĂ˝ soubor k pĹ™edmÄ›tu Paradigmata programovĂˇnĂ­ 3
;;;;
;;;; PĹ™ednĂˇĹˇka 11, knihovna OMG, verze 2.0
;;;;

#| 
PĹ™ed naÄŤtenĂ­m souboru naÄŤtÄ›te knihovnu micro-graphics
Pokud pĹ™i naÄŤĂ­tĂˇnĂ­ (kompilaci) dojde k chybÄ› 
"Reader cannot find package MG",
znamenĂˇ to, Ĺľe knihovna micro-graphics nenĂ­ naÄŤtenĂˇ.
|#

#|

Soubor 08.lisp je psĂˇn tak, aby se dal relativnÄ› snadno pĹ™evĂ©st do jinĂ˝ch
jazykĹŻ. Ukazuje tedy "generickĂ˝" zpĹŻsob, jak podobnĂ© Ăşkoly Ĺ™eĹˇit, bez
vyuĹľitĂ­ zvlĂˇĹˇtnostĂ­ jednotlivĂ˝ch jazykĹŻ.

Tento soubor pĹ™edstavuje novou verzi kĂłdu z 08.lisp s vyuĹľitĂ­m specialit
Common Lispu (s vĂ˝jimkou vĂ­cenĂˇsobnĂ© dÄ›diÄŤnosti).

Dejte si vedle sebe soubor 08.lisp a tento soubor a porovnejte rozdĂ­ly.

VĂ˝hody tĂ©to verze by mÄ›ly bĂ˝t patrnĂ© z testĹŻ na konci tohoto souboru
i z dalĹˇĂ­ch pĹ™Ă­kladĹŻ. 
|#

#|

ObecnÄ› je knihovna stejnĂˇ jako 08.lisp. V implementaci jsou vyuĹľity
pokroÄŤilejĹˇĂ­ moĹľnosti Lispu. ZmÄ›ny jsou vesmÄ›s nekompatibilnĂ­

HlavnĂ­ Ăşpravy:

- volba :initarg u nÄ›kterĂ˝ch slotĹŻ kvĹŻli jednoduĹˇĹˇĂ­mu vytvĂˇĹ™enĂ­ objektĹŻ
- metoda initialize-instance pĹ™ijĂ­mĂˇ &key parametry z make-instance
  (nÄ›kterĂ© z nich jsou rovnou :initarg slotĹŻ, jinĂ© ne; popis viz nĂ­Ĺľe)
- volba :accessor nebo :reader u nÄ›kterĂ˝ch slotĹŻ, aby nebylo nutnĂ© definovat 
  metody pro vlastnosti objektĹŻ. NastavitelnĂ© vlastnosti jsou nynĂ­ mĂ­sta, 
  takĹľe k nastavovĂˇnĂ­ se pouĹľĂ­vĂˇ (setf (vlastnost objekt) ...) mĂ­sto 
  (set-vlastnost objekt ...)
- v Lispu nenĂ­ zvykem, aby nastavovĂˇnĂ­ pĹ™es setf vracelo nastavovanĂ˝
  objekt.
  NapĹ™Ă­klad (setf (color object) :green) nevracĂ­ object, ale :green.
- kde to bylo moĹľnĂ©, mĂ­sto (call-next-method) pouĹľity :before nebo :after
  metody 
- zruĹˇeny metody do-..., mĂ­sto nich pouĹľity kombinace metod (primĂˇrnĂ­ a
  :around metody).
- metody check-item pro sloĹľenĂ© grafickĂ© objekty jsou s vĂ˝hodou psanĂ© jako
  multimetody 
- na hlĂˇĹˇenĂ­ zmÄ›n se pouĹľĂ­vĂˇ makro with-change, metody changing a change
  se nevolajĂ­ pĹ™Ă­mo.
- v makru with-change takĂ© pouĹľĂ­vĂˇme speciĂˇlnĂ­ operĂˇtor unwind-protwct
  na oĹˇetĹ™enĂ­ chybovĂ˝ch situacĂ­. To je opravdovĂˇ novinka. PodobnĂ© nĂˇstroje
  jsou k dispozici ve vÄ›tĹˇinÄ› jazykĹŻ, kterĂ© pracujĂ­ s vĂ˝jimkami 
  (... kromÄ› C++ ...). ZajiĹˇĹĄujĂ­ provedenĂ­ Ăşklidu i v chybovĂ© situaci.
  V C# a JavÄ› jde o blok klĂ­ÄŤovĂ© slovo finally v bloku try


MOĹ˝NĂ‰ &KEY PARAMETRY FUNKCE MAKE-INSTANCE
-----------------------------------------

TĹĂŤDA OMG-OBJECT

:delegate  delegĂˇt


TĹĂŤDA SHAPE

:color      barva
:thickness  tlouĹˇĹĄka pera
:filledp    zda vĂ˝plĹ
:window     okno


TĹĂŤDA POINT

:x         kartĂ©zskĂˇ souĹ™adnice x
:y         kartĂ©zskĂˇ souĹ™adnice y
:xy        seznam (x y) - mĂˇ pĹ™ednost pĹ™ed pĹ™edchozĂ­mi
:r         polĂˇrnĂ­ souĹ™adnice r (default 0) - mĂˇ pĹ™ednost pĹ™ed pĹ™edchozĂ­mi,
           pokud je uvedeno spoleÄŤnÄ› s :phi
:phi       polĂˇrnĂ­ souĹ™adnice phi (default 0) - mĂˇ pĹ™ednost pĹ™ed pĹ™edchozĂ­mi,
           pokud je uvedeno spoleÄŤnÄ› s :r


TĹĂŤDA CIRCLE

:center-x  x-ovĂˇ souĹ™adnice stĹ™edu (default: 0)
:center-y  y-ovĂˇ souĹ™adnice stĹ™edu (default: 0)
:center-xy souĹ™adnice stĹ™edu ve tvaru (x y) - mĂˇ pĹ™ednost pĹ™ed 
           :center-x a :center-y
:radius    polomÄ›r


TĹĂŤDA COMPOUND-SHAPE

:items     seznam prvkĹŻ


TĹĂŤDA PICTURE

nic


TĹĂŤDA ABSTRACT-POLYGON

:closedp  vlastnost closedp
:items    jako v compound-shape, kaĹľdĂ˝ prvek navĂ­c mĹŻĹľe bĂ˝t seznam (x y)


TĹĂŤDA ABSTRACT-WINDOW

:background  barva pozadĂ­
:shape       grafickĂ˝ objekt (default nil)
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da omg-object
;;;

(defclass omg-object () 
  ((delegate :initform nil :accessor delegate :initarg :delegate)
   (change-level :reader change-level)
   (events :reader events :initform '((ev-changing . ev-changing) 
                                      (ev-change . ev-change)
                                      (ev-mouse-down . ev-mouse-down)))))

(defmethod initialize-instance :around ((obj omg-object) &key)
  ;; ManuĂˇlnÄ› zabrĂˇnĂ­me hlĂˇĹˇenĂ­ zmÄ›n ve vĹˇech :before, :after a primĂˇrnĂ­ch metodĂˇch:
  (setf (slot-value obj 'change-level) 1)
  (call-next-method)
  (setf (slot-value obj 'change-level) 0)
  obj)
  
(defmethod inc-change-level ((obj omg-object))
  (incf (slot-value obj 'change-level)))

(defmethod dec-change-level ((obj omg-object))
  (decf (slot-value obj 'change-level)))

;; Vlastnost events nastavuje delegĂˇt. TĂ­m urÄŤĂ­, jakĂ© udĂˇlosti
;; mu mĂˇ objekt posĂ­lat.
;; Prvky seznamu jsou pĂˇry (event . translation). event je standardnĂ­ nĂˇzev
;; udĂˇlosti (napĹ™. ev-change), translation je nĂˇzev zprĂˇvy, kterĂˇ se mĂˇ
;; reĂˇlnÄ› posĂ­lat (napĹ™. ev-circle1-change). Obvykle je stejnĂ˝ jako standardnĂ­.

(defmethod add-event ((obj omg-object) event translation)
  (remove-event obj event)
  (push (cons event translation)
        (slot-value obj 'events)))

(defmethod remove-event ((obj omg-object) event)
  (setf (slot-value obj 'events)
        (remove event (events obj) :key 'car)))

(defmethod event-translation ((obj omg-object) event)
  (cdr (find event (events obj) :key 'car)))

;; posĂ­lĂˇnĂ­ udĂˇlostĂ­: send-event

(defmethod send-event ((object omg-object) event &rest event-args)
  (let ((delegate (delegate object))
        (real-event (event-translation object event)))
    (when (and delegate real-event)
      (apply real-event delegate object event-args))))

;; V change a changing zmÄ›na poĹ™adĂ­ parametrĹŻ. NenĂ­ podstatnĂˇ, protoĹľe tyto
;; funkce se vÄ›tĹˇinou nevolajĂ­, ale pouĹľĂ­vĂˇ se makro with-change (viz nĂ­Ĺľe)
(defmethod changing ((object omg-object))
  (when (zerop (change-level object))
    (send-event object 'ev-changing))
    (inc-change-level object))

(defmethod change ((object omg-object))
  (dec-change-level object)
  (when (zerop (change-level object))
    (send-event object 'ev-change)))

(defmacro with-change (object &body body)
  (let ((obj-var (gensym "OBJECT")))
    `(let ((,obj-var ,object))
       (changing ,obj-var)
       (unwind-protect (progn ,@body)
         (change ,obj-var)))))

;; zĂˇkladnĂ­ udĂˇlosti

(defmethod ev-changing ((obj omg-object) sender)
  (changing obj))

(defmethod ev-change ((obj omg-object) sender)
  (change obj))

(defmethod ev-mouse-down 
           ((obj omg-object) sender clicked button position)
  (send-event obj 'ev-mouse-down clicked button position))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da shape
;;;

(defclass shape (omg-object)
  ((color :initform :black :accessor color :initarg :color)
   (thickness :initform 1 :accessor thickness :initarg :thickness)
   (filledp :initform nil :accessor filledp :initarg :filledp)))

;; Zde staÄŤĂ­ definovat :around metody, primĂˇrnĂ­ uĹľ jsou definovĂˇny
;; v defclass volbou :accessor
(defmethod (setf color) :around (value (shape shape)) 
  (with-change shape
    (call-next-method)))

(defmethod (setf thickness) :around (value (shape shape))
  (with-change shape
    (call-next-method)))

(defmethod (setf filledp) :around (value (shape shape))
  (with-change shape
    (call-next-method)))


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
Ve tĹ™Ă­dÄ› shape nenĂ­ definovĂˇna ĹľĂˇdnĂˇ geometrie objektĹŻ.
PrimĂˇrnĂ­ metody vĹŻbec nedefinujeme.
|#

(defmethod move :around ((shape shape) dx dy)
  (with-change shape
    (call-next-method))
  shape)

(defmethod rotate :around ((shape shape) angle center)
  (with-change shape
    (call-next-method))
  shape)

(defmethod scale :around ((shape shape) coeff center)
  (with-change shape
    (call-next-method))
  shape)


;;; PrĂˇce s myĹˇĂ­

;; KaĹľdĂ˝ objekt je defaultnÄ› solidp. PĹ™epsĂˇno ve tĹ™Ă­dÄ› abstract-picture
(defmethod solidp ((shape shape))
  t)

(defmethod solid-shapes ((shape shape))
  (if (solidp shape)
      (list shape)
    (solid-subshapes shape)))

;; PĹ™epsat ve tĹ™Ă­dĂˇch, kde solidp mĹŻĹľe bĂ˝t nil
;; (metody bychom takĂ© vĹŻbec nemuseli definovat)
(defmethod solid-subshapes ((shape shape))
  (error "Method has to be rewritten."))

(defmethod contains-point-p ((shape shape) point)
  (error "Method has to be rewritten."))

(defmethod mouse-down ((shape shape) button position)
  (send-event shape 'ev-mouse-down shape button position))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da point
;;;

(defclass point (shape) 
  ((x :initform 0 :accessor x :initarg :x) 
   (y :initform 0 :accessor y :initarg :y)))

(defmethod initialize-instance :after ((pt point) &key xy r phi)
  (when xy 
    (setf (x pt) (first xy)
          (y pt) (second xy)))
  (when (and r phi)
    (set-r-phi pt r phi))
  pt)

#|
PĹ™i zavolĂˇnĂ­ (setf (pt x) 1) se nejprve spustĂ­ :around metoda.
V rĂˇmci makra with-change zaĹ™Ă­dĂ­ inkrementaci poÄŤĂ­tadla na zaÄŤĂˇtku a 
jeho dekrementaci na konci. MezitĂ­m zavolĂˇ call-next-method. 

call-next-method zavolĂˇ nejprve vĹˇechny :before metody, pak nejspecifiÄŤtÄ›jĹˇĂ­
primĂˇrnĂ­ metodu (kterĂˇ mĹŻĹľe volat zdÄ›dÄ›nĂ© primĂˇrnĂ­ metody pĹ™es call-next-method)
a pak vĹˇechny :after metody (ty v tomto pĹ™Ă­padÄ› neexistujĂ­).  

Do :before metod si zvykneme dĂˇvat testy na prekondice (pokud jsme se rozhodli
je dÄ›lat).
|#

(defmethod (setf x) :around (value (point point))
  (with-change point
    (call-next-method)))

(defmethod (setf x) :before (value (point point))
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number")))

(defmethod (setf y) :around (value (point point))
  (with-change point
    (call-next-method)))

(defmethod (setf y) :before (value (point point))
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number")))

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
  (setf (x point) (* r (cos phi)))
  (setf (y point) (* r (sin phi))))

(defmethod set-r-phi :around ((point point) r phi) 
  (with-change point
    (call-next-method)))

(defmethod (setf r) (value (point point))
  (set-r-phi point value (phi point)))

(defmethod (setf r) :around (value (point point)) 
  (with-change point
    (call-next-method)))

(defmethod (setf phi) (value (point point))
  (set-r-phi point (r point) value))

(defmethod (setf phi) :around (value (point point)) 
  (with-change point 
    (call-next-method)))

;; NastavenĂ­ parametrĹŻ je netypickĂ© - mÄ›nĂ­me nastavenĂ­ parametru :filledp
;; ze zdÄ›dÄ›nĂ© metody, protoĹľe bod kreslĂ­me jako koleÄŤko
(defmethod set-mg-params :after ((pt point) mgw)
  (mg:set-param mgw :filledp t))

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
  (incf (x pt) dx)
  (incf (y pt) dy)
  pt)

(defmethod rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (incf (phi pt) angle)
    (move pt cx cy)
    pt))

(defmethod scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (setf (r pt) (* (r pt) coeff))
    (move pt cx cy)
    pt))

;; PrĂˇce s myĹˇĂ­

;; PomocnĂ© funkce (vzdĂˇlenost bodĹŻ)

(defun sqr (x)
  (expt x 2))

;; Multimetoda:
(defmethod point-dist ((pt1 point) (pt2 point))
  (sqrt (+ (sqr (- (x pt1) (x pt2)))
           (sqr (- (y pt1) (y pt2))))))

;; Multimetoda:
(defmethod contains-point-p ((shape point) (point point))
  (<= (point-dist shape point) 
      (thickness shape)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da circle
;;;

(defclass circle (shape) 
  ((center :reader center) 
   (radius :initform 1 :accessor radius :initarg :radius)))

(defmethod initialize-instance :after ((c circle) 
                                       &key (center-x 0) (center-y 0)
                                            (center-xy (list center-x center-y)))
  (setf (slot-value c 'center)
        (make-instance 'point
                       :xy center-xy
                       :delegate c)))

;;;
;;; Geometrie
;;;

(defmethod (setf radius) :before (value (c circle))
  (when (< value 0)
    (error "Circle radius should be a non-negative number")))

(defmethod (setf radius) :around (value (c circle))
  (with-change c
    (call-next-method)))

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
  (move (center c) dx dy))

(defmethod rotate ((c circle) angle center)
  (rotate (center c) angle center))

(defmethod scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (setf (radius c) (* (radius c) coeff)))

;; PrĂˇce s myĹˇĂ­

(defmethod contains-point-p ((circle circle) (point point))
  (let ((dist (point-dist (center circle) point))
        (half-thickness (/ (thickness circle) 2)))
    (if (filledp circle)
        (<= dist (radius circle))
      (<= (- (radius circle) half-thickness)
          dist
          (+ (radius circle) half-thickness)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da compound-shape
;;;

#|
TĹ™Ă­da compound-shape slouĹľĂ­ jako pĹ™edek sloĹľenĂ˝ch grafickĂ˝ch objektĹŻ, tedy 
tÄ›ch, co majĂ­ vlastnost items.

NepĹ™edpoklĂˇdĂˇme vytvĂˇĹ™enĂ­ pĹ™Ă­mĂ˝ch instancĂ­. PrĂˇce s vlastnostĂ­ items je
pĹ™ipravena, ale je zaĹ™Ă­zeno, aby items neĹˇlo nastavit - prekondice metody
set-shape nenĂ­ nikdy splnÄ›na.
|#

(defclass compound-shape (shape)
  ((items :initform '())))

(defmethod initialize-instance :after ((cs compound-shape) &key (items '() itemsp))
  (when itemsp
    (setf (items cs) items)))

(defmethod items ((shape compound-shape)) 
  (copy-list (slot-value shape 'items)))

;; MĂ­sto pĹŻvodnĂ­ho send-to-items obecnÄ›jĹˇĂ­ broadcast. DĹŻvodem je, Ĺľe
;; metody nemusĂ­ mĂ­t item jako prvnĂ­ argument.
(defmethod broadcast ((shape compound-shape) function)
  (dolist (item (items shape))
    (funcall function item)))

(defmethod check-item ((shape compound-shape) item)
  (error "Invalid compound-shape item"))

(defmethod do-check-items ((shape compound-shape) item-list)
  (dolist (item item-list)
    (check-item shape item)))

(defmethod check-items ((shape compound-shape) item-list)
  (error "Invalid items."))

(defmethod do-set-items ((shape compound-shape) value)
  (setf (slot-value shape 'items) (copy-list value)))

(defmethod do-set-items :after ((shape compound-shape) value)
  (broadcast shape (lambda (x) (setf (delegate x) shape))))

(defmethod (setf items) (value (shape compound-shape))
  (do-set-items shape value))

(defmethod (setf items) :before (value (shape compound-shape))
  (check-items shape value))

(defmethod (setf items) :around (value (shape compound-shape))
  (with-change shape
    (call-next-method)))

;;;
;;; GeometrickĂ© transformace
;;;
 
(defmethod move ((shape compound-shape) dx dy)
  (broadcast shape (lambda (item) (move item dx dy))))

(defmethod rotate ((shape compound-shape) angle center)
  (broadcast shape (lambda (item) (rotate item angle center))))

(defmethod scale ((shape compound-shape) coeff center)
  (broadcast shape (lambda (item) (scale item coeff center))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da abstract-picture
;;;

#|
U nÄ›kterĂ˝ch obrĂˇzkĹŻ nechceme, aby uĹľivatel mohl nastavovat items, protoĹľe
by je uvedl do nekonzistentnĂ­ho stavu (tĹ™eba u bulls-eye). Ty budou potomky
pĹ™Ă­mo tĂ©to tĹ™Ă­dy.

Proto nepĹ™episujeme metodu check-items.

Instance takovĂ˝ch tĹ™Ă­d budou s items pracovat pĹ™es internĂ­ funkci 
do-set-items (v obvyklĂ˝ch jazycĂ­ch by byla oznaÄŤena jako "protected").
|#

(defclass abstract-picture (compound-shape)
  ())

(defmethod check-item ((pic abstract-picture) item)
  (error "Invalid picture element type."))

;; Multimetoda
(defmethod check-item ((pic abstract-picture) (item shape))
  t)

;;;
;;; KreslenĂ­
;;;

(defmethod draw ((pic abstract-picture) mg-window)
  (dolist (item (reverse (items pic)))
    (draw item mg-window))
  pic)

;;;
;;; PrĂˇce s myĹˇĂ­
;;;

(defmethod solidp ((pic abstract-picture))
  nil)

(defmethod solid-subshapes ((shape abstract-picture))
  (mapcan 'solid-shapes (items shape)))

(defmethod contains-point-p ((pic abstract-picture) (point point))
  (find-if (lambda (item)
	     (contains-point-p item point))
	   (items pic)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da picture
;;;

#|
Tato tĹ™Ă­da povoluje u obrĂˇzkĹŻ libovolnĂ© nastavovĂˇnĂ­ items.
|#

(defclass picture (abstract-picture)
  ())

(defmethod check-items ((p picture) item-list)
  (do-check-items p item-list))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da abstract-polygon
;;; 

#|
U nÄ›kterĂ˝ch polygonĹŻ nechceme, aby uĹľivatel mohl nastavovat items, protoĹľe
by je uvedl do nekonzistentnĂ­ho stavu (tĹ™eba u ÄŤtyĹ™ĂşhelnĂ­ka). Ty budou potomky
pĹ™Ă­mo tĂ©to tĹ™Ă­dy.

Proto nepĹ™episujeme metodu check-items.

Instance takovĂ˝ch tĹ™Ă­d budou s items pracovat pĹ™es internĂ­ funkci 
do-set-items (v obvyklĂ˝ch jazycĂ­ch by byla oznaÄŤena jako "protected").
|#

#|
Proti tĹ™Ă­dÄ› shape obsahuje polygon novou grafickou vlastnost: closedp.
MusĂ­me ji tedy definovat (novĂ˝ slot, pĹ™Ă­stupovĂ© metody, doplnÄ›nĂ­ do 
set-mg-params).
|#

(defclass abstract-polygon (compound-shape)
  ((closedp :initform t :accessor closedp :initarg :closedp)))

#|
PrĂˇce s items

Polygon je moĹľnĂ© vytvĂˇĹ™et i takto:

(make-instance 'polygon :items '((0 0) (10 0) (10 10) (0 10)))

a podobnÄ› jim i items nastavovat. Proto pĹ™epĂ­Ĺˇeme metodu do-set-items:
|#

(defmethod make-poly-item ((item point))
  item)

(defmethod make-poly-item ((item list))
  (make-instance 'point :xy item))

(defmethod do-set-items ((poly abstract-polygon) items)
  ;; VolĂˇnĂ­ call-next-method s argumenty:
  (call-next-method poly (mapcar 'make-poly-item items)))

(defmethod check-item ((poly abstract-polygon) item)
  (error "Invalid polygon element type."))

;; Multimetoda!
(defmethod check-item ((poly abstract-polygon) (item point))
  t)

;; Povolujeme jako item i dvouprvkovĂ˝ seznam ÄŤĂ­sel
;; Multimetoda s volĂˇnĂ­m zdÄ›dÄ›nĂ© metody
(defmethod check-item ((poly abstract-polygon) (item list))
  ;; UkĂˇzka moĹľnostĂ­ typovĂ©ho systĂ©mu. DruhĂ˝ argument funkce typep
  ;; znamenĂˇ typ "dvouprvkovĂ˝ seznam obsahujĂ­cĂ­ ÄŤĂ­sla"
  (unless (typep item '(cons number (cons number null)))
    (call-next-method)))

;; Vlastnost closedp

(defmethod (setf closedp) :around (value (p abstract-polygon))
  (with-change p
    (call-next-method)))

;;;
;;; KreslenĂ­
;;;

(defmethod set-mg-params :after ((p abstract-polygon) mgw) 
  (mg:set-param mgw :closedp (closedp p)))

(defmethod polygon-coordinates ((p abstract-polygon))
  (let (coordinates)
    (dolist (point (reverse (items p)))
      (setf coordinates (cons (y point) coordinates)
            coordinates (cons (x point) coordinates)))
    coordinates))

(defmethod do-draw ((poly abstract-polygon) mg-window) 
  (mg:draw-polygon mg-window 
                   (polygon-coordinates poly))
  poly)

;;
;; contains-point-p pro polygon vyuĹľĂ­vĂˇ funkci
;; mg:point-in-polygon-p knihovny micro-graphics.
;;

(defmethod contains-point-p ((poly abstract-polygon) (point point))
  (mg:point-in-polygon-p (x point) (y point) 
                         (closedp poly)
                         (filledp poly) 
                         (thickness poly)
                         (polygon-coordinates poly)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da polygon
;;;

#|
Tato tĹ™Ă­da povoluje u polygonĹŻ libovolnĂ© nastavovĂˇnĂ­ items.
|#

(defclass polygon (abstract-polygon)
  ())

(defmethod check-items ((p polygon) item-list)
  (do-check-items p item-list))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da abstract-window
;;;

(defclass abstract-window (omg-object)
  ((mg-window :initform (mg:display-window))
   (shape :initform nil :reader shape)
   (background :initform :white :accessor background
               :initarg :background)))

;; Inicializace

(defmethod install-display-callback ((w abstract-window))
  (mg:set-callback (slot-value w 'mg-window)
		   :display (lambda (mgw)
                              (declare (ignore mgw))
                              (redraw w)))
  w)

(defmethod install-mouse-down-callback ((w abstract-window))
  (mg:set-callback 
   (slot-value w 'mg-window) 
   :mouse-down (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-mouse-down 
                  w
                  button 
                  (make-instance 'point :x x :y y))))
  w)

(defmethod install-callbacks ((w abstract-window))
  (install-display-callback w)
  (install-mouse-down-callback w)
  w)

(defmethod initialize-instance :after ((w abstract-window) &key (shape nil shapep))
  (when shapep (setf (shape w) shape))
  (install-callbacks w))

;; Vlastnosti

(defmethod can-set-shape-p ((w abstract-window) shape)
  nil)

(defmethod (setf shape) :before (shape (w abstract-window))
  (unless (can-set-shape-p w shape)
    (error "Cannot set shape")))

(defmethod (setf shape) (shape (w abstract-window))
  (when shape
    (setf (delegate shape) w))
  (setf (slot-value w 'shape) shape))

(defmethod (setf shape) :around (shape (w abstract-window))
  (with-change w
    (call-next-method)))

(defmethod (setf background) :around (color (w abstract-window))
  (with-change w
    (call-next-method)))

(defmethod redraw ((window abstract-window))
  (let ((mgw (slot-value window 'mg-window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window) mgw)))
  window)

;;;
;;; ZmÄ›ny
;;;

(defmethod invalidate ((w abstract-window))
  (mg:invalidate (slot-value w 'mg-window))
  w)

;; Proti minulĂ© verzi zmÄ›na poĹ™adĂ­ parametrĹŻ
(defmethod change :after ((w abstract-window))
  (invalidate w))

;;;
;;; KlikĂˇnĂ­
;;;

(defmethod find-clicked-shape ((w abstract-window) (position point))
  (when (shape w)
    (find-if (lambda (shape) (contains-point-p shape position))
             (solid-shapes (shape w)))))

(defmethod mouse-down-inside-shape ((w abstract-window) shape button position)
  (mouse-down shape button position)
  w)

(defmethod mouse-down-no-shape ((w abstract-window) button position)
  w)

(defmethod window-mouse-down ((w abstract-window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (mouse-down-inside-shape w shape button position)
      (mouse-down-no-shape w button position))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TĹ™Ă­da window
;;;

(defclass window (abstract-window)
  ())

(defmethod can-set-shape-p ((w window) shape)
  t)


#|

(setf ground (make-instance 'polygon
                            :filledp t
                            :color :green3
                            :items '((0 155) (297 155) (297 275) (0 275))))

(setf tree (make-instance 'picture
                          :items 
                          (list (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(83 63)
                                               :radius 11)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(82 75)
                                               :radius 18)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(67 90)
                                               :radius 15)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(90 97)
                                               :radius 20)
                                (make-instance 'circle
                                               :color :green2
                                               :filledp t
                                               :center-xy '(75 110)
                                               :radius 25)

                                (make-instance 'polygon
                                               :color :brown4
                                               :filledp t
                                               :items '((70 173) (77 75) (85 75) (90 175))))))

(setf sun (make-instance 'circle 
                         :center-xy '(225 38)
                         :radius 18
                         :color :gold
                         :filledp t))

(setf ravens (make-instance 'picture
                            :items (list (make-instance 'polygon
                                                        :filledp nil
                                                        :closedp nil
                                                        :thickness 4
                                                        :color :grey23
                                                        :items '((233 53) (245 47) (252 51) (260 48) (270 57)))
                                         (make-instance 'polygon
                                                        :filledp nil
                                                        :closedp nil
                                                        :thickness 4
                                                        :color :grey23
                                                        :items '((203 73) (215 67) (222 71) (230 68) (240 77)))
                                         (make-instance 'polygon
                                                        :filledp nil
                                                        :closedp nil
                                                        :thickness 4
                                                        :color :grey23
                                                        :items '((183 58) (195 52) (202 56) (210 53) (220 62))))))

(make-instance 'window
               :background :skyblue
               :shape (make-instance 'picture
                                     :items (list ravens tree ground sun)))

(move sun 0 40)
(rotate tree pi (make-instance 'point :x 90 :y 97))
(setf (color ground) :black)

|#