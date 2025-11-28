-- =============================================================================
-- Arquivo: bram_dual_port.vhdl
-- Descrição: Memória BRAM dual-port
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRAMDualPort is
    generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 5
    );
    port (
        clk    : in  std_logic;
        we     : in  std_logic;
        addr_a : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        addr_b : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        di     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        val_a  : out std_logic_vector(DATA_WIDTH-1 downto 0);
        val_b  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity BRAMDualPort;

architecture Behavioral of BRAMDualPort is
    type ram_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    shared variable ram : ram_type := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(to_integer(unsigned(addr_a))) := di;
            end if;
            val_a <= ram(to_integer(unsigned(addr_a)));
            val_b <= ram(to_integer(unsigned(addr_b)));
        end if;
    end process;
end architecture Behavioral;
