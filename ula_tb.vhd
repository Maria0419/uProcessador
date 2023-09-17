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
      --  x <= "0100110011001110";
      --  y <= "0010011110001111";
      --  op <= "00";
      --  wait for 10 ns;
        -- subtracao
      --  x <= "0110110011001110";
      --  y <= "0010011111001111";
      --  op <= "01";
      --  wait for 10 ns;
        -- maior ou igual -> true
      --  x <= "0010110101000010";	
      --  y <= "0010011111101111";
       -- op <= "10";
       -- wait for 10 ns;
        -- maior ou igual -> false
       -- x <= "0010011110001111";
       -- y <= "0100110011001110";
       -- op <= "10";
       -- wait for 10 ns;
        --maior igual -> true (x = y)
       -- x <= "0010010010101101";
       -- y <= "0010010010101101";
       -- op <= "10";
       -- wait for 10 ns;
        --multiplicacao
        x <= "0000110011101110";
        y <= "0000010110101001";
        op <= "11";
        wait for 10 ns;
        wait;

    end process;
    end architecture;
