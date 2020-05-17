LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DeMux IS
	PORT (
		d_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		d_out1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		d_out2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		d_out3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		d_out4 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		En : IN STD_LOGIC);
END DeMux;

ARCHITECTURE Behavioral OF DeMux IS
	SIGNAL tmpOut1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL tmpOut2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL tmpOut3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL tmpOut4 : STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
	P2 : PROCESS (d_in, Sel, En, tmpOut1, tmpOut2, tmpOut3, tmpOut4)
	BEGIN
		IF En = '1' THEN
			CASE Sel IS
				WHEN "11" =>
					tmpOut4 <= d_in;
				WHEN "01" =>
					tmpOut2 <= d_in;
				WHEN "10" =>
					tmpOut3 <= d_in;
				WHEN OTHERS =>
					tmpOut1 <= d_in;
			END CASE;
		END IF;
		d_out1 <= tmpOut1;
		d_out2 <= tmpOut2;
		d_out3 <= tmpOut3;
		d_out4 <= tmpOut4;
	END PROCESS;

END Behavioral;