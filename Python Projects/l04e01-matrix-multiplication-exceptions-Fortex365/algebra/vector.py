def dot_product(vector_1, vector_2):
    """Makes a dot product of two given vectors

    Args:
        vector_1 (list): First vector as list.
        vector_2 (list): Second vector as list.

    Returns:
        int: Dot product of given vectors.
    """
    if len(vector_1) != len(vector_2):
        raise ValueError(f"Vectors are not the same size, {len(vector_1)} and {len(vector_2)} was given.")
    
    result = []
    
    for a, b in zip(vector_1, vector_2):
        result.append(a * b)

    return sum(result)