
# Ball and stick 2: Build a ring network of ball-and-stick cells

from neuron import h
from neuron.units import ms, mV, µm 

import matplotlib.pyplot as plt   # For plotting using matplotlib
from matplotlib.lines import Line2D  # Import Line2D for custom legend entries

h.load_file("stdrun.hoc") #load the standard run library to give us high-level simulation control functions (e.g. running a simulation for a given period of time):


class BallAndStick:
    def __init__(self, gid):
        self._gid = gid
        self._setup_morphology()
        self._setup_biophysics()

    def _setup_morphology(self):
        self.soma = h.Section(name="soma", cell=self)
        self.dend = h.Section(name="dend", cell=self)
        self.dend.connect(self.soma)
        self.all = self.soma.wholetree()
        self.soma.L = self.soma.diam = 12.6157 * µm
        self.dend.L = 200 * µm
        self.dend.diam = 1 * µm

    def _setup_biophysics(self):
        for sec in self.all:
            sec.Ra = 100  # Axial resistance in Ohm * cm
            sec.cm = 1  # Membrane capacitance in micro Farads / cm^2
        self.soma.insert("hh")
        for seg in self.soma:
            seg.hh.gnabar = 0.12  # Sodium conductance in S/cm2
            seg.hh.gkbar = 0.036  # Potassium conductance in S/cm2
            seg.hh.gl = 0.0003  # Leak conductance in S/cm2
            seg.hh.el = -54.3 * mV  # Reversal potential 
        self.dend.insert("pas")  # # Insert passive current in the dendrite  
        for seg in self.dend:   
            seg.pas.g = 0.001  # Passive conductance in S/cm2        
            seg.pas.e = -65 * mV  # Leak reversal potential             

    def __repr__(self):
        return "BallAndStick[{}]".format(self._gid)


my_cell = BallAndStick(0)

