/*
Uvažujme ralční proměnnou result s hodnotou:
+---------+-------------+--------------------------+
| task_no | field       | task_result              |
+=========+=============+==========================+
| 1       | mathematics | +--------------+-------+ |
|         |             | | student_name | score | |
|         |             | +==============+=======+ |
|         |             | | Anna         | 5     | |
|         |             | | Bert         | 1     | |
|         |             | | Cyril        | 4     | |
|         |             | +--------------+-------+ |
| 2       | physics     | +--------------+-------+ |
|         |             | | student_name | score | |
|         |             | +==============+=======+ |
|         |             | | Anna         | 2     | |
|         |             | | Cyril        | 3     | |
|         |             | +--------------+-------+ |
| 3       | physics     | +--------------+-------+ |
|         |             | | student_name | score | |
|         |             | +==============+=======+ |
|         |             | | Anna         | 5     | |
|         |             | | Bert         | 2     | |
|         |             | | Cyril        | 5     | |
|         |             | +--------------+-------+ |
+---------+-------------+--------------------------+

Vezmeme relaci <r> nad atributy <A1>, ..., <An>, <B>.

Atribut <B> je typu C1, ..., Cm.

Množiny  {<A1>, ..., <An>}, {<C1>, ..., <Cm>} musí být disjunktní.

Rozdělením atributu <B> relace <r> získáme relaci <s> nad <A1>, ..., <An>, <C1>, ..., <Cm>.

Projekci relce <r> na <A1>, ..., <An> si označíme <r2>.

Vezmeme libovolnou n-tici <t> nad <A1>, ..., <An>, <C1>, ..., <Cm>.

Hodnoty, které n-tice <t> přiřazuje atributům <A1>, ..., <An>, si označíme <v1>, ..., <vn>.

Restrikci relace <r> na podmínku <A1> = <v1> AND ... AND <An> = <vn> si označíme <r3>.

Projekci n-tice <t> na <C1>, ..., <Cm> si označíme <t2>.

Nyní n-tice <t> nad <A1>, ..., <An>, <C1>, ..., <Cm> náleží do těla relace <s>, pokud

1. projekce <t> na <A1>, ..., <An>  náleží do těla relace <r2>,
2. exituje n-tice <t3> v těle relace <r3>, která přiřazuje atributu <B> hodnotu <vB> a
   n-tice <t2> náleží do těla relace <vB>
*/

/*
Například rozdělením atributu task_result relace result obdržíme relaci:

+---------+-------------+-------+--------------+
| task_no | field       | score | student_name |
+=========+=============+=======+==============+
| 1       | mathematics | 5     | Anna         |
| 1       | mathematics | 1     | Bert         |
| 1       | mathematics | 4     | Cyril        |
| 2       | physics     | 2     | Anna         |
| 2       | physics     | 3     | Cyril        |
| 3       | physics     | 5     | Anna         |
| 3       | physics     | 2     | Bert         |
| 3       | physics     | 5     | Cyril        |
+---------+-------------+-------+--------------+
*/

/*
SQL neumožňuje, aby typ atributu v záhlaví relace byl typem relace.  
Tedy slučování a rozdělování atributů SQL nepodporuje.

V souboru group_test.py v adresáří Group 
se nachází příklady slučování a rozdělování 
v experimentální implementaci Dee specifikace D.
*/