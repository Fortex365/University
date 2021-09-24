;Implementace bin stromu
(defun binary-tree-node (val left-child right-child)
  (list val left-child right-child))

(defun left-child (node)
  (cadr node))
(defun right-child (node)
  (caddr node))

;Potomci uzlu
(defun bt-node-children (node)
  (remove nil (cdr node)))

;Funkce vraci hodnotu v uzlu bin. stromu

(defun node-value (tree)
  (car tree))

;Pridani prvku

(defun my-adjoin (elem tree)
  (if (null tree)
      (binary-tree-node elem nil nil)
    (let ((val (node-value tree))
          (left (left-child tree))
          (right (right-child tree)))
      (cond ((= elem val) tree)
            ((< elem val) (binary-tree-node val
                                            (my-adjoin elem left)
                                            right))
            (t (binary-tree-node val
                                 left
                                 (my-adjoin elem right)))))))


#|
Jak bude vypadat vysledek?
(my-adjoin 15 (my-adjoin 5 (my-adjoin 10 NIL)))
|#

#|
UKOL 1
Naprogramujte funkci (bin-tree-height tree), ktera vraci vysku binarniho stromu.
|#

#|
(my-adjoin 15 (my-adjoin 5 (my-adjoin 10 (my-adjoin 2 NIL))))
(bin-tree-height (my-adjoin 15 (my-adjoin 5 (my-adjoin 10 (my-adjoin 2 NIL)))))
|#

#|
UKOL 1.5
Naprogramujte funkci (tree-height tree), ktera vraci vysku obecneho stromu.
|#

#|
UKOL 2
Naprogramujte funkci (tree-path tree target-value), ktera vraci cestu k prvku v binarnimu stromu, predpokladejte ze prvek je vzdy pritomen ve strome.

(tree-path (my-adjoin 15 (my-adjoin 5 (my-adjoin 10 (my-adjoin 2 NIL)))) 15)

Cesta vypada napriklad nasledovne (2 10 15)
|#

#|
UKOL 3
Upravte binarni stromy tak, aby hodnota uzlu mohla byt dvojce hodnot klic/symbol.
|#

#|
(Tezsi ukol)
UKOL 4
Naprogramujte funkci (tree-remove tree target-value), ktera vraci novy binarni strom ze ktereho odstranila zadany prvel.
|#

#|
(Tezsi ukol)
UKOL 5
Naprogramujte funkci (tree-add-balanced tree value), ktera do vyvazeneho binarniho stromu prida prvek tak aby strom zustal vyvazen.
|#
    

#|
Mnoziny reprezentovane bin. stromem
|#

;Test na prvek
(defun elementp (el tree)
  (if (null tree)
      nil
    (let ((val (node-value tree)))
      (or (= el (node-value tree))
          (and (< el val) (elementp el (left-child tree)))
          (and (> el val) (elementp el (right-child tree)))))))

#|
UKOL 6
Naprogramujte funkci (my-intersection tree1 tree2), ktera provede mnozinovy prunik.
|#

#|
UKOL 7
Naprogramujte funkci (my-difference tree1 tree2), ktera odecte od mnoziny tree1 mnozinu tree2.
|#

#|
UKOL 8
Naprogramujte funkci (my-union tree1 tree2), ktera provede mnozinove sjednoceni.
|#