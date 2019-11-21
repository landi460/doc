vcom -93 -work ./work ./fa.vhd
vcom -93 -work ./work ./rca.vhd

vcom -93 -work ./work ./rca_tb.vhd

vsim -t ns -novopt work.rca_tb

set NumericStdNoWarnings 1 
run 0 ps
set NumericStdNoWarnings 0 

add wave -radix binary   -color GREEN      sim:/rca_tb/A_TB
add wave -radix binary   -color GREEN      sim:/rca_tb/B_TB
add wave -radix binary    -color GREEN      sim:/rca_tb/Ci_TB
add wave -radix binary   -color BLUE       sim:/rca_tb/S_TB
add wave -radix binary   -color RED        sim:/rca_tb/Co_TB

run 60 ns
