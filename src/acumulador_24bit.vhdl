library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Acumulador24Bit is
    port (
        rst: in std_logic;
        clk: in std_logic;
        en: in std_logic;
        a: in std_logic_vector(23 downto 0);
        
        v: out std_logic_vector(23 downto 0)
    );
end entity;

architecture Acumulador24BitArc of Acumulador24Bit is
    signal acc: std_logic_vector(23 downto 0);
begin

    process (rst, clk) begin
        if rst = '1' then
            acc <= "000000000000000000000000";
        elsif rising_edge(clk) and en = '1' then
            acc <= std_logic_vector(unsigned(acc) + unsigned(a));
        end if;
    end process;

    v <= acc;

end Acumulador24BitArc;
