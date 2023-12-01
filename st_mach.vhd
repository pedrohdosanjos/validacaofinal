library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity st_mach is 
    port(
        rst: in std_logic;
        clk: in std_logic;
        estado: out unsigned(1 downto 0)
    );
end entity;

architecture a_st_mach of st_mach is
    signal state_s: unsigned(1 downto 0);

begin
    process(clk, rst)
    begin
        if rst='1' then
            state_s<="00";
        elsif rising_edge(clk) then
            if state_s="11" then        
                state_s<="00";         
            else
                state_s<=state_s+1;   
            end if;
        end if;
    end process;

    estado<=state_s;
end architecture;
