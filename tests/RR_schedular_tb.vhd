LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RR_schedular_tb IS
END RR_schedular_tb;

ARCHITECTURE behavioral OF RR_schedular_tb IS

	COMPONENT RR_Schedular
		PORT (
			clock : IN std_logic;
			din1 : IN std_logic_vector(7 DOWNTO 0);
			din2 : IN std_logic_vector(7 DOWNTO 0);
			din3 : IN std_logic_vector(7 DOWNTO 0);
			din4 : IN std_logic_vector(7 DOWNTO 0);
			dout : OUT std_logic_vector(7 DOWNTO 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clock : std_logic := '0';
	SIGNAL din1 : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL din2 : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL din3 : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL din4 : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');

	--Outputs
	SIGNAL dout : std_logic_vector(7 DOWNTO 0);

	-- Clock period definitions
	CONSTANT clock_period : TIME := 10 ns;

BEGIN

	uut : RR_Schedular PORT MAP(
		clock => clock,
		din1 => din1,
		din2 => din2,
		din3 => din3,
		din4 => din4,
		dout => dout
	);

	-- Clock process definitions
	clock_process : PROCESS
	BEGIN
		clock <= '0';
		WAIT FOR clock_period/2;
		clock <= '1';
		WAIT FOR clock_period/2;
	END PROCESS;

	p1 : PROCESS
	BEGIN

		--Hold zero input for 40 ns
		REPORT "start of Zero input duration";
		WAIT FOR clock_period * 4;
		REPORT "end of Zero input duration";
		--Test 1
		REPORT "start of Test 1";
		din1 <= "00000001";
		WAIT FOR clock_period;
		ASSERT dout = "00000001"
		REPORT "Wrong output in state port1"
			SEVERITY Error;
		din2 <= "00000011";
		WAIT FOR clock_period;
		ASSERT dout = "00000011"
		REPORT "Wrong output in state port2"
			SEVERITY Error;
		din3 <= "00000111";
		WAIT FOR clock_period;
		ASSERT dout = "00000111"
		REPORT "Wrong output in state port3"
			SEVERITY Error;
		din4 <= "00001111";
		WAIT FOR clock_period;
		ASSERT dout = "00001111"
		REPORT "Wrong output in state port4"
			SEVERITY Error;

		WAIT FOR clock_period * 4;
		REPORT "end of Test 1";

		--Test 2
		REPORT "start of Test 2";
		din4 <= "00000000";
		WAIT FOR clock_period;
		ASSERT dout = "00000001"
		REPORT "Wrong output in state port4"
			SEVERITY Error;
		din3 <= "11111111";
		WAIT FOR clock_period;
		ASSERT dout = "00000011"
		REPORT "Wrong output in state port3"
			SEVERITY Error;
		din2 <= "00000000";
		WAIT FOR clock_period;
		ASSERT dout = "11111111"
		REPORT "Wrong output in state port2"
			SEVERITY Error;
		din1 <= "11111111";
		WAIT FOR clock_period;
		ASSERT dout = "00000000"
		REPORT "Wrong output in state port1"
			SEVERITY Error;

		WAIT FOR clock_period * 4;
		ASSERT dout = "00000000"
		REPORT "Wrong output in state port4"
			SEVERITY Error;

		REPORT "end of Test 2";
		--Test 3
		REPORT "start of Test 3";
		din1 <= "11111111";
		WAIT FOR clock_period;
		ASSERT dout = "11111111"
		REPORT "Wrong output in state port1"
			SEVERITY Error;
		din2 <= "11111111";
		WAIT FOR clock_period;
		ASSERT dout = "11111111"
		REPORT "Wrong output in state port2"
			SEVERITY Error;
		din3 <= "11111111";
		WAIT FOR clock_period;
		ASSERT dout = "11111111"
		REPORT "Wrong output in state port3"
			SEVERITY Error;
		din4 <= "11111111";
		WAIT FOR clock_period;
		ASSERT dout = "11111111"
		REPORT "Wrong output in state port4"
			SEVERITY Error;

		WAIT FOR clock_period * 4;
		ASSERT dout = "11111111"
		REPORT "Wrong output in state port4"
			SEVERITY Error;
		REPORT "end of Test 3";

		WAIT;
	END PROCESS;

END;