import threading
from random import randint
import time

def evenp(num):
    if num%2 == 0:
        return True;
    else:
        return False;

def sort(id):
    global numbers 
    global barrier 
    global anything_swapped, finished

    if(not(evenp(id))):
        barrier.wait()
    while not finished:
        barrier.wait()
        if(id < len(numbers)-1):
            if(numbers[id]>numbers[id+1]):
                temp = numbers[id+1]
                numbers[id+1] = numbers[id]
                numbers[id] = temp
                anything_swapped = True
        barrier.wait()
        if not evenp(id):
            if(id == len(numbers)-1):
                if not anything_swapped:
                    done = True
                else:
                    anything_swapped = False
        barrier.wait()
        barrier.wait()
        if evenp(id):
            barrier.wait()

               
numbers = [2, 4, 5, 6, 3, 10, 99, 18]
barrier = threading.Barrier(len(numbers))
anything_swapped = False
finished = False

threads = [threading.Thread(target=sort, args=(id,)) for id in range(len(numbers))]

for t in threads:
    t.start()

for t in threads:
    t.join()

print(numbers)