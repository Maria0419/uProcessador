library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
        port(
        clk     : in std_logic;
        rst     : in std_logic;
        estado  : out unsigned (1 downto 0);
        instr   : out unsigned (14 downto 0);
        reg1    : out unsigned (15 downto 0);
        reg2    : out unsigned (15 downto 0);
        ula_out : out unsigned (15 downto 0)
        );
    end component;

    constant period_time             : time       := 100 ns;     -- periodo do clock
    signal finished                  : std_logic  := '0';        -- flag finalizacao da simulacao
    signal rst_s, clk_s              : std_logic;                
    signal estado_s                  : unsigned (1 downto 0);
    signal instr_s                   : unsigned (14 downto 0);
    signal reg1_s, reg2_s, ula_out_s : unsigned (15 downto 0);

begin

    uut: processador port map (
        clk     => clk_s,
        rst     => rst_s,
        estado  => estado_s,
        instr   => instr_s,
        reg1    => reg1_s,
        reg2    => reg2_s,
        ula_out => ula_out_s
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
        wait for 103 us;
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