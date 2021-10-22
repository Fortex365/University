from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])


def read_points(text, separator = ";"):
    """Parses points as string and returns them in a list as namedTuple.

    Args:
        text (str): Point reprezentation in string.
        separator (str, optional): Separator of each point.. Defaults to None.

    Returns:
        list: Each point is in namedTuple appended in the list.
    """
    split_points = text.split(separator)

    output = []

    for point in split_points:
        ptx, pty = point.split(",")
        output.append(Point(float(ptx), float(pty)))

    return output