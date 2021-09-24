from threading import Thread
from threading import Lock
from threading import Condition
from random import randint

def produce():
    global buffer
    while True:
        with lock:
            val = randint(-100,100)
            buffer.append(val)
            any_item.notify()


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
        with lock: 
            while not any_item:
                any_item.wait()
            val = buffer.pop()
            print("Num: " + str(val) + " in sign function is: " + str(sign(val)))


n = 100
buffer = []
lock = Lock()
any_item = Condition(lock)

while True:
    t1 = Thread(target=produce)
    t1.start()
    t2 = Thread(target=consume)
    t2.start()

    t1.join()
    t2.join()


