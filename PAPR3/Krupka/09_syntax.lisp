;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojový soubor k učebnímu textu M. Krupka: Objektové programování
;;;;
;;;; Kapitola 9, Prototypy 1 - syntax pro posílání zpráv
;;;;


#|

Po načtení souboru bude možné posílat zprávy v syntaxi

[obj message arg1 ...]

místo

(send obj 'message arg1 ...)

Na konci jsou některé testy z 09_prototypes.lisp přepsané do nové syntaxe.

Vyžaduje načtený soubor 09_prototypes.lisp

|#

;; Modifikace syntaxe Lispu (rozšíření readeru), aby rozuměl hranatým závorkám.
;; výraz [obj message x y z ...] se přečte jako (send obj 'message x y z ...)
;; Je ale třeba vyhodnocovat v Listeneru, F8 apod. na tyto výrazy nefunguje
;; (v principu to jde v LispWorks opravit, ale nebudeme to dělat).
(defun left-brack-reader (stream char)
  (declare (ignore char))
  (let* ((list (read-delimited-list #\] stream t))
         (object (first list))
         (message (second list))
         (arguments (cddr list)))
    (list* 'send object (list 'quote message) arguments)))

(set-macro-character #\[ 'left-brack-reader)

(defun right-brack-reader (stream char)
  (declare (ignore stream char))
  (error "Non-balanced #\\] encountered."))

(set-macro-character #\] 'right-brack-reader)

#|
;;Test:
'[a b c d]
|#

;; Hack, aby editor rozuměl hranatým a složeným závorkám
;; (děkuji anonymnímu studentovi)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\[ #\{) 2)
(editor::set-vector-value
 (slot-value editor::*default-syntax-table* 'editor::table) '(#\] #\}) 3)



#|
(send *object* 'name)
[*nihil* name]
[*nihil* test]

'[[*nihil* super] name]
[[*nihil* super] name]
|#

                                       
#|
[*object* equals *object*]
[*nihil* equals *nihil*]
[*nihil* equals *object*]
(setf obj1 [[*object* clone] set-name "NEW-OBJECT"])
[obj1 name]
[obj1 remove "NAME"]
[obj1 name]
[[*object* clone] is *object*]
[*nihil* is *nihil*]
(setf obj2 [*object* clone])
[obj2 is *object*]
(setf obj3 [*object* clone])
[obj3 is obj2]
|#

