from random import randint
import threading

VECTOR_SIZE = 10

class SyncVector:

    def __init__(self, size, initial_value=0):
        self.lock = threading.Semaphore(1)
        creating_vector = []
        lock_list = []

        #Inicializace vektoru
        if callable(initial_value):
            for i in range(size):
                creating_vector.append(initial_value())
        else:
            for i in range(size):
                creating_vector.append(initial_value)
        self.vector = creating_vector

        #Inicializace zámků indexů vektoru
        for i in range(size):
            lock_list.append(threading.Semaphore(1))
        self.index_locks = lock_list

    def print(self):
        print(self.vector)

    def get(self, index):
        with self.index_locks[index]:
            return self.vector[index]

    def set(self, value, index):
        with self.index_locks[index]:
            self.vector[index] = value

    def length(self):
        with self.lock:
            return len(self.vector)


def nmapv(func, vector, threads=2):
    vect_index_iter = 0 
    global barrier
    barrier = threading.Barrier(threads)
    thrds = []

    while (vect_index_iter+threads) <= vector.length():
        for i in range(threads):
            t = threading.Thread(target=apply_func_on_index, args=(func, vector, vect_index_iter))
            vect_index_iter += 1
            t.start()
            thrds.append(t)

        for i in thrds:
            i.join()

        thrds = [] 

    left = vector.length() - vect_index_iter
    barrier = threading.Barrier(left)
    for i in range(left):
        t = threading.Thread(target=apply_func_on_index, args=(func, vector, vect_index_iter))
        vect_index_iter += 1
        t.start()
        thrds.append(t)
    for i in thrds:
        i.join()   

def apply_func_on_index(func, vector, index):
    global barrier
    new = func(vector.get(index))
    vector.set(new,index)
    barrier.wait()
    
barrier = 'UNITIALIZED VALUE'

vector = SyncVector(VECTOR_SIZE)
vector.print()

vector = SyncVector(VECTOR_SIZE, initial_value=1)
vector.print()

vector = SyncVector(VECTOR_SIZE, initial_value=lambda:randint(0,100))
vector.print()

vector.set(10,5)
vector.print()

nmapv(lambda x: x*x, vector,threads=3)

vector.print()
