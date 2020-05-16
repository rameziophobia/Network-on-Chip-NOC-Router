LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_grayCounter IS
	GENERIC (N : INTEGER := 3);
END tb_grayCounter;

ARCHITECTURE behavior OF tb_grayCounter IS
	COMPONENT  grayCounter IS
		GENERIC (N : INTEGER := 3);
		PORT (
        		clk, rst, en : IN STD_LOGIC;
        		count_out : OUT STD_LOGIC_VECTOR (N DOWNTO 0));
	END COMPONENT;

  	SIGNAL clk, rst, en: STD_LOGIC;
  	SIGNAL count_out: STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN
	CompToTest: grayCounter GENERIC MAP (3) PORT MAP (clk, rst, en, count_out);
   
	clk_proc: PROCESS	
	BEGIN
		clk <= '1';
		WAIT FOR 10 ns;
		clk <= '0';
    		WAIT FOR 10 ns;
  	END PROCESS clk_proc;
                      
  	Vector_proc: PROCESS
  	BEGIN
    		rst <= '1';
    		WAIT UNTIL clk='1' AND clk'EVENT;
    		WAIT FOR 5 NS;
    		rst <= '0';
    		en <= '1';
    		FOR index IN 0 To 3 LOOP
      			WAIT UNTIL clk='1' AND clk'EVENT;
    		END LOOP;
    		WAIT FOR 5 NS;
    		WAIT;
  	END PROCESS Vector_proc;
END behavior;