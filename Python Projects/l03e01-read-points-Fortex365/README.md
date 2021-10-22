# L03E01: Read points
Vytvořte modul `points.py` obsahující funkci `read_points()`.

Funkce `read_points()` vyžaduje jeden povinný parametr `text` a volitelný parametr `separator` s výchozí hodnotou `;`.

Parametr `text` obsahuje vstupní text s body ve formátu `x1,y1;x2,y2;....;xn,yn`, volitelný parametr `separator` umožňuje měnit oddělovač jednotlivých bodů v parametru `text`. Například pro `separator="_"` bude text ve formátu `x1,y1_x2,y2_...._xn,yn`. Program nemusí fungovat pro `separator=","`, `separator="."` a `separator="-"`.

Výsledkem funkce je seznam slovníků obsahující načtené body (podbné úkolu [L02E01](https://github.com/kmi-jp/template-L02E01), jednotlivé souřadnice však neumocňujeme!). Souřadnice bodů vždy ukládejte jako `float`.

## Příklad chování
```python
from points import read_points

read_points("10,20;20,10")
```

Výstup: `[{'x': 10.0, 'y': 20.0}, {'x': 20.0, 'y': 10.0}]`

```python
from points import read_points

read_points("10,20_20,10", separator="_")
```

Výstup: `[{'x': 10.0, 'y': 20.0}, {'x': 20.0, 'y': 10.0}]`

```python
from points import read_points

read_points("1.234,0;10,20")
```

Výstup: `[{'x': 1.234, 'y': 0.0}, {'x': 10.0, 'y': 20.0}]`

```python
from points import read_points

read_points("1.234,0*10,20*1.234,0*-10,20", separator="*")
```

Výstup: `[{'x': 1.234, 'y': 0.0}, {'x': 10.0, 'y': 20.0}, {'x': 1.234, 'y': 0.0}, {'x': -10.0, 'y': 20.0}]`