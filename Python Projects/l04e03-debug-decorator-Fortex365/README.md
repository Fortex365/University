# L04E03: Debug decorator
Vytvořte modul `debug.py` obsahující `@debug` dekorátor, který při zavolání obalené funkce vypíše na standardní výstup seznam argumentů (`args`), seznam pojmenovaných argumentů (`kwargs`), název funkce a výsledek v následujícím formátu. Zbytek funkce a její návratová hodnota funguje stejně.

Pro získání hodnoty argumentu a výsledku použijte funkci `repr()`.

```python
# vrátí reprezentaci hodnoty 2
repr(2)

# vrátí reprezentaci výsledku sum(2, 3)
repr(sum(2, 3))
```

---

Příklad použití:

```python
@debug
def my_sum(a, b):
    return a + b

assert my_sum(6, 9) + 2 == 17
```

Na standardní výstup vypíše:
```
Calling: my_sum(6, 9)
Result: 15
```

---


```python
@debug
def my_sum(a, b):
    return a + b

assert my_sum(2, b=3) + 2 == 7
```

Na standardní výstup vypíše:
```
Calling: my_sum(2, b=3)
Result: 5
```

---

```python
@debug
def test():
    return 42

assert test() == 42
```

Na standardní výstup vypíše:
```
Calling: test()
Result: 42
```

---

```python
@debug
def test():
    pass

assert test() == None
```

Na standardní výstup vypíše:
```
Calling: test()
Result: None
```