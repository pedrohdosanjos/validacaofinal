library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
    port(
        rst: in std_logic;
        clk: in std_logic;
        prime_numbers: out unsigned(15 downto 0)
    );
end entity;

architecture a_toplevel of toplevel is

    component rom 
        port(
            rd_en: in std_logic;
            clk: in std_logic;
            address: in unsigned(6 downto 0);
            data: out unsigned(15 downto 0)
        );
    end component;

    component pc 
        port(
            rst: in std_logic;
            clk: in std_logic;
            wr_en: in std_logic;
            data_in: in unsigned(6 downto 0);
            data_out: out unsigned(6 downto 0)
        );
    end component;

    component reg_instr 
        port(
            clk: in std_logic;
            instruction: in unsigned(15 downto 0);
            wr_en: in std_logic;
            data: out unsigned(15 downto 0)
        );
    end component;

    component uc is
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
    end component;

    component banco_regs is
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
    end component;

    component ula is
        port(
            in_a, in_b: in unsigned(15 downto 0);
            op_selector: in unsigned(1 downto 0);
            result: out unsigned(15 downto 0);
            negative, overflow: out std_logic
        );
    end component;

    component st_mach
        port(
            rst: in std_logic;
            clk: in std_logic;
            estado: out unsigned(1 downto 0)
        );
    end component;

    component jump_data_reg 
        port(
            rst: in std_logic;
            wr_en: in std_logic;
            clk: in std_logic;
            data_in: in std_logic;
            data_out: out std_logic
        );
    end component;

    component negative_register 
        port(
            rst: in std_logic;
            wr_en: in std_logic;
            clk: in std_logic;
            data_in: in std_logic;
            data_out: out std_logic
        );
    end component;

    component overflow_register
        port(
            rst: in std_logic;
            wr_en: in std_logic;
            clk: in std_logic;
            data_in: in std_logic;
            data_out: out std_logic
        );
    end component;

    component blt_register 
        port(
            rst: in std_logic;
            estado: in unsigned(1 downto 0);
            clk: in std_logic;
            data_in: in std_logic;
            data_out: out std_logic
        );
    end component;

    component ram 
        port( 
            clk      : in std_logic;
            address  : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0) 
        );
     end component;

    signal rom_rd_s: std_logic;
    signal data_out_pc_s: unsigned(6 downto 0);
    signal pc_wr_s: std_logic;
    signal pc_wr_jump_s: std_logic;
    signal data_in_pc_s: unsigned(6 downto 0);
    signal data_in_pc_main: unsigned(6 downto 0);
    signal rom_data_s: unsigned(15 downto 0);
    signal inst_wr_s: std_logic;
    signal instruction: unsigned(15 downto 0);
    signal jump_en_s: std_logic;
    signal reg_rd_s: std_logic;
    signal reg_wr_s: std_logic;
    signal imm_ctrl_s: std_logic;
    signal in_b_s: unsigned(15 downto 0);
    signal selec_op_s: unsigned(1 downto 0);
    signal alu_result_reg_out_s: unsigned(15 downto 0);
    signal data_out_A_s: unsigned(15 downto 0);
    signal data_out_B_s: unsigned(15 downto 0);
    signal ula_result_s: unsigned(15 downto 0);
    signal imm_extended: unsigned(15 downto 0);
    signal imm_signal: std_logic;
    signal state_s: unsigned(1 downto 0);
    signal jump_reg_wr_s: std_logic;
    signal jump_reg_out_s: std_logic;
    signal negative_s: std_logic;
    signal overflow_s: std_logic;
    signal negative_reg_out: std_logic;
    signal overflow_reg_out: std_logic;
    signal blt: std_logic;
    signal blt_address: unsigned(6 downto 0);
    signal blt_reg_out: std_logic;
    signal flags_wr_s: std_logic;
    signal ram_wr_s: std_logic;    
    signal ram_data_out_s: unsigned(15 downto 0);
    signal data_in_banco_s: unsigned(15 downto 0);
    signal ram_address_s: unsigned(6 downto 0);
    signal reg_wr_data_selector_s: std_logic;
    signal prime_numbers_s: unsigned(15 downto 0);

