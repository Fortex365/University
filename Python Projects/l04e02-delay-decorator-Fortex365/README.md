# L04E02: Delay decorator
Vytvořte modul `delay.py` obsahující `@delay(seconds=X)` dekorátor, který při zavolání obalené funkce zpomalí její vykonání o `X` sekund. Výchozí doba zpomalení bez uvedení parametru `seconds` bude 1 sekunda.

Zpomalení (uspání) je možné provést následovně:

```python
import time

# uspí program na 3 sekundy
time.sleep(3)
```

Příklad použití:

```python
@delay()
def my_sum(a, b):
    return a + b

my_sum(2, b=3)
```

```python
@delay()
def test_print():
    return "Ahoj svete"

test_print()
```

```python
@delay(seconds=2)
def my_sum(a, b):
    return a + b

my_sum(2, b=3)
```