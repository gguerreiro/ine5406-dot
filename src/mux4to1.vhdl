Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity mux4to1 is
    port(sel: in std_logic_vector(1 downto 0);
         A,B,C,D: in std_logic_vector (7 downto 0);
         Y: out std_logic_vector (7 downto 0));
end mux4to1;

architecture selected of mux4to1 is
begin
    Y <= A when sel = "00" else
        B when sel = "01" else
        C when sel = "10" else
        D;
end selected;
