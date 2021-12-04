/*
Uvažujme relační proměnnou result typu task_no, field, student_name a score, kde task_no a score je typu integer a ostatní atributy typu varchar(20). 

Hodnotou proměnné result je relace:

+---------+-------------+--------------+-------+
| task_no | field       | student_name | score |
+=========+=============+==============+=======+
| 1       | mathematics | Anna         | 5     |
| 2       | physics     | Anna         | 2     |
| 3       | physics     | Anna         | 5     |
| 1       | mathematics | Bert         | 1     |
| 3       | physics     | Bert         | 2     |
| 1       | mathematics | Cyril        | 4     |
| 2       | physics     | Cyril        | 3     |
| 3       | physics     | Cyril        | 5     |
+---------+-------------+--------------+-------+

(Proměnná result není dobře navržena. Proč?)

Vezmeme relaci <r> nad atributy <A1>, ..., <An>.

Zvolíme některé atributy <B1>, ..., <Bm> ze záhlaví relace <r>.

Označíme <C1>, ..., <Ck> všechny atributy v záhlaví relace <r> různé od atributů <B1>, ..., <Bm>. Tedy k = n - m.

Zvolíme jméno atributu <D> různé od <C1>, ..., <Ck>.

Typ atributu <D> je relace typu <B1>, ..., <Bm>.

Označíme <r2> výsledek projekce relace <r> na <C1>, ..., <Ck>.

Sloučení atributů <B1>, ..., <Bm> na atribut <C> relace <r> rozumíme relaci <s> nad <C1>, ..., <Ck>, <D>.

Vezměme libovolnou n-tici <t> nad <C1>, ..., <Ck>, <D>.

Hodnoty, které n-tice <t> přiřazuje atributům <C1>, ..., <Ck>, označíme <v1>, ..., <vk>.

Hodnotu, kterou n-tice <t> přiřazuje atributu <D>, označíme <sD>.

Nyní n-tice <t> náleží do těla relace <s>, pokud:

1. Projekce n-tice <t> na <C1>, ..., <Ck> náleží do těla relace <r2> a
2. restrikce relace <r> na podmínku <C1> = <v1> AND ... AND <Ck> = <vk> je rovna relaci <sD>.
*/

/*
Například sloučením atributů task_no, student_name a score na field_result relace result získáme relaci:

+-------------+------------------------------------+
| field       | field_result                       |
+=============+====================================+
| mathematics | +---------+--------------+-------+ |
|             | | task_no | student_name | score | |
|             | +=========+==============+=======+ |
|             | | 1       | Anna         | 5     | |
|             | | 1       | Bert         | 1     | |
|             | | 1       | Cyril        | 4     | |
|             | +---------+--------------+-------+ |
| physics     | +---------+--------------+-------+ |
|             | | task_no | student_name | score | |
|             | +=========+==============+=======+ |
|             | | 2       | Anna         | 2     | |
|             | | 3       | Anna         | 5     | |
|             | | 3       | Bert         | 2     | |
|             | | 2       | Cyril        | 3     | |
|             | | 3       | Cyril        | 5     | |
|             | +---------+--------------+-------+ |
+-------------+------------------------------------+

Sloučením atributů student_name a score na task_result relace result získáme relaci:
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

Konečně sloučením atributů task_no, field' a score na student_result relace result obdržíme relaci:
+-----------------------------------+--------------+
| student_result                    | student_name |
+===================================+==============+
| +---------+-------------+-------+ | Anna         |
| | task_no | field       | score | |              |
| +=========+=============+=======+ |              |
| | 1       | mathematics | 5     | |              |
| | 2       | physics     | 2     | |              |
| | 3       | physics     | 5     | |              |
| +---------+-------------+-------+ |              |
| +---------+-------------+-------+ | Bert         |
| | task_no | field       | score | |              |
| +=========+=============+=======+ |              |
| | 1       | mathematics | 1     | |              |
| | 3       | physics     | 2     | |              |
| +---------+-------------+-------+ |              |
| +---------+-------------+-------+ | Cyril        |
| | task_no | field       | score | |              |
| +=========+=============+=======+ |              |
| | 1       | mathematics | 4     | |              |
| | 2       | physics     | 3     | |              |
| | 3       | physics     | 5     | |              |
| +---------+-------------+-------+ |              |
+-----------------------------------+--------------+
*/