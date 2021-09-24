(load (current-pathname "micro-graphics V2/load.lisp")) 
(load (current-pathname "Krupka/08.lisp"))
(load (current-pathname "Krupka/05_bounds.lisp"))
(load (current-pathname "Krupka/08_text-shape.lisp"))

(defvar *copy-action* 'c)
(defvar *paste-action* 'p)

;; CIRCLE
(defmethod copy ((original circle))
  (let ((new (make-instance 'circle)))
    (set-center new (make-point (+ (x original) 20) (+ (y original) 20)))
    (set-thickness new (thickness original))
    (set-filledp new (filledp original))
    (set-color new (color original))
    (set-radius new (radius original))
    new))

(defmethod set-center ((c circle) point)
  (unless (typep point 'point)
    (error "Argument must be type of point"))
  (setf (slot-value c 'center) point))

(defun make-point (x y)
  (let ((p (make-instance 'point)))
    (set-x p x)
    (set-y p y)
    p))

(defun make-circle (point radius)
  (unless (typep point 'point)
    (error "Argument must be type of point"))
  (let ((c (make-instance 'circle)))
    (set-center c point)
    (set-radius c radius)
    c))


;; CANVAS
(defclass canvas (picture)
  ((clipboard :initform nil)
   (clip-action :initform nil)))

(defmethod initialize-instance ((canvas canvas) &key)
  (call-next-method))
;  (let ((background (make-instance 'full-shape)))
;    (set-color background :white)
;    (set-items canvas (list background))))


(defmethod clipboard ((canvas canvas))
  (slot-value canvas 'clipboard))

(defmethod set-clipboard ((canvas canvas) value)
  (setf (slot-value canvas 'clipboard) value))

(defmethod clip-action ((canvas canvas))
  (slot-value canvas 'clip-action))

(defmethod set-clip-action ((canvas canvas) value)
  (setf (slot-value canvas 'clip-action) value))

(defmethod ev-mouse-down ((canvas canvas) sender clicked button position) 
  (cond ((typep clicked 'copy-button) (set-clip-action canvas *copy-action*))
        ((typep clicked 'paste-button) (set-clip-action canvas *paste-action*))
        (t (do-clipboard-action canvas clicked position))))

(defmethod do-clipboard-action ((canvas canvas) clicked position)
  (cond ((equal (clip-action canvas) *copy-action*) (copy-to-clipboard canvas clicked))
        ((equal (clip-action canvas) *paste-action*) (paste canvas position))))


(defmethod copy-to-clipboard ((canvas canvas) object)
  (if (not (typep object 'full-shape))
      (set-clipboard canvas (copy object))))

(defmethod paste ((canvas canvas) position)
  (if (not (equal (clipboard canvas) nil))
           (let ((object (copy (clipboard canvas))))
             (move object (x position) (y position))    
             (set-items canvas (append (list object) (items canvas))))))
    

;; GUI-BUTTON
(defclass gui-button (picture) 
  ((background :initform nil)
   (text :initform (make-text "Button"))))

(defun make-text (text)
  (let ((ts (make-instance 'text-shape)))
    (set-text ts text)
    (move ts 0 15)
    ts))
  

; Přebírá odpovědnost za události vyvolané některou z jeho komponent
(defmethod mouse-down ((gui-button gui-button) button position)
  ; Zavolá metodu ev-mouse-down nadřazeného objektu
  (send-event gui-button 'ev-mouse-down gui-button button position))

(defmethod text ((gui-button gui-button))
  (slot-value gui-button 'text))

(defmethod set-text ((gui-button gui-button) value)
  (setf (slot-value gui-button 'text) (make-text value)))


;; COPY-BUTTON
(defclass copy-button (gui-button) ())

(defun make-copy-button (text)
  (let ((button (make-instance 'copy-button)))
    (set-text button text)
    (move button 0 0)
    
    ; Při vykreslení radiobuttonu vykreslit jeho komponenty
    (set-items button (list (text button)))))


;; PASTE-BUTTON
(defclass paste-button (gui-button) ())

(defun make-paste-button (text)
  (let ((button (make-instance 'paste-button)))
    (set-text button text)
    (move button 0 0)
    
    ; Při vykreslení radiobuttonu vykreslit jeho komponenty
    (set-items button (list (text button)))))

#|
;; TRIANGLE
(defclass triangle (polygon) ())

(defun make-triangle (A B C)
  (let ((triangle (make-instance 'triangle)))
    (set-items triangle (list A B C))
    triangle))

(defmethod copy ((original triangle))
  (let ((new (make-instance 'triangle)))
    (set-items new '())
    (set-thickness new (thickness original))
    (set-filledp new (filledp original))
    (set-color new (color original))
    
    (dolist (point (items original))
      (set-items new (append (items new) (list (make-point (x point) (y point))))))
    
    (let ((x-offset (x (car (items new))))
          (y-offset (y (car (items new)))))

      (move new (- x-offset) (- y-offset))
      new)))
|#


;; MAIN

(defvar *win*)
(setf *win* (make-instance 'window))

(let* ((canvas (make-instance 'canvas))
       (copy (make-copy-button "Copy"))
       (paste (make-paste-button "Paste"))
       
       (circle (make-circle (make-point 50 60) 20)))
  
  (move paste 70 0)


  (set-filledp circle t)
  

  (set-items canvas (append (list circle copy paste) (items canvas)))
  (set-shape *win* canvas)
  (redraw *win*))

#|
(defclass full-shape (shape)
  ((color :initform :black)))

(defmethod color ((fs full-shape))
  (slot-value fs 'color))

(defmethod set-color ((fs full-shape) value)
  (setf (slot-value fs 'color) value)
  fs)

(defmethod set-mg-params ((fs full-shape) mg-window)
  (mg:set-param mg-window :background (color fs))
  fs)

(defmethod do-draw ((fs full-shape) mg-window)
  (mg:clear mg-window)
  fs)

(defmethod draw ((fs full-shape) mg-window)
  (set-mg-params fs mg-window)
  (do-draw fs mg-window))
|#