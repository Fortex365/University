import pytest

from algebra.matrix import matrix_multiplication


@pytest.mark.parametrize(
    "matrix_1,matrix_2,expected",
    [
        (
            [[1, -2, 5, 20], [0, 2, 3, 4], [100, 2, 3, 4]],
            [[10, -2], [0, 20], [100, 2], [2, 10]],
            [[550, 168], [308, 86], [1308, -114]],
        ),
    ],
)
def test_dot_product(matrix_1, matrix_2, expected):
    assert matrix_multiplication(matrix_1, matrix_2) == expected


@pytest.mark.parametrize(
    "matrix_1,matrix_2",
    [
        ([[1, -2, 5], [0, 2, 3], [100, 2, 3]], [[10, -2], [0, 20], [100, 2], [2, 10]]),
        (
            [[1, -2, 5, 20], [0, 2, 3, 4], [100, 2, 3, 4]],
            [[10, -2], [0, 20], [100, 2]],
        ),
    ],
)
def test_dot_product_exception(matrix_1, matrix_2):
    with pytest.raises(ValueError):
        matrix_multiplication(matrix_1, matrix_2)
