library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end rom_tb;

architecture a_rom_tb of rom_tb is

    component rom is
        port(
            clk  : in std_logic;
            addr : in unsigned (7 downto 0);
            data : out unsigned (14 downto 0)
        );
    end component;

    constant period_time : time       := 100 ns;     -- periodo do clock
    signal finished      : std_logic  := '0';        -- flag finalizacao da simulacao
    signal clk_s         : std_logic;
    signal addr_s        : unsigned (7 downto 0);
    signal data_s        : unsigned (14 downto 0);

begin

    uut: rom port map (clk  => clk_s,
                       addr => addr_s,
                       data => data_s);

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
        addr_s <= "00000000";
        wait for 100 ns;
        addr_s <= "00000001";
        wait for 100 ns;
        addr_s <= "00000010";
        wait for 100 ns;
        addr_s <= "00000011";
        wait for 100 ns;
        addr_s <= "00000100";
        wait for 100 ns;
        addr_s <= "00000101";
        wait for 100 ns;
        addr_s <= "00000110";
        wait for 100 ns;
        addr_s <= "00000111";
        wait for 100 ns;
        addr_s <= "00001000";
        wait for 100 ns;
        addr_s <= "00001001";
        wait for 100 ns;
        addr_s <= "00001010";
        wait for 100 ns;
        addr_s <= "00001011";
        wait for 100 ns;
        addr_s <= "00100000";
        wait for 100 ns;
        addr_s <= "11111111";
        wait;
    end process;

end architecture;