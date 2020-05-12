LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RR_schedular_tb IS
END RR_schedular_tb;
 
ARCHITECTURE behavioral OF RR_schedular_tb IS 
 
    COMPONENT RR_Schedular
    PORT(
         clock : IN  std_logic;
         din1 : IN  std_logic_vector(7 downto 0);
         din2 : IN  std_logic_vector(7 downto 0);
         din3 : IN  std_logic_vector(7 downto 0);
         din4 : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal clock : std_logic := '0';
   signal din1 : std_logic_vector(7 downto 0) := (others => '0');
   signal din2 : std_logic_vector(7 downto 0) := (others => '0');
   signal din3 : std_logic_vector(7 downto 0) := (others => '0');
   signal din4 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
   uut: RR_Schedular PORT MAP (
          clock => clock,
          din1 => din1,
          din2 => din2,
          din3 => din3,
          din4 => din4,
          dout => dout
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 
   p1: process
   begin

		--Hold zero input for 40 ns
		wait for clock_period*4;
		
		--Test 1
		report "start of Test 1";
		din1 <= "00000001";
		din2 <= "00000011";
		din3 <= "00000111";
		din4 <= "00001111";
      wait for clock_period*8;
		
		--Test 2
		report "start of Test 2";
		din1 <= "00000000";
		din2 <= "00000000";
		din3 <= "11111111";
		din4 <= "11111111";
      wait for clock_period*8;
		
		--Test 3
		report "start of Test 3";
		din1 <= "00000000";
		din2 <= "00000000";
		din3 <= "00000000";
		din4 <= "00000000";
      wait for clock_period*8;
		
      wait;
   end process;

END;
