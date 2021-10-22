# L01E03: Point input
Vytvořte program `point_input.py`, který získá uživatelem zadaný bod v dvourozměrném prostoru (x, y souřadnice). Takto získané souřadnice umocní (matematicky tedy `x^2` a `y^2`) a vypíše výsledek.

Bod je zadaný jako dvojice čísel oddělených čárkou (je nutné podporovat rovněž čísla záporná a čísla desetinná). Správnost vstupu neověřujeme.

Pozor výstup programu je testován automaticky, proto dodržujte přesný formát výstupu a vstupu! K řešení používejte pouze nástroje jazyka Python, které byly již představeny na seminářích.

## Příklad výstupu
```
> python3 point_input.py
Please enter an point where x and y coordinates are separated by comma (i.e. 20,-10.23): 10,20
x^2: 100.0, y^2: 400.0
```

```
> python3 point_input.py
Please enter an point where x and y coordinates are separated by comma (i.e. 20,-10.23): -12,20
x^2: 144.0, y^2: 400.0
```

```
> python3 point_input.py
Please enter an point where x and y coordinates are separated by comma (i.e. 20,-10.23): 1.234,0
x^2: 1.522756, y^2: 0.0
```

```
> python3 point_input.py
Please enter an point where x and y coordinates are separated by comma (i.e. 20,-10.23): -12.324,-12313
x^2: 151.880976, y^2: 151609969.0
```
