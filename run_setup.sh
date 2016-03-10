#!/bin/bash
mkdir work
cd work
ghdl -i --work=unisim ../SimulationModels/*.vhd
ghdl -i ../Core/*.vhd
ghdl -i ../Package/*.vhd
ghdl -i ../Primitive/*.vhd
ghdl -i ../Testbench/*.vhd
