import pytest

from algebra.vector import dot_product

@pytest.mark.parametrize(
    "vector_1,vector_2,expected",
    [
        ([1, 2, 3], [3, 2, 1], 10),
        ([-1, 2, 3], [3, 2, 1], 4),
    ],
)
def test_dot_product(vector_1, vector_2, expected):
    assert dot_product(vector_1, vector_2) == expected