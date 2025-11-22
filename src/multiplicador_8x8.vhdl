library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplicador8x8 is
    port (
        a, b: in std_logic_vector(7 downto 0);

        r: out std_logic_vector(15 downto 0)
    );
end entity;

architecture Multiplicador8x8Arc of Multiplicador8x8 is
begin

    r <= std_logic_vector(unsigned(a) * unsigned(b));

end Multiplicador8x8Arc;
