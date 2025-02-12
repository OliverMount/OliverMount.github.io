
# Ball and stick 2: Build a ring network of ball-and-stick cells

from neuron import h, gui
from neuron.units import ms, mV

import matplotlib.pyplot as plt   # For plotting using matplotlib
from matplotlib.lines import Line2D  # Import Line2D for custom legend entries

h.load_file("stdrun.hoc") #load the standard run library to give us high-level simulation control functions (e.g. running a simulation for a given period of time):

    
# A new Cell

class Cell:
    def __init__(self, gid, x, y, z, theta):
        self._gid = gid
        self._setup_morphology()
        self.all = self.soma.wholetree()
        self._setup_biophysics()
        self.x = self.y = self.z = 0  # <-- NEW
        h.define_shape()
        self._rotate_z(theta)  # <-- NEW
        self._set_position(x, y, z)  # <-- NEW

    def __repr__(self):
        return "{}[{}]".format(self.name, self._gid)

    # everything below here is NEW

    def _set_position(self, x, y, z):
        for sec in self.all:
            for i in range(sec.n3d()):
                sec.pt3dchange(
                    i,
                    x - self.x + sec.x3d(i),
                    y - self.y + sec.y3d(i),
                    z - self.z + sec.z3d(i),
                    sec.diam3d(i),
                )
        self.x, self.y, self.z = x, y, z

    def _rotate_z(self, theta):
        """Rotate the cell about the Z axis."""
        for sec in self.all:
            for i in range(sec.n3d()):
                x = sec.x3d(i)
                y = sec.y3d(i)
                c = h.cos(theta)
                s = h.sin(theta)
                xprime = x * c - y * s
                yprime = x * s + y * c
                sec.pt3dchange(i, xprime, yprime, sec.z3d(i), sec.diam3d(i))




# The only difference between the Practice1 and Practice 2 BallAndStick is the removal of init and repr class
# And it is inherited from the Cell parent class
class BallAndStick(Cell):
    name = "BallAndStick"

    def _setup_morphology(self):
        self.soma = h.Section(name="soma", cell=self)
        self.dend = h.Section(name="dend", cell=self)
        self.dend.connect(self.soma)
        self.soma.L = self.soma.diam = 12.6157
        self.dend.L = 200
        self.dend.diam = 1

    def _setup_biophysics(self):
        for sec in self.all:
            sec.Ra = 100  # Axial resistance in Ohm * cm
            sec.cm = 1  # Membrane capacitance in micro Farads / cm^2
        self.soma.insert("hh")
        for seg in self.soma:
            seg.hh.gnabar = 0.12  # Sodium conductance in S/cm2
            seg.hh.gkbar = 0.036  # Potassium conductance in S/cm2
            seg.hh.gl = 0.0003  # Leak conductance in S/cm2
            seg.hh.el = -54.3  # Reversal potential in mV
        # Insert passive current in the dendrite
        self.dend.insert("pas")
        for seg in self.dend:
            seg.pas.g = 0.001  # Passive conductance in S/cm2
            seg.pas.e = -65  # Leak reversal potential mV  

mycell = BallAndStick(0, 0, 0, 0, 0)  


def create_n_BallAndStick(n, r):
    """n = number of cells; r = radius of circle"""
    cells = []
    for i in range(n):
        theta = i * 2 * h.PI / n
        cells.append(BallAndStick(i, h.cos(theta) * r, h.sin(theta) * r, 0, theta))
    return cells


my_cells = create_n_BallAndStick(7, 50)
ps = h.PlotShape(True)
ps.show(0)

my_cells = create_n_BallAndStick(5, 50) 
#my_cells = create_n_BallAndStick(50, 1)


## For connecting cells

# Event-based communication between objects in NEURON takes place via network connection objects called NetCons. 
# Each NetCon has a source and target, where the source is typically a spike threshold detector. 
# When a spike is detected, the NetCon sends a message to a target, usually a synapse on a postsynaptic cell.


#ExpSyn  # External Synapse Object
## For creating spikes () 

stim = h.NetStim()  # Make a new stimulator (generates spike events at specified intervals or with randomized timing.)
stim.number = 1  # The total number of spikes to generate. 
stim.start = 9 #The time (in ms) at which the first spike is most likely to occur.

#noise: A fractional value between 0 and 1 that controls randomness in spike timing:
#0: Deterministic, fixed intervals between spikes.
#1: Fully random intervals with an exponential distribution.

## Attach it to a synapse in the middle of the dendrite
## of the first cell in the network. (Named 'syn_' to avoid
## being overwritten with the 'syn' var assigned later.)
syn_ = h.ExpSyn(my_cells[0].dend(0.5)) 
syn_.tau = 2 * ms

ncstim = h.NetCon(stim, syn_) # The time delay (in ms) between when the source generates an event and when it is delivered to the target.
ncstim.delay = 1 * ms
ncstim.weight[0] = 0.04  # NetCon weight is a vector.


## Check if the frist cell works


recording_cell = my_cells[0]
soma_v = h.Vector().record(recording_cell.soma(0.5)._ref_v)
dend_v = h.Vector().record(recording_cell.dend(0.5)._ref_v)
t = h.Vector().record(h._ref_t)

h.finitialize(-65 * mV)
h.continuerun(25 * ms)


plt.plot(t, soma_v, label="soma(0.5)")
plt.plot(t, dend_v, label="dend(0.5)")
plt.legend()
plt.show()