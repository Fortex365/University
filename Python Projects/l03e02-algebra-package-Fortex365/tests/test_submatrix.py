import pytest

from algebra.matrix import submatrix


@pytest.mark.parametrize(
    "matrix,drop_rows,drop_columns,expected",
    [
        ([[1,2,3], [1,2,3]], [], [0], [[2,3], [2,3]]),
        ([[1,2,3], [1,2,3]], [0], [0], [[2,3]]),
        ([[1,2,3], [1,2,3]], [0], [0,1], [[3]]),
        ([[1,2,3], [1,2,3]], [0], [0,1,2], []),
    ],
)
def test_submatrix(matrix, drop_rows, drop_columns, expected):
    assert submatrix(matrix, drop_rows, drop_columns) == expected
