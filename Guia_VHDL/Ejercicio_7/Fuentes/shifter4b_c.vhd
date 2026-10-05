library IEEE;
use IEEE.std_logic_1164.all;

entity shifter4b_c is
	port(
		clk_i: in std_logic;
		d_i: in std_logic;
		rst_i: in std_logic;
		q_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture shifter4b_c_arq of shifter4b_c is

    signal aux : std_logic_vector(3 downto 0);
    

begin
            
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                aux <= "0000";
            else
            aux(3) <= d_i;
            aux(2) <= aux(3);
            aux(1) <= aux(2);
            aux(0) <= aux(1);
            end if;
        end if;
    end process;
    q_o <= aux(0);  
            
end;