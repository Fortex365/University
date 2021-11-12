# L07E01: Generator function
Vytvořte modul `progression` obsahující funkci (generátorovou) `arithmetic_progression(begin, step, end=None)`. Uvažujme pouze rostoucí posloupnosti.

## Funkce `arithmetic_progression(begin, step, end)`
Generátor generující prvky [aritmetické posloupnosti](https://cs.wikipedia.org/wiki/Aritmetická_posloupnost) počínaje prvkem `begin`, diferencí `step` a končicí prvkem `end` (posloupnost poslední prvek neobsahuje). Pokud `end` není uveden (má hodnotu `None`), aritmetická posloupnost je nekonečná.

```python
for number in arithmetic_progression(5, 2, 8):
    print(number)

# Vypíše následující čísla, v každý moment se vypočítá a uloží pouze jedno, celá posloupnost není nikde uložena
5
7
```

```python
progression = arithmetic_progression(5, 2)

assert next(progression) == 5
assert next(progression) == 7
assert next(progression) == 9
```