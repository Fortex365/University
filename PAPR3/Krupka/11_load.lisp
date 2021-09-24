;; 11.load

#|
Načtením tohoto souboru načtete všechny soubory potřebné k práci s knihovnou OMG ve verzi
z 11. přednášky.

Adresář s knihovnou micro-graphics a ostatní potřebné soubory musí být ve stejném adresáři
jako tento soubor.

Pokud chcete načíst jinou verzi knihovny, nejprve ukončete LispWorks.
|#

(in-package "CL-USER")

(defsystem pp3-11 ()
  :members ("micro-graphics/load" "11" "05_bounds" "11_text-shape" "11_button")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(compile-system 'pp3-11 :load t)