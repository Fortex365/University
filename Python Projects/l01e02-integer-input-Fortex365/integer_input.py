user_input = input("Please enter an integer with atleast 3 digits : ")
user_input = user_input.strip()

if ((len(user_input) >= 3 and user_input[0] != "-") or
    (len(user_input) > 3 and user_input[0] == "-")):
    print(f"Digit in the tens position is {user_input[-2]}.")
else:
    print(f"Error: {user_input} has less than three digits.")