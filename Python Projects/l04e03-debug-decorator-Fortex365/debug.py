import functools


def debug(func):
    """Decorator which serves as simple debugging tool.

    Args:
        func (Function): Function you want to debug.

    Returns:
        Function: Wrapper function around your given function,
        printing the called function with parameters and the result itself.

    Example:
    @debug
    def my_sum(a,b):
        return a + b

    my_sum(1,b=2)

    >>> Calling: my_sum(1, b=2)
    >>> Result: 3
    """
    @functools.wraps(func)
    def wrapper_debug(*args, **kwargs):
        args_repr = []
        for arg in args:
            args_repr.append(repr(arg))

        kwargs_repr = []
        if kwargs:
            for key, value in kwargs.items():
                kwargs_repr.append(f"{key}={repr(value)}")

        value = func(*args, **kwargs)

        print(
            f"Calling: {func.__name__}({', '.join(args_repr + kwargs_repr)})")
        print(f"Result: {repr(value)}")

        return value

    return wrapper_debug

