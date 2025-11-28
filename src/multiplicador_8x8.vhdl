-- =============================================================================
-- Arquivo: multiplicador_8x8.vhdl
-- Descrição: Multiplicador 8x8 com sinal (signed)
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplicador8x8 is
    port (
        a : in  std_logic_vector(7 downto 0);  -- Operando A (signed)
        b : in  std_logic_vector(7 downto 0);  -- Operando B (signed)
        p : out std_logic_vector(15 downto 0) -- Produto (signed)
    );
end entity Multiplicador8x8;

architecture Behavioral of Multiplicador8x8 is
    signal a_signed : signed(7 downto 0);
    signal b_signed : signed(7 downto 0);
    signal p_signed : signed(15 downto 0);
begin
    a_signed <= signed(a);
    b_signed <= signed(b);
    
    p_signed <= a_signed * b_signed;
    
    p <= std_logic_vector(p_signed);
end architecture Behavioral;
