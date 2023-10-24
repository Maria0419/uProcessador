library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end;

architecture a_uc_tb of uc_tb is
    component uc
        port(
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
            ula_sel     : out std_logic
        );
    end component;

    constant period_time : time       := 100 ns;
    signal finished      : std_logic  := '0';
    signal clk, rst : std_logic;
    signal opcode : unsigned (3 downto 0);

    signal ula_op      :  unsigned (1 downto 0);    
    signal rd0_sel     :  std_logic;                
    signal rd1_sel     :  std_logic;                
    signal wr_sel      :  std_logic;                
    signal pc_wr       :  std_logic;              
    signal ir_wr       :  std_logic;       
    signal jump_en     :  std_logic;    
    signal reg_wr_en   :  std_logic;   
    signal ula_sel     :  std_logic;

begin
    uut: uc port map (  
        clk => clk,
        rst => rst,
        opcode => opcode,
        ula_op => ula_op,
        rd0_sel => rd0_sel,
        rd1_sel => rd1_sel,
        wr_sel => wr_sel,
        pc_wr => pc_wr,
        ir_wr => ir_wr,
        jump_en => jump_en,
        reg_wr_en => reg_wr_en,
        ula_sel => ula_sel
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process;

    process
    begin
        wait for period_time;
        opcode <= "0000";
        wait for 3*period_time;
        opcode <= "0001";
        wait for 3*period_time;
        opcode <= "0010";
        wait for 3*period_time;
        opcode <= "0011";
        wait for 3*period_time;
        opcode <= "0100";
        wait for 3*period_time;
        opcode <= "0101";
        wait for 3*period_time;
        opcode <= "0110";
        wait for 3*period_time;
        opcode <= "1111";
        wait;
    end process;

end architecture;