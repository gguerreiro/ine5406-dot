LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_somador_subtrator IS
END ENTITY tb_somador_subtrator;

ARCHITECTURE behavior OF tb_somador_subtrator IS
    
    CONSTANT C_DATA_WIDTH  : INTEGER := 8;
    CONSTANT C_VECTOR_SIZE : INTEGER := 4;
    CONSTANT C_VEC_WIDTH   : INTEGER := 32;
    CONSTANT C_CLK_PERIOD  : TIME    := 10 ns; 

    SIGNAL clk         : STD_LOGIC := '0';
    SIGNAL alu_enable  : STD_LOGIC := '0';
    SIGNAL alu_op_sel  : STD_LOGIC := '0';
    SIGNAL Vector_A    : STD_LOGIC_VECTOR(C_VEC_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Vector_B    : STD_LOGIC_VECTOR(C_VEC_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Vector_S    : STD_LOGIC_VECTOR(C_VEC_WIDTH - 1 DOWNTO 0);

    SHARED VARIABLE failures : INTEGER := 0;

BEGIN
    
    DUT : ENTITY work.somador_subtrator_vetorial
        GENERIC MAP (
            DATA_WIDTH  => C_DATA_WIDTH,
            VECTOR_SIZE => C_VECTOR_SIZE
        )
        PORT MAP (
            clk         => clk,
            alu_enable  => alu_enable,
            alu_op_sel  => alu_op_sel,
            Vector_A    => Vector_A,
            Vector_B    => Vector_B,
            Vector_S    => Vector_S
        );

    clk_process : PROCESS
    BEGIN
        LOOP
            clk <= '0'; WAIT FOR C_CLK_PERIOD/2;
            clk <= '1'; WAIT FOR C_CLK_PERIOD/2;
        END LOOP;
    END PROCESS;

    stimulus_process : PROCESS
        
        CONSTANT MAX_VAL : INTEGER := 127;
        CONSTANT MIN_VAL : INTEGER := -128;
        TYPE INTEGER_VECTOR IS ARRAY (INTEGER RANGE <>) OF INTEGER;

        FUNCTION MakeVector(E0, E1, E2, E3 : INTEGER) RETURN STD_LOGIC_VECTOR IS
            VARIABLE V : STD_LOGIC_VECTOR(C_VEC_WIDTH - 1 DOWNTO 0);
        BEGIN
            V(7 DOWNTO 0)    := STD_LOGIC_VECTOR(TO_SIGNED(E0, 8));
            V(15 DOWNTO 8)   := STD_LOGIC_VECTOR(TO_SIGNED(E1, 8));
            V(23 DOWNTO 16)  := STD_LOGIC_VECTOR(TO_SIGNED(E2, 8));
            V(31 DOWNTO 24)  := STD_LOGIC_VECTOR(TO_SIGNED(E3, 8));
            RETURN V;
        END FUNCTION;

        FUNCTION GetElement(V : STD_LOGIC_VECTOR; Index : INTEGER) RETURN INTEGER IS
        BEGIN
            RETURN TO_INTEGER(SIGNED(V( (Index+1)*C_DATA_WIDTH - 1 DOWNTO Index*C_DATA_WIDTH )));
        END FUNCTION;
        
        PROCEDURE RunOpAndCheck (
            p_Vector_A: IN STD_LOGIC_VECTOR;
            p_Vector_B: IN STD_LOGIC_VECTOR;
            p_Op_Sel: IN STD_LOGIC;
            p_Expected_E: IN INTEGER_VECTOR(0 TO C_VECTOR_SIZE-1);
            p_Case_Desc: IN STRING
        ) IS
            VARIABLE v_op_desc : STRING(1 TO 4) := (OTHERS => ' ');
            VARIABLE v_op_char : CHARACTER := ' ';
            VARIABLE v_success : BOOLEAN := TRUE;
            VARIABLE v_element_obtained : INTEGER;
        BEGIN
            
            IF p_Op_Sel = '0' THEN v_op_desc := "SOMA"; v_op_char := '+';
            ELSE v_op_desc := "SUB "; v_op_char := '-'; 
				END IF;
            
            REPORT "--- Executando Teste: " & v_op_desc & " (" & p_Case_Desc & ") ---" SEVERITY NOTE;

            Vector_A <= p_Vector_A;
            Vector_B <= p_Vector_B;
            alu_op_sel <= p_Op_Sel;
            
            WAIT UNTIL rising_edge(clk);
            alu_enable <= '1';
            WAIT UNTIL rising_edge(clk);
            alu_enable <= '0';
            
            WAIT FOR 1 ps; 
            
            FOR I IN 0 TO C_VECTOR_SIZE - 1 LOOP
                v_element_obtained := GetElement(Vector_S, I);

                IF v_element_obtained /= p_Expected_E(I) THEN
                    v_success := FALSE;
                    failures := failures + 1;
                    
                    ASSERT FALSE
                    REPORT "FALHA DE ASSERTION: " & p_Case_Desc & 
                           " | Elemento " & INTEGER'image(I) & " (" & INTEGER'image(GetElement(p_Vector_A, I)) & v_op_char & INTEGER'image(GetElement(p_Vector_B, I)) & "):" &
                           " Obtido: " & INTEGER'image(v_element_obtained) & 
                           " | Esperado: " & INTEGER'image(p_Expected_E(I))
                    SEVERITY ERROR;
                END IF;
            END LOOP;

            IF v_success THEN
                REPORT "TESTE DE SUCESSO: " & p_Case_Desc & " (" & v_op_desc & ") passou." SEVERITY NOTE;
            END IF;
            
        END PROCEDURE;
        
    BEGIN
        REPORT "Executando Simulação do Somador/Subtrator Vetorial (Saturação)" SEVERITY NOTE;
        WAIT FOR C_CLK_PERIOD;

        -- Teste 1: SOMA Normal (10 + 5 = 15)
        RunOpAndCheck(
            MakeVector(10, 20, 30, 40),      -- Vetor A
            MakeVector(5, 5, 5, 5),          -- Vetor B
            '0',                             -- SOMA
            (15, 25, 35, 45),                -- Esperado
            "SOMA Normal"
        );
        
        -- Teste 2: SOMA com Overflow (Saturação em 127)
        RunOpAndCheck(
            MakeVector(MAX_VAL, 100, 126, 127), -- A: [127, 100, 126, 127]
            MakeVector(1, 40, 5, 1),             -- B: [1, 40, 5, 1]
            '0',                             -- SOMA
            (MAX_VAL, MAX_VAL, MAX_VAL, MAX_VAL), -- Esperado (Elemento 1: 140->127; Elemento 2: 131->127; Elemento 3: 128->127)
            "SOMA com Saturação Positiva"
        );

        -- Teste 3: SUBTRAÇÃO Normal (50 - 10 = 40)
        RunOpAndCheck(
            MakeVector(50, 60, 70, 80),      -- Vector A
            MakeVector(10, 10, 10, 10),      -- Vector B
            '1',                             -- SUB
            (40, 50, 60, 70),                -- Esperado
            "SUB Normal"
        );

        -- Teste 4: SUBTRAÇÃO com Underflow (Saturação em -128)
        RunOpAndCheck(
            MakeVector(-120, -100, -127, -128), -- A: [-120, -100, -127, -128]
            MakeVector(10, 40, 2, 1),             -- B: [10, 40, 2, 1]
            '1',                             -- SUB
            (MIN_VAL, MIN_VAL, MIN_VAL, MIN_VAL), -- Esperado (Elementos: -130->-128, -140->-128, -129->-128, -129->-128)
            "SUB com Saturação Negativa"
        );
        
        WAIT FOR C_CLK_PERIOD;

        IF failures > 0 THEN
            REPORT "FALHA DE SIMULACAO: " & INTEGER'image(failures) & " erros de ASSERTION detectados." SEVERITY FAILURE;
        ELSE
            REPORT "SIMULACAO CONCLUIDA: Somador/Subtrator passou nos testes de Saturação." SEVERITY NOTE;
        END IF;
        
        WAIT; 
    END PROCESS stimulus_process;
    
END ARCHITECTURE behavior;

