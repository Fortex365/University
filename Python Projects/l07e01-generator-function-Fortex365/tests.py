import inspect
from progression import arithmetic_progression


def test_docstrings():
    assert arithmetic_progression.__doc__


def test_arithmetic():
    assert inspect.isgeneratorfunction(arithmetic_progression)
    assert list(arithmetic_progression(5, 2, 8)) == [5, 7]
    assert list(arithmetic_progression(5, 20, 6)) == [5]


def test_arithmetic_infinite():
    gen_ = arithmetic_progression(5, 2)

    assert next(gen_) == 5
    next(gen_) == 7
    next(gen_) == 9
    next(gen_) == 11