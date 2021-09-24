"""
Zadání:
Naprogramujte paralelní výpočet n-tého fibonacciho čísla.
Funkce bude brát jako argument číslo n a počet vláken použitých k výpočtu.
K řešení úkolu můžete použít cokoliv co nabízí knihovny threading a concurrent.
"""

"""
Author: Lukáš Netřeba
Date: 7.5.2021
"""

"""
Poznámka:
Zrovna fibonacci je docela nešťastná volba na paralizaci, neboť
jeho výpočet je sám na sobě dost závislý ve vztazích k jeho předkům.
Paralizovat rekurzivní výpočet fibonacciho by byl nesmysl, proto jsem zvolil
řešení skrze sčítání jako tzv. fastfib (naive iterative solution).
Ke všemu navíc vytváření threadů je drahá operace, tím spíš
když to vykonává jen funkci která něco primitivně sečte.

Chtěl jsem využít futures a ThreadPoolExecutor, ale nenašel jsem jeho uplatnění, 
vzhledem k návrhu funkce _do_parallel_fibonacci neboť nemá návratovou hodnotu.

Pro kontrolu fib. čísla lze použít http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Fibonacci/fibtable.html,
pozor však na indexování od jedničky!
"""
import threading
from concurrent.futures import ThreadPoolExecutor

#Custom Exception, lze ignorovat pro řešení zadání.
class FibonacciIndexOutOfRange(Exception):
    """
    Source:
    https://www.programiz.com/python-programming/user-defined-exception
    """
    def __init__(self, n, message="Index out of range. Fibonnaci indexing starts at 1."):
        self.n = n
        self.message = message
        super().__init__(self.message)

    def __str__(self):
        return f'{self.n} -> {self.message}'

def parallel_fibonacci(n, max_threads=10):
    #Ošetření chybného volání
    if n <= 0:
        raise FibonacciIndexOutOfRange(n)
    #Řešení triviálních případů
    elif n == 1:
        return 0
    elif n == 2:
        return 1

    #Fibonnaci dict
    fib_dict = {
        "current": 1,
        "previous": 0
        }

    #Zámek pro dictonary
    lock = threading.Semaphore(1)

    def _do_parallel_fibonacci():
        with lock:
            a = fib_dict["current"]
            b = fib_dict["previous"]
            next = a+b

            fib_dict["current"] = next
            fib_dict["previous"] = a

    true_executes = n-2 #Protože první dva nespouštíme ve vlákně
    thrds = []

    while true_executes-max_threads > 0:
        for i in range(max_threads):
            t = threading.Thread(target=_do_parallel_fibonacci)
            t.start()
            thrds.append(t)
        for t in thrds:
            t.join()
        thrds = []
        true_executes -= max_threads
    else:
        #Opakování kódu, bylo by dobrý to ještě zabalit do funkce.
        for i in range(true_executes):
            t = threading.Thread(target=_do_parallel_fibonacci)
            t.start()
            thrds.append(t)
        for t in thrds:
            t.join()
        thrds = []
        true_executes -= true_executes

    return fib_dict["current"]

#Code
print(parallel_fibonacci(47, 14))