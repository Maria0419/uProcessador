library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port (
        x, y : in unsigned(15 downto 0);
        op : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0)
    );
    end component;

    signal x, y, saida : unsigned(15 downto 0);
    signal op : unsigned(1 downto 0);

begin
    utt: ula port map ( x => x, 
                        y => y, 
                        op => op,
                        saida => saida);

    process
    begin
        -- soma
        x <= "0100110011001110";
        y <= "0010011110001111";
        op <= "00";
        wait for 10 ns;
        -- subtracao
        x <= "0110110011001110";
        y <= "0010011111001111";
        op <= "01";
        wait for 10 ns;
        -- maior -> true
        x <= "0010110101000010"; -- 0x34A2
        y <= "0010011111101111"; -- 0x27EF
        op <= "10";
        wait for 10 ns;
        -- maior -> false
        x <= "0010110010101101"; -- 0x34AD
        y <= "0010110010101101"; -- 0x34AD
        op <= "10";
        wait for 10 ns;
        -- igual -> true 
        x <= "0010110010101101"; -- 0x34AD
        y <= "0010110010101101"; -- 0x34AD
        op <= "11";
        wait for 10 ns;
        --igual -> false
        x <= "0000110011101110"; -- 0x1C7E
        y <= "0000010110101001"; -- 0x0B29
        op <= "11";
        wait for 10 ns;
        wait;

    end process;
    end architecture;
