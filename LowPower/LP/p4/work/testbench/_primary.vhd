library verilog;
use verilog.vl_types.all;
entity testbench is
    generic(
        CLOCK_PERIOD    : integer := 10;
        DELAY           : real    := 0.100000
    );
end testbench;
