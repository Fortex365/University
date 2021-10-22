# L02E03: Matrix max value
Vytvořte program `matrix_max_value.py`, který vypíše matici s očíslovanými řádky, zjistí součet všech prvků matice a maximální prvek matice. Tyto údaje vypište ve formátu uvedeném níže.

Matici reprezentujte v lokální proměnné (vícerozměrný tuple).

```
matrix = (
    (1, -2, 5, 20),
    (0, 2, 3, 4),
    (100, 2, 3, 4)
)
```

**Musí fungovat pro matici libovoných rozměrů!**

Pozor výstup programu je testován automaticky, proto dodržujte přesný formát výstupu a vstupu! K řešení používejte pouze nástroje jazyka Python, které byly již představeny na seminářích.

## Očekávaný výstup
```
> python3 matrix_max_value.py
0 (1, -2, 5, 20)
1 (0, 2, 3, 4)
2 (100, 2, 3, 4)
maximal=100, summation=142
```