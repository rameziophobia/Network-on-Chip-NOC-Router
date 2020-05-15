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
		report "start of Zero input duration";
		wait for clock_period*4;
		report "end of Zero input duration";
		--Test 1
		report "start of Test 1";
		din1 <= "00000001";
		wait for clock_period;
		Assert dout = "00000001"
			Report "Wrong output in state port1"
			Severity Error;
		din2 <= "00000011";
		wait for clock_period;
		Assert dout = "00000011"
			Report "Wrong output in state port2"
			Severity Error;
		din3 <= "00000111";
		wait for clock_period;
		Assert dout = "00000111"
			Report "Wrong output in state port3"
			Severity Error;
		din4 <= "00001111";
      wait for clock_period;
		Assert dout = "00001111"
			Report "Wrong output in state port4"
			Severity Error;
			
      wait for clock_period*4;
		report "end of Test 1";
		
		--Test 2
		report "start of Test 2";
		din4 <= "00000000";
      wait for clock_period;
		Assert dout = "00000001"
			Report "Wrong output in state port4"
			Severity Error;
		din3 <= "11111111";
      wait for clock_period;
		Assert dout = "00000011"
			Report "Wrong output in state port3"
			Severity Error;
		din2 <= "00000000";
      wait for clock_period;
		Assert dout = "11111111"
			Report "Wrong output in state port2"
			Severity Error;
		din1 <= "11111111";
      wait for clock_period;
		Assert dout = "00000000"
			Report "Wrong output in state port1"
			Severity Error;
		
      wait for clock_period*4;
		Assert dout = "00000000"
			Report "Wrong output in state port4"
			Severity Error;
		
		report "end of Test 2";
		--Test 3
		report "start of Test 3";
		din1 <= "11111111";
      wait for clock_period;
		Assert dout = "11111111"
			Report "Wrong output in state port1"
			Severity Error;
		din2 <= "11111111";
      wait for clock_period;
		Assert dout = "11111111"
			Report "Wrong output in state port2"
			Severity Error;
		din3 <= "11111111";
      wait for clock_period;
		Assert dout = "11111111"
			Report "Wrong output in state port3"
			Severity Error;
		din4 <= "11111111";
      wait for clock_period;
		Assert dout = "11111111"
			Report "Wrong output in state port4"
			Severity Error;
		
      wait for clock_period*4;
		Assert dout = "11111111"
			Report "Wrong output in state port4"
			Severity Error;
		
		
		report "end of Test 3";
		
      wait;
   end process;

END;
