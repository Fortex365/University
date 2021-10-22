matrix = (
    (1, -2, 5, 20),
    (0, 2, 3, 400),
    (100, 2, 3, 4)
)

maximal = None
summation = 0

for row_idx, row in enumerate(matrix):
    print(f"{row_idx} {row}")
    summation += sum(row)

    if not maximal:
        maximal = max(row)
    else:
        maximal = max(maximal,  max(row))
print(f"{maximal=}, {summation=}")