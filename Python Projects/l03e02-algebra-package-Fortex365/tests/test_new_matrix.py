import pytest

from algebra.matrix import new_matrix


@pytest.mark.parametrize(
    "shape,fill,expected",
    [
        ((2, 2), 1.0, [[1.0, 1.0], [1.0, 1.0]]),
        ((3, 2), 0.0, [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]),
        ((2, 3), 0.0, [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]),
    ],
)
def test_new_matrix(shape, fill, expected):
    assert new_matrix(shape, fill) == expected
