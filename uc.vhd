library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        estado: in unsigned(1 downto 0);
        clk: in std_logic;
        instruction: in unsigned(15 downto 0);
        jump_en: out std_logic;
        reg_rd: out std_logic;
        reg_wr: out std_logic;
        inst_wr: out std_logic;
        imm_ctrl: out std_logic;
        selec_op: out unsigned(1 downto 0);
        rom_rd: out std_logic;
        jump_reg_wr: out std_logic;
        flags_wr: out std_logic;
        ram_wr: out std_logic;
        reg_wr_data_selector: out std_logic
    );
end entity;

architecture a_uc of uc is
    signal opcode: unsigned(3 downto 0);
    signal jump_en_s: std_logic;

begin
    opcode<=instruction(15 downto 12);

    --main control signals

    rom_rd<='1' when estado="01" else
            '0';

    inst_wr<='1' when estado="10" else
             '0';

    --signals controlled by opcode
    
    jump_en_s<='1' when (opcode="0011" and estado="11") else
               '0';

    jump_reg_wr<='1' when estado="11" else
                    '0';
            
    jump_en<=jump_en_s;
    
    reg_wr<='1' when (opcode="0001" and estado="11") or 
                     (opcode="0010" and estado="11") or       
                     (opcode="0110" and estado="11") or
                     (opcode="1000" and estado="11") else
            '0';

    reg_rd<='1' when estado="11" else
            '0';

    imm_ctrl<='0' when (opcode="0001" and estado="11") or 
                        (opcode="0101" and estado="11") else
               '1'; 
    
    selec_op<="00" when (opcode="0001" and estado="11") or
                      (opcode="0010" and estado="11") or
                      (opcode="0000" and estado="11") else
            "01" when (opcode="0100" and estado="11") or 
                      (opcode="0110" and estado="11") else
            "00";

    flags_wr<='1' when opcode="0001" or
                          opcode="0010" or
                          opcode="0100" or
                          opcode="0110" else
                 '0';

    ram_wr<='1' when (opcode="0111" and estado="11") else
               '0'; 

    reg_wr_data_selector<='1' when (opcode="1000" and estado="11") else
                          '0';
end architecture;

