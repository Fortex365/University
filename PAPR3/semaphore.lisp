;---------------------------------------
;
;Je potřeba, aby byly načteny soubory
;05.lisp, knihovna mg, light.lisp
;
;Autor: Lukáš Netřeba
;Datum: 23.11.2020
;---------------------------------------


(defclass semaphore (picture)
  ((semaphore-type :initform :vehicle)
   (semaphore-phase :initform 0)))

;----------------------------------------
;Gettery
;;;;;;;;;

(defmethod semaphore-type ((s semaphore))
  (slot-value s 'semaphore-type))

(defmethod semaphore-phase ((s semaphore))
  (slot-value s 'semaphore-phase))

;Počet fází typu semaforu
(defmethod phase-count ((s semaphore))
  (cond ((vehiclep s) 4)
        ((pedestrianp s) 2)
        (t (error "Invalid semaphore type."))))

;----------------------------------------------------------------------
;Pomocné predikáty, pro přehlednost kódu
;
;Převzaté při konzultaci během návrhu od spolužáka Michal Bezděk,
;pouze tyto dvě funkce, z hlediska čitelnosti kódu.
;Z hlediska správnosti si myslím, že mají být jako funkce,
;ne metody (jako jeho řešení).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun vehiclep (s)
  (eql (semaphore-type s) :vehicle))

(defun pedestrianp (s)
  (eql (semaphore-type s) :pedestrian))

;------------------------------------------------------------------------------
;Settery
;;;;;;;;;

(defmethod set-semaphore-type ((s semaphore) type)
  (unless (or (eql type :vehicle) (eql type :pedestrian))
    (error "Invalid semaphore type."))
  (setf (slot-value s 'semaphore-type) type)
  (cond ((eql type :pedestrian) (progn
                                  (initialize-pedestrian s)
                                  (reset-semaphore-phase s)
                                  s))
        ((eql type :vehicle) (progn 
                               (back-from-pedestrian-to-vehicle s) 
                               (reset-semaphore-phase s) 
                               s))))

(defmethod set-semaphore-phase ((s semaphore) phase)
  (cond ((vehiclep s) (if (and (>= phase 0) (< phase 4)) 
                          (progn 
                            (setf (slot-value s 'semaphore-phase) phase) 
                            (set-semaphore-light-by-phase-vehicle s phase)
                            s)
                        (error "Invalid semaphore phase.")))
        ((pedestrianp s) (if (and (>= phase 0) (< phase 2)) 
                             (progn 
                               (setf (slot-value s 'semaphore-phase) phase) 
                               (set-semaphore-light-by-phase-pedestrian s phase) 
                               s)
                           (error "Invalid semaphore phase.")))
        (t (error "Invalid semaphore phase."))))

;--------------------------------------------------
;Pomocná metoda setterům
;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod reset-semaphore-phase ((s semaphore))
  (setf (slot-value s 'semaphore-phase) 0)
  (set-semaphore-light-by-phase s 0)
  s)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Inicializace
;;;;;;;;;;;;;;
(defmethod initialize-instance ((s semaphore) &key)
  (call-next-method)
  (set-items s (list 
                (set-radius (move (make-instance 'light) 100 100) 25)
                (toggle (set-radius (move (set-on-color (make-instance 'light) :orange) 100 150) 25))
                (toggle (set-radius (move (set-on-color (make-instance 'light) :green) 100 200) 25))
                (set-color (set-filledp (set-items (make-instance 'polygon) 
                                                   (list (move (make-instance 'point) 65 65)
                                                         (move (make-instance 'point) 65 235)
                                                         (move (make-instance 'point) 135 235)
                                                         (move (make-instance 'point) 135 65))) t) :skyblue))))

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Pomocné inicializační metody, pokud se mění typ semaforu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod initialize-pedestrian ((s semaphore))
  (set-items s (list
                (move (set-radius (make-instance 'light) 25) 100 100)
                (toggle (set-radius (move (set-on-color (make-instance 'light) :green) 100 150) 25))
                (set-color (set-filledp (set-items (make-instance 'polygon) 
                                                   (list (move (make-instance 'point) 65 65)
                                                         (move (make-instance 'point) 65 185)
                                                         (move (make-instance 'point) 135 185)
                                                         (move (make-instance 'point) 135 65))) t) :skyblue)))
  s)

;Kdyby bylo potřeba z pedestrianu to změnit zpátky
(defmethod back-from-pedestrian-to-vehicle ((s semaphore))
  (set-items s (list
                (set-radius (move (make-instance 'light) 100 100) 25)
                (toggle (set-radius (move (set-on-color (make-instance 'light) :orange) 100 150) 25))
                (toggle (set-radius (move (set-on-color (make-instance 'light) :green) 100 200) 25))
                (set-color (set-filledp (set-items (make-instance 'polygon) 
                                                   (list (move (make-instance 'point) 65 65)
                                                         (move (make-instance 'point) 65 235)
                                                         (move (make-instance 'point) 135 235)
                                                         (move (make-instance 'point) 135 65))) t) :skyblue)))
  s)

;--------------------------------------------------------
;Fáze semaforů
;;;;;;;;;;;;;;;;

(defmethod next-phase ((s semaphore))
  (cond ((vehiclep s) (do-next-phase-vehicle s))
         ((pedestrianp s) (do-next-phase-pedestrian s))
         (t (error "Invalid semaphore type.")))
  s)

(defmethod set-semaphore-light-by-phase ((s semaphore) phase)
  (cond ((vehiclep s) (set-semaphore-light-by-phase-vehicle s phase))
        ((pedestrianp s) (set-semaphore-light-by-phase-pedestrian s phase))
        (t (error "Invalid semaphore type.")))
  (set-semaphore-phase s phase)
  s)

;------------------------------------------------
;Rozdělovací metoda fází typu vehicle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod do-next-phase-vehicle ((s semaphore))
  (let ((count (semaphore-phase s)))
    (incf count)
    (setf count (rem count 4))
    (set-semaphore-light-by-phase-vehicle s count)
    (set-semaphore-phase s count)
        s))

(defmethod set-semaphore-light-by-phase-vehicle ((s semaphore) phase)
  (cond ((= phase 0) (vehicle-phase-0 s))
           ((= phase 1) (vehicle-phase-1 s))
           ((= phase 2) (vehicle-phase-2 s))
           ((= phase 3) (vehicle-phase-3 s)))
  s)
  

;----------------------------------------------
;Pomocné metody pro přehlednost,
;použitelné pouze pro semafor typu vehicle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod top-light ((s semaphore))
  (first (items s)))

(defmethod mid-light ((s semaphore))
  (second (items s)))

(defmethod bot-light ((s semaphore))
  (third (items s)))

;----------------------------------------------
;Jednotlivé metody starající se o toggle světel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Z červené na červenou+oranžovou
(defmethod vehicle-phase-1 ((s semaphore))
  (turn-on (top-light s))
  (turn-on (mid-light s))
  (turn-off (bot-light s))
  s)

;Přepisuje stav z červené+oranžová na zelenou
(defmethod vehicle-phase-2 ((s semaphore))
  (turn-off (top-light s))
  (turn-off (mid-light s))
  (turn-on (bot-light s))
  s)

;Přepisuje stav ze zelené na oranžovou
(defmethod vehicle-phase-3 ((s semaphore))
  (turn-off (top-light s))
  (turn-on (mid-light s))
  (turn-off (bot-light s))
  s)


;Přepisuje stav z oranžové na červenou
(defmethod vehicle-phase-0 ((s semaphore))
  (turn-on (top-light s))
  (turn-off (mid-light s))
  (turn-off (bot-light s))
  s)


;--------------------------------------------------
;Rozdělovací metoda fází typu pedestrian
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod do-next-phase-pedestrian ((s semaphore))
  (let ((count (semaphore-phase s)))
    (incf count)
    (setf count (rem count 2))
    (set-semaphore-light-by-phase-pedestrian s count)
    (set-semaphore-phase s count)
    s))

(defmethod set-semaphore-light-by-phase-pedestrian ((s semaphore) phase)
  (cond ((= phase 0) (pedestrian-phase-0 s))
           ((= phase 1) (pedestrian-phase-1 s)))
  s)

;----------------------------------------------
;Jednotlivé metody starající se o toggle světel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Přepisuje se ze zelené na červenou
(defmethod pedestrian-phase-0 ((s semaphore))
  (let ((new-items (copy-list (items s))))
    (turn-on (first new-items))
    (turn-off (second new-items))
    (set-items s new-items)
    s))

;Přepisuje se ze červené na zelenou
(defmethod pedestrian-phase-1 ((s semaphore))
  (let ((new-items (copy-list (items s))))
    (turn-off (first new-items))
    (turn-on (second new-items))
    (set-items s new-items)
    s))

#|
Testy:

(setf s (make-instance 'semaphore))
(setf w (make-instance 'window))
(set-shape w s)
(redraw w)

(next-phase s)
(redraw w)
(phase-count s)

(move s 20 20)

(set-semaphore-type s :pedestrian)
(set-semaphore-type s :vehicle)
|#



;------------------
;Crossroads
;;;;;;;;;;;;

(defclass crossroads (picture)
  ((crossroads-phase :initform 0)
   (program :initform '())))

;Předpokládá se, že se bude do items zadávat do seznamu prvně semafory,
;poté až ostatní objekty jako třeba nějaké silnice.

;A fáze semaforů v jednotlivých fázích programu jsou zadané taky postupně.
;Jedná se o paralelní procházení seznamu!

;Příklad items (<semaphore> <semaphore> <polygon>)
;a programem ((0 1) (1 2) ...)
;=> první semafor bude ve fázi 0, druhý semafor ve fázi 1

;--------------------------------------------
;Gettery
;;;;;;;;;;

(defmethod crossroads-phase ((c crossroads))
  (slot-value c 'crossroads-phase))

(defmethod program ((c crossroads))
  (slot-value c 'program))

(defmethod phase-count ((c crossroads))
  (length (program c)))

(defmethod semaphores ((c crossroads))
  (semaphores-help c))

(defun semaphores-help-deep (pip)
  (apply #'append
         (mapcar #'semaphores-help
                 (remove-if-not #'(lambda (s)
                                    (typep s 'compound-shape)) 
                                (items pip)))))
    
(defun semaphores-help (item)
  (if (typep item 'semaphore)
      (list item)
    (semaphores-help-deep item)))

#|
(setf p (set-items (make-instance 'picture) (list (make-instance 'semaphore))))
(setf p2 (set-items (make-instance 'picture)
                                (list 
                                 (set-items (make-instance 'picture) (list (make-instance 'semaphore) (make-instance 'semaphore))))))
(setf c (make-instance 'crossroads))
(set-items c (list p p2))
(semaphores c)
|#

;--------------------------------------------------
;Settery
;;;;;;;;;

(defmethod set-crossroads-phase ((c crossroads) phase)
  (unless (and (>= phase 0) (< phase (length (program c))))
    (error "Invalid phase count."))
  (setf (slot-value c 'crossroads-phase) phase)
  (set-semaphores-by-crossroad-phase c (nth phase (program c)))
  c)

(defmethod set-program ((c crossroads) prg)
  (setf (slot-value c 'program) prg)
  c)

;---------------------------------------------------
;Next phase
;;;;;;;;;;;;

(defmethod next-phase ((c crossroads))
  (let ((phase (crossroads-phase c)))
    (incf phase)
    (setf phase (rem phase (length (program c))))
    (set-crossroads-phase c phase)
    c))

(defmethod set-semaphores-by-crossroad-phase ((c crossroads) prg-sublist)
  (let ((new-items (copy-list (items c))))
        (setf new-items (mapcar (lambda (semaphore phase) (set-semaphore-light-by-phase semaphore phase))
                                new-items prg-sublist))
        (set-items c (append new-items (nthcdr (length prg-sublist) (copy-list (items c)))))
        c))

;-----------------------------------------------------------------------------------------
;Inicializace crossroads
;;;;;;;;;;;;;;;;;;;;;;;;;

(defmethod initialize-instance ((c crossroads) &key)
  (call-next-method)
  (set-items c '())
;  (set-items c (list (make-instance 'semaphore) (move (make-instance 'semaphore) 200 0) 
;                     (set-filledp (set-items (make-instance 'polygon)
;                                             (list (move (make-instance 'point) 0 0)
;                                                   (move (make-instance 'point) 400 0)
;                                                   (move (make-instance 'point) 400 300)
;                                                   (move (make-instance 'point) 0 300))) t)))
; (set-program c '((0 2) (0 3) (1 0) (2 0) (3 0) (0 1))))
 (set-program c '()))

#|
Testy pokud je nastavená grafika v initialize-instance

(setf c (make-instance 'crossroads))
(setf w (make-instance 'window))
(set-shape w c)

(redraw w)
(next-phase c)
(phase-count c)

|#
  






    
  




            

      
          
         

                              
 