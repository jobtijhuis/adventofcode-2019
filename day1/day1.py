import math
from pathlib import Path

DAY_DIR = Path(__file__).parent

# Part 1
def calculate_fuel(mass):
    return math.floor(mass / 3) - 2

# Part 2
def calculate_module_fuel(mass):
    module_fuel = calculate_fuel(mass)
    if module_fuel > 0:
        return calculate_module_fuel(module_fuel) + module_fuel
    else:
        return 0

total_fuel = 0
with open(DAY_DIR / 'input.txt', 'r') as file:
    for line in file:
        module_mass = int(line)
        module_fuel = calculate_module_fuel(module_mass)
        total_fuel += module_fuel

# print(f"input: {12} output: {calculate_fuel(12)}")
# print(f"input: {14} output: {calculate_fuel(14)}")
# print(f"input: {1969} output: {calculate_fuel(1969)}")
# print(f"input: {100756} output: {calculate_fuel(100756)}")

# print(f"input: {12} output: {calculate_module_fuel(12)}")
# print(f"input: {14} output: {calculate_module_fuel(14)}")
# print(f"input: {1969} output: {calculate_module_fuel(1969)}")
# print(f"input: {100756} output: {calculate_module_fuel(100756)}")

print(f"Total fuel: {total_fuel}")
