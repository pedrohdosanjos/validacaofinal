library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_tb is
end entity;

architecture a_toplevel_tb of toplevel_tb is
    component toplevel 
        port(
            rst: in std_logic;
            clk: in std_logic;
            prime_numbers: out unsigned(15 downto 0)
        );
    end component;

    constant period_time: time :=100 ns;    --clk period
    signal finished: std_logic :='0';
    signal clk: std_logic;

    signal rst: std_logic;

begin
    uut: toplevel port map(
        rst,
        clk
    );

    reset: process
    begin
        rst<='1';
        wait for 50 ns;
        rst<='0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 1000 us;
        finished<='1';
        wait;
    end process;

    global_clk: process
    begin
        while finished/='1' loop
            clk<='0';
            wait for period_time/2;
            clk<='1';
            wait for period_time/2;
        end loop;
        wait;
    end process;

    main_process: process
    begin
        wait;
        
    end process;
end architecture;
