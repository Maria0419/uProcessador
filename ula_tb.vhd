library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port (
            x, y     : in unsigned(15 downto 0);
            op       : in unsigned(1 downto 0);
            saida    : out unsigned(15 downto 0);
            carry    : out std_logic;
            overflow : out std_logic
    );
    end component;

    signal x, y, saida : unsigned(15 downto 0);
    signal op : unsigned(1 downto 0);
    signal carry, overflow : std_logic;

begin
    utt: ula port map ( x => x, 
                        y => y, 
                        op => op,
                        saida => saida,
                        carry => carry,
                        overflow => overflow
                        );

    process
    begin
        -- soma (0x4CCE + 0x278F = 0x745D)
        x <= "0100110011001110";
        y <= "0010011110001111";
        op <= "00";
        wait for 10 ns;
        -- subtracao (0x6CCE - 0x27CF = 0x44FF)
        x <= "0110110011001110";
        y <= "0010011111001111";
        op <= "01";
        wait for 10 ns;
        -- multiplicacao (0x2D42 * 0x27EF = 0x[70F]4E9E)
        x <= "0010110101000010";
        y <= "0010011111101111";
        op <= "10";
        wait for 10 ns;
        -- xor (0x2CAD xor 0x2CAD = 0x0000)
        x <= "0010110010101101";
        y <= "0010110010101101";
        op <= "11";
        wait for 10 ns;
        --xor (0x0CEE xor 0x05A9 = 0x0947)
        x <= "0000110011101110";
        y <= "0000010110101001";
        op <= "11";
        wait for 10 ns;
        wait;

    end process;
    end architecture;