LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY somador_subtrator_vetorial IS
    GENERIC (
        DATA_WIDTH  : INTEGER := 8;
        VECTOR_SIZE : INTEGER := 4
    );
    PORT (
        clk         : IN  STD_LOGIC;
        alu_enable  : IN  STD_LOGIC;
        alu_op_sel  : IN  STD_LOGIC;     -- 0 = SOMA, 1 = SUBTRAÇÃO
        Vector_A    : IN  STD_LOGIC_VECTOR(VECTOR_SIZE*DATA_WIDTH - 1 DOWNTO 0);
        Vector_B    : IN  STD_LOGIC_VECTOR(VECTOR_SIZE*DATA_WIDTH - 1 DOWNTO 0);
        Vector_S    : OUT STD_LOGIC_VECTOR(VECTOR_SIZE*DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY somador_subtrator_vetorial;

ARCHITECTURE rtl OF somador_subtrator_vetorial IS
    SIGNAL S_elements : STD_LOGIC_VECTOR(VECTOR_SIZE*DATA_WIDTH - 1 DOWNTO 0);

    COMPONENT element_alu IS
        GENERIC (
            ELEM_WIDTH : INTEGER := 8
        );
        PORT (
            A_in        : IN  SIGNED(ELEM_WIDTH - 1 DOWNTO 0);
            B_in        : IN  SIGNED(ELEM_WIDTH - 1 DOWNTO 0);
            op_sel      : IN  STD_LOGIC;
            result_out  : OUT STD_LOGIC_VECTOR(ELEM_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT element_alu;

BEGIN

    ALU_GEN : FOR I IN 0 TO VECTOR_SIZE - 1 GENERATE

        SIGNAL A_elem : SIGNED(DATA_WIDTH - 1 DOWNTO 0);
        SIGNAL B_elem : SIGNED(DATA_WIDTH - 1 DOWNTO 0);
        
        CONSTANT START_INDEX : INTEGER := I * DATA_WIDTH;
        CONSTANT END_INDEX   : INTEGER := (I + 1) * DATA_WIDTH - 1;
		  
BEGIN
        
        A_elem <= SIGNED(Vector_A( END_INDEX DOWNTO START_INDEX ));
        B_elem <= SIGNED(Vector_B( END_INDEX DOWNTO START_INDEX ));
        
        ALU_I : ENTITY work.element_alu
            GENERIC MAP (
                ELEM_WIDTH => DATA_WIDTH
            )
            PORT MAP (
                A_in        => A_elem,
                B_in        => B_elem,
                op_sel      => alu_op_sel,
                result_out  => S_elements( END_INDEX DOWNTO START_INDEX )
            );
            
    END GENERATE ALU_GEN;
    
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF alu_enable = '1' THEN
                Vector_S <= S_elements;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;