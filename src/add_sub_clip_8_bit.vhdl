library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddSubClip8Bit is
    port (
        a, b: in std_logic_vector(7 downto 0);
        is_sub: in std_logic;

        r: out std_logic_vector(7 downto 0)
    );
end entity;

architecture AddSubClip8BitArc of AddSubClip8Bit is
    signal res: std_logic_vector(8 downto 0);
begin

    res <= std_logic_vector(unsigned("0" & a) - unsigned("0" & b)) when is_sub = '1' else
        std_logic_vector(unsigned("0" & a) + unsigned("0" & b));

    r <= "00000000" when is_sub = '1' and res(8) = '1' else
        "11111111" when is_sub = '0' and res(8) = '1' else
        res(7 downto 0);

end AddSubClip8BitArc;
