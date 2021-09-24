;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 11_polygon-editor.lisp - příklad k přednášce 11
;;;;

#|

Jedná se o stejný zdrojový kód jako v souboru 08_polygon-editor.lisp, pouze 
upravený na knihovnu 11.lisp.

polygon-editor - příklad komplexnějšího použití knihovny omg

Kromě standardních souborů vyžaduje načíst soubory:
- 11_polygon-canvas.lisp
- 05_bounds.lisp
- 11_text-shape.lisp
- 11_button.lisp

|#

(defun random-color () 
  (color:make-rgb (random 1.0)
                  (random 1.0)
                  (random 1.0)))


(defclass polygon-editor (abstract-picture)
  ())

(defmethod editor-canvas ((e polygon-editor))
  (first (items e)))

(defmethod editor-polygon ((e polygon-editor))
  (canvas-polygon (editor-canvas e)))

(defmethod info-text ((e polygon-editor))
  (second (items e)))

(defmethod closedp-button ((e polygon-editor))
  (third (items e)))

(defmethod filledp-button ((e polygon-editor))
  (fourth (items e)))

(defmethod color-button ((e polygon-editor))
  (fifth (items e)))

(defmethod clear-button ((e polygon-editor))
  (sixth (items e)))

(defmethod buttons ((e polygon-editor))
  (cddr (items e)))

(defmethod update-info-text ((e polygon-editor))
  (let ((p (editor-polygon e)))
    (setf (text (info-text e))
          (format nil 
                  "Počet bodů: ~s; closedp: ~s; filledp: ~s; bounds: ~s~%color: ~s"
                  (length (items p))
                  (closedp p)
                  (filledp p)
                  (list (left p) (top p) (right p) (bottom p))
                  (color p)))
    e))

(defmethod initialize-instance :after ((e polygon-editor) &key)
  (do-set-items e
                (list
                 (scale (make-instance 'polygon-canvas) 2.5 (make-instance 'point))
                 (make-instance 'text-shape)
                 (make-instance 'button)
                 (make-instance 'button)
                 (make-instance 'button)
                 (make-instance 'button)))
  (setf (button-text (closedp-button e)) "Přepnout closedp")
  (add-event (closedp-button e) 'ev-button-click 'ev-closedp-click)
  (setf (button-text (filledp-button e)) "Přepnout filledp")
  (add-event (filledp-button e) 'ev-button-click 'ev-filledp-click)
  (setf (button-text (color-button e)) "Změnit barvu")
  (add-event (color-button e) 'ev-button-click 'ev-color-click)
  (setf (button-text (clear-button e)) "Vymazat")
  (add-event (clear-button e) 'ev-button-click 'ev-clear-click)
  (update-buttons e)
  (update-info-text e)
  (update-info-position e)
  (add-event (editor-canvas e) 'ev-poly-change 'ev-poly-change))

(defun update-ed-button (button prev-button canvas)
  (let ((c-bottom (bottom canvas)))
    ;; Vždy rozdíl nová-pozice - stará-pozice
    (move button
          (- (+ (if prev-button (right prev-button) 0)
                5)
             (left button))
          (- (+ c-bottom 5)
             (top button)))))

(defmethod update-buttons ((e polygon-editor))
  (let ((c (editor-canvas e)))
    (update-ed-button (closedp-button e) nil c)
    (update-ed-button (filledp-button e) (closedp-button e) c)
    (update-ed-button (color-button e) (filledp-button e) c)
    (update-ed-button (clear-button e) (color-button e) c)
    (update-ed-button (info-text e) (clear-button e) c)))

(defmethod update-info-position ((e polygon-editor))
  (let ((text (info-text e))
        (btn (closedp-button e)))
    (move text
          (- (left btn) (left text))
          (- (+ (bottom btn) 5)
             (top text))))
  e)

(defmethod ev-closedp-click ((e polygon-editor) sender)
  (setf (closedp (editor-polygon e))
        (not (closedp (editor-polygon e)))))

(defmethod ev-filledp-click ((e polygon-editor) sender)
  (setf (filledp (editor-polygon e))
        (not (filledp (editor-polygon e)))))

(defmethod ev-color-click ((e polygon-editor) sender)
  (setf (color (editor-polygon e))
        (random-color)))

(defmethod ev-clear-click ((e polygon-editor) sender)
  (setf (items (editor-polygon e)) '()))

(defmethod ev-poly-change ((e polygon-editor) sender)
  (update-info-text e))

#|

(setf w (make-instance 'window :shape (make-instance 'polygon-editor)))

|#
