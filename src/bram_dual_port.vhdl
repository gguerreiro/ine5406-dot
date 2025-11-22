library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRAM is
    port (
        addr_a, addr_b, addr_w: in std_logic_vector(7 downto 0);
        clk, we: in std_logic;
        wd: in std_logic_vector(31 downto 0);

        val_a, val_b: out std_logic_vector(31 downto 0)
    );
end entity;

architecture BRAMArc of BRAM is
    type memory is array (0 to 255) of std_logic_vector(31 downto 0);
    signal data: memory;
begin

    process (clk) begin
        if rising_edge(clk) and we = '1' then
            data(to_integer(unsigned(addr_w))) <= wd;
        end if;
    end process;

    val_a <= data(to_integer(unsigned(addr_a)));
    val_b <= data(to_integer(unsigned(addr_b)));

end BRAMArc;
