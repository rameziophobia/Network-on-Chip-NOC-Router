LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY grayCounter IS
  GENERIC (N : INTEGER := 3);
  PORT (
    clk, rst, en : IN STD_LOGIC;
    count_out : OUT STD_LOGIC_VECTOR (N DOWNTO 0));
END grayCounter;

ARCHITECTURE GrayCounter_beh OF grayCounter IS
  SIGNAL Currstate, Nextstate, hold, next_hold : std_logic_vector (N DOWNTO 0);
BEGIN

  StateReg : PROCESS (clk)
  BEGIN
    IF (rising_edge(clk)) THEN
      IF (rst = '1') THEN
        Currstate <= (OTHERS => '0');
      ELSIF (en = '1') THEN
        Currstate <= Nextstate;
      END IF;
    END IF;
  END PROCESS;

  hold <= Currstate XOR ('0' & hold(N DOWNTO 1));
  next_hold <= std_logic_vector(unsigned(hold) + 1);
  Nextstate <= next_hold XOR ('0' & next_hold(N DOWNTO 1));
  count_out <= Currstate;

END GrayCounter_beh;