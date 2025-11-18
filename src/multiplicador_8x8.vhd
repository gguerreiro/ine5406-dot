LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY multiplicador_8x8 IS
    GENERIC (
        IN_WIDTH  : INTEGER := 8;
        OUT_WIDTH : INTEGER := 16
    );
    PORT (
        clk         : IN  STD_LOGIC;
        mult_enable : IN  STD_LOGIC;
        A_in        : IN  STD_LOGIC_VECTOR(IN_WIDTH - 1 DOWNTO 0);
        B_in        : IN  STD_LOGIC_VECTOR(IN_WIDTH - 1 DOWNTO 0);
        P_out       : OUT STD_LOGIC_VECTOR(OUT_WIDTH - 1 DOWNTO 0)
    );
END ENTITY multiplicador_8x8;

ARCHITECTURE rtl OF multiplicador_8x8 IS
    SIGNAL product_comb : SIGNED(OUT_WIDTH - 1 DOWNTO 0);
BEGIN

    product_comb <= SIGNED(A_in) * SIGNED(B_in);

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF mult_enable = '1' THEN
                P_out <= STD_LOGIC_VECTOR(product_comb);
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;
