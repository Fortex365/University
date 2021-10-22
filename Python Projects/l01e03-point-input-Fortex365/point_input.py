points_input = input("Please enter an point where x and y coordinates are separated by comma (i.e. 20,-10.23): ")
points_input = points_input.strip()

comma_index = points_input.index(",")
point_x = points_input[:comma_index]
point_y = points_input[comma_index+1:]

point_x = float(point_x)
point_y = float(point_y)

print(f"x^2: {point_x ** 2}, y^2: {point_y ** 2}")