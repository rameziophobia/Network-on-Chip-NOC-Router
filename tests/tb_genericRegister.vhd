LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_genericRegister IS
    GENERIC (N : INTEGER := 7);
END tb_genericRegister;

ARCHITECTURE behavior OF tb_genericRegister IS

    COMPONENT genericRegister IS
        GENERIC (N : INTEGER := 7);
        PORT (
            data_in : IN STD_LOGIC_VECTOR (N DOWNTO 0);
            clk, clk_en, rst : IN STD_LOGIC;
            data_out : OUT STD_LOGIC_VECTOR (N DOWNTO 0));
    END COMPONENT;
    FOR Dut : genericRegister USE ENTITY work.genericRegister(Behavioral);

    SIGNAL data_in : std_logic_vector(N DOWNTO 0);
    SIGNAL data_out : std_logic_vector(N DOWNTO 0);
    SIGNAL clk, clk_en, rst : std_logic;

    SIGNAL temp : std_logic_vector(N DOWNTO 0);

    CONSTANT WAIT_TIME : TIME := 30 ns;
BEGIN

    Dut : genericRegister
    GENERIC MAP(N => N)
    PORT MAP(data_in, clk, clk_en, rst, data_out);

    p1 : PROCESS
    BEGIN
        -- Init Clock
        clk <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 1
        data_in <= "11111111";
        rst <= '0';
        clk_en <= '1';
        clk <= '1';
        WAIT FOR WAIT_TIME;
        ASSERT data_out = "11111111"
        REPORT "ERROR in test 1" SEVERITY error;
        clk <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 2
        temp <= data_out;
        data_in <= "10101010";
        rst <= '0';
        clk_en <= '0';
        clk <= '1';
        WAIT FOR WAIT_TIME;
        ASSERT data_out = temp
        REPORT "ERROR in test 1" SEVERITY error;
        clk <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 3
        data_in <= "11111111";
        rst <= '1';
        clk_en <= '0';
        clk <= '1';
        WAIT FOR WAIT_TIME;
        ASSERT data_out = "00000000"
        REPORT "ERROR in test 3" SEVERITY error;
        clk <= '0';
        WAIT FOR WAIT_TIME;

        -- Test 4
        -- Change Current Output
        data_in <= "11111111";
        rst <= '0';
        clk_en <= '1';
        clk <= '1';
        WAIT FOR WAIT_TIME;
        clk <= '0';
        WAIT FOR WAIT_TIME;
        -- Try Reset
        rst <= '1';
        clk_en <= '1';
        clk <= '1';
        WAIT FOR WAIT_TIME;
        ASSERT data_out = "00000000"
        REPORT "ERROR in test 4" SEVERITY error;
        clk <= '0';
        WAIT FOR WAIT_TIME;

        WAIT;
    END PROCESS;

END;