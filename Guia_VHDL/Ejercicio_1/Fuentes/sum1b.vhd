library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de identidad
entity sum1b is
	port(
		ci_i: in std_logic;
		a_i: in std_logic;
		b_i: in std_logic;
		s_o: out std_logic;
		co_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture sum1b_arq of sum1b is
begin
	s_o <= a_i xor b_i xor ci_i;
	co_o <= (a_i and b_i) or (a_i and ci_i) or (b_i and ci_i);
end;