begin
    rom0: rom port map(
        rd_en=>rom_rd_s,
        clk=>clk,
        address=>data_out_pc_s,
        data=>rom_data_s
    );

    pc0: pc port map(
        rst=>rst,
        clk=>clk,
        wr_en=>pc_wr_s,
        data_in=>data_in_pc_main,
        data_out=>data_out_pc_s
    );

    reg_instr0: reg_instr port map(
        clk=>clk,
        instruction=>rom_data_s,
        wr_en=>inst_wr_s,
        data=>instruction
    );

    uc0: uc port map(
        estado=>state_s,
        clk=>clk,
        instruction=>instruction,
        jump_en=>jump_en_s,
        reg_rd=>reg_rd_s,
        reg_wr=>reg_wr_s,
        inst_wr=>inst_wr_s,
        imm_ctrl=>imm_ctrl_s,
        selec_op=>selec_op_s,
        rom_rd=>rom_rd_s,
        jump_reg_wr=>jump_reg_wr_s,
        flags_wr=>flags_wr_s,
        ram_wr=>ram_wr_s,
        reg_wr_data_selector=>reg_wr_data_selector_s
    );

    banco_regs0: banco_regs port map(
        read_enable=>reg_rd_s,
        rs1=>instruction(11 downto 9),
        rs2=>instruction(8 downto 6),
        rd =>instruction(8 downto 6),
        data_in_banco=>data_in_banco_s,
        write_enable=>reg_wr_s,
        clk=>clk,
        rst=>rst,
        data_out_A=>data_out_A_s,
        data_out_B=>data_out_B_s
    );

    ula0: ula port map(
        in_a=>data_out_A_s, 
        in_b=>in_b_s,
        op_selector=>selec_op_s,
        result=>ula_result_s,
        negative=>negative_s,
        overflow=>overflow_s
    );

    st_mach0: st_mach port map(
        rst=>rst,
        clk=>clk,
        estado=>state_s
    );

    jump_data_reg0: jump_data_reg port map(
        rst=>rst,
        wr_en=>jump_reg_wr_s,
        clk=>clk,
        data_in=>jump_en_s,
        data_out=>jump_reg_out_s
    );

    negative_register0: negative_register port map(
        rst=>rst,
        wr_en=>flags_wr_s,
        clk=>clk,
        data_in=>negative_s,
        data_out=>negative_reg_out
    );

    overflow_register0: overflow_register port map(
        rst=>rst,
        wr_en=>flags_wr_s,
        clk=>clk,
        data_in=>overflow_s,
        data_out=>overflow_reg_out
    );

    blt_register0: blt_register port map(
            rst=>rst,
            estado=>state_s,
            clk=>clk,
            data_in=>blt,
            data_out=>blt_reg_out
    );
    
    ram0: ram port map(
        clk=>clk,      
        address=>ram_address_s, 
        wr_en=>ram_wr_s,    
        data_in=>data_out_B_s, 
        data_out=>ram_data_out_s 
    );

    blt<=negative_reg_out xor overflow_reg_out;

    pc_wr_s<='1' when (state_s="00" and jump_reg_out_s='0' and blt_reg_out='0') or 
                      (state_s="11" and jump_en_s='1')                          or
                      (state_s="11" and blt_reg_out='1')                        else
             '0';

    blt_address<=data_out_pc_s+instruction(6 downto 0);

    data_in_pc_s<=blt_address when jump_en_s='0' and blt_reg_out='1' else
                  --data_out_pc_s+1 when jump_en_s='0' else
                  data_out_A_s(6 downto 0) when jump_en_s='1' else
                  data_out_pc_s+1;

    data_in_pc_main<=data_in_pc_s when rst='0' else
                     "0000000";

    imm_signal<='0';--instruction(5);
    imm_extended<=imm_signal&imm_signal&imm_signal&imm_signal&imm_signal&
                  imm_signal&imm_signal&imm_signal&imm_signal&imm_signal&
                  instruction(5 downto 0);

    in_b_s<=imm_extended when imm_ctrl_s='0' else
                  data_out_B_s;

    data_in_banco_s<=ram_data_out_s when reg_wr_data_selector_s='1' else
                      ula_result_s;

    ram_address_s<=data_out_A_s(6 downto 0)+(instruction(5) & instruction(5 downto 0));
    
    prime_numbers_s<=ram_data_out_s when (data_out_pc_s="0010101" and state_s="11") else
                     "0000000000000000";

    prime_numbers<=prime_numbers_s;
end architecture;
