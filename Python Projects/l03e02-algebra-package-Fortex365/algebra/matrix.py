from .vector import dot_product


def matrix_multiplication(matrix_1, matrix_2):
    """Multiply M1 by M2 and returns new M.

    Args:
        matrix_1 (list): List reprezentation of first matrix.
        matrix_2 (list): List reprezentation of second matrix.

    Returns:
        list: Returns new matrix.
    """
    result = []

    for row in matrix_1:
        new_row = []
        # column is relative name for the nontransposed matrix_2
        for column in zip(*matrix_2):
            new_row.append(dot_product(row, column))
        result.append(new_row)

    return result


def new_matrix(shape, fill):
    """Creates new matrix based on shape (rows,columns) and default value to be filled with.

    Args:
        shape (tuple): Paired rows and columns in tuple.
        fill (int): Value to be the new matrix initialized with.

    Returns:
        list: Returns the new generated matrix.
    """
    rows_size, columns_size = shape
    matrix = []

    for _ in range(rows_size):
        matrix.append([fill] * columns_size)

    return matrix


def submatrix(matrix, drop_rows=[], drop_columns=[]):
    """Returns submatrix of given matrix by simple excluding given rows and columns.

    Args:
        matrix (list): List reprezentation of matrix.
        drop_rows (list, optional): A list containing indexed rows to be exluded in submatrix. Defaults to None.
        drop_columns (list, optional): A list containing indexed columns to be exluded in submatrix. Defaults to None.

    Returns:
        list: Returns new generated submatrix of matrix.
    """
    submatrix = []

    for row_idx, _ in enumerate(matrix):
        new_row = []
        if row_idx not in drop_rows:
            for column_idx, __ in enumerate(matrix[0]):
                if column_idx not in drop_columns:
                    new_row.append(matrix[row_idx][column_idx])
            if new_row:
                submatrix.append(new_row)

    return submatrix
