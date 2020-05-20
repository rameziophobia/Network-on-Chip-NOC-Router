LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FIFOcontrol IS
  PORT (
    reset : IN STD_LOGIC;
    rdclk : IN STD_LOGIC;
    wrclk : IN STD_LOGIC;
    r_req : IN STD_LOGIC;
    w_req : IN STD_LOGIC;
    write_valid : OUT STD_LOGIC;
    read_valid : OUT STD_LOGIC;
    wr_ptr : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
    rd_ptr : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
    empty : OUT STD_LOGIC;
    full : OUT STD_LOGIC
  );
END FIFOcontrol;
ARCHITECTURE FIFOcontrolarch OF FIFOcontrol IS

  SIGNAL rd_gray : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL wr_gray : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL rd_binout : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL wr_binout : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL read_valid_sig : STD_LOGIC;
  SIGNAL write_valid_sig : STD_LOGIC;
  COMPONENT grayToBinary
    PORT (
      gray_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      bin_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
  END COMPONENT;

  COMPONENT grayCounter
    PORT (
      clk, rst, en : IN STD_LOGIC;
      count_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
  END COMPONENT;
BEGIN
  gray_cnt_rd : grayCounter PORT MAP(
    clk => rdclk,
    rst => reset,
    en => read_valid_sig,
    count_out => rd_gray
  );
  gray_cnt_wr : grayCounter PORT MAP(
    clk => wrclk,
    rst => reset,
    en => write_valid_sig,
    count_out => wr_gray
  );
  gray_2bin_rd : grayToBinary PORT MAP(
    gray_in => rd_gray,
    bin_out => rd_binout
  );
  gray_2bin_wr : grayToBinary PORT MAP(
    gray_in => wr_gray,
    bin_out => wr_binout
  );

  proc : PROCESS (reset, rd_gray, wr_gray, r_req, w_req) IS
  BEGIN
    IF reset = '1' THEN
      empty <= '1';
      write_valid_sig <= '1';
    ELSIF (rd_gray = wr_gray) THEN
      empty <= '1';
      read_valid_sig <= '0';
    ELSE
      empty <= '0';
      IF  (r_req = '1') THEN
        read_valid_sig <= '1';
      ELSE
        read_valid_sig <= '0';
      END IF;
    END IF;

    IF reset = '1' THEN
      full <= '0';
      read_valid_sig <= '0';
    ELSIF ((NOT (wr_gray(3 DOWNTO 2)) = rd_gray(3 DOWNTO 2)) AND (wr_gray(1 DOWNTO 0) = rd_gray(1 DOWNTO 0))) THEN
      full <= '1';
      write_valid_sig <= '0';
    ELSE
      full <= '0';
      IF (w_req = '1') THEN
        write_valid_sig <= '1';
      ELSE
        write_valid_sig <= '0';
      END IF;
    END IF;
  END PROCESS proc;

  write_valid <= write_valid_sig;
  read_valid <= read_valid_sig;
  wr_ptr <= wr_binout(2 DOWNTO 0);
  rd_ptr <= rd_binout(2 DOWNTO 0);

END FIFOcontrolarch;