OUTPUT_PREFIX = "Result"

input_number = 42

remainder = input_number % 2

if remainder:
    result = "odd"
else:
    result = "even"

print(f"{OUTPUT_PREFIX}: number {input_number} is {result}, since division remainer is {remainder}.")