;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; 11_stacks_3.lisp - Zásobníkové programování
;;;
;;; Jazyk pro myšlený zásobníkový stroj.
;;; fáze 3 - Interpret Scheme: procedury
;;;
;;; Předchozí soubory musí být načteny.

#|
Směřujeme k vytvoření interpretu Scheme pro náš zásobníkový stroj.

V tomto souboru naprogramujeme možnost zavést procedury.
Budou to hodnoty (mohou se vyskytovat na zásobníku výsledků),
které ale půjde spustit podobně jako slova. 
Spuštění procedury umístěné na zásobníku výsledků se zařídí přesunutím
procedury zpět na programový zásobník. 
|#

;; Přesun z výsledkového zásobníku na zásobník programový slovem :execute.
;; Přesouvá se až na druhé místo, kdybychom před spuštěním chtěli ještě 
;; něco udělat. Když nechceme dělat nic, můžeme použít slovo :nop
;; (No Operation)

(define-word :nop (lambda ()))

(define-word :execute (lambda ()
                        (let ((old-top (pop *exec*)))
                          (push (pop *rslt*) *exec*)
                          (push old-top *exec*))))

;; Většinou ale nechceme dělat nic, takže si na to uděláme další slovo:
(define-word :exec '(:execute :nop))

;; Procedura je hodnota obsahující kód.
;; Reprezentujeme ji seznamem s prvním prvkem %proc.
;; Seznamy jako vykonatelné hodnoty na zásobníku exec jsme ještě
;; neměli. Vždy, když se na zásobníku objeví, bude to mít něco
;; společného s procedurami a Schemem.
;;
;; (se seznamy jsme už pracovali, ale vždy jen jako s daty. Když
;; se vyskytl seznam na programovém zásobníku, vždy se potlačilo 
;; jeho spuštění: :noexec list)

;; Když je procedura na vrcholu programového zásobníku, vezme se
;; její kód a dá se na zásobník jeden prvek po druhém.
;; Procedura je reprezentovaná seznamem (%proc . code),
;; kde code je jí kód v seznamu.

(defun procedurep (elem)
  (and (consp elem)
       (eql (car elem) '%proc)))

;;
;; Spuštění procedury (byla na vrcholu programového zásobníku):
;; funkce exec-proc
;;

(defun exec-proc (proc)
  (setf *exec* (append (cdr proc) *exec*)))

#|

;; exec-proc by ovšem šlo napsat v našem jazyce!
;; (netestováno):

(defun exec-proc (proc)
  (push proc *rslt*)
  (push :execproc *code*))

;; Seznam na vrcholu *rslt* prvek po prvku přeskládá na *exec*:
(define-word :execlst '(:dup :null? :if :drop :then
                                        :split :swap :execute :execlst :else))

;; Pomocí :revappend převrátí seznam na vrcholu *rslt*:
(define-word :reverse '(:noexec nil :revappend))

;; Přehodí tělo procedury z vrcholu zásobníku *rslt* na *exec*,
;; aby se poté vykonalo:
(define-word :execproc '(:cdr :reverse :execlst))

|#

;;
;; Krok vyhodnocení (úprava funkce z předchozí fáze)
;;

;; (vysvětlení k proměnné dspec:*redefinition-action* viz v předchozím souboru)
(setf dspec:*redefinition-action* :quiet)

(defun exec-step ()
  (let ((elem (pop *exec*)))
    (cond ((wordp elem) (exec-word elem))
          ((symbolp elem) (exec-symbol elem))
          ((procedurep elem) (exec-proc elem))
          (t (push elem *rslt*)))))

(setf dspec:*redefinition-action* :warn)

;; Definice aritmetických procedur:
(execute '(:noexec (%proc :+) :noexec + :bind))
(execute '(:noexec (%proc :swap :-) :noexec - :bind))
(execute '(:noexec (%proc :*) :noexec * :bind))
(execute '(:noexec (%proc :swap :/) :noexec / :bind))
(execute '(:noexec (%proc :=) :noexec = :bind))

#|

;; Příklady 

(execute '(5 (%proc 2 * :exec)))

;; faktoriál jako procedura: 

(execute '(:noexec (%proc :dup 0 := :if :drop 1 :then :dup 1 :- fact :exec :* :else)
           :noexec fact
           :bind))

(execute '(5 fact :exec))

|#

#|
Procedura může obsahovat libovolný kód, může si tedy dělat se zásobníky, co chce.
Můžeme ji ale přiblížit procedurám (funkcím) z vyšších programovacích jazyků
využitím parametrů. Například kód procedury s jedním parametrem by mohl vypadat takto:

:noexec x :bind ... kód využívající parametr x ... :unbind

Výsledek je o něco čitelnější. Například faktoriál:

(execute '(:noexec (%proc :noexec n :bind
                          n 0 := :if 1 :then n n 1 :- fact :exec :* :else
                          :unbind)
           :noexec fact
           :bind))

(execute '(5 fact :exec))

;; Více parametrů je třeba navazovat v obráceném pořadí.
;; např. výpočet druhé mocniny diskriminantu kvadratické rovnice s koeficienty
;; a, b, c:

(execute '(:noexec (%proc :noexec c :bind
                          :noexec b :bind
                          :noexec a :bind
                          b b :* 4 a c :* :* :-
                          :unbind
                          :unbind
                          :unbind)
           :noexec sqdiscr
           :bind))

|#

#|

;; Aplikace dané procedury na všechny prvky seznamu.
;; Tím se otestuje spuštění procedury dané jako data.

(define-word :mapcar '(:dup :null? :if :swap :drop 
                                       :then
                                       ;; kdybychom měli víc slov na manipulaci
                                       ;; se zásobníkem, nemuseli bychom tohle dělat
                                       ;; tak kostrbatě:
                                       :swap :dup :rot :split :rot- :swap :exec :rot-
                                       :mapcar :cons
                                       :else))

(execute '(:noexec (%proc 1 :+) :noexec (1 2 3) :mapcar))

;; A teď jako procedura s parametry a lokálními proměnnými:

(execute '(:noexec (%proc :noexec list :bind
                          :noexec fun :bind
                          list :null? :if :noexec () :then
                                          list :split :noexec cdr :bind
                                                      :noexec car :bind
                                                      car fun :exec
                                                      fun cdr mapcar :exec :cons 
                                                      :unbind
                                                      :unbind
                                                     :else
                          :unbind
                          :unbind)
           :noexec mapcar
           :bind))

(execute '(:noexec (%proc 1 :+) :noexec (1 2 3) mapcar :exec))

|#