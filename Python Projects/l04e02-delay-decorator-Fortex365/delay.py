import time
import functools


def delay(seconds=1):
    """Decorator which delays by given number of seconds the function before its invoked
    and returned its result.

    Args:
        seconds (int, optional): Number of seconds to be delayed. Defaults to 1.
    """
    def _delay(func):
        @functools.wraps(func)
        def wrapper_delay(*args, **kwargs):
            time.sleep(seconds)
            value = func(*args, **kwargs)
            return value
        return wrapper_delay
    return _delay
