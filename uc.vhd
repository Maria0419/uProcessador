library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk, rst    : in std_logic;
        opcode      : in unsigned (3 downto 0);

        estado      : out unsigned (1 downto 0);    --estado atual da maquina de estados

        ula_op      : out unsigned (1 downto 0);    --operacao da ula
        rd0_sel     : out unsigned (1 downto 0);    --'0' -> zero, '1' -> acumulador
        rd1_sel     : out std_logic;                --'0' -> zero, '1' -> registrador src
        wr_sel      : out std_logic;                --'0' -> registrador dest, '1' -> acumulador 
        pc_wr       : out std_logic;                --atualizar o PC
        jump_sel    : out unsigned (1 downto 0);    --selecao do endereco de salto
        reg_wr_en   : out std_logic;                --escrever no RB
        ula_sel     : out unsigned (1 downto 0);    --selecao registrador ('0') ou constante ('1')
        carry_wr_en : out std_logic;                --write enable do registrador carry
        carry_rst   : out std_logic;                --reset do registrador carry
        ov_wr_en    : out std_logic;                --write enable do registrador overflow
        ram_wr_en   : out std_logic                 --write enable da ram
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
    signal estado_s      : unsigned (1 downto 0);
    signal jump_sel_s    : unsigned (1 downto 0);
    signal ula_op_s      : unsigned (1 downto 0);
    signal ula_sel_s     : unsigned (1 downto 0);
    signal rd0_sel_s     : unsigned (1 downto 0);
    signal rd1_sel_s     : std_logic;
    signal wr_sel_s      : std_logic;

begin

    maquinaestados: maq_estados port map (
        clk => clk,
        rst => rst,
        estado => estado_s
    );

    --FETCH -> atualiza o PC
    pc_wr <= '1' when estado_s = "00" else '0';
    --DECODE -> escreve instrucao no IR

    --EXECUTE -> se a operacao envolve escrita, escreve resultado no RB
    reg_wr_en <= '1' when estado_s = "01" and (opcode = "0001" or opcode = "0010" or opcode = "0011" or opcode = "0100" or opcode = "0101" or opcode = "1000" or opcode = "0110" or opcode = "1001") else '0';
    carry_wr_en <= '1' when estado_s = "01" and (opcode = "0001" or opcode = "0010" ) else '0';
    ov_wr_en <= '1' when estado_s = "01" and (opcode = "0001" or opcode = "0010" ) else '0';
    carry_rst <= '1' when estado_s = "10" and opcode = "0111" else '0';
    ram_wr_en <= '1' when estado_s = "01" and opcode = "1010" else '0';

    -- opcode "0001" -> ADD A, Rn     -> rd0 = A, rd1 = Rn, wr = A
    -- opcode "0010" -> SUBB A, Rn    -> rd0 = A, rd1 = Rn, wr = A
    -- opcode "0011" -> ANL A, #data  -> rd0 = A, rd1 = zero (#data), wr = A
    -- opcode "0100" -> XRL A, Rn     -> rd0 = A, rd1 = Rn, wr = A
    -- opcode "0101" -> MOV Rn, #data -> rd0 = zero, rd1 = zero (#data), wr = Rn
    -- opcode "0110" -> MOV Rn, A     -> rd0 = A, rd1 = zero, wr = Rn
    -- opcode "1001" -> MOV A, @Ri    -> rd0 = zero, rd1 = Ri (mem_out), wr = A
    -- opcode "1010" -> MOV @Ri, A    -> rd0 = A, rd1 = Ri, wr = Rn (reg_wr_en = '0'), ram_wr_en = '1'


    -- determina os sinais de controle no estado DECODE
    jump_sel <= "01" when opcode = "1111" else                          --AJMP (absolute jump)
                "10" when opcode = "1110" else                          --JC (jump if carry is set)                    
                "00";

    ula_op_s <= "00" when opcode = "0001"  or  opcode = "0101" or opcode = "0110" or opcode = "1000" or opcode = "1001" else
                "01" when opcode = "0010" else
                "10" when opcode = "0011" else
                "11" when opcode = "0100" else
                "00";
    
    ula_sel_s <= "01" when opcode = "0101"  or opcode = "0011" or opcode = "1000" else
                 "10" when opcode = "1001" else
                 "00";

    rd0_sel_s <= "00" when opcode = "0101" or opcode = "1000" or opcode = "1001" else
                 "01" when opcode = "0001" or opcode = "0110"  or opcode = "0010" or opcode = "0011" or opcode = "0100" or opcode = "1010" else
                 "00";

    rd1_sel_s <= '0' when opcode = "0110" or opcode = "0011" or opcode = "0101" or opcode = "1000" else
                 '1' when opcode = "0001" or opcode = "0010" or opcode = "0100" or opcode = "1001" or opcode = "1010" else
                 '0';
                 
    wr_sel_s <= '0' when opcode = "0101" or opcode = "0110" else
                '1' when opcode = "0001" or opcode = "0010" or opcode = "0011" or opcode = "0100" or opcode = "1000" or opcode = "1001" else
                '0';
    

    -- envia os sinais de controle no estado EXECUTE
    ula_op <= ula_op_s when estado_s = "01" else "00";
    ula_sel <= ula_sel_s when estado_s = "01" else "00";
    rd0_sel <= rd0_sel_s when estado_s = "01" else "00";
    rd1_sel <= rd1_sel_s when estado_s = "01" else '0';
    wr_sel <= wr_sel_s when estado_s = "01" else '0';

    estado <= estado_s;

end architecture;