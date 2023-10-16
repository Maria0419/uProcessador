library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados_tb is
end maq_estados_tb;

architecture a_maq_estados_tb of maq_estados_tb is

    component maq_estados is
        port(
            estado           : out std_logic;
            clk, rst, enable : in std_logic
        );
    end component;

    constant period_time : time       := 100 ns;     -- periodo do clock
    signal finished      : std_logic  := '0';        -- flag finalizacao da simulacao
    signal clk_s         : std_logic;
    signal estado_s      : std_logic;
    signal rst_s         : std_logic;
    signal enable_s      : std_logic;

begin

    uut: maq_estados port map (estado => estado_s,
                               clk    => clk_s,
                               rst    => rst_s,
                               enable => enable_s);

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
        enable_s <= '1';
        wait;
    end process;
    
end architecture;