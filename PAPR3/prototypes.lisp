;;
;; 1) Doplnění logické disjunkce a negace (OR, NOT)

;;
;; OR

[true add "OR" :value true]
[false add "OR" :value {(arg1) arg1}]

#|
TESTY:

[[true or true] name]
[[true or false] name]
[[false or false] name]
[[false or true] name]
|#

;;
;; NOT

[true add "NOT" :value false]
[false add "NOT" :value true]

#|
TESTY:

[[true not] name]
[[false not] name]
|#



;;
;; 2) Doplnění zprávy IS-NIHIL

[nihil add "IS-NIHIL" :value true]
[object add "IS-NIHIL" :value false]



;;
;; 3) Seznamy, prototyp tečkového páru a prázdný seznam.

;;
;; Odůvodnění: Neprázdný seznam nepotřebuje prototyp, protože tečkové páry jsou vlastně seznamy. Neboť v Common Lispu výraz (listp (cons 1 2)) je pravdivý.

;;
;; Prázdný seznam

[lobby add "EMPTY" :value [object clone]]
[empty set-name "EMPTY"]

;;
;; Tečkový pár ("seznam")

[lobby add "CONS" :value [object clone]]
[cons set-name "CONS"]
[cons add "CAR" :value nihil]
[cons add "CDR" :value empty]
[cons add "SETCONS" :value {(arg1 arg2) [self set-car arg1] [self set-cdr arg2]}]

#|
TESTY:

Tečkový pár (1 . 2):
[[[cons clone] setcons 1 :arg2 2] cdr]
|#



;;
;; 4) Zpráva IS-LIST

[cons add "IS-LIST" :value true]
[empty add "IS-LIST" :value true]
[object add "IS-LIST" :value false]

#|
TESTY:

[[[object clone] is-list] name]
[[[empty clone] is-list] name]
[[[cons clone] is-list] name]
|#



;;
;; 5) Zpráva LENGTH

[empty add "LENGTH" :value [0 esoteric]]
[cons add "LENGTH" :value {() [one + [[self cdr] length]]}]

#|
TESTY:

[[[empty clone] length] name]
[[[cons clone] length] name]

List (1 2):
[[[[[cons clone] set-car 1] set-cdr [[cons clone] set-car 2]] length] name]
|#



;;
;; 6) Práce se seznamy

;;
;; APPEND

[empty add "APPEND" :value {(arg1) [[arg1 is-list] if-true {() arg1} 
                                        :else {() [[cons clone] set-car arg1]}]}]
[cons add "APPEND" :value {(arg1) [[cons clone] setcons [self car] :arg2 [[self cdr] append arg1]]}]

#|
TESTY:

[[cons clone] append [cons clone]]
[[empty clone] append [empty clone]]
|#

;;
;; REMOVE

[empty add "REM" :value empty]
[cons add "REM" :value {(arg1) [[arg1 equals [self car]] if-true {() [[self cdr] rem arg1]}
                                :else {() [[cons clone] setcons [self car] :arg2 [[self cdr] rem arg1]]}]}]

#|
TESTY:

[[empty clone] rem]
[[cons clone] rem 1]
|#



;;
;; 9) Operace s esoterickými čísly

;;
;; Násobení

[zero add "*" :value zero]
[one add "*" :value {(arg1) [[[self super] * arg1] + arg1]}]

#|
TESTY:

[[[2 esoteric] * [3 esoteric]] name]
|#

;;
;; Nerovnosti

[zero add "<" :value {(arg1) [[arg1 equals zero] not]}]
[one  add "<" :value {(arg1) [arg1 is [self succ]]}]

[zero add ">" :value false]
[one  add ">" :value {(arg1) [self is [arg1 succ]]}]

#|
TESTY:

[[[2 esoteric] < one] name]
[[[2 esoteric] > one] name]
|#

;;
;; Rovnost

[zero add "=" :value {(arg1) [self equals arg1]}]

#|
TESTY:

[[[2 esoteric] = one] name]
[[[1 esoteric] = one] name]
|#


