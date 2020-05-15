library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DeMux is
    Port ( d_in : in  STD_LOGIC_VECTOR (7 downto 0);
           d_out1 : out  STD_LOGIC_VECTOR (7 downto 0);
           d_out2 : out  STD_LOGIC_VECTOR (7 downto 0);
           d_out3 : out  STD_LOGIC_VECTOR (7 downto 0);
           d_out4 : out  STD_LOGIC_VECTOR (7 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           En : in  STD_LOGIC);
end DeMux;

architecture Behavioral of DeMux is
		signal tmpOut1: STD_LOGIC_VECTOR (7 downto 0);
		signal tmpOut2: STD_LOGIC_VECTOR (7 downto 0);
		signal tmpOut3: STD_LOGIC_VECTOR (7 downto 0);
		signal tmpOut4: STD_LOGIC_VECTOR (7 downto 0);
begin
	P2: process(d_in, Sel, En,tmpOut1,tmpOut2,tmpOut3,tmpOut4)
	begin
		if En = '1' then
			case Sel is
				when "11" =>
					tmpOut4 <= d_in;
				when "01" =>
					tmpOut2 <= d_in;
				when "10" =>
					tmpOut3 <= d_in;
				when others =>
					tmpOut1 <= d_in;
			end case;	
		end if;
			d_out1 <= tmpOut1;
			d_out2 <= tmpOut2;
			d_out3 <= tmpOut3;
			d_out4 <= tmpOut4; 
	end process;

end Behavioral;

