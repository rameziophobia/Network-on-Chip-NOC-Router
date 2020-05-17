LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_grayToBinary IS
END tb_grayToBinary;

ARCHITECTURE behavior OF tb_grayToBinary IS

   COMPONENT grayToBinary
      PORT (
         gray_in : IN std_logic_vector(3 DOWNTO 0);
         bin_out : OUT std_logic_vector(3 DOWNTO 0)
      );
   END COMPONENT;
   SIGNAL gray_in : std_logic_vector(3 DOWNTO 0);

   SIGNAL bin_out : std_logic_vector(3 DOWNTO 0);
   SIGNAL clk : std_logic;

   CONSTANT clk_period : TIME := 10 ns;

BEGIN

   uut : grayToBinary PORT MAP(
      gray_in => gray_in,
      bin_out => bin_out
   );

   clk_process : PROCESS
   BEGIN
      clk <= '0';
      WAIT FOR clk_period/2;
      clk <= '1';
      WAIT FOR clk_period/2;
   END PROCESS;

   stim_proc : PROCESS
   BEGIN
      gray_in <= "0001";
      WAIT UNTIL clk = '1' AND clk'EVENT;
      ASSERT bin_out <= "0001";
      gray_in <= "0011";
      WAIT UNTIL clk = '1' AND clk'EVENT;
      ASSERT bin_out <= "0010";
      gray_in <= "0111";
      WAIT UNTIL clk = '1' AND clk'EVENT;
      ASSERT bin_out <= "0100";
      gray_in <= "1110";
      WAIT UNTIL clk = '1' AND clk'EVENT;
      ASSERT bin_out <= "1001";
      WAIT;

   END PROCESS;

END;