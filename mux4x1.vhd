library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4x1 is
    port(
        op_selector: in unsigned(1 downto 0);
        operation0: in unsigned(15 downto 0);
        operation1: in unsigned(15 downto 0);
        operation2: in unsigned(15 downto 0);
        operation3: in unsigned(15 downto 0);
        result: out unsigned(15 downto 0)
    );
end entity;

architecture behavioral of mux4x1 is
begin
    result  <=  operation0    when    op_selector="00" else
                operation1    when    op_selector="01" else
                operation2    when    op_selector="10" else
                operation3    when    op_selector="11" else
                "0000000000000000";        
end architecture;
