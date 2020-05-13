LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY tb_Demux IS
END tb_Demux;
 
ARCHITECTURE behavior OF tb_Demux IS 
 
    COMPONENT DeMux
    PORT(
         d_in : IN  std_logic_vector(7 downto 0);
         d_out1 : OUT  std_logic_vector(7 downto 0);
         d_out2 : OUT  std_logic_vector(7 downto 0);
         d_out3 : OUT  std_logic_vector(7 downto 0);
         d_out4 : OUT  std_logic_vector(7 downto 0);
         Sel : IN  std_logic_vector(1 downto 0);
         En : IN  std_logic
        );
    END COMPONENT;
    
   --Inputs
   signal d_in : std_logic_vector(7 downto 0) := (others => '0');
   signal Sel : std_logic_vector(1 downto 0) := (others => '0');
   signal En : std_logic := '0';

 	--Outputs
   signal d_out1 : std_logic_vector(7 downto 0);
   signal d_out2 : std_logic_vector(7 downto 0);
   signal d_out3 : std_logic_vector(7 downto 0);
   signal d_out4 : std_logic_vector(7 downto 0);
 
BEGIN

   uut: DeMux PORT MAP (
          d_in => d_in,
          d_out1 => d_out1,
          d_out2 => d_out2,
          d_out3 => d_out3,
          d_out4 => d_out4,
          Sel => Sel,
          En => En
        );

   stim_proc: process
   begin
	
		En <= '0';
      wait for 100 ns;	

		--Test 1
		Report "Start of Test 1";
		d_in <= "10101010";
		Sel <= "00";
      wait for 100 ns;
		En <= '1';
		wait for 100 ns;
		Assert d_out1 = "10101010"
			Report "d_out1 assertion, expected: (10101010) and found, FAILED"
			Severity Error;
		Sel <= "10";
		wait for 100 ns;
		Assert d_out3 = "10101010"
			Report "d_out3 assertion, expected: (10101010) and found, FAILED"
			Severity Error;
		Sel <= "11";
		wait for 100 ns;
		Assert d_out4 = "10101010"
			Report "d_out4 assertion, expected: (10101010) and found, FAILED"
			Severity Error;
		Sel <= "01";
      wait for 100 ns;
		Assert d_out2 = "10101010"
			Report "d_out2 assertion, expected: (10101010) and found, FAILED"
			Severity Error;
		Report "End of Test 1";

		--Test 2
		Report "Start of Test 2";
		Sel <= "01";
      wait for 100 ns;
		Assert d_out3 = "10101010"
			Report "Wrong output from output port d_out3, expected: (10101010)"
			Severity Error;
		Report "End of Test 2";

		--Test 3
		En <= '1';
		Report "Start of Test 3";
		d_in <= "00111100";
		Sel <= "01";
      wait for 100 ns;
		Assert d_out2 = "00111100"
			Report "Wrong output from output port d_out2, expected: (00111100)"
			Severity Error;
		Assert d_out3 = "10101010"
			Report "Wrong output from output port d_out3, expected: (10101010)"
			Severity Error;
		Report "End of Test 3";
      wait;
   end process;

END;
