library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_16bits is
    port (
        data_in  : in unsigned (15 downto 0);
        data_out : out unsigned (15 downto 0);
        wr_en, clk, rst : in std_logic
    );
end reg_16bits;

architecture a_reg_16bits of reg_16bits is

    signal reg : unsigned (15 downto 0);

begin

    process (clk, rst, wr_en)
    begin
        if (rst = '1') then
            reg <= "0000000000000000";
        elsif (wr_en = '1') then
            if (rising_edge(clk)) then
                reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg;
end architecture;