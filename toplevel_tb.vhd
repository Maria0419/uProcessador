library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_tb is
end;

architecture a_toplevel_tb of toplevel_tb is
    component toplevel is
        port(
            wr_en : in std_logic;
            rst : in std_logic;
            clk : in std_logic;
            constant_mux1 : in unsigned(15 downto 0);
            ula_o : out unsigned(15 downto 0);
            ula_operation : in unsigned(1 downto 0);
            mux1_selection : in std_logic;
            read_reg0 : in unsigned(2 downto 0);
            read_reg1 : in unsigned(2 downto 0);
            write_reg : in unsigned(2 downto 0);
            rom_o : out unsigned(14 downto 0)
        );
    end component;


    constant period_time            : time       := 100 ns;     -- periodo do clock
    signal finished                 : std_logic  := '0';        -- flag finalizacao da simulacao
    signal wr_en_s, rst_s, clk_s    : std_logic;                
    signal constant_mux1_s          : unsigned(15 downto 0);
    signal ula_o_s                  : unsigned(15 downto 0);
    signal ula_operation_s          : unsigned(1 downto 0);
    signal mux1_selection_s         : std_logic;
    signal read_reg0_s              : unsigned(2 downto 0);
    signal read_reg1_s              : unsigned(2 downto 0);
    signal write_reg_s              : unsigned(2 downto 0);
    signal rom_o_s                  : unsigned(14 downto 0);



begin
    uut: toplevel port map (
        wr_en => wr_en_s,
        rst => rst_s,
        clk => clk_s,
        constant_mux1 => constant_mux1_s,
        ula_o => ula_o_s,
        ula_operation => ula_operation_s,
        mux1_selection => mux1_selection_s,
        read_reg0 => read_reg0_s,
        read_reg1 => read_reg1_s,
        write_reg => write_reg_s,
        rom_o => rom_o_s
    );


    -- reset global / simulation time / clock

    -- reset no inicio da simulacao
    reset_global: process
    begin
        rst_s <= '1';
        wait for period_time*2;
        rst_s <= '0';
        wait;
    end process;

    -- controla tempo de simulacao
    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    -- geracao do clock
    clk_proc: process
    begin
        while finished /= '1' loop
            clk_s <= '0';
            wait for period_time/2;
            clk_s <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process;


    process
    begin
        wr_en_s <= '0';
        wait for 200 ns;
        -- zero (x0) + constante (9DA7), escreve em x2
        wr_en_s <= '1';
        ula_operation_s <= "00";
        read_reg0_s <= "000";
        read_reg1_s <= "001";
        mux1_selection_s <= '1';
        write_reg_s <= "010";
        constant_mux1_s <= "1001110110100111";
        wait for 200 ns;
        -- zero (x0) + constante (D953), escreve em x3
        read_reg0_s <= "000";
        read_reg1_s <= "001";
        mux1_selection_s <= '1';
        write_reg_s <= "011";
        constant_mux1_s <= "1101100101010011";
        wait for 200 ns;
        -- 9DA7 (x2) + D953 (x3), escreve em x4
        mux1_selection_s <= '0';
        read_reg0_s <= "010";
        read_reg1_s <= "011";
        write_reg_s <= "100";
        wait for 200 ns;
        -- tenta escrever constante (1953) em x2 com wr_en = '0'
        wr_en_s <= '0';
        read_reg0_s <= "000";
        write_reg_s <= "010";
        mux1_selection_s <= '1';
        constant_mux1_s <= "0001100101010011";
        wait for 200 ns;
        -- verifica valor de x2 -> continua armazenando 9DA7
        wr_en_s <= '1';
        mux1_selection_s <= '0';
        read_reg0_s <= "010";
        read_reg1_s <= "000";
        write_reg_s <= "101";
        wait;
    end process;
    ---------------------------------------------------------

end architecture;