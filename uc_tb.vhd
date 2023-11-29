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

            estado      : out unsigned (1 downto 0);

            ula_op      : out unsigned (1 downto 0);
            rd0_sel     : out std_logic;
            rd1_sel     : out std_logic;
            wr_sel      : out std_logic;
            pc_wr       : out std_logic;
            jump_sel    : out unsigned (1 downto 0);
            reg_wr_en   : out std_logic;
            ula_sel     : out std_logic;
            carry_wr_en : out std_logic;
            carry_rst   : out std_logic;
            ov_wr_en    : out std_logic;
            ram_wr_en   : out std_logic
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
    signal reg_wr_en   :  std_logic;   
    signal ula_sel     :  std_logic;
    signal jump_sel    :  unsigned (1 downto 0);
    signal estado      :  unsigned (1 downto 0);
    signal carry_wr_en :  std_logic;
    signal carry_rst   :  std_logic;
    signal ov_wr_en    :  std_logic;
    signal ram_wr_en   :  std_logic;

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
        jump_sel => jump_sel,
        reg_wr_en => reg_wr_en,
        ula_sel => ula_sel,
        estado => estado,
        carry_wr_en => carry_wr_en,
        carry_rst => carry_rst,
        ov_wr_en => ov_wr_en,
        ram_wr_en => ram_wr_en
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
        opcode <= "0111";
        wait for 3*period_time;
        opcode <= "1000";
        wait for 3*period_time;
        opcode <= "1001";
        wait for 3*period_time;
        opcode <= "1010";
        wait for 3*period_time;
        opcode <= "1110";
        wait for 3*period_time;
        opcode <= "1111";
        wait;
    end process;

end architecture;