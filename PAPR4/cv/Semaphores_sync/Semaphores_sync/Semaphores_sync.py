import threading
from random import randint

def gen_two_random_ints(start, end):
    global a, b

    space_1_2.acquire();
    a = randint(start, end) #Vygenerujeme dvojici náhodných čísel
    b = randint(start, end)
    item_1_2.release()


def gcd(a,b): 
    if(b==0): 
        return a 
    else: 
        return gcd(b,a%b) 

def are_comprime():
    global a, b
    global is_comprime

    item_1_2.acquire()
    space_2_3.acquire()
    if(gcd(a,b) > 1):
        is_comprime = 1 #Vygenerovaná čísla jsou soudělná
    else: 
        is_comprime = 0 #Nejsou soudělná
    space_1_2.release()
    item_2_3.release()

def count_comprimes():
    global is_comprime #Přístup k výsledku z procesu are_comprime

    global comprimes_count #Počet celkově zaslaných soudělných čísel
    global overall_results_send #Počet celkově zaslaných čísel

    item_2_3.acquire()
    overall_results_send +=1
    if(is_comprime == 1): #Jestliže čísla z předchozího procesu byli soudělná, spočítáme si je
        comprimes_count +=1
    space_2_3.release()


space_1_2 = threading.Semaphore(1)
item_1_2 = threading.Semaphore(0)

space_2_3 = threading.Semaphore(1)
item_2_3 = threading.Semaphore(0)

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
