LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY element_alu IS
    GENERIC (
        ELEM_WIDTH : INTEGER := 8
    );
    PORT (
        A_in        : IN  SIGNED(ELEM_WIDTH - 1 DOWNTO 0);
        B_in        : IN  SIGNED(ELEM_WIDTH - 1 DOWNTO 0);
        op_sel      : IN  STD_LOGIC;      -- 0 = SOMA, 1 = SUBTRAÇAO
        result_out  : OUT STD_LOGIC_VECTOR(ELEM_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF element_alu IS
    
    SIGNAL sum_ext   : SIGNED(ELEM_WIDTH DOWNTO 0);

    CONSTANT MAX_VAL : SIGNED(ELEM_WIDTH - 1 DOWNTO 0) :=
        TO_SIGNED( (2**(ELEM_WIDTH-1))-1, ELEM_WIDTH );  -- +127

    CONSTANT MIN_VAL : SIGNED(ELEM_WIDTH - 1 DOWNTO 0) :=
        TO_SIGNED( -(2**(ELEM_WIDTH-1)), ELEM_WIDTH );    -- -128

    SIGNAL MAX_EXT   : SIGNED(ELEM_WIDTH DOWNTO 0);
    SIGNAL MIN_EXT   : SIGNED(ELEM_WIDTH DOWNTO 0);

BEGIN

    MAX_EXT <= RESIZE(MAX_VAL, ELEM_WIDTH+1); -- +127 estendido
    MIN_EXT <= RESIZE(MIN_VAL, ELEM_WIDTH+1); -- -128 estendido

    sum_ext <= 
        (RESIZE(A_in, ELEM_WIDTH+1) + RESIZE(B_in, ELEM_WIDTH+1)) WHEN op_sel = '0' ELSE
        (RESIZE(A_in, ELEM_WIDTH+1) - RESIZE(B_in, ELEM_WIDTH+1));

    PROCESS(sum_ext)
        VARIABLE sat : SIGNED(ELEM_WIDTH - 1 DOWNTO 0);
    BEGIN

        IF sum_ext > MAX_EXT THEN
            sat := MAX_VAL;

        ELSIF sum_ext < MIN_EXT THEN
            sat := MIN_VAL;

        ELSE
            sat := sum_ext(ELEM_WIDTH-1 DOWNTO 0);
        END IF;

        result_out <= STD_LOGIC_VECTOR(sat);
    END PROCESS;

END ARCHITECTURE;
