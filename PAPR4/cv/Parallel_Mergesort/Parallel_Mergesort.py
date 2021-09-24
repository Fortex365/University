import threading, concurrent
from math import floor

"""
Zadání:
Naprogramujte paralelní Mergesort který bude k při výpočtu používat k vláken.
Při řešení můžete použít cokoliv z knihoven threading a concurrent.

[EN] Assignment:
Program parallel Mergesort function, which will use k threads to compute.
For solving this problem anything from threading and concurrent libraries can be used.
"""

"""
Author: Lukáš Netřeba
Date: 14.5.2021
"""

#Custom Exception, can be ignored as its not part of solving the problem
class ThreadArgException(Exception):
    """
    Source:
    https://www.programiz.com/python-programming/user-defined-exception
    """
    def __init__(self, max_threads, message="Wrong max_threads argument passed."):
        self.max_threads = max_threads
        self.message = message
        super().__init__(self.message)

    def __str__(self):
        return f'{self.max_threads} -> {self.message}'

class ThreadArgMakesNoSense(Exception):
    def __init__(self, max_threads, message="Passing an argument max_threads lower than 2 makes no sense at all to use parallel_merge_sort."):
        self.max_threads = max_threads
        self.message = message
        super().__init__(self.message)

    def __str__(self):
        return f'{self.max_threads} -> {self.message}'

def parallel_merge_sort(array, max_threads=2):
    #Handling the edge cases
    if array == None and max_threads > 1: return None
    elif len(array) == 0 and max_threads > 1: return []
    elif len(array) == 1 and max_threads > 1: return array
    if not isinstance(max_threads, int): raise ThreadArgException(max_threads)
    if not max_threads > 1: raise ThreadArgMakesNoSense(max_threads)

    #Local function meant to be hidden from outside
    def merge_sort_with_lock(array,lock):
        #The first lock passed as an argument here from calling inside parallel_merge_sort
        #has no use to synchronize with other threads due to two already mergesorted left and right halves
        #which were returned from the first creation of new threads on those halves to solve.
        #It is considered that using 'with lock:' while merging into final array isn't expansive operation.
        #And re-entrancy of the lock is heavily used.
        #The reason to do this was to have only one function and not two almost identical with this one.
        if len(array) > 1:
            mid = floor(len(array)/2)
            left = array[:mid]
            right = array[mid:]

            # Recursive call on each half
            if max_threads-2 >= 0:
                n_lock = threading.Semaphore(1)
                #Sending the next lock which these two threads will use to synchronize
                thread_left = threading.Thread(target=merge_sort_with_lock, args=(left,n_lock))
                thread_right = threading.Thread(target=merge_sort_with_lock, args=(right,n_lock))
                thread_left.start()
                thread_right.start()

                thread_left.join()
                thread_right.join()
            else:
                #If we have no more threads left to use while going down the tree
                #we simply continue in the current thread. The lock had to be passed
                #as an argument and works as meantioned at top of the function.
                merge_sort_with_lock(left,lock)
                merge_sort_with_lock(right,lock)

            # Two iterators for traversing the two halves
            i = 0
            j = 0
        
            # Iterator for the main array
            k = 0
        
            while i < len(left) and j < len(right):
                if left[i] < right[j]:
                  # The value from the left half has been used
                    with lock:
                        array[k] = left[i]
                  # Move the iterator forward
                    i += 1
                else:
                    with lock:
                        array[k] = right[j]
                    j += 1
                # Move to the next slot
                k += 1

            # For all the remaining values
            while i < len(left):
                with lock:
                    array[k] = left[i]
                i += 1
                k += 1

            while j < len(right):
                with lock:
                    array[k]=right[j]
                j += 1
                k += 1
    
    #Code of the parallel_merge_sort function
    merge_sort_with_lock(array, threading.Semaphore(1))

if __name__ == '__main__':
    #Your main code here:
    numbers = [4, 3, 2, 6, 7, 9, 1, 5, 8]

    parallel_merge_sort(numbers,10)

    """
    Tests you can use:
    -----------------
    """
    #print(parallel_merge_sort([])) # -> []
    #print(parallel_merge_sort([1])) # -> [1]
    #print(parallel_merge_sort(None)) # -> None
    #parallel_merge_sort([1,2,3], None) # -> raised Exception subclass
    #parallel_merge_sort([1,2,3], max_threads=1) # -> raised Exception subclass

    print(numbers) # -> [1, 2, 3, 4, 5, 6, 7, 8, 9]

