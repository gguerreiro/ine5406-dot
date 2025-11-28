-- =============================================================================
-- Arquivo: somador_subtrator_vetorial.vhdl
-- Descrição: Somador/Subtrator vetorial de 4 elementos de 8 bits
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity SomadorSubtratorVetorial is
    port (
        A      : in  std_logic_vector(31 downto 0);
        B      : in  std_logic_vector(31 downto 0);
        is_sub : in  std_logic;
        result : out std_logic_vector(31 downto 0)
    );
end entity SomadorSubtratorVetorial;

architecture Structural of SomadorSubtratorVetorial is
    component AddSubClip8Bit is
        port (
            a       : in  std_logic_vector(7 downto 0);
            b       : in  std_logic_vector(7 downto 0);
            is_sub  : in  std_logic;
            result  : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    gen_add_sub: for i in 0 to 3 generate
        add_sub_inst: AddSubClip8Bit
            port map (
                a       => A(8*i+7 downto 8*i),
                b       => B(8*i+7 downto 8*i),
                is_sub  => is_sub,
                result  => result(8*i+7 downto 8*i)
            );
    end generate;
end architecture Structural;
