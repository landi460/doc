#!/bin/bash

source /software/scripts/init_synopsys_64.18

vcd2saif -input ../vcd/riscv.vcd -output ../saif/riscv.saif

dc_shell-xg-t -f Power_consumption_estim.tcl
