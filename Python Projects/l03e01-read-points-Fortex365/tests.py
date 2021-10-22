import pytest

from points import read_points


@pytest.mark.parametrize(
    "test_input,expected",
    [
        ("10,20;20,10", [{"x": 10.0, "y": 20.0}, {"x": 20.0, "y": 10.0}]),
        ("1.234,0;10,20", [{"x": 1.234, "y": 0.0}, {"x": 10.0, "y": 20.0}]),
    ],
)
def test_read_points(test_input, expected):
    assert read_points(test_input) == expected


@pytest.mark.parametrize(
    "test_input,separator,expected",
    [
        ("10,20_20,10", "_", [{"x": 10.0, "y": 20.0}, {"x": 20.0, "y": 10.0}]),
        (
            "1.234,0*10,20*1.234,0*-10,20",
            "*",
            [
                {"x": 1.234, "y": 0.0},
                {"x": 10.0, "y": 20.0},
                {"x": 1.234, "y": 0.0},
                {"x": -10.0, "y": 20.0},
            ],
        ),
    ],
)
def test_read_points_custom_separator(test_input, separator, expected):
    assert read_points(test_input, separator) == expected
