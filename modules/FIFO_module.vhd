LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY module_fifo IS
  PORT (
    reset : IN std_logic;
    wclk : IN std_logic;
    rclk : IN std_logic;
    rreq : IN std_logic;
    wreq : IN std_logic;
    datain : IN std_logic_vector(7 DOWNTO 0);
    dataout : OUT std_logic_vector(7 DOWNTO 0);
    empty : OUT std_logic;
    full : OUT std_logic
  );
END module_fifo;

ARCHITECTURE module_FIFO_Arch OF module_fifo IS
  SIGNAL read_valid_sig : std_logic;
  SIGNAL write_valid_sig : std_logic;
  signal write_ptr : std_logic_vector (2 downto 0);
  signal read_ptr : std_logic_vector (2 downto 0);

BEGIN

fuckface : entity work.FIFOcontrol PORT MAP(
    reset => reset,
    wrclk => wclk,
    rdclk => rclk,
    r_req => rreq,
    w_req => wreq,
    write_valid => write_valid_sig,
    read_valid => read_valid_sig,
    wr_ptr => write_ptr,
    rd_ptr => read_ptr,
    empty => empty,
    full => full
  );
mem : entity work.dualPortRam PORT MAP(
  d_in => datain,
  addr_a => write_ptr,
  addr_b => read_ptr,
  clk_A => wclk,
  clk_B => rclk,
  wea => write_valid_sig,
  rea => read_valid_sig,
  d_out => dataout
);
END module_FIFO_Arch;