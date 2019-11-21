library verilog;
use verilog.vl_types.all;
entity inccomp is
    port(
        C               : out    vl_logic_vector(7 downto 0);
        ck              : in     vl_logic;
        rst             : in     vl_logic;
        INCA            : in     vl_logic;
        INCB            : in     vl_logic
    );
end inccomp;
