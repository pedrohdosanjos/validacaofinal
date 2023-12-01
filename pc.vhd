library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port(
        rst: in std_logic;
        clk: in std_logic;
        wr_en: in std_logic;
        data_in: in unsigned(6 downto 0);
        data_out: out unsigned(6 downto 0)
    );
end entity;

architecture a_pc of pc is
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if wr_en='1' and rst='0' then
                data_out<=data_in;
            end if;
        end if;
    end process;
end architecture;
