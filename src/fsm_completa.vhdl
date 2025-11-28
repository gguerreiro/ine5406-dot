-- =============================================================================
-- Arquivo: fsm_completa.vhdl
-- Descrição: FSM completa para controlar as 3 operações
-- Autor: Equipe Processador Vetorial
-- Data: 26/11/2025
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity FSMCompleta is
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;
        start         : in  std_logic;
        op_sel        : in  std_logic_vector(1 downto 0); -- 00:SOMA, 01:SUB, 10:PROD_ESC
        
        -- Sinais de controle para o Datapath
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
end entity FSMCompleta;

architecture Behavioral of FSMCompleta is
    type state_t is (IDLE, LOAD_A, LOAD_B, EXEC_SUM_SUB, EXEC_DOT_0, EXEC_DOT_1, EXEC_DOT_2, EXEC_DOT_3, WRITE_BACK, DONE_STATE);
    signal estado_atual, proximo_estado : state_t;
begin
    -- Processo síncrono: Atualiza o estado atual
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                estado_atual <= IDLE;
            else
                estado_atual <= proximo_estado;
            end if;
        end if;
    end process;
    
    -- Processo combinacional: Lógica de próximo estado
    process(estado_atual, start, op_sel)
    begin
        proximo_estado <= estado_atual;
        case estado_atual is
            when IDLE =>
                if start = '1' then
                    proximo_estado <= LOAD_A;
                end if;
            when LOAD_A =>
                proximo_estado <= LOAD_B;
            when LOAD_B =>
                if op_sel = "10" then -- Produto Escalar
                    proximo_estado <= EXEC_DOT_0;
                else -- Soma ou Subtração
                    proximo_estado <= EXEC_SUM_SUB;
                end if;
            when EXEC_SUM_SUB =>
                proximo_estado <= WRITE_BACK;
            when EXEC_DOT_0 =>
                proximo_estado <= EXEC_DOT_1;
            when EXEC_DOT_1 =>
                proximo_estado <= EXEC_DOT_2;
            when EXEC_DOT_2 =>
                proximo_estado <= EXEC_DOT_3;
            when EXEC_DOT_3 =>
                proximo_estado <= WRITE_BACK;
            when WRITE_BACK =>
                proximo_estado <= DONE_STATE;
            when DONE_STATE =>
                proximo_estado <= IDLE;
            when others =>
                proximo_estado <= IDLE;
        end case;
    end process;
    
    -- Processo combinacional: Saídas (Máquina de Moore)
    process(estado_atual, op_sel)
    begin
        -- Valores padrão
        bram_addr_a <= "00000";
        bram_addr_b <= "00000";
        bram_we     <= '0';
        reg_a_load  <= '0';
        reg_b_load  <= '0';
        acc_rst     <= '0';
        acc_en      <= '0';
        mux_sel     <= "00";
        done        <= '0';
        
        case estado_atual is
            when IDLE =>
                done <= '0';
            when LOAD_A =>
                bram_addr_a <= "00000";
                reg_a_load  <= '1';
            when LOAD_B =>
                bram_addr_b <= "00001";
                reg_b_load  <= '1';
            when EXEC_SUM_SUB =>
                mux_sel <= "00";
            when EXEC_DOT_0 =>
                acc_rst <= '1';
                mux_sel <= "01";
            when EXEC_DOT_1 =>
                acc_en  <= '1';
                mux_sel <= "01";
            when EXEC_DOT_2 =>
                acc_en  <= '1';
                mux_sel <= "01";
            when EXEC_DOT_3 =>
                acc_en  <= '1';
                mux_sel <= "01";
            when WRITE_BACK =>
                bram_addr_a <= "00010";
                bram_we     <= '1';
                if op_sel = "10" then
                    mux_sel <= "10";
                else
                    mux_sel <= "00";
                end if;
            when DONE_STATE =>
                done <= '1';
            when others =>
                null;
        end case;
    end process;
    
end architecture Behavioral;
