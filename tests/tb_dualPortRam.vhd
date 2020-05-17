LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_dualPortRam IS
    GENERIC (
        MEM_WIDTH : INTEGER := 8;
        MEM_DEPTH : INTEGER := 256); -- 2 ^ 3
END tb_dualPortRam;

ARCHITECTURE behavior OF tb_dualPortRam IS

    COMPONENT dualPortRam IS
        GENERIC (
            MEM_WIDTH : INTEGER := 8;
            MEM_DEPTH : INTEGER := 256); -- 2 ^ 3
        PORT (
            d_in : IN STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0);
            addr_a, addr_b : IN NATURAL RANGE 0 TO MEM_DEPTH - 1;
            clk_A, clk_B, wea, rea : IN STD_LOGIC;
            d_out : OUT STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0));
    END COMPONENT;
    FOR Dut : dualPortRam USE ENTITY work.dualPortRam(Behavioral);

    SIGNAL d_in : STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0);
    SIGNAL addr_a, addr_b : NATURAL RANGE 0 TO MEM_DEPTH - 1;
    SIGNAL clk_A, clk_B, wea, rea : STD_LOGIC;
    SIGNAL d_out : STD_LOGIC_VECTOR (MEM_WIDTH - 1 DOWNTO 0);

    CONSTANT WAIT_TIME : TIME := 30 ns;
BEGIN

    Dut : dualPortRam
    GENERIC MAP(
        MEM_WIDTH => MEM_WIDTH,
        MEM_DEPTH => MEM_DEPTH
    )
    PORT MAP(d_in, addr_a, addr_b, clk_A, clk_B, wea, rea, d_out);

    tb : PROCESS
    BEGIN
        -- Init Clock
        clk_A <= '0';
        clk_B <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 1
        clk_A <= '1';
        clk_B <= '1';

        d_in <= "00000001";
        wea <= '1';
        rea <= '1';
        addr_a <= 0;
        addr_b <= 0;
        WAIT FOR WAIT_TIME;
        ASSERT d_out = "00000001"
        REPORT "ERROR in test 1" SEVERITY error;
        clk_A <= '0';
        clk_B <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 2
        clk_A <= '1';
        clk_B <= '1';

        d_in <= "00000010";
        wea <= '1';
        rea <= '1';
        addr_a <= 1;
        addr_b <= 0;
        WAIT FOR WAIT_TIME;
        ASSERT d_out /= "00000010"
        REPORT "ERROR in test 2" SEVERITY error;
        clk_A <= '0';
        clk_B <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 3
        clk_A <= '1';
        clk_B <= '1';

        d_in <= "00000011";
        wea <= '0';
        rea <= '1';
        addr_a <= 0;
        addr_b <= 0;
        WAIT FOR WAIT_TIME;
        ASSERT d_out /= "00000011"
        REPORT "ERROR in test 3" SEVERITY error;
        clk_A <= '0';
        clk_B <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 4
        clk_A <= '1';
        clk_B <= '1';

        d_in <= "00000100";
        wea <= '1';
        rea <= '0';
        addr_a <= 0;
        addr_b <= 0;
        WAIT FOR WAIT_TIME;
        ASSERT d_out /= "00000100"
        REPORT "ERROR in test 4" SEVERITY error;
        clk_A <= '0';
        clk_B <= '0';
        WAIT FOR WAIT_TIME;

        WAIT;
    END PROCESS tb;

END;