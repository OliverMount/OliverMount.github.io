NEURON {
    SUFFIX example
    RANGE range_var
    GLOBAL global_var
}

PARAMETER {
    range_var = 0.0  // Varies across compartments
    global_var = 1.0 // Same across all compartments
}

