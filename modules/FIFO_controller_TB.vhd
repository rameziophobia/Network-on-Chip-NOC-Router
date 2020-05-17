LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_FIFOcontrol IS
END tb_FIFOcontrol;

ARCHITECTURE behavior OF tb_FIFOcontrol IS
    SIGNAL reset : STD_LOGIC;
    SIGNAL rdclk : STD_LOGIC;
    SIGNAL wrclk : STD_LOGIC;
    SIGNAL r_req : STD_LOGIC;
    SIGNAL w_req : STD_LOGIC;
    SIGNAL write_valid : STD_LOGIC;
    SIGNAL read_valid : STD_LOGIC;
    SIGNAL wr_ptr : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL rd_ptr : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL empty : STD_LOGIC;
    SIGNAL full : STD_LOGIC;
    SIGNAL clk : std_logic;
    CONSTANT clk_period : TIME := 100 ns;

BEGIN

    dut : ENTITY work.FIFOcontrol PORT MAP(
        reset => reset,
        rdclk => rdclk,
        wrclk => wrclk,
        r_req => r_req,
        w_req => w_req,
        write_valid => write_valid,
        read_valid => read_valid,
        wr_ptr => wr_ptr,
        rd_ptr => rd_ptr,
        empty => empty,
        full => full
        );

    rclk_process : PROCESS
    BEGIN
        rdclk <= '0';
        WAIT FOR clk_period/2;
        rdclk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    wrclk_process : PROCESS
    BEGIN
        wrclk <= '0';
        WAIT FOR clk_period/2;
        wrclk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    stim_proc : PROCESS
    BEGIN
        reset <= '1';
        r_req <= '1';
        wait for clk_period;
        Assert read_valid = '0';
        reset <= '0';
        w_req <= '1';
        wait for clk_period;
        Assert wr_ptr = "001";
        
    END PROCESS;

END;