library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel2 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        estado : out std_logic
    );
end toplevel2;

architecture a_toplevel2 of toplevel2 is

    component pc is 
        port(
            data_i : in unsigned (7 downto 0);
            data_o : out unsigned (7 downto 0);
            clk, wr_en, rst : in std_logic
        );
    end component;

    component rom is
        port(
            clk  : in std_logic;
            addr : in unsigned (7 downto 0);
            data : out unsigned (14 downto 0)
        );
    end component;

    component uc is
        port(
            clk, rst : in std_logic;
            instruction : in unsigned(14 downto 0);
            jump_en : out std_logic;
            estado_maq : out std_logic;
            pc_wr_en : out std_logic
        );
    end component;

    signal relative_addr : unsigned (7 downto 0);
    signal pc_to_rom : unsigned (7 downto 0);
    signal rom_to_uc : unsigned (14 downto 0);
    signal pc_en, jump_sel : std_logic;
begin

    pc1: pc port map (data_i => relative_addr,
                      data_o => pc_to_rom,
                      clk => clk,
                      wr_en => pc_en,
                      rst => rst);

    rom1: rom port map (clk => clk,
                        addr => pc_to_rom,
                        data => rom_to_uc);

    uc1: uc port map (clk => clk,
                      rst => rst,
                      instruction => rom_to_uc,
                      jump_en => jump_sel,
                      estado_maq => estado,
                      pc_wr_en => pc_en);

    relative_addr <= "00000001" when jump_sel = '0' else
                      (rom_to_uc(7 downto 0) - pc_to_rom);

end architecture;