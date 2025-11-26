Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_8bit is
    port(clk,reset,enable : in std_logic;
        D          : in unsigned (7 downto 0);
        Q          : out unsigned (7 downto 0));
end reg_8bit;

architecture behavior of reg_8bit is
    signal data: std_logic_vector(7 downto 0);
begin
    process(reset, clk)
        begin
        if reset = '0' then
            data <= "00000000";
        elsif rising_edge(clk) then
            if enable = '1' then
                data <= D;
            end if;
        end if;
    end process;

    Q <= data;
end behavior;
