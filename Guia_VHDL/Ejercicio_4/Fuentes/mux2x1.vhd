library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de identidad
entity mux2x1 is
	port(
		sel_i: in std_logic;
		a_i: in std_logic;
		b_i: in std_logic;
		sal_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture mux2x1_arq of mux2x1 is
begin
    -- uso sentencia concurrente
	sal_o <= a_i when sel_i = '0' else b_i;
end;