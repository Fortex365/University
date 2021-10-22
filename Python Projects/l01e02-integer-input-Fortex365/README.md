# L01E02: Integer input
Vytvořte program `integer_input.py`, který získá uživatelem zadané celé číslo (`input()`), poté na standardní výstup (`print()`) vypíše jednu z následujících možností:

1. `Error: x has less than three digits.`: kde "x" je zadané číslo, které má méně jak 3 cifry.
2. `Digit in the tens position is x.`: kde "x" je cifra na pozici desítek.

Situaci kdy uživatel nezadá číslo neošetřujeme. Program musí fungovat i pro záporná čísla.

Pozor výstup programu je testován automaticky, proto dodržujte přesný formát výstupu a vstupu! K řešení používejte pouze nástroje jazyka Python, které byly již představeny na seminářích.

## Příklad výstupu
```
> python3 integer_input.py
Please enter an integer with atleast 3 digits : 123
Digit in the tens position is 2.
```

```
> python3 integer_input.py
Please enter an integer with atleast 3 digits : -123
Digit in the tens position is 2.
```

```
> python3 integer_input.py
Please enter an integer with atleast 3 digits : 12345
Digit in the tens position is 4.
```

```
> python3 integer_input.py
Please enter an integer with atleast 3 digits : -12
Error: -12 has less than three digits.
```

```
> python3 integer_input.py
Please enter an integer with atleast 3 digits : 1
Error: 1 has less than three digits.
```

