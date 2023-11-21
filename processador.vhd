library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk : in std_logic;
        rst : in std_logic;
        estado : out unsigned (1 downto 0);
        instr : out unsigned (14 downto 0);
        reg1 : out unsigned (15 downto 0);
        reg2 : out unsigned (15 downto 0);
        ula_out : out unsigned (15 downto 0)
    );
end entity;

architecture a_processador of processador is

    component ula is 
        port( 
            x, y  : in unsigned(15 downto 0);
            op    : in unsigned(1 downto 0);
            saida : out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;

    component banco_reg is 
        port(
            rd_reg0, rd_reg1, wr_reg : in unsigned (2 downto 0);
            wr_data                  : in unsigned (15 downto 0);
            out_data0, out_data1     : out unsigned (15 downto 0);
            wr_en, clk, rst          : in std_logic
        );
    end component;

    component mux4x1_16bits is
        port(
            sel            : in unsigned (1 downto 0);
            i0, i1, i2, i3 : in unsigned (15 downto 0);
            saida          : out unsigned (15 downto 0)
        );
    end component;

    component mux2x1_3bits is
        port(
            sel    : in std_logic;
            i0, i1 : in unsigned (2 downto 0);
            saida  : out unsigned (2 downto 0)
        );
    end component;

    component mux4x1_3bits is
        port(
            sel : in unsigned (1 downto 0);
            i0, i1, i2, i3 : in unsigned (2 downto 0);
            saida : out unsigned (2 downto 0)
        );
    end component;
    
    component rom is
        port 
        (
            clk  : in std_logic;
            addr : in unsigned (7 downto 0);
            data : out unsigned (14 downto 0)
        );
    end component;

    component pc is
        port (
            increase        : in unsigned (7 downto 0);
            data_o          : out unsigned (7 downto 0);
            clk, wr_en, rst : in std_logic
        );
    end component;

    component reg_15bits is
        port (
            data_in         : in unsigned (14 downto 0);
            data_out        : out unsigned (14 downto 0);
            wr_en, clk, rst : in std_logic
        );
    end component;

    component reg_8bits is
        port (
            data_i         : in unsigned (7 downto 0);
            data_o        : out unsigned (7 downto 0);
            wr_en, clk, rst : in std_logic
        );
    end component;

    component reg_1bit is
        port (
            data_in  : in std_logic;
            data_out : out std_logic;
            wr_en, clk, rst : in std_logic
        );
    end component;

    component uc is
        port (
            clk, rst    : in std_logic;
            opcode      : in unsigned (3 downto 0);
            ula_op      : out unsigned (1 downto 0);  
            rd0_sel     : out unsigned (1 downto 0);            
            rd1_sel     : out std_logic;         
            wr_sel      : out std_logic;       
            pc_wr       : out std_logic;      
            jump_sel    : out unsigned (1 downto 0);                
            reg_wr_en   : out std_logic;           
            ula_sel     : out unsigned (1 downto 0);
            estado      : out unsigned (1 downto 0);
            carry_wr_en : out std_logic;
            carry_rst   : out std_logic;
            ov_wr_en    : out std_logic;
            ram_wr_en   : out std_logic
        );
    end component;

    component ram is
        port( 
            clk      : in std_logic;
            endereco : in unsigned(7 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0) 
        );
    end component;


    signal rb_to_ula        : unsigned(15 downto 0);
    signal rb_to_mux        : unsigned(15 downto 0);
    signal ula_to_rb        : unsigned(15 downto 0);
    signal pc_to_rom        : unsigned(7 downto 0);
    signal rom_to_instr_reg : unsigned (14 downto 0);
    signal instr_reg_out    : unsigned (14 downto 0);
    signal ula_to_carry_reg : std_logic;
    signal carry_ula        : std_logic;
    signal carry_rst_uc     : std_logic;
    signal ram_out          : unsigned(15 downto 0);

    signal ula_to_ov_reg    : std_logic;
    signal ov_ula           : std_logic;
    signal ov_wr_en         : std_logic;

    signal pc_wr       : std_logic;
    signal jump_sel    : unsigned (1 downto 0);
    signal rb_wr_en    : std_logic;
    signal carry_wr_en : std_logic;
    signal carry_rst   : std_logic;
    signal ram_wr_en   : std_logic;

    signal mux_ula_sel : unsigned (1 downto 0);
    signal mux_rd0_sel : unsigned (1 downto 0);
    signal mux_rd1_sel : std_logic;
    signal mux_wr_sel  : std_logic;

    signal mux_to_rb_rd0 : unsigned (2 downto 0);
    signal mux_to_rb_rd1 : unsigned (2 downto 0);
    signal mux_to_rb_wr  : unsigned (2 downto 0);
    signal mux_to_ula    : unsigned(15 downto 0);

    signal src_mem_reg   : unsigned (2 downto 0);
    signal dest_reg      : unsigned (2 downto 0);
    signal opcode        : unsigned (3 downto 0);
    signal ula_op        : unsigned (1 downto 0);
    signal constant_ula  : unsigned (15 downto 0);
    signal relative_addr : unsigned (7 downto 0);
    signal instr_addr    : unsigned (7 downto 0);
    signal imm_data      : unsigned (7 downto 0);

    signal endereco_ram  : unsigned (7 downto 0);

    signal estado_s : unsigned (1 downto 0);

    constant acc  : unsigned (2 downto 0) := "111";
    constant zero : unsigned (2 downto 0) := "000";
    constant zero_16bits : unsigned (15 downto 0) := "0000000000000000";


begin

    pc1: pc port map (
        increase => relative_addr,
        data_o   => pc_to_rom,
        clk      => clk,
        wr_en    => pc_wr,
        rst      => rst
    );
    rom1: rom port map (
        clk  => clk,
        addr => pc_to_rom,
        data => rom_to_instr_reg
    );
    instr_reg: reg_15bits port map (
        data_in  => rom_to_instr_reg,
        data_out => instr_reg_out,
        clk      => clk,
        rst      => rst,
        wr_en    => '1'
    );

    mux_rd0: mux4x1_3bits port map (
        sel   => mux_rd0_sel,
        i0    => zero,
        i1    => acc,
        i2    => src_mem_reg,
        i3    => zero,
        saida => mux_to_rb_rd0
    );
    mux_rd1: mux2x1_3bits port map (
        sel   => mux_rd1_sel,
        i0    => zero,
        i1    => src_mem_reg,
        saida => mux_to_rb_rd1
    );
    mux_wr: mux2x1_3bits port map (
        sel   => mux_wr_sel,
        i0    => dest_reg,
        i1    => acc,
        saida => mux_to_rb_wr
    );
    bancoreg1: banco_reg port map (
        rd_reg0   => mux_to_rb_rd0,
        rd_reg1   => mux_to_rb_rd1,
        wr_reg    => mux_to_rb_wr,
        wr_en     => rb_wr_en,
        rst       => rst,
        clk       => clk,
        wr_data   => ula_to_rb,
        out_data0 => rb_to_ula,
        out_data1 => rb_to_mux
    );
    ula1: ula port map (
        x      => rb_to_ula,
        y      => mux_to_ula,
        op     => ula_op,
        saida  => ula_to_rb,
        carry  => ula_to_carry_reg,
        overflow => ula_to_ov_reg
    );
    mux_ula: mux4x1_16bits port map (
        sel   => mux_ula_sel,
        i0    => rb_to_mux,
        i1    => constant_ula,
        i2    => ram_out,
        i3    => zero_16bits,
        saida => mux_to_ula 
    );
    carry_reg: reg_1bit port map (
        data_in  => ula_to_carry_reg,
        data_out => carry_ula,
        clk      => clk,
        rst      => carry_rst,
        wr_en    => carry_wr_en
    );
    ov_reg: reg_1bit port map (
        data_in  => ula_to_ov_reg,
        data_out => ov_ula,
        clk      => clk,
        rst      => rst,
        wr_en    => ov_wr_en
    );
    uc1: uc port map (
        clk         => clk,
        rst         => rst,
        opcode      => opcode,
        ula_op      => ula_op,
        rd0_sel     => mux_rd0_sel,
        rd1_sel     => mux_rd1_sel,
        wr_sel      => mux_wr_sel,
        pc_wr       => pc_wr,
        jump_sel    => jump_sel,
        reg_wr_en   => rb_wr_en,
        ula_sel     => mux_ula_sel,
        estado      => estado_s,
        carry_wr_en => carry_wr_en,
        carry_rst   => carry_rst_uc,
        ov_wr_en    => ov_wr_en,
        ram_wr_en   => ram_wr_en
    );

    ram1: ram port map (
            clk      => clk,
            endereco => endereco_ram,
            wr_en    => ram_wr_en,
            dado_in  => rb_to_ula,
            dado_out => ram_out
      );

    carry_rst <= rst or carry_rst_uc;

    -- controle da atualizacao do PC
    relative_addr <= "00000001"               when jump_sel = "00" else   
                     (instr_addr - pc_to_rom) when jump_sel = "01" else
                     (instr_addr + 1)         when jump_sel = "10" and carry_ula = '1' else
                     "00000001"               when jump_sel = "10" and carry_ula = '0' else
                     "00000001";

    -- extensao de sinal
    constant_ula <= "00000000" & imm_data when imm_data (7) = '0' else
                    "11111111" & imm_data when imm_data (7) = '1' else
                    "0000000000000000"; 

    -- endereco da ram dentro do registrador
    endereco_ram <= rb_to_mux (7 downto 0);

    -- informacoes extraidas da instrucao
    src_mem_reg  <= instr_reg_out (5 downto 3);
    dest_reg <= instr_reg_out (2 downto 0);
    opcode   <= instr_reg_out (14 downto 11);
    instr_addr <=  instr_reg_out (7 downto 0);
    imm_data <=  instr_reg_out (10 downto 3);

    -- pinnout
    estado <= estado_s;
    instr <= instr_reg_out;
    reg1 <= rb_to_ula;
    reg2 <= rb_to_mux;
    ula_out <= ula_to_rb;

end architecture;