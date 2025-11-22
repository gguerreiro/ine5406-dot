library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SomadorSubtratorVetorial is
    port (
        a, b: in std_logic_vector(31 downto 0);
        is_sub: in std_logic;

        r: out std_logic_vector(31 downto 0)
    );
end entity;

architecture SomadorSubtratorVetorialArc of SomadorSubtratorVetorial is
    signal res: std_logic_vector(8 downto 0);
begin

    S0: entity work.AddSubClip8Bit port map (
        a => a(7 downto 0), b => b(7 downto 0), is_sub => is_sub, r => r(7 downto 0)
    );

    S1: entity work.AddSubClip8Bit port map (
        a => a(15 downto 8), b => b(15 downto 8), is_sub => is_sub, r => r(15 downto 8)
    );

    S2: entity work.AddSubClip8Bit port map (
        a => a(23 downto 16), b => b(23 downto 16), is_sub => is_sub, r => r(23 downto 16)
    );

    S3: entity work.AddSubClip8Bit port map (
        a => a(31 downto 24), b => b(31 downto 24), is_sub => is_sub, r => r(31 downto 24)
    );

end SomadorSubtratorVetorialArc;
