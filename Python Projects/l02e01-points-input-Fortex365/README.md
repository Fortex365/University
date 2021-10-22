# L02E01: Points input
Vytvořte program `points_input.py`, který od uživatele získá body (1 a více) v 2D prostoru (x, y souřadnice). Tyto souřadnice umocní a vypíše výsledek (je nutné podporovat rovněž čísla záporná a čísla desetinná). Jednotlivé body uložte jako slovníky do seznamu. Seznam vypište.

Body jsem zadány ve formátu `x1,y1;x2,y2;....;xn,yn`. Správnost vstupu neověřujeme.

Pozor výstup programu je testován automaticky, proto dodržujte přesný formát výstupu a vstupu! K řešení používejte pouze nástroje jazyka Python, které byly již představeny na seminářích.

## Příklad výstupu
```
> python3 points_input.py
Please enter points: 10,20;20,10
[{'x': 100.0, 'y': 400.0}, {'x': 400.0, 'y': 100.0}]
```

```
> python3 points_input.py
Please enter points: -12,20
[{'x': 144.0, 'y': 400.0}]
```

```
> python3 points_input.py
Please enter points: 1.234,0;10,20
[{'x': 1.522756, 'y': 0.0}, {'x': 100.0, 'y': 400.0}]
```

```
> python3 points_input.py
Please enter points: 1.234,0;10,20;1.234,0;10,20
[{'x': 1.522756, 'y': 0.0}, {'x': 100.0, 'y': 400.0}, {'x': 1.522756, 'y': 0.0}, {'x': 100.0, 'y': 400.0}]
```