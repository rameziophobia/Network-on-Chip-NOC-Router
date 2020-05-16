LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY grayToBinary IS
    PORT ( 
	clk, rst, en: IN STD_LOGIC;
        g : inout STD_LOGIC_VECTOR (3 downto 0);
        b : out STD_LOGIC_VECTOR (3 downto 0));
END grayToBinary;

ARCHITECTURE Behavioral OF grayToBinary IS
COMPONENT grayCounter IS
        GENERIC (N : INTEGER := 3);
        PORT (
		clk, rst, en : IN STD_LOGIC;
                count_out : OUT STD_LOGIC_VECTOR (N DOWNTO 0));
END COMPONENT;

BEGIN  
    C2: grayCounter GENERIC MAP (3) PORT MAP (clk => clk, rst=> rst, en => en, count_out  => g);
    b(3)<= g(3);
    b(2)<= g(3) xor g(2);
    b(1)<= g(3) xor g(2) xor g(1);
    b(0)<= g(3) xor g(2) xor g(1) xor g(0);
END behavioral;