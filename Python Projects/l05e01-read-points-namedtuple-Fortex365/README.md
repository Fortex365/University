# L05E01: Read points (NamedTuple)
Vytvořte modul `points.py` obsahující funkci `read_points()`. Podobně jako v úkolu [L03E01](https://github.com/kmi-jp/template-L03E01).

Funkce `read_points()` funguje stejně, jediný rozdíl je, že body namísto slovníkem reprezentujeme třídou `Points` vytvořenou pomoci `NamedTuple` (vlastnosti `x` a `y`).

Třídu `Points` vytvořte v modulu `points.py` mimo funkci `read_points()`.

## Příklad chování
```python
from points import read_points, Point

assert read_points("10,20;20,10") == [Point(10, 20), Point(20, 10)]
```

```python
from points import read_points, Point

assert read_points("10,20_20,10", separator="_") == [Point(10, 20), Point(20, 10)]
```

```python
from points import read_points, Point

assert read_points("1.234,0;10,20") == [Point(1.234, 0), Point(10, 20)]
```

```python
from points import read_points, Point

assert read_points("1.234,0*10,20*1.234,0*-10,20", separator="*") == [Point(1.234, 0), Point(10, 20), Point(1.234, 0), Point(10, 20)]
```