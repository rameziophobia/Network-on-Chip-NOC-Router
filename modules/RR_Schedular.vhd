LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY RR_Schedular IS
	PORT (
		clock : IN STD_LOGIC;
		din1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		din2 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		din3 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		din4 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		dout : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END RR_Schedular;

ARCHITECTURE behavioral OF RR_Schedular IS
	TYPE state IS (start, Port1, Port2, Port3, Port4);
	SIGNAL current_state : state;
	SIGNAL next_state : state;
BEGIN
	cs : PROCESS (clock)
	BEGIN
		IF rising_edge(clock) THEN
			current_state <= next_state;
		END IF;
	END PROCESS;
	rs : PROCESS (current_state)
	BEGIN
		CASE current_state IS
			WHEN Port1 =>
				next_state <= Port2;
				dout <= din1;
			WHEN Port2 =>
				next_state <= Port3;
				dout <= din2;
			WHEN Port3 =>
				next_state <= Port4;
				dout <= din3;
			WHEN Port4 =>
				next_state <= Port1;
				dout <= din4;
			WHEN OTHERS =>
				next_state <= Port1;
		END CASE;
	END PROCESS;

END behavioral;