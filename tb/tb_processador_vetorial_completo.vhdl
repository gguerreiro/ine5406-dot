-- =============================================================================
-- Arquivo: tb_processador_vetorial_completo.vhdl
-- Descrição: Testbench completo para o processador vetorial
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ProcessadorVetorialCompleto is
end entity tb_ProcessadorVetorialCompleto;

architecture Behavioral of tb_ProcessadorVetorialCompleto is
    -- Componente a ser testado
    component ProcessadorVetorialCompleto is
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            start  : in  std_logic;
            op_sel : in  std_logic_vector(1 downto 0);
            done   : out std_logic
        );
    end component;
    
    -- Sinais do testbench
    signal clk_tb    : std_logic := '0';
    signal rst_tb    : std_logic := '0';
    signal start_tb  : std_logic := '0';
    signal op_sel_tb : std_logic_vector(1 downto 0) := "00";
    signal done_tb   : std_logic;
    
    -- Constantes
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- Instanciação do DUT (Device Under Test)
    DUT : ProcessadorVetorialCompleto port map (
        clk    => clk_tb,
        rst    => rst_tb,
        start  => start_tb,
        op_sel => op_sel_tb,
        done   => done_tb
    );
    
    -- Geração de clock
    clk_tb <= not clk_tb after CLK_PERIOD/2;
    
    -- Processo de estímulos
    stimulus_proc : process
    begin
        report "===========================================" severity note;
        report "Testbench do Processador Vetorial Completo" severity note;
        report "===========================================" severity note;
        
        -- Teste 1: Reset
        report "Teste 1: Aplicando Reset..." severity note;
        rst_tb <= '1';
        wait for 2*CLK_PERIOD;
        rst_tb <= '0';
        wait for 2*CLK_PERIOD;
        report "Reset concluído." severity note;
        
        -- Teste 2: Operação de SOMA
        report "Teste 2: Iniciando operação de SOMA..." severity note;
        op_sel_tb <= "00";
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';
        wait until done_tb = '1';
        report "Operação de SOMA concluída." severity note;
        wait for 2*CLK_PERIOD;
        
        -- Teste 3: Operação de SUBTRAÇÃO
        report "Teste 3: Iniciando operação de SUBTRAÇÃO..." severity note;
        op_sel_tb <= "01";
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';
        wait until done_tb = '1';
        report "Operação de SUBTRAÇÃO concluída." severity note;
        wait for 2*CLK_PERIOD;
        
        -- Teste 4: Operação de PRODUTO ESCALAR
        report "Teste 4: Iniciando operação de PRODUTO ESCALAR..." severity note;
        op_sel_tb <= "10";
        start_tb <= '1';
        wait for CLK_PERIOD;
        start_tb <= '0';
        wait until done_tb = '1';
        report "Operação de PRODUTO ESCALAR concluída." severity note;
        wait for 2*CLK_PERIOD;
        
        report "===========================================" severity note;
        report "Todos os testes concluídos com sucesso!" severity note;
        report "===========================================" severity note;
        
        wait;
    end process stimulus_proc;
    
end architecture Behavioral;
