library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_3bits is
    port (
        data_i  : in unsigned (2 downto 0);
        data_o : out unsigned (2 downto 0);
        wr_en, clk, rst : in std_logic
    );
end reg_3bits;

architecture a_reg_3bits of reg_3bits is

    signal reg : unsigned (2 downto 0);

begin

    process (clk, rst, wr_en)
    begin
        if (rst = '1') then
            reg <= "000";
        elsif (wr_en = '1') then
            if (rising_edge(clk)) then
                reg <= data_i;
            end if;
        end if;
    end process;

    data_o <= reg;
end architecture;