import threading

def cutHair():
    while True:
        Customers.acquire()
        accessSeats.acquire()
        NumberOfFreeSeats += 1
        Barber.release()
        accessSeats.release()
        #tady stříhá

def getHairCut():
    while True:
        accessSeats.acquire()
        if(NumberOfFreeSeats>0):
            NumberOfFreeSeats -= 1
            Customers.release()
            accessSeats.release()
            Barber.acquire()
            #zde je stříhán
        else:
            accessSeats.release()
            #odchází neostříhán

n = 5 #počet míst k sezení v čekárně

Customers = threading.Semaphore(0)
Barber = threading.Semaphore(0)

accessSeats = threading.Semaphore(1)
NumberOfFreeSeats = n

Barberman = threading.Thread(target=cutHair)
Barberman.start()

Threads = []

for i in range(10):
    t = threading.Thread(target=getHairCut)
    t.start()
    Threads.append(t)

for t in Threads:
    t.join()

