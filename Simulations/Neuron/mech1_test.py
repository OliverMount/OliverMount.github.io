from neuron import h

# Create a section
soma = h.Section(name='soma')
soma.L = soma.diam = 10  # Length and diameter

# Insert the mechanism defined in the MOD file
soma.insert('example')

# Access and modify range variable at specific positions
soma(0.5).range_var = 5.0  # Set range_var at the center of soma
print("Range variable at center:", soma(0.5).range_var)

# Access and modify global variable (same everywhere)
h.global_var = 2.0
print("Global variable:", h.global_var)

# Iterate through segments to observe range variable behavior
for seg in soma:
    print(f"Range variable at {seg.x}: {seg.range_var}")

