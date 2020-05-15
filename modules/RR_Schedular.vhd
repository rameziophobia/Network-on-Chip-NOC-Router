library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RR_Schedular is
    Port ( clock : in  STD_LOGIC;
           din1 : in  STD_LOGIC_VECTOR (7 downto 0);
           din2 : in  STD_LOGIC_VECTOR (7 downto 0);
           din3 : in  STD_LOGIC_VECTOR (7 downto 0);
           din4 : in  STD_LOGIC_VECTOR (7 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end RR_Schedular;

architecture behavioral of RR_Schedular is
	Type state is (start, Port1, Port2, Port3, Port4);
	signal current_state: state;
	signal next_state: state;
begin
	cs: process(clock)
	begin
		if rising_edge(clock) then
			current_state <= next_state;
		end if;
	end process;
	rs: process(current_state)
	begin
		case current_state is
			when Port1 =>
				next_state <= Port2;
				dout <= din1;
			when Port2 =>
				next_state <= Port3;
				dout <= din2;
			when Port3 =>
				next_state <= Port4;
				dout <= din3;
			when Port4 =>
				next_state <= Port1;
				dout <= din4;
			when others =>
				next_state <= Port1;
		end case;
	end process;

end behavioral;

