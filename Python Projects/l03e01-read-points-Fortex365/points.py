def read_points(text, separator = ";"):
    """Parses points in string and returns them in a dictionary.

    Args:
        text (str): Point reprezentation in string.
        separator (str, optional): Separator of each point.. Defaults to None.

    Returns:
        list: Each point is in dictionary appended in the list.
    """
    split_points = text.split(separator)

    output = []

    for point in split_points:
        ptx, pty = point.split(",")
        output.append({"x": float(ptx), "y": float(pty)})

    return output