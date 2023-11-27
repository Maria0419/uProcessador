----------------------------------------------
-----------UNIDADE DE CONTROLE----------------
----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk, rst    : in std_logic;
        opcode      : in unsigned (3 downto 0);

        estado      : out unsigned (1 downto 0);    --estado atual da maquina de estados

        ula_op      : out unsigned (1 downto 0);    --"00" -> soma, "01" -> subtração, "10" -> and, "11" -> xor

        rd0_sel     : out std_logic;                --'0' -> zero, '1' -> acumulador
        rd1_sel     : out std_logic;                --'0' -> zero, '1' -> registrador geral
        wr_sel      : out std_logic;                --'0' -> registrador geral, '1' -> acumulador 
        
        pc_wr       : out std_logic;                --sinal para atualizar o PC
        jump_sel    : out unsigned (1 downto 0);    --"00" -> PC+1, "01" -> endereço absoluto, "10" -> PC+1+endereço relativo
        reg_wr_en   : out std_logic;                --escrever no banco de registradores
        ula_sel     : out unsigned (1 downto 0);    --"00" -> registrador, "01" -> constante, "10" -> saída da memória
        carry_wr_en : out std_logic;                --write enable do registrador carry
        carry_rst   : out std_logic;                --sinal de clear do registrador carry
        ov_wr_en    : out std_logic;                --write enable do registrador overflow
        ram_wr_en   : out std_logic                 --write enable da ram
    );
end entity;

architecture a_uc of uc is
    component maq_estados is
        port( 
            clk, rst : in std_logic;
            estado   : out unsigned (1 downto 0)
        );
        end component;

    --sinais internos
    signal estado_s      : unsigned (1 downto 0);
    signal jump_sel_s    : unsigned (1 downto 0);
    signal ula_op_s      : unsigned (1 downto 0);
    signal ula_sel_s     : unsigned (1 downto 0);
    signal rd0_sel_s     : std_logic;
    signal rd1_sel_s     : std_logic;
    signal wr_sel_s      : std_logic;

begin

    maquinaestados: maq_estados port map (
        clk    => clk,
        rst    => rst,
        estado => estado_s
    );

    --atualizar o PC (próxima instrução)
    pc_wr <= '1' when estado_s = "00" else '0';

    --write enable dos registradores
    reg_wr_en   <= '1' when estado_s = "01" and (opcode = "0001" or opcode = "0010" or opcode = "0011" or 
                                                 opcode = "0100" or opcode = "0101" or opcode = "1000" or 
                                                 opcode = "0110" or opcode = "1001") else '0';

    carry_wr_en <= '1' when estado_s = "01" and (opcode = "0001" or opcode = "0010") else '0';

    ov_wr_en    <= '1' when estado_s = "01" and (opcode = "0001" or opcode = "0010") else '0';

    --sinal de clear do registrador carry
    carry_rst   <= '1' when estado_s = "10" and opcode = "0111" else '0';
    
    --write enable da ram
    ram_wr_en   <= '1' when estado_s = "01" and opcode = "1010" else '0';


    -- REGISTRADORES SELECIONADOS PARA CADA INSTRUÇÃO:
    -- opcode "0001" -> ADD A, Rn     -> rd0 = A    | rd1 = Rn                     | wr = A
    -- opcode "0010" -> SUBB A, Rn    -> rd0 = A    | rd1 = Rn                     | wr = A
    -- opcode "0011" -> ANL A, #data  -> rd0 = A    | rd1 = zero (ula_sel = #data) | wr = A
    -- opcode "0100" -> XRL A, Rn     -> rd0 = A    | rd1 = Rn                     | wr = A
    -- opcode "0101" -> MOV Rn, #data -> rd0 = zero | rd1 = zero (ula_sel = #data) | wr = Rn
    -- opcode "0110" -> MOV Rn, A     -> rd0 = A    | rd1 = zero                   | wr = Rn
    -- opcode "1000" -> MOV A, #data  -> rd0 = zero | rd1 = zero (ula_sel = #data) | wr = A
    -- opcode "1001" -> MOV A, @Ri    -> rd0 = zero | rd1 = Ri (ula_sel = mem_out) | wr = A
    -- opcode "1010" -> MOV @Ri, A    -> rd0 = A    | rd1 = Ri                     | wr = Rn (reg_wr_en = '0')


    --sinal de seleção do salto
    jump_sel <= "01" when opcode = "1111" else    --AJMP (absolute jump)
                "10" when opcode = "1110" else    --JC (jump if carry is set)                    
                "00";

    --sinais de seleção da ula
    ula_op_s <= "00" when (opcode = "0001" or opcode = "0101" or 
                           opcode = "0110" or opcode = "1000" or opcode = "1001") else
                "01" when (opcode = "0010")                                       else
                "10" when (opcode = "0011")                                       else
                "11" when (opcode = "0100")                                       else
                "00";
    
    ula_sel_s <= "01" when (opcode = "0101"  or opcode = "0011" or opcode = "1000") else
                 "10" when (opcode = "1001")                                        else
                 "00";

    --sinais de seleção dos registradores
    rd0_sel_s <= '0' when (opcode = "0101" or opcode = "1000" or opcode = "1001") else
                 '1' when (opcode = "0001" or opcode = "0110" or opcode = "0010" or 
                           opcode = "0011" or opcode = "0100" or opcode = "1010") else
                 '0';

    rd1_sel_s <= '0' when (opcode = "0110" or opcode = "0011" or opcode = "0101" or opcode = "1000") else
                 '1' when (opcode = "0001" or opcode = "0010" or opcode = "0100" or 
                           opcode = "1001" or opcode = "1010")                                       else
                 '0';
                 
    wr_sel_s <= '0' when (opcode = "0101" or opcode = "0110")                       else
                '1' when (opcode = "0001" or opcode = "0010" or opcode = "0011" or 
                          opcode = "0100" or opcode = "1000" or opcode = "1001")    else
                '0';
    
    --sinais despachados para o circuito
    ula_op  <= ula_op_s  when estado_s = "01" else "00";
    ula_sel <= ula_sel_s when estado_s = "01" else "00";
    rd0_sel <= rd0_sel_s when estado_s = "01" else '0';
    rd1_sel <= rd1_sel_s when estado_s = "01" else '0';
    wr_sel  <= wr_sel_s  when estado_s = "01" else '0';

    estado <= estado_s;

end architecture;