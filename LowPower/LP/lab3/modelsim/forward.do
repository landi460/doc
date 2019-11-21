# Loads the technological library and the SDF, resolution is ps
vsim -voptargs=+acc -L /software/dk/nangate45/verilog/msim6.5c -sdftyp /tbinccomp/DUT=../inccomp.sdf work.tbinccomp -t ps

#add wave *

# Generates the VCD file and add all the DUT signals
vcd file ../inccomp.vcd
vcd add /tbinccomp/DUT/*

# runs the simulation
run 2000ns
