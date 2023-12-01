library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_instr is
    port(
        --rst: in std_logic;
        clk: in std_logic;
        instruction: in unsigned(15 downto 0);
        wr_en: in std_logic;
        data: out unsigned(15 downto 0)
    );
end entity;

architecture a_reg_instr of reg_instr is

begin
    process(clk)
    begin
        --if rst='1' then
        --    data<="0000000000000000";
        if rising_edge(clk) then
            if wr_en='1' then
                data<=instruction;
            end if;
        end if;
    end process;
end architecture;
