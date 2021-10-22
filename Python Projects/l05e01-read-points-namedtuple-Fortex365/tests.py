import pytest

from points import read_points, Point


def test_point():
    point = Point(20, 10)

    assert point.x == 20
    assert point.y == 10


@pytest.mark.parametrize(
    "test_input,expected",
    [
        ("10,20;20,10", [Point(10.0, 20.0), Point(20.0, 10.0)]),
        ("1.234,0;10,20", [Point(1.234, 0.0), Point(10.0, 20.0)]),
    ],
)
def test_read_points(test_input, expected):
    assert read_points(test_input) == expected


@pytest.mark.parametrize(
    "test_input,separator,expected",
    [
        ("10,20_20,10", "_", [Point(10.0, 20.0), Point(20.0, 10.0)]),
        (
            "1.234,0*10,20*1.234,0*-10,20",
            "*",
            [
                Point(1.234, 0.0),
                Point(10.0, 20.0),
                Point(1.234, 0.0),
                Point(-10.0, 20.0),
            ],
        ),
    ],
)
def test_read_points_custom_separator(test_input, separator, expected):
    assert read_points(test_input, separator) == expected
