LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dualPortRam IS
    GENERIC (
        MEM_WIDTH : INTEGER := 8;
        MEM_DEPTH : INTEGER := 256); -- 2 ^ 3
    PORT (
        d_in : IN STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0);
        addr_a, addr_b : IN NATURAL RANGE 0 TO MEM_DEPTH - 1;
        clk_A, clk_B, wea, rea : IN STD_LOGIC;
        d_out : OUT STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0));
END dualPortRam;

ARCHITECTURE Behavioral OF dualPortRam IS
    TYPE MemoryType IS ARRAY (0 TO MEM_DEPTH - 1) OF STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0);
    SHARED VARIABLE mem : MemoryType;

BEGIN

    writeProcess : PROCESS (clk_A)
    BEGIN
        IF rising_edge(clk_A) AND wea = '1' THEN
            mem(addr_a) := d_in;
        END IF;
    END PROCESS writeProcess;

    readProcess : PROCESS (clk_B)
    BEGIN
        IF rising_edge(clk_B) AND rea = '1' THEN
            d_out <= mem(addr_b);
        END IF;
    END PROCESS readProcess;

END Behavioral;