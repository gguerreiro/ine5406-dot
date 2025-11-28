-- =============================================================================
-- Arquivo: add_sub_clip_8_bit.vhdl
-- Descrição: Somador/Subtrator de 8 bits com saturação (clipping) para signed
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddSubClip8Bit is
    port (
        a       : in  std_logic_vector(7 downto 0);  -- Operando A (signed)
        b       : in  std_logic_vector(7 downto 0);  -- Operando B (signed)
        is_sub  : in  std_logic;                     -- '1' para subtração, '0' para soma
        result  : out std_logic_vector(7 downto 0)   -- Resultado com saturação
    );
end entity AddSubClip8Bit;

architecture Behavioral of AddSubClip8Bit is
    -- Constantes para os limites de saturação (signed 8 bits)
    constant MAX_VAL : signed(7 downto 0) := to_signed(127, 8);
    constant MIN_VAL : signed(7 downto 0) := to_signed(-128, 8);
    
    -- Sinais internos
    signal a_signed    : signed(7 downto 0);
    signal b_signed    : signed(7 downto 0);
    signal temp_result : signed(8 downto 0);  -- 9 bits para detectar overflow
    signal final_result : signed(7 downto 0);
    
begin
    -- Conversão das entradas para signed
    a_signed <= signed(a);
    b_signed <= signed(b);
    
    -- Processo combinacional para soma/subtração
    process(a_signed, b_signed, is_sub)
    begin
        if is_sub = '1' then
            -- Subtração: A - B
            temp_result <= resize(a_signed, 9) - resize(b_signed, 9);
        else
            -- Soma: A + B
            temp_result <= resize(a_signed, 9) + resize(b_signed, 9);
        end if;
    end process;
    
    -- Processo combinacional para saturação (clipping)
    process(temp_result)
    begin
        if temp_result > resize(MAX_VAL, 9) then
            -- Overflow positivo: saturar em +127
            final_result <= MAX_VAL;
        elsif temp_result < resize(MIN_VAL, 9) then
            -- Overflow negativo: saturar em -128
            final_result <= MIN_VAL;
        else
            -- Sem overflow: usar o resultado normal
            final_result <= temp_result(7 downto 0);
        end if;
    end process;
    
    -- Saída
    result <= std_logic_vector(final_result);
    
end architecture Behavioral;
