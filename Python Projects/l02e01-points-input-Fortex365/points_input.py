X, Y = 0, 1

points_input = input("Please enter points: ")

split_points = points_input.split(";")

output = []

for point in split_points:
    point_split_coords = point.split(",")
    point_x_squared = float(point_split_coords[X]) ** 2
    point_y_squared = float(point_split_coords[Y]) ** 2
    output.append({"x": point_x_squared, "y": point_y_squared})

print(output)