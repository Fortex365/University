;(1)Definujte spojky NOT a OR

;Nejprve pro spojku OR
;Zápis v lambda-kalkulu, budu používat L jako symbol pro řecké písmeno lambdy, jelikož se zde nedá napsat.
;Vypadalo by to poté nějak takto:

;---------------------
;OR := Lx.Ly.x y x
;---------------------

;Lxy.IF x x y
;IF := Lpca.pca

;Když převedeme i IF do lambda-kalkulu:
;Lxy.IF x x y -> Lxy.Lpca.pca x x y


;Pro spojku NOT
;-----------------------------
;NOT := Lx.x FALSE TRUE
;-----------------------------

;FALSE := Lxy.y
;TRUE := Lxy.x

;Lx.x FALSE TRUE -> Lx.x Lxy.y Lxy.x
;V tomto bodě se mi to už více rozvádět nechce, definované spojky NOT a OR v lambda-kalkulu jsem uvedl.




;(2) Pomocí výrazu <= definujte test na rovnost čísel. 
;(Popravdě bych chtěl říct, že téhle úloze rozumím z těhle 4 nejmíň.)

;----------------------------------
;<= := Lm.Ln.ZERO (SUB m n)
;----------------------------------

;ZERO := Ln.n (Lx.FALSE) TRUE
;SUB := Lm.Ln.n PRED m
;PRED := Ln.Lf.Lx.n (Lg.Lh.h (g f)) (Lu.x) (Lu.u)



;(5)K práci se seznamy P potřebujeme prázdný seznam EMPTY a predikát na prázdný seznam EMPTY?

;-----------------------
;EMPTY := Lx. TRUE
;-----------------------
;Což tohle je nějaká reprezentace nilu, ne? A prázdný seznam je nil.

;--------------------------------------
;EMPTY? := IF EMPTY TRUE FALSE
;--------------------------------------




;(6) Lze předchozí úlohu vyřešit, že EMPTY (ekvivalence) FALSE?
;(Asi se otočí jenom logika?)

;-----------------------
;EMPTY := Lx. FALSE
;-----------------------

;--------------------------------------
;EMPTY? := IF EMPTY FALSE TRUE
;--------------------------------------



