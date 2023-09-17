ghdl -a ula.vhd
ghdl -e ula

ghdl -a ula_tb.vhd
ghdl -e ula_tb


ghdl  -r  ula_tb  --wave=ula_tb.ghw
gtkwave ula_tb.ghw