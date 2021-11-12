def arithmetic_progression(begin, step, end=None):
    """Generator for arithmetic progression

    Args:
        begin: Starting number.
        step: Next number to increase by.
        end (optional): Ending number. Defaults to None.

    Yields:
        Number in arithmetic serie.
    """
    while not end or begin < end:
        yield begin
        begin += step