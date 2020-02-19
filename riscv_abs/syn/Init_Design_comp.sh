#!/bin/bash

source /software/scripts/init_synopsys_64.18

mkdir work

dc_shell-xg-t -f Logic_syn.tcl
