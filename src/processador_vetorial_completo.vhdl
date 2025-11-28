-- =============================================================================
-- Arquivo: processador_vetorial_completo.vhdl
-- Descrição: Top-level do processador vetorial completo
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity ProcessadorVetorialCompleto is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        start  : in  std_logic;
        op_sel : in  std_logic_vector(1 downto 0);
        done   : out std_logic
    );
end entity ProcessadorVetorialCompleto;

architecture Structural of ProcessadorVetorialCompleto is
    -- Componentes
    component FSMCompleta is
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            start         : in  std_logic;
            op_sel        : in  std_logic_vector(1 downto 0);
            bram_addr_a   : out std_logic_vector(4 downto 0);
            bram_addr_b   : out std_logic_vector(4 downto 0);
            bram_we       : out std_logic;
            reg_a_load    : out std_logic;
            reg_b_load    : out std_logic;
            acc_rst       : out std_logic;
            acc_en        : out std_logic;
            mux_sel       : out std_logic_vector(1 downto 0);
            done          : out std_logic
        );
    end component;
    
    component DatapathCompleto is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            bram_addr_a : in  std_logic_vector(4 downto 0);
            bram_addr_b : in  std_logic_vector(4 downto 0);
            bram_we     : in  std_logic;
            reg_a_load  : in  std_logic;
            reg_b_load  : in  std_logic;
            acc_rst     : in  std_logic;
            acc_en      : in  std_logic;
            mux_sel     : in  std_logic_vector(1 downto 0);
            op_sel      : in  std_logic_vector(1 downto 0);
            result_out  : out std_logic_vector(31 downto 0)
        );
    end component;
    
    -- Sinais de interconexão
    signal bram_addr_a_s, bram_addr_b_s : std_logic_vector(4 downto 0);
    signal bram_we_s, reg_a_load_s, reg_b_load_s, acc_rst_s, acc_en_s : std_logic;
    signal mux_sel_s : std_logic_vector(1 downto 0);
    signal result_out_s : std_logic_vector(31 downto 0);
    
begin
    -- Instanciação da FSM
    FSM_inst : FSMCompleta port map (
        clk           => clk,
        rst           => rst,
        start         => start,
        op_sel        => op_sel,
        bram_addr_a   => bram_addr_a_s,
        bram_addr_b   => bram_addr_b_s,
        bram_we       => bram_we_s,
        reg_a_load    => reg_a_load_s,
        reg_b_load    => reg_b_load_s,
        acc_rst       => acc_rst_s,
        acc_en        => acc_en_s,
        mux_sel       => mux_sel_s,
        done          => done
    );
    
    -- Instanciação do Datapath
    Datapath_inst : DatapathCompleto port map (
        clk         => clk,
        rst         => rst,
        bram_addr_a => bram_addr_a_s,
        bram_addr_b => bram_addr_b_s,
        bram_we     => bram_we_s,
        reg_a_load  => reg_a_load_s,
        reg_b_load  => reg_b_load_s,
        acc_rst     => acc_rst_s,
        acc_en      => acc_en_s,
        mux_sel     => mux_sel_s,
        op_sel      => op_sel,
        result_out  => result_out_s
    );
    
end architecture Structural;
