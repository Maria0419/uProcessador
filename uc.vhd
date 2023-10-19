library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk, rst : in std_logic;
        instruction : in unsigned(14 downto 0);
        jump_en : out std_logic;
        estado_maq : out std_logic;
        pc_wr_en : out std_logic
    );
end entity;

architecture a_uc of uc is
    component maq_estados is
        port( 
            clk,rst: in std_logic;
            estado: out std_logic
        );
        end component;



    signal opcode : unsigned(3 downto 0);
    signal estado_s : std_logic;


begin

    maquinaestado: maq_estados port map (
        clk => clk,
        rst => rst,
        estado => estado_s
    );

    estado_maq <= estado_s;
    opcode <= instruction(14 downto 11);
    jump_en <= '1' when opcode = "1111" else '0';
    pc_wr_en <= '1' when estado_s = '1' else '0';

end architecture;