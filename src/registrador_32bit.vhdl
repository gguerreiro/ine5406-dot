-- Arquivo: registrador_32bit.vhdl
-- Descrição: Registrador de 32 bits com carga síncrona e reset assíncrono

library ieee;
use ieee.std_logic_1164.all;

entity Registrador32Bit is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        enable : in  std_logic;
        d      : in  std_logic_vector(31 downto 0);
        q      : out std_logic_vector(31 downto 0)
    );
end entity Registrador32Bit;

architecture Behavioral of Registrador32Bit is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                q <= d;
            end if;
        end if;
    end process;
end architecture Behavioral;
