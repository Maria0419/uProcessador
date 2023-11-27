library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_1bit is
    port (
        data_in         : in std_logic;
        data_out        : out std_logic;
        wr_en, clk, rst : in std_logic
    );
end reg_1bit;

architecture a_reg_1bit of reg_1bit is

    signal reg : std_logic;

begin

    process (clk, rst, wr_en)
    begin
        if (rst = '1') then
            reg <= '0';
        elsif (wr_en = '1') then
            if (rising_edge(clk)) then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
    
end architecture;