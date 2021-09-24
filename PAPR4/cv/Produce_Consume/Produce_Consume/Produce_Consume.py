from threading import Thread
from threading import Semaphore
from random import randint

def produce():
    global buffer
    while True:
        val = randint(-100,100)
        space.acquire()
        lock.acquire()
        buffer.append(val)
        lock.release()
        item.release()

def sign(n):
    if n == 0:
        return 0
    if n > 0:
        return 1
    else:
        return -1

def consume():
    global buffer
    while True:
        item.acquire()
        lock.acquire()
        val = buffer.pop()
        print("Num: " + str(val) + " in sign function is: " + str(sign(val)))
        lock.release()
        space.release()

n = 100
buffer = []
lock = Semaphore(1)
space = Semaphore(n)
item = Semaphore(0)

while True:
    t1 = Thread(target=produce)
    t1.start()
    t2 = Thread(target=consume)
    t2.start()

    t1.join()
    t2.join()

