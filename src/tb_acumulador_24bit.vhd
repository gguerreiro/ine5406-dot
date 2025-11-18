LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_acumulador_24bit IS
END ENTITY tb_acumulador_24bit;

ARCHITECTURE behavior OF tb_acumulador_24bit IS
    
    CONSTANT C_IN_WIDTH  : INTEGER := 16;
    CONSTANT C_ACC_WIDTH : INTEGER := 24;
    CONSTANT C_CLK_PERIOD: TIME    := 10 ns; 

    SIGNAL clk           : STD_LOGIC := '0';
    SIGNAL acc_reset     : STD_LOGIC := '1';
    SIGNAL acc_enable    : STD_LOGIC := '0';
    SIGNAL P_in          : STD_LOGIC_VECTOR(C_IN_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL acc_out       : STD_LOGIC_VECTOR(C_ACC_WIDTH - 1 DOWNTO 0);

    SHARED VARIABLE failures : INTEGER := 0;

BEGIN
    
    DUT : ENTITY work.acumulador_24bit
        GENERIC MAP (
            IN_WIDTH  => C_IN_WIDTH,
            ACC_WIDTH => C_ACC_WIDTH
        )
        PORT MAP (
            clk         => clk,
            acc_reset   => acc_reset,
            acc_enable  => acc_enable,
            P_in        => P_in,
            acc_out     => acc_out
        );

    clk_process : PROCESS
    BEGIN
        LOOP
            clk <= '0'; WAIT FOR C_CLK_PERIOD/2;
            clk <= '1'; WAIT FOR C_CLK_PERIOD/2;
        END LOOP;
    END PROCESS;

    stimulus_process : PROCESS
        
        CONSTANT C_MAX_PROD : INTEGER := 16129; 

        PROCEDURE RunAccumulationAndCheck (
            p_Prod: IN INTEGER;
            p_Expected_Total: IN INTEGER;
            p_Case_Desc: IN STRING
        ) IS
            VARIABLE v_obtained_val : INTEGER;
        BEGIN
            
            REPORT "--- Executando Teste: " & p_Case_Desc & " ---" SEVERITY NOTE;
            
            P_in <= STD_LOGIC_VECTOR(TO_SIGNED(p_Prod, C_IN_WIDTH));
            
            WAIT UNTIL rising_edge(clk);
            acc_enable <= '1';
            WAIT UNTIL rising_edge(clk);
            acc_enable <= '0';
            
            WAIT FOR 1 ps; 
            
            v_obtained_val := TO_INTEGER(SIGNED(acc_out));

            ASSERT v_obtained_val = p_Expected_Total
            REPORT "FALHA DE ASSERTION: " & p_Case_Desc & 
                   " | Obtido: " & INTEGER'image(v_obtained_val) & 
                   " | Esperado: " & INTEGER'image(p_Expected_Total)
            SEVERITY ERROR;

            IF v_obtained_val /= p_Expected_Total THEN
                failures := failures + 1;
            ELSE
                REPORT "TESTE DE SUCESSO: " & p_Case_Desc & " passou." SEVERITY NOTE;
            END IF;
            
        END PROCEDURE;
		  
		  VARIABLE current_total : INTEGER := 0;
        
    BEGIN
        REPORT "Executando Simulação do Acumulador 24 bits (Validação Detalhada)" SEVERITY NOTE;
        WAIT FOR C_CLK_PERIOD;

        -- Teste 1: Reset (Estado IDLE da FSM, acc_reset='1')
        REPORT "--- Executando Teste: RESET (Início do DOT) ---" SEVERITY NOTE;
        WAIT UNTIL rising_edge(clk);
        acc_reset <= '1';
        WAIT UNTIL rising_edge(clk);
        acc_reset <= '0';
        
        -- Validação pós-reset (deve ser 0)
        WAIT FOR 1 ps;
        ASSERT TO_INTEGER(SIGNED(acc_out)) = 0
        REPORT "FALHA DE ASSERTION: Teste de RESET. Obtido: " & INTEGER'image(TO_INTEGER(SIGNED(acc_out))) & " | Esperado: 0"
        SEVERITY ERROR;

        IF TO_INTEGER(SIGNED(acc_out)) /= 0 THEN
            failures := failures + 1;
        ELSE
            REPORT "TESTE DE SUCESSO: Reset passou." SEVERITY NOTE;
        END IF;

        -- Teste 2: Acumulação 1/4 (EXEC_DOT_0)
        current_total := current_total + 1000;
        RunAccumulationAndCheck(1000, current_total, "ACUMULACAO 1/4");

        -- Teste 3: Acumulação 2/4 (EXEC_DOT_1)
        current_total := current_total + 5000;
        RunAccumulationAndCheck(5000, current_total, "ACUMULACAO 2/4");

        -- Teste 4: Acumulação 3/4 (Negativo) (EXEC_DOT_2)
        current_total := current_total - 2000;
        RunAccumulationAndCheck(-2000, current_total, "ACUMULACAO 3/4 (Negativo)");

        -- Teste 5: Acumulação 4/4 (EXEC_DOT_3)
        current_total := current_total + 3000;
        RunAccumulationAndCheck(3000, current_total, "ACUMULACAO 4/4 (Fim DOT)");
        
        -- Teste 6: Pior Caso (Overflow Check - 4x Max Prod)
        REPORT "--- Executando Teste: Limite Superior (Pior Caso) ---" SEVERITY NOTE;
        
        -- Reset para novo cálculo
        WAIT UNTIL rising_edge(clk);
        acc_reset <= '1';
        WAIT UNTIL rising_edge(clk);
        acc_reset <= '0';
        current_total := 0;
        
        -- 4 somas do valor máximo: 64516
        current_total := current_total + C_MAX_PROD;
        RunAccumulationAndCheck(C_MAX_PROD, current_total, "LIMITE 1/4");
        current_total := current_total + C_MAX_PROD;
        RunAccumulationAndCheck(C_MAX_PROD, current_total, "LIMITE 2/4");
        current_total := current_total + C_MAX_PROD;
        RunAccumulationAndCheck(C_MAX_PROD, current_total, "LIMITE 3/4");
        current_total := current_total + C_MAX_PROD;
        RunAccumulationAndCheck(C_MAX_PROD, current_total, "LIMITE 4/4 (64516)");

        -- 7. Finalização
        WAIT FOR C_CLK_PERIOD;

        IF failures > 0 THEN
            REPORT "FALHA DE SIMULACAO: " & INTEGER'image(failures) & " erros de ASSERTION detectados." SEVERITY FAILURE;
        ELSE
            REPORT "SIMULACAO CONCLUIDA: Todos os testes passaram sem erros de ASSERTION." SEVERITY NOTE;
        END IF;
        
        WAIT; 
    END PROCESS stimulus_process;
    
END ARCHITECTURE behavior;