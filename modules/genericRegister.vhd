LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY genericRegister IS
    GENERIC (N : INTEGER := 7);
    PORT (
        data_in : IN STD_LOGIC_VECTOR (N DOWNTO 0);
        clk, clk_en, rst : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR (N DOWNTO 0));
END genericRegister;

ARCHITECTURE Behavioral OF genericRegister IS
BEGIN
    p1 : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            data_out <= "00000000";
        ELSIF rising_edge(clk) THEN
            IF clk_en = '1' THEN
                data_out <= data_in;
            END IF;
        END IF;
    END PROCESS p1;

END Behavioral;