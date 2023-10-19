library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
    port(
        wr_en, rst, clk : in std_logic;             -- sinais de controle e clock
        mux1_selection : in std_logic;              -- selecao do mux ('0' -> registrador, '1' -> constante)
        constant_mux1 : in unsigned(15 downto 0);   -- constante a ser passada para a ULA
        ula_o : out unsigned(15 downto 0);          -- saida da ULA
        ula_operation : in unsigned(1 downto 0);    -- operacao da ULA
        read_reg0 : in unsigned(2 downto 0);        -- registradores de leitura
        read_reg1 : in unsigned(2 downto 0);
        write_reg : in unsigned(2 downto 0);         -- registrador de escrita
        rom_o : out unsigned(14 downto 0)           -- saida da ROM
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

    component rom is
        port 
        (
            clk  : in std_logic;
            addr : in unsigned (7 downto 0);
            data : out unsigned (14 downto 0)
        );
    end component;

    component pc is
        port (
            increase : in unsigned (7 downto 0);
            data_o : out unsigned (7 downto 0);
            clk, wr_en, rst : in std_logic
        );
    end component;

    component reg_15bits is
        port (
            data_in  : in unsigned (14 downto 0);
            data_out : out unsigned (14 downto 0);
            wr_en, clk, rst : in std_logic
        );
    end component;

    component uc is
        port (
            clk, rst : in std_logic;
            instruction : in unsigned(14 downto 0);
            jump_en : out std_logic;
            estado_maq : out std_logic;
            pc_wr_en : out std_logic
        );
    end component;

    -- sinais pra ligar um componente ao outro
    signal rb_to_ula : unsigned(15 downto 0);
    signal rb_to_mux : unsigned(15 downto 0);
    signal mux_to_ula : unsigned(15 downto 0);
    signal ula_to_rb : unsigned(15 downto 0);
    signal pc_to_rom : unsigned(7 downto 0);
    signal rom_to_instr_reg : unsigned (14 downto 0);
    signal instr_reg_to_uc : unsigned (14 downto 0);


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
    rom1: rom port map (
        clk => clk,
        addr => pc_to_rom,
        data => rom_o
    );
    pc1: pc port map (
        data_o => pc_to_rom,
        clk => clk,
        wr_en => wr_en,
        rst => rst
    );

    inst_reg: reg_15bits port map (
        data_in => rom_to_instr_reg,
        data_out => instr_reg_to_uc,
        clk => clk
    );

    uc1: uc port map (
        
    );
    ---------------------------------------------------------

    ula_o <= ula_to_rb;

end architecture;