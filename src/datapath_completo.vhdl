-- =============================================================================
-- Arquivo: datapath_completo.vhdl
-- Descrição: Datapath completo do processador vetorial
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DatapathCompleto is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        
        -- Sinais de controle
        bram_addr_a : in  std_logic_vector(4 downto 0);
        bram_addr_b : in  std_logic_vector(4 downto 0);
        bram_we     : in  std_logic;
        reg_a_load  : in  std_logic;
        reg_b_load  : in  std_logic;
        acc_rst     : in  std_logic;
        acc_en      : in  std_logic;
        mux_sel     : in  std_logic_vector(1 downto 0);
        op_sel      : in  std_logic_vector(1 downto 0);
        
        -- Saída para BRAM
        result_out  : out std_logic_vector(31 downto 0)
    );
end entity DatapathCompleto;

architecture Structural of DatapathCompleto is
    -- Componentes
    component BRAMDualPort is
        port (
            clk    : in  std_logic;
            we     : in  std_logic;
            addr_a : in  std_logic_vector(4 downto 0);
            addr_b : in  std_logic_vector(4 downto 0);
            di     : in  std_logic_vector(31 downto 0);
            val_a  : out std_logic_vector(31 downto 0);
            val_b  : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component Registrador32Bit is
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            enable : in  std_logic;
            d      : in  std_logic_vector(31 downto 0);
            q      : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component SomadorSubtratorVetorial is
        port (
            A      : in  std_logic_vector(31 downto 0);
            B      : in  std_logic_vector(31 downto 0);
            is_sub : in  std_logic;
            result : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component Multiplicador8x8 is
        port (
            a : in  std_logic_vector(7 downto 0);
            b : in  std_logic_vector(7 downto 0);
            p : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component Acumulador24Bit is
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            enable : in  std_logic;
            d      : in  std_logic_vector(15 downto 0);
            q      : out std_logic_vector(23 downto 0)
        );
    end component;
    
    -- Sinais internos
    signal bram_val_a, bram_val_b, reg_a_out, reg_b_out, soma_sub_result, mux_out : std_logic_vector(31 downto 0);
    signal prod_0, prod_1, prod_2, prod_3 : std_logic_vector(15 downto 0);
    signal acc_in : std_logic_vector(15 downto 0);
    signal acc_out : std_logic_vector(23 downto 0);
    
begin
    -- BRAM
    BRAM_inst : BRAMDualPort port map (clk, bram_we, bram_addr_a, bram_addr_b, mux_out, bram_val_a, bram_val_b);
    
    -- Registradores
    RegA_inst : Registrador32Bit port map (clk, rst, reg_a_load, bram_val_a, reg_a_out);
    RegB_inst : Registrador32Bit port map (clk, rst, reg_b_load, bram_val_b, reg_b_out);
    
    -- Somador/Subtrator Vetorial
    Somador_inst : SomadorSubtratorVetorial port map (reg_a_out, reg_b_out, op_sel(0), soma_sub_result);
    
    -- Multiplicadores
    Mult0_inst : Multiplicador8x8 port map (reg_a_out(7 downto 0),   reg_b_out(7 downto 0),   prod_0);
    Mult1_inst : Multiplicador8x8 port map (reg_a_out(15 downto 8),  reg_b_out(15 downto 8),  prod_1);
    Mult2_inst : Multiplicador8x8 port map (reg_a_out(23 downto 16), reg_b_out(23 downto 16), prod_2);
    Mult3_inst : Multiplicador8x8 port map (reg_a_out(31 downto 24), reg_b_out(31 downto 24), prod_3);
    
    -- MUX para entrada do acumulador
    with mux_sel(1 downto 0) select
        acc_in <= prod_0 when "00",
                  prod_1 when "01",
                  prod_2 when "10",
                  prod_3 when "11";
    
    -- Acumulador
    Acc_inst : Acumulador24Bit port map (clk, acc_rst, acc_en, acc_in, acc_out);
    
    -- MUX de saída
    with mux_sel(1 downto 0) select
        mux_out <= soma_sub_result when "00",
                   std_logic_vector(resize(signed(acc_out), 32)) when "01",
                   (others => '0') when others;
                   
    result_out <= mux_out;
    
end architecture Structural;
