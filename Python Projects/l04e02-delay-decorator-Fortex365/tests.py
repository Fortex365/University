import time

from delay import delay

def test_delay():
    @delay()
    def my_sum(a, b):
        return a + b
    
    start = time.perf_counter()
    result = my_sum(2, 3)
    duration = time.perf_counter() - start

    assert duration > 1
    assert result == 5

def test_delay_long():
    @delay(seconds=3)
    def my_sum(a, b):
        return a + b
    
    start = time.perf_counter()
    result = my_sum(2, 3)
    duration = time.perf_counter() - start

    assert duration > 3
    assert result == 5
    