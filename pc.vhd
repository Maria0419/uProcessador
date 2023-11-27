----------------------------------------------
--------------PROGRAM COUNTER-----------------
----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        increase        : in unsigned (7 downto 0);     --numero de enderecos de memoria que o pc deve incrementar
        data_o          : out unsigned (7 downto 0);    --endereco de memoria atual
        clk, wr_en, rst : in std_logic                  --clock, write enable e reset
    );
end pc;

architecture a_pc of pc is

    component reg_8bits is
        port(
            data_in         : in unsigned (7 downto 0);
            data_out        : out unsigned (7 downto 0);
            wr_en, clk, rst : in std_logic
        );
    end component;

    component incrementador is
        port(
            increase : in unsigned (7 downto 0);
            data_i   : in unsigned (7 downto 0);
            data_o   : out unsigned (7 downto 0)
        );
    end component;

    signal pc_out, incrementador_out : unsigned (7 downto 0);

begin

    pc_reg1: reg_8bits port map (data_in  => incrementador_out,
                                 data_out => pc_out,
                                 wr_en    => wr_en,
                                 clk      => clk,
                                 rst      => rst);

    incrementador1: incrementador port map (increase => increase,
                                            data_i   => pc_out,
                                            data_o   => incrementador_out);
                    
    data_o <= pc_out;

end architecture;