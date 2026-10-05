library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de identidad
entity sumres4b is
	port(
		sr_i: in std_logic; -- senal de control. 0: suma, 1: resta
		a_i: in std_logic_vector(3 downto 0);
		b_i: in std_logic_vector(3 downto 0);
		s_o: out std_logic_vector(3 downto 0);
		co_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture sumres4b_arq of sumres4b is

	component sum4b is
		port(
			ci_i: in std_logic;
			a_i: in std_logic_vector(3 downto 0);
			b_i: in std_logic_vector(3 downto 0);
			s_o: out std_logic_vector(3 downto 0);
			co_o: out std_logic
		);
	end component;

	-- b condicionado: pasa igual si sr_i = 0 (suma), invertido si sr_i = 1 (resta)
	signal b_aux: std_logic_vector(3 downto 0);

begin

	b_aux(0) <= b_i(0) when sr_i = '0' else not (b_i(0));
	b_aux(1) <= b_i(1) when sr_i = '0' else not (b_i(1));
	b_aux(2) <= b_i(2) when sr_i = '0' else not (b_i(2));
	b_aux(3) <= b_i(3) when sr_i = '0' else not (b_i(3));

	-- en la resta: a - b = a + (not b) + 1 (complemento a 2), por eso el acarreo de entrada es sr_i
	sum4b_0: sum4b
		port map(
			ci_i => sr_i,
			a_i => a_i,
			b_i => b_aux,
			s_o => s_o,
			co_o => co_o
		);

end;
