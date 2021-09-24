; trida radio-button

(defclass radio-button (abstract-picture)
  ((selectedp :initform nil)))

(defmethod initialize-instance ((rb radio-button) &key)
  (let ((inner (set-radius (set-filledp (make-instance 'circle)
                                        t)
                           5))
        (outer (set-radius (make-instance 'circle)
                           10))
        (text (move (make-instance 'text-shape)
                    12 3))
        (inside (set-radius (set-filledp (make-instance 'circle)
                                         t)
                           10)))
    (call-next-method)
    (do-set-items rb (list inner outer text inside))
    rb))

(defmethod selectedp ((rb radio-button))
  (slot-value rb 'selectedp))

(defmethod do-set-selectedp ((rb radio-button) val)
  (setf (slot-value rb 'selectedp) val))

(defmethod set-selectedp ((rb radio-button) val)
  (changing rb)
  (do-set-selectedp rb val)
  (change rb))

(defmethod text ((rb radio-button))
  (text (third (items rb))))

(defmethod do-set-text ((rb radio-button) val)
  (set-text (third (items rb)) val))

(defmethod set-text ((rb radio-button) val)
  (changing rb)
  (do-set-text rb val)
  (change rb))

(defmethod draw ((rb radio-button) mgw)
  (when (selectedp rb)
    (draw (first (items rb)) mgw))
  (draw (second (items rb)) mgw)
  (draw (third (items rb)) mgw)
  rb)

; udalosti - klikani a hlaseni zmen

(defmethod solidp ((rb radio-button))
  t)


#|
(setf w (make-instance 'window))
(setf rb (make-instance 'radio-button))
(set-shape w rb)
(move rb 100 50)
(move rb -50 0)
(set-text rb "Ahoj")
(set-selectedp rb t)
(set-selectedp rb nil)
|#

; pomocna funkce - snadna konstrukce

(defun make-rb (text x y)
  (set-text (move (make-instance 'radio-button)
                  x y)
            text))

; trida radio-group

(defclass radio-group (picture)
  ((selected-index :initform -1)))

(defmethod radio-buttons ((rg radio-group))
  (labels ((rbs (list) 
             (let ((rbs '()))
               (dolist (item list)
                 (cond ((typep item 'radio-button) 
                        (setf rbs (cons item rbs)))
                       ((typep item 'abstract-picture) 
                        (setf rbs (append (reverse (rbs (items item))) rbs)))
                       (t nil)))
               (reverse rbs))))
    (rbs (items rg))))

(defmethod button-count ((rg radio-group))
  (length (radio-buttons rg)))

(defmethod selected-index ((rg radio-group))
  (slot-value rg 'selected-index))

(defmethod do-set-selected-index ((rg radio-group) val)
  (setf (slot-value rg 'selected-index) val)
  (dolist (rb (radio-buttons rg))
    (set-selectedp rb nil))
  (when (<= 0 val) 
    (set-selectedp (nth val (radio-buttons rg)) t)))

; nevybrano = -1
(defmethod set-selected-index ((rg radio-group) val)
  (unless (and (>= val -1) (< val (button-count rg)))
    (error "Index out of range. "))
  (changing rg)
  (do-set-selected-index rg val)
  (send-event rg 'ev-selected-index-changed)
  (change rg))

; udalosti - klikani a hlaseni zmen

(defmethod ev-mouse-down ((rg radio-group) sender clicked button position)
  (when (typep clicked 'radio-button)
    (set-selected-index rg (position clicked (radio-buttons rg))))
  (call-next-method))

; nepekny hack
(defmethod check-selection ((rg radio-group))
  (let* ((rbs (radio-buttons rg))
         (selected (if (<= 0 (selected-index rg)) 
                       (nth (selected-index rg) rbs)
                     nil))
         (changed (find-if (lambda (rb)
                             (or (and (selectedp rb) 
                                      (not (eql rb selected)))
                                 (and (not (selectedp rb))
                                      (eql rb selected))))
                           rbs)))
    (when changed
      (if (selectedp changed) 
          (set-selected-index rg (position changed rbs))
        (set-selected-index rg -1)))))

(defmethod ev-change ((rg radio-group) sender)
  (call-next-method)
  (when (zerop (change-level rg))
    (check-selection rg))
  rg)
  
    

; pomocne funkce pro testy

(defun make-point (x y)
  (move (make-instance 'point) x y))

(defun make-polygon (x-list y-list filledp closedp color)
  (set-closedp (set-filledp
                (set-color
                 (set-items (make-instance 'polygon)
                            (mapcar 'make-point x-list y-list))
                 color)
                filledp)
               closedp))
  

#|
(setf rg (make-instance 'radio-group))
(setf rbs (set-items (make-instance 'picture)
                     (list
                      (make-rb "Aaaa" 30 30)
                      (make-rb "Bbb" 30 60)
                      (make-rb "Cccc" 30 90)
                      (make-rb "Ddd" 30 120))))
(set-items rg (list rbs
                    (make-rb "E" 30 150)))
(set-items rg (list rbs
                    (make-rb "E" 30 150)
                    (make-polygon '(0 0 200 200) '(0 200 200 0) t t :red)))

(set-shape w rg)

(setf rb (third (radio-buttons rg)))
(set-selectedp rb t)
(set-selected-index rg 1)
(scale rg 3 (make-point 0 0))
|#

; trida test-window

(defclass test-window (abstract-window)
  ())

(defmethod initialize-instance ((w test-window) &key)
  (call-next-method)
  (do-set-shape w (set-items (make-instance 'picture)
                             (list
                              (move (make-instance 'text-shape)
                                    10 10)
                              (set-items (make-instance 'radio-group)
                                         (list
                                          (make-rb "Aaaa" 30 30)
                                          (make-rb "Bbb" 30 60)
                                          (make-rb "Cccc" 30 90)
                                          (make-rb "Ddd" 30 120))))))
  (set-delegate (second (items (shape w))) w)
  (add-event (second (items (shape w))) 'ev-selected-index-changed 'ev-selected-index-changed)
  
  (invalidate w)
  w)

(defmethod ev-selected-index-changed ((w test-window) sender)
  (set-text (first (items (shape w)))
            (format nil "~D" (selected-index sender)))
  w)

#|
(setf w (make-instance 'test-window))
(set-selected-index (second (items (shape w))) 1)
(set-selected-index (second (items (shape w))) -1)
(set-selectedp (first (items (second (items (shape w))))) t)
(set-selectedp (second (items (second (items (shape w))))) t)
(set-selectedp (third (items (second (items (shape w))))) t)
(set-selectedp (fourth (items (second (items (shape w))))) t)
(set-selectedp (fourth (items (second (items (shape w))))) nil)

|#


