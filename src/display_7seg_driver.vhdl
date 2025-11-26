library ieee;
use ieee.std_logic_1164.ALL;

Entity display_7seg_driver IS
    Port(
        bcd: in std_logic_vector (3 downto 0);
        abcdefg: out std_logic_vector (6 downto 0) 
    );
end display_7seg_driver;

Architecture arch of display_7seg_driver is
begin
    abcdefg <= 
        "0000001" when bcd = "0000" else --0
        "1001111" when bcd = "0001" else --1
        "0010010" when bcd = "0010" else --2
        "0000110" when bcd = "0011" else --3
        "1001100" when bcd = "0100" else --4
        "0100100" when bcd = "0101" else --5
        "0100000" when bcd = "0110" else --6
        "0001111" when bcd = "0111" else --7
        "0000000" when bcd = "1000" else --8
        "0000100" when bcd = "1001" else --9
        "0110000";                       --E
end architecture;
