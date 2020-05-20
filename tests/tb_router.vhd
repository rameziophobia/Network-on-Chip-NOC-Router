LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_router IS
    GENERIC (N : INTEGER := 7);
END tb_router;

ARCHITECTURE behavior OF tb_router IS
    SIGNAL datai1, datai2, datai3, datai4 : STD_LOGIC_VECTOR (N DOWNTO 0);
    SIGNAL wr1, wr2, wr3, wr4 : STD_LOGIC;
    SIGNAL wclock, rclock, rst : STD_LOGIC;
    SIGNAL datao1, datao2, datao3, datao4 : STD_LOGIC_VECTOR (N DOWNTO 0);

    CONSTANT clk_period : TIME := 100 ns;

BEGIN

    dut : ENTITY work.router PORT MAP(
        datai1, datai2, datai3, datai4,
        wr1, wr2, wr3, wr4,
        wclock, rclock, rst,
        datao1, datao2, datao3, datao4
        );

    rclk_process : PROCESS
    BEGIN
        rclock <= '0';
        WAIT FOR clk_period/2;
        rclock <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    wrclk_process : PROCESS
    BEGIN
        wclock <= '0';
        WAIT FOR clk_period/2;
        wclock <= '1';
        WAIT FOR clk_period/2;

    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR clk_period;
        datai1 <= "00000100";
        datai2 <= "00000011";
        datai3 <= "00000010";
        datai4 <= "00000001";
        rst <= '0';
        wr1 <= '1';
        wr2 <= '1';
        wr3 <= '1';
        wr4 <= '1';
        WAIT FOR clk_period;
        datai1 <= "00010000";
        datai2 <= "00100000";
        datai3 <= "00110000";
        datai4 <= "01000000";
        WAIT FOR clk_period;
        wr1 <= '0';
        wr2 <= '0';
        wr3 <= '0';
        wr4 <= '0';
        WAIT FOR clk_period;
        ASSERT datao2 = "00000001"
        REPORT "Test case 1a failed"
            SEVERITY Error;

        WAIT FOR clk_period;
        ASSERT datao1 = "00000100"
        REPORT "Test case 1b failed"
            SEVERITY Error;

        WAIT FOR clk_period;
        ASSERT datao4 = "00000011"
        REPORT "Test case 1c failed"
            SEVERITY Error;
        ASSERT datao1 = "00100000"
        REPORT "Test case 2a failed"
            SEVERITY Error;

        WAIT FOR clk_period;
        ASSERT datao3 = "00000010"
        REPORT "Test case 1d failed"
            SEVERITY Error;
        ASSERT datao1 = "00110000"
        REPORT "Test case 2b failed"
            SEVERITY Error;

        WAIT FOR clk_period;
        ASSERT datao1 = "01000000"
        REPORT "Test case 2c failed"
            SEVERITY Error;

        WAIT FOR clk_period;
        ASSERT datao1 = "00010000"
        REPORT "Test case 2d failed"
            SEVERITY Error;

        wr2 <= '1';
        datai2 <= "10100001";
        WAIT FOR clk_period * 10;
        datai2 <= "11110001";
        WAIT FOR clk_period;
        wr2 <= '0';

        WAIT FOR clk_period * 30;
        ASSERT datao2 = "10100001"
        REPORT "Test case 3 failed"
            SEVERITY Error;

        datai4 <= "11110011";
        wr4 <= '1';
        WAIT FOR clk_period * 2;
        rst <= '1';
        wr4 <= '0';
        WAIT FOR clk_period;
        datai4 <= "11010011";
        wr4 <= '1';
        rst <= '0';
        WAIT FOR clk_period;
        wr4 <= '0';
        WAIT FOR clk_period * 2;
        ASSERT datao4 = "11010011"
        REPORT "Test case 4 failed"
            SEVERITY Error;

        WAIT;
    END PROCESS;

END;