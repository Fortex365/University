(defun tree-node (val children)
  (cons val children))

(defun node-value (node)
  (car node))

(defun node-children (node)
  (cdr node))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun node-value-list (nodes)
  (if (null nodes)
      '()
    (cons (node-value (car nodes))
          (node-value-list (cdr nodes)))))

(defun node-children-list (nodes)
  (if (null nodes)
      '()
    (append (node-children (car nodes))
            (node-children-list (cdr nodes)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tree-value-dfs (root)
  (cons (node-value root)
        (tree-value-dfs-multi (node-children root))))

(defun tree-value-dfs-multi (roots)
  (if (null roots)
      '()
    (append (tree-value-dfs (car roots))
            (tree-value-dfs-multi (cdr roots)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tree-value-bfs (root)
  (tree-value-bfs-multi (list root)))

(defun tree-value-bfs-multi (roots)
  (if (null roots)
      '()
    (append (node-value-list roots)
            (tree-value-bfs-multi (node-children-list roots)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Binarni stromy
(defun binary-tree-node (val left-child right-child)
  (list val left-child right-child))

(defun left-child (node)
  (cadr node))

(defun right-child (node)
  (caddr node))

(defun bt-node-children (node)
  (remove nil (cdr node)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tree-values-dfs-bt (root)
  (cons (node-value root)
        (tree-values-dft-bt-multi (bt-node-children root))))

(defun tree-values-dft-bt-multi (roots)
  (if (null roots)
      '()
    (append (tree-values-dfs-bt (car roots))
            (tree-values-dft-bt-multi (cdr roots)))))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Nová reprezentace obecného uzlu
(defun tree-node2 (val children)
  (cons 'tree (cons val children)))

(defun tree-node-value2 (node)
  (cadr node))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Nová reprezentace binárního stromu
(defun binary-tree-node2 (val left-child right-child)
  (list 'binary-tree val left-child right-child))

(defun left-child2 (node)
  (caddr node))

(defun right-child2 (node)
  (cadddr node))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Detekce typu stromu
(defun tree-type (node)
  (car node))

(defun treep (tree)
  (eql (tree-type tree) 'tree))

(defun binary-tree-p (tree)
  (eql (tree-type tree) 'binary-tree))

;Nová funkce node-children, nyní polymorfní (umí pracovat s více typů hodnot současně)
(defun node-children2 (node)
  (cond ((treep node) (cddr node))
        ((binary-tree-p node) (remove nil (cddr node)))
        (t (error "Unknown tree type"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun  elementp (el tree)
  (if (null tree)
      nil
    (let ((val (node-value2 tree)))
      (or (= el (node-value2 tree))
          (and (< el val) (elementp el (left-child2 tree)))
          (and (> el val) (elementp el (right-child2 tree)))))))

(defun my-adjoin (elem tree)
  (if (null tree)
      (binary-tree-node2 elem nil nil)
    (let ((val (tree-node-value2 tree))
          (left (left-child2 tree))
          (right (right-child2 tree)))
      (cond ((= elem val) tree)
            ((< elem val)
             (binary-tree-node2 val (my-adjoin elem left) right))
            (t (binary-tree-node2 val left (my-adjoin elem right)))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište výraz, který vytvoří reprezentaci vyváženého binárního stromu z přednášky.
;Uzly vytvářejte výhradně pomocí konstruktoru binary-tree-node



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Vytvořte stejný binární strom z prázdného stromu opakovaným použitím funkce my-adjoin.
;Zkuste změnou pořadí přidávaných uzlů vytvořit ze stejných hodnot jiný strom.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci, která k danému seznamu čísel vytvoří binární vyhledávací strom.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište predikát balancedp, který zjistí, zda je daný binární vyhledávací strom vyvážený



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci bt-swap, která k danému binárnímu stromu vrátí strom s 
;vyměněným pravým a levým následníkem všech uzlů



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci, která k danému číslu vrátí jeho uzel v binárním vyhledávacím stromu.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci tree-sum, která k danému stromu s číselnými hodnotami vrátí jejich součin (spíš součet ne?)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Je možné napsat funkce na průnik a sjednocení množin čísel reprezentovaných
;binárními vyhledávacími stromy stejně, jako příslušné funkce pro množiny
;reprezentované seznamy z minulé přednášky?



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci tree-maximal-path, která k danému stromu vrátí seznam všech cest k listům



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Napište funkci tree-height, která vrátí výšku daného stromu, aniž by zjištovala cesty 
;(tedy bez pomoci funkce tree-maximal-paths)
(defun tree-height (node)
  (if (null (node-children2 node))
      0
    (+ (apply #'max (mapcar #'tree-height (node-children2 node))) 1)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Strom je zadán eznamem hodnot a symbolů / a //, kde / znamená přechod k dalšímu předchůdci
;a // přechod na další vrstvu. Prvním strom z přednášky lze tedy zadat seznamem
;( 4 // 1 5 6 // / 2 3 1 / 2 11 // / / 3 6)
;Napište funkci, která z takového seznamu udělá strom



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Upravte funkci my-adjoin, aby zachovala vyváženost stromu, ke kterému přidává nový prvek





