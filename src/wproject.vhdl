library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Semaphore is
    port (
        reset, advance: in std_logic;
        r, g, b: out std_logic
    );
end entity;

architecture SemaphoreArch of Semaphore is
    signal color, next_color: std_logic_vector(2 downto 0);
begin

    process (reset, advance)
    begin
    
        if reset = '1' then
            color <= "000";
        elsif rising_edge(advance) then
            color <= next_color;
        end if;
    
    end process;

    next_color <= std_logic_vector(unsigned(color) + 1);

end SemaphoreArch;
