library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
    port(
        read_enable: in std_logic;
        rs1: in unsigned(2 downto 0);
        rs2: in unsigned(2 downto 0);
        rd: in unsigned(2 downto 0);
        data_in_banco: in unsigned(15 downto 0);
        write_enable: in std_logic;
        clk: in std_logic;
        rst: in std_logic;
        data_out_A: out unsigned(15 downto 0);
        data_out_B: out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_regs of banco_regs is
    component reg16bits 
        port(
            clk: in std_logic;
            rst: in std_logic;
            wr_en: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    signal wr_en_aux: std_logic_vector(7 downto 0);

    signal data_out_0: unsigned(15 downto 0);
    signal data_out_1: unsigned(15 downto 0);
    signal data_out_2: unsigned(15 downto 0);
    signal data_out_3: unsigned(15 downto 0);
    signal data_out_4: unsigned(15 downto 0);
    signal data_out_5: unsigned(15 downto 0);
    signal data_out_6: unsigned(15 downto 0);
    signal data_out_7: unsigned(15 downto 0);

begin
    data_out_0<="0000000000000000";
    
    reg0: reg16bits port map(
        clk,
        rst,
        wr_en_aux(0),
        "0000000000000000",
        data_out_0
    );

    reg1: reg16bits port map(
        clk,
        rst,
        wr_en_aux(1),
        data_in_banco,
        data_out_1
    );

    reg2: reg16bits port map(
        clk,
        rst,
        wr_en_aux(2),
        data_in_banco,
        data_out_2
    );

    reg3: reg16bits port map(
        clk,
        rst,
        wr_en_aux(3),
        data_in_banco,
        data_out_3
    );

    reg4: reg16bits port map(
        clk,
        rst,
        wr_en_aux(4),
        data_in_banco,
        data_out_4
    );

    reg5: reg16bits port map(
        clk,
        rst,
        wr_en_aux(5),
        data_in_banco,
        data_out_5
    );

    reg6: reg16bits port map(
        clk,
        rst,
        wr_en_aux(6),
        data_in_banco,
        data_out_6
    );

    reg7: reg16bits port map(
        clk,
        rst,
        wr_en_aux(7),
        data_in_banco,
        data_out_7
    );

    wr_en_aux(0) <= '1' when rd="000" and write_enable='1' else
                            '0';

    wr_en_aux(1) <= '1' when rd="001" and write_enable='1' else
                            '0';  

    wr_en_aux(2) <= '1' when rd="010" and write_enable='1' else
                            '0';  

    wr_en_aux(3) <= '1' when rd="011" and write_enable='1' else
                            '0';

    wr_en_aux(4) <= '1' when rd="100" and write_enable='1' else
                            '0';  

    wr_en_aux(5) <= '1' when rd="101" and write_enable='1' else
                            '0';  
    
    wr_en_aux(6) <= '1' when rd="110" and write_enable='1' else
                            '0';  

    wr_en_aux(7) <= '1' when rd="111" and write_enable='1' else
                            '0';   

    data_out_A <= data_out_0 when (rs1="000" and read_enable='1') else
                            data_out_1 when (rs1="001" and read_enable='1') else
                            data_out_2 when (rs1="010" and read_enable='1') else
                            data_out_3 when (rs1="011" and read_enable='1') else
                            data_out_4 when (rs1="100" and read_enable='1') else
                            data_out_5 when (rs1="101" and read_enable='1') else
                            data_out_6 when (rs1="110" and read_enable='1') else
                            data_out_7 when (rs1="111" and read_enable='1') else
                            "0000000000000000";
    
    data_out_B <= data_out_0 when (rs2="000" and read_enable='1') else
                            data_out_1 when (rs2="001" and read_enable='1') else
                            data_out_2 when (rs2="010" and read_enable='1') else
                            data_out_3 when (rs2="011" and read_enable='1') else
                            data_out_4 when (rs2="100" and read_enable='1') else
                            data_out_5 when (rs2="101" and read_enable='1') else
                            data_out_6 when (rs2="110" and read_enable='1') else
                            data_out_7 when (rs2="111" and read_enable='1') else
                            "0000000000000000";
end architecture;
