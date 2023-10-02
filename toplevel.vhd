library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
    port(
        wr_en, rst, clk, mux1_selection : in std_logic;
        constant_mux1 : in unsigned(15 downto 0);
        ula_o : out unsigned(15 downto 0);
        ula_operation : in unsigned(1 downto 0);
        read_reg0 : in unsigned(2 downto 0);
        read_reg1 : in unsigned(2 downto 0);
        write_reg : in unsigned(2 downto 0)
    );
end entity;

architecture a_toplevel of toplevel is
    ---------------------------------------------------------
    -- declara os componentes que serão utilizados
    component ula is 
        port( 
            x, y : in unsigned(15 downto 0);
            op : in unsigned(1 downto 0);
            saida : out unsigned(15 downto 0)
        );
    end component;

    component banco_reg is 
        port(
            rd_reg0, rd_reg1, wr_reg : in unsigned (2 downto 0);
            wr_data : in unsigned (15 downto 0);
            out_data0, out_data1 : out unsigned (15 downto 0);
            wr_en, clk, rst : in std_logic
            );
    end component;

    component mux2x1 is
        port(
            sel : in std_logic;
            i0, i1 : in unsigned (15 downto 0);
            saida : out unsigned (15 downto 0)
        );
    end component;

    -- sinais pra ligar um componente ao outro
    signal rb_to_ula : unsigned(15 downto 0);
    signal rb_to_mux : unsigned(15 downto 0);
    signal mux_to_ula : unsigned(15 downto 0);
    signal ula_to_rb : unsigned(15 downto 0);


begin
    -- cria os componentes no toplevel
    ula1: ula port map (
        x => rb_to_ula,
        y => mux_to_ula,
        op => ula_operation,
        saida => ula_to_rb
    );

    bancoreg1: banco_reg port map (
        rd_reg0 => read_reg0,
        rd_reg1 => read_reg1,
        wr_reg => write_reg,
        wr_en => wr_en,
        rst => rst,
        clk => clk,
        wr_data => ula_to_rb,
        out_data0 => rb_to_ula,
        out_data1 => rb_to_mux
    );

    mux2x1_1: mux2x1 port map (
        sel => mux1_selection,
        i0 => rb_to_mux,
        i1 => constant_mux1,
        saida => mux_to_ula 
    );
    ---------------------------------------------------------

    ula_o <= ula_to_rb;

end architecture;