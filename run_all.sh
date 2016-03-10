mkdir work
cd work
ghdl -i --work=unisim ../SimulationModels/unisims/*.vhd
ghdl -i --work=unisim ../SimulationModels/unisims/primitive/*.vhd
ghdl -i ../Core/*.vhd
ghdl -i ../Package/*.vhd
ghdl -i ../Primitive/*.vhd
ghdl -i ../Testbench/*.vhd
ghdl -m tb_SyncResetCtrl
ghdl -r tb_SyncResetCtrl --stop-time=500ns
cd ..
rm -rf work
