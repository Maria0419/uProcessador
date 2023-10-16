ghdl -a ula.vhd
ghdl -e ula

ghdl -a ula_tb.vhd
ghdl -e ula_tb

ghdl -a mux_8x1.vhd
ghdl -e mux_8x1

ghdl -a decoder_3to8.vhd
ghdl -e decoder_3to8

ghdl -a reg_16bits.vhd
ghdl -e reg_16bits

ghdl -a banco_reg.vhd
ghdl -e banco_reg


ghdl -a banco_reg_tb.vhd
ghdl -e banco_reg_tb


ghdl -a mux2x1.vhd
ghdl -e mux2x1

ghdl -a toplevel.vhd
ghdl -e toplevel

ghdl -a toplevel_tb.vhd
ghdl -e toplevel_tb

ghdl  -r  ula_tb  --wave=ula_tb.ghw
gtkwave ula_tb.ghw

ghdl  -r  toplevel_tb  --wave=toplevel_tb.ghw
gtkwave toplevel_tb.ghw