;; -*- mode: lisp; encoding: utf-8; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; bitmap-viewer.lisp
;;;
;;; Jednoduché okno na zobrazování černobílých bitmap
;;;

#|
Použití:

(setf v (display-bitmap-viewer))

;; nyní lze otevřít obrázek tlačítkem "Open..."

;; Funkce pro čtení a nastavování bitmapy
;; Bitmapa je dvourozměrné pole obsahující hodnoty nil a t

(setf arr (bitmap-viewer-bitmap v)) ;získá bitmapu z okna
(set-bitmap-viewer-bitmap v arr)  ;nastaví bitmapu do okna

|#

(in-package "CL-USER")

(capi:define-interface bitmap-viewer ()
  ((image :initform nil)
   (bitmap :initform nil :reader bitmap-viewer-bmp))
  (:panes
   (viewer capi:output-pane
           :display-callback 'bitmap-viewer-display
           :horizontal-scroll t
           :vertical-scroll t
           :visible-min-width 250
           :visible-min-height 250
           :background :black)
   (controller capi:push-button-panel
               :items '(:open...)
               :callbacks '(bitmap-viewer-change-image)
               :callback-type :interface
               :print-function 'string-capitalize))
  (:layouts
   (main-layout capi:column-layout
                '(viewer controller)))
  (:default-initargs
   :layout 'main-layout
   :best-width 200
   :best-height 200))

(defmethod initialize-instance :after ((self bitmap-viewer) &key
                                       &allow-other-keys)
  (update-bitmap-viewer-enabled self))

(defun bitmap-viewer-update (interface)
  (with-slots (viewer image) interface
    (gp:invalidate-rectangle viewer)
    (capi:set-horizontal-scroll-parameters viewer :min-range 0 :max-range (if image (gp:image-width image) 0))
    (capi:set-vertical-scroll-parameters viewer :min-range 0 :max-range (if image (gp:image-height image) 0))
    (update-bitmap-viewer-enabled interface)))

(defun update-bitmap-viewer-enabled (interface)
  (with-slots (controller image) interface
    (if image
        (capi:set-button-panel-enabled-items
         controller
         :set t)
      (capi:set-button-panel-enabled-items
       controller
       :set t
       :disable '(:close)))))

(defun bitmap-viewer-display (pane x y width height)
  (with-slots (image) (capi:top-level-interface pane)
    (when image
      (when (gp:rectangle-overlap x y (+ x width) (+ y height)
                                  0 0 (gp:image-width image) (gp:image-height image))
        (gp:draw-image pane image 0 0)))))

(defvar *image-file-filters* '("Bitmap" "*.bmp;*.dib" 
                               "GIF"    "*.gif"  
                               "JPEG"   "*.jpg;*.jpeg" 
                               "PNG"    "*.png" 
                               "TIFF"   "*.tif;*.tiff"))

(defvar *image-file-types* '("bmp" "dib" "gif" "jpg" "jpeg" "png" "tif" "tiff"))

(defun bitmap-viewer-change-image (interface)
  (with-slots (viewer image bitmap) interface
    (let ((file (capi:prompt-for-file "Choose a bitmap"
                                      :pathname (pathname-location #.(current-pathname))
                                      :filter (second *image-file-filters*)
                                      :filters *image-file-filters*
                                      :ok-check #'(lambda (file)
                                                    (member (pathname-type file) *image-file-types* :test 'equalp)))))
      (when (and file (probe-file file))
        (let ((external-image (gp:read-external-image file)))
          (when image
            (gp:free-image viewer image))
          (setf image (gp:load-image viewer external-image :editable t))
          (setf bitmap (%bitmap-viewer-bitmap interface))
          (bitmap-viewer-update interface))))))

(defun bitmap-viewer-close-image (interface)
  (with-slots (viewer image) interface
    (gp:free-image viewer (shiftf image nil))
    (bitmap-viewer-update interface)))

(defun get-image-bitmap (viewer access)
  (gp:image-access-transfer-from-image access)
  (let* ((w (gp:image-access-width access))
         (h (gp:image-access-height access))
         (arr (make-array `(,w ,h))))
    (dotimes (y h)
      (dotimes (x w)
        (setf (aref arr x y) (round
                              (color:color-red 
                               (color:unconvert-color 
                                viewer
                                (gp:image-access-pixel access x y)))))))
    arr))
    

(defun %bitmap-viewer-bitmap (interface)
  (let (image2 access)
    (with-slots (viewer image) interface
      (gp:with-pixmap-graphics-port (p viewer (gp:image-width image) (gp:image-height image))
        (gp:draw-image p image 0 0)
        (setf image2 (gp:make-image-from-port p))
        (setf access (gp:make-image-access viewer image2))
        (unwind-protect
            (get-image-bitmap viewer access)
          (gp:free-image-access access))))))

(defun set-image-bitmap (viewer access arr)
  (gp:image-access-transfer-from-image access)
  (let* ((w (min (gp:image-access-width access) (array-dimension arr 0)))
         (h (min (gp:image-access-height access) (array-dimension arr 1)))
         (colors (list (color:convert-color viewer (color:make-gray 0))
                       (color:convert-color viewer (color:make-gray 1)))))
    (dotimes (y h)
      (dotimes (x w)
        (setf (gp:image-access-pixel access x y)
              (elt colors (aref arr x y))))))
  (gp:image-access-transfer-to-image access))

(defun trans-logic-to-numbers-bmp (orig)
  (let ((result (make-array (array-dimensions orig) :element-type 'bit)))
    (dotimes (x (array-dimension orig 0))
      (dotimes (y (array-dimension orig 1))
        (setf (aref result x y) (if (aref orig x y) 1 0))))
    result))

#|
(trans-logic-to-numbers-bmp 
 (make-array '(2 3) :initial-contents '((nil t nil) (t t nil))))
|#

(defun trans-numbers-to-logic-bmp (orig)
  (let ((result (make-array (array-dimensions orig))))
    (dotimes (x (array-dimension orig 0))
      (dotimes (y (array-dimension orig 1))
        (setf (aref result x y) (= (aref orig x y) 1))))
    result))

#|
(trans-numbers-to-logic-bmp 
 (make-array '(2 3) :element-type 'bit
             :initial-contents '((0 1 0) (1 1 0))))
|#

(defun bitmap-viewer-bitmap (intf)
  (trans-numbers-to-logic-bmp (bitmap-viewer-bmp intf)))

;; Úprava pro LW6, kde nešlo použít image-access přímo na původní obrázek
(defun set-bitmap-viewer-bitmap (interface bitmap)
  (setf bitmap (trans-logic-to-numbers-bmp bitmap))
  (with-slots (viewer image (bitmap-slot bitmap)) interface
    (gp:clear-graphics-port viewer)
    (let ((new-image (gp:make-image-from-port viewer)))
      (when image
        (gp:free-image viewer image))
      (setf image new-image)
      (let ((access (gp:make-image-access viewer image)))
        (unwind-protect
            (set-image-bitmap viewer access bitmap)
          (gp:free-image-access access)))
      (setf bitmap-slot bitmap)
      (bitmap-viewer-update interface))))

(defun display-bitmap-viewer ()
  (capi:display (make-instance 'bitmap-viewer)))

#|
(display-bitmap-viewer)
|#

