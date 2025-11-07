library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end entity;

architecture TestbenchArch of Testbench is
    signal reset, advance, r, g, b: std_logic;
begin

    S: entity work.Semaphore port map (
        reset => reset,
        advance => advance,
        r => r,
        g => g,
        b => b
    );

    process
    begin

        reset <= '0';
        advance <= '0';
    
        wait for 1 ns;

        reset <= '1';

        wait for 1 ns;

        reset <= '0';

        wait for 1 ns;

        for i in 0 to 20 loop
            advance <= '0';

            wait for 1 ns;
        end loop;

        wait;
    
    end process;

end TestbenchArch;
