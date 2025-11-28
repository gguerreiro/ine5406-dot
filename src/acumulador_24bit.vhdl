-- =============================================================================
-- Arquivo: acumulador_24bit.vhdl
-- Descrição: Acumulador de 24 bits com sinal (signed)
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Acumulador24Bit is
    port (
        clk    : in  std_logic;                      -- Clock
        rst    : in  std_logic;                      -- Reset síncrono (ativo alto)
        enable : in  std_logic;                      -- Enable (acumula o dado)
        d      : in  std_logic_vector(15 downto 0);  -- Dado de entrada (signed 16 bits)
        q      : out std_logic_vector(23 downto 0)   -- Saída acumulada (signed 24 bits)
    );
end entity Acumulador24Bit;

architecture Behavioral of Acumulador24Bit is
    signal q_reg : signed(23 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= (others => '0');
            elsif enable = '1' then
                q_reg <= q_reg + resize(signed(d), 24);
            end if;
        end if;
    end process;
    
    q <= std_logic_vector(q_reg);
end architecture Behavioral;
