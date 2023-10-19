library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel2_tb is
end;

architecture a_toplevel2_tb of toplevel2_tb is
    component toplevel2 is
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : out std_logic
        );
    end component;


    constant period_time            : time       := 100 ns;     -- periodo do clock
    signal finished                 : std_logic  := '0';        -- flag finalizacao da simulacao
    signal clk_s, rst_s, estado_s : std_logic;
    
begin
    uut: toplevel2 port map (clk => clk_s,
                             rst => rst_s,
                             estado => estado_s

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

end architecture;
