LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY acumulador_24bit IS
    GENERIC (
        IN_WIDTH  : INTEGER := 16;
        ACC_WIDTH : INTEGER := 24
    );
    PORT (
        clk         : IN  STD_LOGIC;
        acc_reset   : IN  STD_LOGIC;
        acc_enable  : IN  STD_LOGIC;
        P_in        : IN  STD_LOGIC_VECTOR(IN_WIDTH - 1 DOWNTO 0);
        acc_out     : OUT STD_LOGIC_VECTOR(ACC_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF acumulador_24bit IS
    SIGNAL accumulator_reg : SIGNED(ACC_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL P_in_extended   : SIGNED(ACC_WIDTH - 1 DOWNTO 0);

BEGIN

    P_in_extended <= RESIZE(SIGNED(P_in), ACC_WIDTH);

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF acc_reset = '1' THEN
                accumulator_reg <= (OTHERS => '0');

            ELSIF acc_enable = '1' THEN
                accumulator_reg <= accumulator_reg + P_in_extended;
            END IF;
        END IF;
    END PROCESS;

    acc_out <= STD_LOGIC_VECTOR(accumulator_reg);

END ARCHITECTURE;
