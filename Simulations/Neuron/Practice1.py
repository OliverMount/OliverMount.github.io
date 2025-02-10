from neuron import h
from neuron.units import ms, mV, µm 

import matplotlib.pyplot as plt   # For plotting using matplotlib

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


# Make sure soma is hh and dendtrite is passive membrane
for sec in h.allsec():
    print("%s: %s" % (sec, ", ".join(sec.psection()["density_mechs"].keys())))
    

# Stimulus    
stim = h.IClamp(my_cell.dend(1))  # at the origin of the dentrite
stim.delay = 5 #ms
stim.dur = 1 #ms
stim.amp = 0.1  # nA


soma_v = h.Vector().record(my_cell.soma(0.5)._ref_v)  # this can be plotted directly
dend_v=h.Vector().record(my_cell.dend(0.5)._ref_v)
t = h.Vector().record(h._ref_t)

h.finitialize(-65 * mV) # initialize membrane potential  
h.continuerun(25 * ms) # run until time 25 ms:
    
    
plt.figure()
plt.plot(t, soma_v)
plt.xlabel("t (ms)")
plt.ylabel("v (mV)")
plt.show()


## For differnt values of stimulus input current

amps = [0.075 * i for i in range(1, 5)]  # [0.075, 0.15, 0.22499999999999998, 0.3]
colors = ["green", "blue", "red", "black"] 
for amp, color in zip(amps, colors):
    stim.amp = amp
    h.finitialize(-65 * mV)
    h.continuerun(25 * ms)
    plt.plot(t,list(soma_v),color=color) 
plt.show()


# Why the below is differnt from above? 
amps = [0.02,0.05,0.075,0.1,0.15]
colors = ["gray","green", "blue", "red", "black"]
for amp, color in zip(amps, colors):
    stim.amp = amp
    h.finitialize(-65 * mV)
    h.continuerun(25 * ms)
    plt.plot(t,list(soma_v),color=color) 
plt.show()




