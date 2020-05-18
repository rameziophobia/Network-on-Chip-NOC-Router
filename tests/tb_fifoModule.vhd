LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_fifoModule IS
END tb_fifoModule;

ARCHITECTURE behavior OF tb_fifoModule IS
    SIGNAL reset : STD_LOGIC;
    SIGNAL wclk : STD_LOGIC;
    SIGNAL rclk : STD_LOGIC;
    SIGNAL rreq : STD_LOGIC;
    SIGNAL wreq : STD_LOGIC;
    SIGNAL datain : std_logic_vector(7 DOWNTO 0);
    SIGNAL dataout : std_logic_vector(7 DOWNTO 0);
    SIGNAL empty : STD_LOGIC;
    SIGNAL full : STD_LOGIC;

    CONSTANT clk_period : TIME := 100 ns;

BEGIN

    dut : ENTITY work.module_fifo PORT MAP(
        reset => reset,
        wclk => wclk,
        rclk => rclk,
        rreq => rreq,
        wreq => wreq,
        datain => datain,
        dataout => dataout,
        empty => empty,
        full => full
        );

    rclk_process : PROCESS
    BEGIN
        rclk <= '0';
        WAIT FOR clk_period/2;
        rclk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    wrclk_process : PROCESS
    BEGIN
        wclk <= '0';
        WAIT FOR clk_period/2;
        wclk <= '1';
        WAIT FOR clk_period/2;

    END PROCESS;

    stim_proc : PROCESS
    BEGIN

    reset <= '1';
    rreq <= '1';
    WAIT FOR clk_period;
    ASSERT full = '0' AND empty = '1'
    REPORT "testing RESET ON failed" SEVERITY ERROR;
    reset <= '0';
    wreq <= '1';
    datain <= "10110101";
    WAIT FOR clk_period;
    ASSERT  empty = '0'
    REPORT "Memory is not empty" SEVERITY ERROR;

    wreq <= '0';
    rreq <= '1';
    WAIT FOR clk_period;
    ASSERT dataout = "10110101"
    REPORT "Reading data unsccessful" SEVERITY ERROR;

    -- w_req <= '0';
    -- r_req <= '1';
    -- WAIT FOR clk_period;
    -- ASSERT read_valid = '0' AND empty = '1'
    -- REPORT "attempting to read when FIFO is empty failed" SEVERITY ERROR;

    END PROCESS;

END;