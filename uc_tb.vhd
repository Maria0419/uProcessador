library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end;

architecture a_uc_tb of uc_tb is
    component uc
        port( clk, rst : in std_logic;
              instruction : in unsigned(14 downto 0);
              jump_en : out std_logic;
              estado_maq : out std_logic;
              pc_wr_en : out std_logic
        );
    end component;

    constant period_time : time       := 100 ns;
    signal finished      : std_logic  := '0';
    signal clk, rst : std_logic;
    signal estado_maq, jump_en, pc_wr_en : std_logic;
    signal instruction : unsigned(14 downto 0);

begin
    uut: uc port map (  
        instruction => instruction,
        jump_en => jump_en,
        estado_maq => estado_maq,
        clk => clk,
        rst => rst,
        pc_wr_en => pc_wr_en
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process;

    process
    begin
        instruction <= "111100000000000";
        wait for 100 ns;
        instruction <= "111000000000000";
        wait for 100 ns;
    wait;
    end process;

end architecture;