import threading
from random import randint
from threading import Lock
from threading import Condition

def gen_two_random_ints(start, end):
    global a, b
    global recieved_lock, second_recieved, gen_two_num_lock, first_finished

    with recieved_lock:
        while not second_recieved:
            second_recieved.wait()
        with gen_two_num_lock:
            a = randint(start, end) 
            b = randint(start, end)
            first_finished.notify()


def gcd(a,b): 
    if(b==0): 
        return a 
    else: 
        return gcd(b,a%b) 

def are_comprime():
    global a, b, is_comprime
    global recieved_lock, gen_two_num_lock, first_finished, second_recieved
    global comprime_lock, second_finished

    with comprime_lock:
        with recieved_lock:
            with gen_two_num_lock:
                while not first_finished:
                    first_finished.wait()
                if(gcd(a,b) > 1):
                    is_comprime = 1 
                else: 
                    is_comprime = 0
                second_recieved.notify()
        second_finished.notify()



def count_comprimes():
    global is_comprime, comprimes_count, overall_results_send 
    global comprime_lock, second_finished


    with comprime_lock:
        while not second_finished:
            second_finished.wait()
        overall_results_send +=1
        if(is_comprime == 1): 
            comprimes_count +=1

#Monitor pro první a druhý thread
gen_two_num_lock = Lock()
first_finished = Condition(gen_two_num_lock)

#Monitor pro první a druhý thread (čekání na vyzvednutí)
recieved_lock = Lock()
second_recieved = Condition(recieved_lock)

#Monitor pro druhý a třetí thread
comprime_lock = Lock()
second_finished = Condition(comprime_lock)

a, b = 0, 0 #Zapisování dvojice vygenerovaných náhodných čísel prvním procesem
is_comprime = 0 #Zapisování výsledku soudělnosti dvou čísel
comprimes_count = 0 #Zapisování počtu zaslaných soudělných číslem 2. procesu 3. procesu
overall_results_send = 0 #Zapisování počtu zaslaných celkový čísel, které 2. proces zaslal 3mu

n = 100

while comprimes_count < n:
    t1 = threading.Thread(target=gen_two_random_ints, args=(0,100,))
    t1.start()
    t2 = threading.Thread(target=are_comprime)
    t2.start()
    t3 = threading.Thread(target=count_comprimes)
    t3.start()

    t1.join()
    t2.join()
    t3.join()


print("Poslední vygenerovaná dvojice čísel: " + str(a) + "|" + str(b))
print("Kontrola: " + str(gcd(a,b)) + " (pokud mají gcd > 1 => jsou soudělná)")
print("Byla soudělná: " + str(is_comprime))
print("Celkový počet vygenerovaných soudělných čísel: " + str(comprimes_count) + ", celkový počet zaslaných výsledků: " + str(overall_results_send))