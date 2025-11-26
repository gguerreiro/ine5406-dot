Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity mux4to1 is
    port(sel: in std_logic
         A,B,C,D: in std_logic_vector (7 downto 0);
         Y: out std_logic_vector (7 downto 0));
end mux4to1

architecture selected of mux4to1 is
begin
    with sel select
    Y <= A when '0',
    Y <= B when '1',
    Y <= C when "10",
    Y <= D when "11";
end selected
