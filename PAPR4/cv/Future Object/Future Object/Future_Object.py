from threading import Thread
import threading

class Future:
    def __init__(self, function):
        self.future_value = None
        self.function = function
        self.lock = threading.Lock()
        self.ready = threading.Condition(self.lock)
        self.finished = False

    def _calculate(self):
        self.future_value = self.function()
        self.finished = True
        with self.lock:
            self.ready.notify()

    def deref(self):
        if not self.finished:
            with self.lock:
                while not self.finished:
                    self.ready.wait()
        return self.future_value

class Labour:
    def __init__(self):
        self.worker_count = 'UNINITIALIZED'
        self.work_queue = []
        self.queue_lock = threading.Lock()
        self.queue_ready = threading.Condition(self.queue_lock)
        self.thread_list = ['UNINITIALIZED']
        self.stop = False

    def set_worker_count(self, count):
        self.worker_count = count
        self.thread_list = [threading.Thread(target=self._work) for i in range(self.worker_count)]
        for t in self.thread_list:
            t.start()

    def compute(self, function):
        future = Future(function)
        self.work_queue.append(future)
        with self.queue_lock:
            self.queue_ready.notify()
        return future

    def _work(self):
        while True:
            with self.queue_lock:
                while not self.work_queue:
                    if(self.stop):
                        return
                    self.queue_ready.wait()
            future = self.work_queue.pop()
            future._calculate()

    def stop(self):
        self.stop = True
        with self.queue_lock:
            self.queue_ready.notify_all()

def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)

def fibonacci(n):
    if n <= 1:
        return n
    else:
        return fibonacci(n - 1) + fibonacci(n - 2)

def worker_function():
    return factorial(1000)

labour = Labour()
labour.set_worker_count(5)

factorial_future = labour.compute(worker_function)
large_factorial = factorial_future.deref()

fibonacci_future = labour.compute(lambda: fibonacci(50))
large_fibonacci = fibonacci_future.deref()

labour.stop()

