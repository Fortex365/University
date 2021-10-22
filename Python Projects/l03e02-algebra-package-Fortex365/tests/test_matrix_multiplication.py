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
def test_matrix_multiplication(matrix_1, matrix_2, expected):
    assert matrix_multiplication(matrix_1, matrix_2) == expected
