ghdl -a ula.vhd
ghdl -e ula

ghdl -a ula_tb.vhd
ghdl -e ula_tb

ghdl -a mux_8x1_16bits.vhd
ghdl -e mux_8x1_16bits

ghdl -a decoder_3to8.vhd
ghdl -e decoder_3to8

ghdl -a reg_16bits.vhd
ghdl -e reg_16bits

ghdl -a banco_reg.vhd
ghdl -e banco_reg


ghdl -a banco_reg_tb.vhd
ghdl -e banco_reg_tb


ghdl -a mux2x1_16bits.vhd
ghdl -e mux2x1_16bits

ghdl -a reg_8bits.vhd
ghdl -e reg_8bits

ghdl -a incrementador.vhd
ghdl -e incrementador

ghdl -a rom.vhd
ghdl -e rom

ghdl -a rom_tb.vhd
ghdl -e rom_tb

ghdl -a pc.vhd
ghdl -e pc

ghdl -a mux2x1_3bits.vhd
ghdl -e mux2x1_3bits

ghdl -a reg_15bits.vhd
ghdl -e reg_15bits


ghdl -a toplevel.vhd
ghdl -e toplevel

ghdl -a toplevel_tb.vhd
ghdl -e toplevel_tb

ghdl -a maq_estados.vhd
ghdl -e maq_estados

ghdl -a uc.vhd
ghdl -e uc



ghdl -a uc_tb.vhd
ghdl -e uc_tb

ghdl  -r  toplevel_tb  --wave=toplevel_tb.ghw
gtkwave toplevel_tb.ghw
