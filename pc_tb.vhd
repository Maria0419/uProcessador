library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end pc_tb;

architecture a_pc_tb of pc_tb is

    component pc is
        port(
            data_i : in unsigned (7 downto 0);
            data_o : out unsigned (7 downto 0);
            clk, wr_en, rst : in std_logic
        );
    end component;

    constant period_time : time       := 100 ns;     -- periodo do clock
    signal finished      : std_logic  := '0';        -- flag finalizacao da simulacao
    signal clk_s         : std_logic;
    signal data_o_s      : unsigned (7 downto 0);
    signal data_i_s      : unsigned (7 downto 0);
    signal rst_s         : std_logic;
    signal wr_en_s       : std_logic;

begin

    uut: pc port map (data_i => data_i_s,
                      data_o => data_o_s,
                      clk    => clk_s,
                      wr_en  => wr_en_s,
                      rst    => rst_s);

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
        wr_en_s <= '1';
        data_i_s <= "00000000";   -- 0 -> 0
        wait for period_time*2;
        data_i_s <= "00000001";   -- 0 -> 1
        wait for period_time;
        data_i_s <= "00011100";   -- 1 -> 29
        wait for period_time;
        data_i_s <= "11111111";   -- 29 -> 28
        wait for period_time;
        data_i_s <= "00000010";   -- 28 -> 30
        wait for period_time;
        wr_en_s <= '0';
        data_i_s <= "00000001";   -- 30 -> 30
        wait;
    end process;
    
end architecture;