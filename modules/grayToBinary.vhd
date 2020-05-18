LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY grayToBinary IS
    PORT (
        gray_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        bin_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END grayToBinary;

ARCHITECTURE Behavioral OF grayToBinary IS

BEGIN
    bin_out(3) <= gray_in(3);
    bin_out(2) <= gray_in(3) XOR gray_in(2);
    bin_out(1) <= gray_in(3) XOR gray_in(2) XOR gray_in(1);
    bin_out(0) <= gray_in(3) XOR gray_in(2) XOR gray_in(1) XOR gray_in(0);
END behavioral;