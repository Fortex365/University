# L04E01: Matrix multiplication (exceptions)
Balíček `argebra` (úkol [L03E02](https://github.com/kmi-jp/template-L03E02)) doplňte o následující výjimky.

Funkce `vector.dot_product` vyvolá `ValueError` v případě, kdy nejsou vstupní vektory stejně dlouhé.

Například tedy:

```python
from algebra.vector import dot_product

vector_1 = [1, 2, 3]
vector_2 = [3, 2, 1, 3]

# ValueError, vektory nemají stejnou délku
dot_product(vector_1, vector_2)
```

Funkce `matrix.matrix_multiplication` vyvolá `ValueError` v případě, kdy matice nesplňují vhodné [vstupní podmínky](https://cs.wikipedia.org/wiki/Násoben%C3%AD_matic) (rozměry) pro násobení dvou matic.

Například tedy:

```python
from algebra.vector import dot_product

matrix_1 = [
    [1, -2, 5, 20],
    [0, 2, 3, 4],
    [100, 2, 3, 4]
]

matrix_2 = [
    [10, -2],
    [0, 20],
    [100, 2],
]

# ValueError, matice mají nesprávné vstupní rozměry
matrix_multiplication(matrix1, matrix2)
```

Zbytek funkcionality musí být zachován.
