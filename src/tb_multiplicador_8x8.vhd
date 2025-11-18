LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_multiplicador_8x8 IS
END ENTITY tb_multiplicador_8x8;

ARCHITECTURE behavior OF tb_multiplicador_8x8 IS
    
    CONSTANT C_IN_WIDTH  : INTEGER := 8;
    CONSTANT C_OUT_WIDTH : INTEGER := 16;
    CONSTANT C_CLK_PERIOD: TIME    := 10 ns; -- 100 MHz

    SIGNAL clk           : STD_LOGIC := '0';
    SIGNAL mult_enable   : STD_LOGIC := '0';
    SIGNAL A_in          : STD_LOGIC_VECTOR(C_IN_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B_in          : STD_LOGIC_VECTOR(C_IN_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL P_out         : STD_LOGIC_VECTOR(C_OUT_WIDTH - 1 DOWNTO 0);

    SIGNAL expected_result_sig : SIGNED(C_OUT_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SHARED VARIABLE failures : INTEGER := 0;

BEGIN
    
    DUT : ENTITY work.multiplicador_8x8
        GENERIC MAP (
            IN_WIDTH  => C_IN_WIDTH,
            OUT_WIDTH => C_OUT_WIDTH
        )
        PORT MAP (
            clk         => clk,
            mult_enable => mult_enable,
            A_in        => A_in,
            B_in        => B_in,
            P_out       => P_out
        );

    clk_process : PROCESS
    BEGIN
        LOOP
            clk <= '0'; WAIT FOR C_CLK_PERIOD/2;
            clk <= '1'; WAIT FOR C_CLK_PERIOD/2;
        END LOOP;
    END PROCESS;

    stimulus_process : PROCESS
        
        PROCEDURE RunMultAndCheck (
            p_A: IN INTEGER;
            p_B: IN INTEGER;
            p_Case_Desc: IN STRING
        ) IS
            VARIABLE v_result_int : INTEGER;
            VARIABLE v_obtained_val : INTEGER;
        BEGIN
            v_result_int := p_A * p_B;
            
            A_in <= STD_LOGIC_VECTOR(TO_SIGNED(p_A, C_IN_WIDTH));
            B_in <= STD_LOGIC_VECTOR(TO_SIGNED(p_B, C_IN_WIDTH));
            expected_result_sig <= TO_SIGNED(v_result_int, C_OUT_WIDTH);
            
            REPORT "--- Executando Teste: " & p_Case_Desc & " (" & INTEGER'image(p_A) & " * " & INTEGER'image(p_B) & ") ---" SEVERITY NOTE;

            WAIT UNTIL rising_edge(clk);
            mult_enable <= '1';
            WAIT UNTIL rising_edge(clk); 
            mult_enable <= '0';
            
            WAIT FOR 1 ps;
            
            v_obtained_val := TO_INTEGER(SIGNED(P_out));

            ASSERT SIGNED(P_out) = expected_result_sig
            REPORT "FALHA DE ASSERTION: " & p_Case_Desc & 
                   " | Obtido: " & INTEGER'image(v_obtained_val) & 
                   " | Esperado: " & INTEGER'image(v_result_int)
            SEVERITY ERROR;
            
            IF SIGNED(P_out) /= expected_result_sig THEN
                failures := failures + 1;
            ELSE
                REPORT "TESTE DE SUCESSO: " & p_Case_Desc & " passou." SEVERITY NOTE;
            END IF;
            
        END PROCEDURE;
        
    BEGIN
        REPORT "Executando Simulação do Multiplicador 8x8 (Validação Detalhada)" SEVERITY NOTE;
        WAIT FOR C_CLK_PERIOD;
        
        -- Caso 1: Máximo Positivo (127 * 127 = 16129)
        RunMultAndCheck(127, 127, "Max Positivo");
        
        -- Caso 2: Mínimo Negativo (-128 * -128 = 16384)
        RunMultAndCheck(-128, -128, "Min Negativo");
        
        -- Caso 3: Misto (10 * -20 = -200)
        RunMultAndCheck(10, -20, "Misto");
        
        -- Caso 4: Resultado Zero (5 * 0 = 0)
        RunMultAndCheck(5, 0, "Resultado Zero");

        -- Caso 5: Misto grande (-120 * 80 = -9600)
        RunMultAndCheck(-120, 80, "Misto Grande");

        -- 6. Finalização
        WAIT FOR C_CLK_PERIOD;

        IF failures > 0 THEN
            REPORT "FALHA DE SIMULACAO: " & INTEGER'image(failures) & " erros de ASSERTION detectados." SEVERITY FAILURE;
        ELSE
            REPORT "SIMULACAO CONCLUIDA: Todos os testes passaram sem erros de ASSERTION." SEVERITY NOTE;
        END IF;
        
        WAIT;
    END PROCESS stimulus_process;
    
END ARCHITECTURE behavior;