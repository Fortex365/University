import pathlib as p

csvs = p.Path.cwd().joinpath("data").glob("*/*.csv")

summation = 0

for file in csvs:
   with file.open(mode="r") as f:
       for line in f:
            line = line.strip("\n")
            line = line.split(",")
            line = [int(num) for num in line]
            summation += sum(line)

print(summation)