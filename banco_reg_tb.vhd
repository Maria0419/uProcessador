library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_tb is
end;

architecture a_banco_reg_tb of banco_reg_tb is 
    component banco_reg is
        port (
        rd_reg0, rd_reg1, wr_reg : in unsigned (2 downto 0);
        wr_data : in unsigned (15 downto 0);
        out_data0, out_data1 : out unsigned (15 downto 0);
        wr_en, clk, rst : in std_logic
    );
    end component;

    constant period_time : time       := 100 ns;
    signal finished      : std_logic  := '0';
    signal clk, reset, wr_enable : std_logic;
    signal read0, read1, write1 : unsigned(2 downto 0);
    signal data_in1, data_out0, data_out1 : unsigned(15 downto 0);

begin
    uut: banco_reg port map (
        clk => clk,
        rst => reset,
        wr_en => wr_enable,
        wr_data=> data_in1,
        rd_reg0 => read0,
        rd_reg1 => read1,
        wr_reg => write1,
        out_data0 => data_out0,
        out_data1 => data_out1
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2;
        reset <= '0';
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
       wr_enable <= '0';
       wait for 200 ns;
        wr_enable <= '1';
        write1 <= "011";
        data_in1 <= "1100101100101001";
        wait for 100 ns;
        wr_enable <= '1';
        write1 <= "101";
        data_in1 <= "0110110101110101";
        wait for 100 ns;
        wr_enable <= '0';
        write1 <= "111";
        data_in1 <= "1111111111111111";
        wait for 100 ns;
        wr_enable <= '0';
        read0 <= "011";
        read1 <= "101";
        wait for 100 ns;
        wr_enable <= '1';
        write1 <= "000";
        data_in1 <= "1011101110101111";
        wait for 150 ns;
        wr_enable <= '0';
        read0 <= "000";
        read1 <= "111";
        wait for 100 ns;
        wait;


    end process;


end architecture;