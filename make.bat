ghdl -a mux8x1_16bits.vhd
ghdl -e mux8x1_16bits

ghdl -a mux4x1_16bits.vhd
ghdl -e mux4x1_16bits

ghdl -a mux2x1_3bits.vhd
ghdl -e mux2x1_3bits

ghdl -a decoder_3to8.vhd
ghdl -e decoder_3to8

ghdl -a reg_16bits.vhd
ghdl -e reg_16bits

ghdl -a reg_1bit.vhd
ghdl -e reg_1bit

ghdl -a reg_3bits.vhd
ghdl -e reg_3bits

ghdl -a reg_15bits.vhd
ghdl -e reg_15bits

ghdl -a reg_8bits.vhd
ghdl -e reg_8bits

ghdl -a incrementador.vhd
ghdl -e incrementador

ghdl -a ula.vhd
ghdl -e ula

ghdl -a rom.vhd
ghdl -e rom

ghdl -a ram.vhd
ghdl -e ram

ghdl -a maq_estados.vhd
ghdl -e maq_estados

ghdl -a banco_reg.vhd
ghdl -e banco_reg

ghdl -a pc.vhd
ghdl -e pc

ghdl -a uc.vhd
ghdl -e uc

ghdl -a processador.vhd
ghdl -e processador

ghdl -a processador_tb.vhd
ghdl -e processador_tb


ghdl  -r  processador_tb  --wave=processador_tb.ghw
gtkwave processador_tb.ghw
