"""
Pro číslo menší než 32 vytiskněte všechny jeho cifry ve dvojkové soustavě.

20.9.2021
Lukáš Netřeba
"""

from random import randint

UPPER_BOUND = 32

def print_digit_to_binary() -> None:
    "Prints all digits in binary from given number by its upper bound."
    global UPPER_BOUND

    picked_number = randint(0,UPPER_BOUND-1)
    if picked_number < 10:
        print(bin(picked_number))
    else:
        pnumber_str = str(picked_number)
        for digit in pnumber_str:
            print(bin(int(digit)))

if __name__ == '__main__':
    print_digit_to_binary()