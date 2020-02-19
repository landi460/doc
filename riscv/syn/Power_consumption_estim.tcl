read_verilog -netlist ../netlist/riscv.v
read_saif -input ../saif/riscv.saif -instance tb_fir/UUT -unit ns -scale 1
create_clock -name MY_CLK clk

report_power > ./Reports/riscv.txt
