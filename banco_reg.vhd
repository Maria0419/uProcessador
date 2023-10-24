library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is
    port (
        rd_reg0, rd_reg1, wr_reg : in unsigned (2 downto 0);    -- numero dos regs (leitura e escrita)
        wr_data : in unsigned (15 downto 0);                    -- dados a serem escritos
        out_data0, out_data1 : out unsigned (15 downto 0);      -- dados armazenados nos regs de leitura
        wr_en, clk, rst : in std_logic                         -- write enable, clock e reset dos regs
    );
end banco_reg;

architecture a_banco_reg of banco_reg is

    component decoder_3to8 is
        port (
            in_bus  : in unsigned (2 downto 0);
            out_bus : out unsigned (7 downto 0)
        );
    end component;

    component reg_16bits is
        port (
            data_in  : in unsigned (15 downto 0);
            data_out : out unsigned (15 downto 0);
            wr_en, clk, rst : in std_logic
        );
    end component;

    component mux_8x1_16bits is
        port (
            data0, data1, data2, data3, data4, data5, data6, data7 : in unsigned (15 downto 0);
            sel : in unsigned (2 downto 0);
            data_out : out unsigned (15 downto 0)
        );
    end component;

    signal data_out0, data_out1, data_out2, data_out3,
           data_out4, data_out5, data_out6, data_out7 : unsigned (15 downto 0);
    
    signal wr_en_bus : unsigned (7 downto 0);

    signal wr_en0, wr_en1, wr_en2, wr_en3, 
           wr_en4, wr_en5, wr_en6, wr_en7 : std_logic;

    constant zero : unsigned (15 downto 0) := "0000000000000000";

begin

    -- controle do write enable de cada registrador
    -- decoder seleciona o bit ativo para habilitar a escrita no registrador correto
    dec : decoder_3to8 port map (in_bus  => wr_reg,
                                 out_bus => wr_en_bus);

    wr_en0 <= wr_en and wr_en_bus(0);
    wr_en1 <= wr_en and wr_en_bus(1);
    wr_en2 <= wr_en and wr_en_bus(2);
    wr_en3 <= wr_en and wr_en_bus(3);
    wr_en4 <= wr_en and wr_en_bus(4);
    wr_en5 <= wr_en and wr_en_bus(5);
    wr_en6 <= wr_en and wr_en_bus(6);
    wr_en7 <= wr_en and wr_en_bus(7);


    -- instancia registradores x0 a x7
    x0 : reg_16bits port map (data_in => zero, 
                              data_out => data_out0,
                              wr_en => wr_en0,
                              clk => clk,
                              rst => rst);
    
    x1 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out1,
                              wr_en => wr_en1,
                              clk => clk,
                              rst => rst);
                            
    x2 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out2,
                              wr_en => wr_en2,
                              clk => clk,
                              rst => rst);

    x3 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out3,
                              wr_en => wr_en3,
                              clk => clk,
                              rst => rst);

    x4 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out4,
                              wr_en => wr_en4,
                              clk => clk,
                              rst => rst);
        
    x5 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out5,
                              wr_en => wr_en5,
                              clk => clk,
                              rst => rst);

    x6 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out6,
                              wr_en => wr_en6,
                              clk => clk,
                              rst => rst);
                 
    x7 : reg_16bits port map (data_in => wr_data, 
                              data_out => data_out7,
                              wr_en => wr_en7,
                              clk => clk,
                              rst => rst);
                            
    -- seleciona os registradores de leitura
    mux0 : mux_8x1_16bits port map (data0 => data_out0,
                             data1 => data_out1,
                             data2 => data_out2,
                             data3 => data_out3,
                             data4 => data_out4,
                             data5 => data_out5,
                             data6 => data_out6,
                             data7 => data_out7,
                             sel => rd_reg0,
                             data_out => out_data0);

    mux1 : mux_8x1_16bits port map (data0 => data_out0,
                             data1 => data_out1,
                             data2 => data_out2,
                             data3 => data_out3,
                             data4 => data_out4,
                             data5 => data_out5,
                             data6 => data_out6,
                             data7 => data_out7,
                             sel => rd_reg1,
                             data_out => out_data1);


end architecture;