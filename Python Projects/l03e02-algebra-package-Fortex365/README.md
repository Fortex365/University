# L03E02: Algebra package
Vytvořte balíček `argebra` obsahující dva moduly `matrix.py` a `vector.py`.

## Modul `vector.py`
Modul `vector.py` obsahuje funkci `dot_product(vector_1, vector_2)`, která počítá [skalární součin](https://www.matweb.cz/skalarni-soucin) dvou stejně dlouhých vektorů (vektor reprezentujeme jako seznam).

Například tedy:

```python
from algebra.vector import dot_product

vector_1 = [1, 2, 3]
vector_2 = [3, 2, 1]

assert dot_product(vector_1, vector_2) == 10
```

## Modul `matrix.py`
Modul `matrix.py` obsahuje funkce `matrix_multiplication(matrix_1, matrix_2)`, `new_matrix(shape)`a `submatrix(matrix, rows_id, columns_id)`.

### Funkce `matrix_multiplication(matrix_1, matrix_2)`
Funkce `matrix_multiplication(matrix_1, matrix_2)` vykonává [násobení dvou matic](https://cs.wikipedia.org/wiki/Násoben%C3%AD_matic). V implementaci využíjte funkci `algebra.vector.dot_product()`. Matice můžete reprezentovat jako seznam (mutovatelnost se nám již hodí).

Například tedy:

```python
from algebra.matrix import dot_product

matrix_1 = [
    [1, -2, 5, 20],
    [0, 2, 3, 4],
    [100, 2, 3, 4]
]

matrix_2 = [
    [10, -2],
    [0, 20],
    [100, 2],
    [2, 10]
]

assert matrix_multiplication(matrix1, matrix2) == [[550, 168], [308, 86], [1308, -114]]
```

### Funkce `new_matrix(shape, fill)`
Funkce `new_matrix(shape, fill)` vytvoří matici o rozměrech `shape` (`tuple`, například `(2, 4)`, 2 řádky, 4 sloupce) a všechny prvky vyplní hodnotou `fill` (například, číslo `1.0`).

```python
from algebra.matrix import new_matrix

matrix = new_matrix((3, 2), 1.0)

assert matrix == [[1.0, 1.0], [1.0, 1.0], [1.0, 1.0]]

# opatrně, musí změnit hodnotu pouze na indexu 0,0 nikoli nikde jinde!
matrix[0][0] = 0.0

assert matrix[0][0] == 0
assert matrix[1][0] == 1.0
```

### Funkce `submatrix(matrix, drop_rows, drop_columns)`
Funkce `submatrix(matrix, drop_rows, drop_columns)` vrací [podmatici](https://en.wikipedia.org/wiki/Matrix_(mathematics)#Submatrix) předané matice. Podmatice vznikne odebráním všech řádků na indexech uvedených v parametru `drop_rows`, obdobně potom pro sloupce v parametru `drop_columns`. Výchozí hodnoty těchto argumentů jsou prázdné seznamy, v takovém případě dojde ke kopii předaného seznamu. Původní matici nemodifikujte!

```python
from algebra.matrix import submatrix

matrix = [
    [1, -2, 5, 20],
    [0, 2, 3, 4],
    [100, 2, 3, 4]
]

result = submatrix(matrix, drop_rows=[0, 1], drop_columns=[0])

assert result == [[2, 3, 4]]
assert matrix == [[1, -2, 5, 20], [0, 2, 3, 4], [100, 2, 3, 4]]
```

```python
from algebra.matrix import submatrix

matrix = [
    [1, -2, 5, 20],
    [0, 2, 3, 4],
    [100, 2, 3, 4]
]

result = submatrix(matrix, drop_columns=[0])

assert result == [[-2, 5, 20], [2, 3, 4], [2, 3, 4]]
assert matrix == [[1, -2, 5, 20], [0, 2, 3, 4], [100, 2, 3, 4]]
```

Odstranění všech řádků:

```python
from algebra.matrix import submatrix

matrix = [
    [1, -2, 5, 20],
    [0, 2, 3, 4],
    [100, 2, 3, 4]
]

result = submatrix(matrix, drop_rows=[0, 1, 2])

assert result == []
assert matrix == [[1, -2, 5, 20], [0, 2, 3, 4], [100, 2, 3, 4]]
```

Kopie matice:

```python
from algebra.matrix import submatrix

matrix = [
    [1, -2, 5, 20],
    [0, 2, 3, 4],
    [100, 2, 3, 4]
]

result = submatrix(matrix)

assert result == matrix
assert id(result) != id(matrix)
```

