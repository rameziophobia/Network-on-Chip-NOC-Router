LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_grayToBinary IS
END tb_grayToBinary;
 
ARCHITECTURE behavior OF tb_grayToBinary IS 
 
    COMPONENT grayToBinary
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         g : INOUT  std_logic_vector(3 downto 0);
         b : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';

   signal g : std_logic_vector(3 downto 0);

   signal b : std_logic_vector(3 downto 0);

   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: grayToBinary PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          g => g,
          b => b
        );

   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
 

   stim_proc: process
   begin        
      rst <= '1';
            WAIT UNTIL clk='1' AND clk'EVENT;
            rst <= '0';
            en <= '1';
            FOR index IN 0 To 4 LOOP
                  WAIT UNTIL clk='1' AND clk'EVENT;
            END LOOP;
            wait;

   end process;

END;
