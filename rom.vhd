library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
        rd_en: in std_logic;
        clk: in std_logic;
        address: in unsigned(6 downto 0);
        data: out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type memory is array(0 to 127) of unsigned(15 downto 0);

    constant rom_content: memory:=(
        0=>B"0001_000_010_100001", 
        1=>B"0001_000_001_000000", 
        2=>B"0111_001_001_000000", 
        3=>B"0001_001_001_000001", 
        4=>B"0100_010_001_000000", 
        5=>B"0101_00000_1111101", 
        6=>B"0001_000_111_000001", 
        7=>B"0001_000_010_100001", 
        8=>B"0001_000_011_000010", 
        9=>B"0010_011_101_000000", 
        10=>B"0010_011_101_000000", 
        11=>B"0111_101_000_000000", 
        12=>B"0100_010_101_000000", 
        13=>B"0101_00000_1111101", 
        14=>B"0010_111_011_000000", 
        15=>B"0001_000_101_000000", 
        16=>B"0100_010_011_000000",
        17=>B"0101_00000_1111000", 
        18=>B"0001_000_111_000001", 
        19=>B"0001_000_010_100001", 
        20=>B"0001_000_001_000010", 
        21=>B"1000_001_110_000000", 
        22=>B"0010_111_001_000000", 
        23=>B"0100_010_001_000000", 
        24=>B"0101_00000_1111101", 

        others=>"0000000000000000"  
    );

    signal data_s: unsigned(15 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rd_en='1' then
                data_s<=rom_content(to_integer(address));
            end if;
        end if;
    end process;

    data<=data_s;
end architecture;
