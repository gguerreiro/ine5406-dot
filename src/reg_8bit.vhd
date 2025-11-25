Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_8bit is
    generic(N: positive := 8);
    port(clk,reset,start : in std_logic;
        D          : in unsigned (N-1 downto 0);
        Q          : out unsigned (N-1 downto 0));
end reg_8bit;

architecture behavior of reg_8bit is
begin
    process(reset,clk)
        begin
        if (reset = '0') then
        Q <= (others => '0');
        elsif (rising_edge(clk)) then
            if (start = '1') then
            Q <= D;
            end if;
        end if;
    end process;
end behavior;
