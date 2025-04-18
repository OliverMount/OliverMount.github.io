NEURON {
    SUFFIX example
    RANGE range_var
    GLOBAL global_var
}


UNITS {
    (mV) = (millivolt)  :  Declare 'mV' as millivolt

}

PARAMETER {
    range_var = 0.0 (mV)  : Initialize with value and units
    global_var = 1.0 (mV) 
}

