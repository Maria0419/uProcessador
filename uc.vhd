library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk, rst    : in std_logic;
        opcode      : in unsigned (3 downto 0);

        ula_op      : out unsigned (1 downto 0);    --operacao da ula
        rd0_sel     : out std_logic;                --'0' -> zero, '1' -> acumulador
        rd1_sel     : out std_logic;                --'0' -> zero, '1' -> registrador src
        wr_sel      : out std_logic;                --'0' -> registrador dest, '1' -> acumulador 
        pc_wr       : out std_logic;                --atualizar o PC
        ir_wr       : out std_logic;                --escrever instrucao no IR
        jump_en     : out std_logic;                --habilitar salto
        reg_wr_en   : out std_logic;                --escrever no RB
        ula_sel     : out std_logic                 --selecao registrador ('0') ou constante ('1')
    );
end entity;

architecture a_uc of uc is
    component maq_estados is
        port( 
            clk,rst: in std_logic;
            estado: out unsigned (1 downto 0)
        );
        end component;

    --sinais internos
    signal estado_s  : unsigned (1 downto 0);
    signal jump_en_s : std_logic;
    signal ula_op_s  : unsigned (1 downto 0);
    signal ula_sel_s : std_logic;
    signal rd0_sel_s : std_logic;
    signal rd1_sel_s : std_logic;
    signal wr_sel_s  : std_logic;

begin

    maquinaestados: maq_estados port map (
        clk => clk,
        rst => rst,
        estado => estado_s
    );

    --FETCH -> atualiza o PC
    pc_wr <= '1' when estado_s = "00" else '0';
    --DECODE -> escreve instrucao no IR
    ir_wr <= '1' when estado_s = "01" else '0';
    --EXECUTE -> se a operacao envolve escrita, escreve resultado no RB
    reg_wr_en <= '1' when estado_s = "10" and (opcode = "0001" or opcode = "0101" or opcode = "0110") else '0';

    -- determina os sinais de controle no estado DECODE
    jump_en_s <= '1' when opcode = "1111" else '0';

    ula_op_s <= "00" when opcode = "0001" or opcode = "0101" or opcode = "0110" else
                "01" when opcode = "0010" else
                "10" when opcode = "0011" else
                "11" when opcode = "0100" else
                "00";
    
    ula_sel_s <= '1' when opcode = "0101" else
                 '0';
    

    -- opcode "0001" -> ADD A, Rn     -> rd0 = A, rd1 = Rn, wr = A
    -- opcode "0101" -> MOV Rn, #data -> rd0 = zero, rd1 = zero (#data), wr = Rn
    -- opcode "0110" -> MOV Rn, A     -> rd0 = A, rd1 = zero, wr = Rn

    rd0_sel_s <= '0' when opcode = "0101" else
                 '1' when opcode = "0001" or opcode = "0110" else
                 '0';
    rd1_sel_s <= '0' when opcode = "0110" else
                 '1' when opcode = "0001" else
                 '0';
    wr_sel_s <= '0' when opcode = "0101" or opcode = "0110" else
                '1' when opcode = "0001" else
                '0';
    

    -- envia os sinais de controle no estado EXECUTE
    ula_op <= ula_op_s when estado_s = "10" else "00";
    jump_en <= jump_en_s when estado_s = "10" else '0';
    ula_sel <= ula_sel_s when estado_s = "10" else '0';
    rd0_sel <= rd0_sel_s when estado_s = "10" else '0';
    rd1_sel <= rd1_sel_s when estado_s = "10" else '0';
    wr_sel <= wr_sel_s when estado_s = "10" else '0';

end architecture;