LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_Demux IS
END tb_Demux;

ARCHITECTURE behavior OF tb_Demux IS

	COMPONENT DeMux
		PORT (
			d_in : IN std_logic_vector(7 DOWNTO 0);
			d_out1 : OUT std_logic_vector(7 DOWNTO 0);
			d_out2 : OUT std_logic_vector(7 DOWNTO 0);
			d_out3 : OUT std_logic_vector(7 DOWNTO 0);
			d_out4 : OUT std_logic_vector(7 DOWNTO 0);
			Sel : IN std_logic_vector(1 DOWNTO 0);
			En : IN std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL d_in : std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Sel : std_logic_vector(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL En : std_logic := '0';

	--Outputs
	SIGNAL d_out1 : std_logic_vector(7 DOWNTO 0);
	SIGNAL d_out2 : std_logic_vector(7 DOWNTO 0);
	SIGNAL d_out3 : std_logic_vector(7 DOWNTO 0);
	SIGNAL d_out4 : std_logic_vector(7 DOWNTO 0);

BEGIN

	uut : DeMux PORT MAP(
		d_in => d_in,
		d_out1 => d_out1,
		d_out2 => d_out2,
		d_out3 => d_out3,
		d_out4 => d_out4,
		Sel => Sel,
		En => En
	);

	stim_proc : PROCESS
	BEGIN

		En <= '0';
		WAIT FOR 100 ns;

		--Test 1
		REPORT "Start of Test 1";
		d_in <= "10101010";
		Sel <= "00";
		WAIT FOR 100 ns;
		En <= '1';
		WAIT FOR 100 ns;
		ASSERT d_out1 = "10101010"
		REPORT "d_out1 assertion, expected: (10101010) and found, FAILED"
			SEVERITY Error;
		Sel <= "10";
		WAIT FOR 100 ns;
		ASSERT d_out3 = "10101010"
		REPORT "d_out3 assertion, expected: (10101010) and found, FAILED"
			SEVERITY Error;
		Sel <= "11";
		WAIT FOR 100 ns;
		ASSERT d_out4 = "10101010"
		REPORT "d_out4 assertion, expected: (10101010) and found, FAILED"
			SEVERITY Error;
		Sel <= "01";
		WAIT FOR 100 ns;
		ASSERT d_out2 = "10101010"
		REPORT "d_out2 assertion, expected: (10101010) and found, FAILED"
			SEVERITY Error;
		REPORT "End of Test 1";

		--Test 2
		REPORT "Start of Test 2";
		Sel <= "01";
		WAIT FOR 100 ns;
		ASSERT d_out3 = "10101010"
		REPORT "Wrong output from output port d_out3, expected: (10101010)"
			SEVERITY Error;
		REPORT "End of Test 2";

		--Test 3
		En <= '1';
		REPORT "Start of Test 3";
		d_in <= "00111100";
		Sel <= "01";
		WAIT FOR 100 ns;
		ASSERT d_out2 = "00111100"
		REPORT "Wrong output from output port d_out2, expected: (00111100)"
			SEVERITY Error;
		ASSERT d_out3 = "10101010"
		REPORT "Wrong output from output port d_out3, expected: (10101010)"
			SEVERITY Error;
		REPORT "End of Test 3";
		WAIT;
	END PROCESS;

END;