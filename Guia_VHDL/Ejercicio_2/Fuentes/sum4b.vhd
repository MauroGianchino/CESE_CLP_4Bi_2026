library IEEE;
use IEEE.std_logic_1164.all;

-- Declaracion de identidad
entity sum4b is
	port(
		ci_i: in std_logic;
		a_i: in std_logic_vector(3 downto 0); --son arrays de 4 bits
		b_i: in std_logic_vector(3 downto 0);
		s_o: out std_logic_vector(3 downto 0);
		co_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture sum4b_arq of sum4b is

	component sum1b is
		port(
			ci_i: in std_logic;
			a_i: in std_logic;
			b_i: in std_logic;
			s_o: out std_logic;
			co_o: out std_logic
		);
	end component;

	-- senal auxiliar que representan los 5 carrys, el de entrada, los 3 intermedios y el de salida 
	signal aux_c: std_logic_vector(4 downto 0);

begin

	aux_c(0) <= ci_i;
	co_o <= aux_c(4);
	sum1b_0: sum1b
		port map(
			ci_i => aux_c(0),
			a_i => a_i(0),
			b_i => b_i(0),
			s_o => s_o(0),
			co_o => aux_c(1) --el carry de salida es el segundo del vector, que ira al siguiente sumador
		);

	sum1b_1: sum1b
		port map(
			ci_i => aux_c(1),
			a_i => a_i(1),
			b_i => b_i(1),
			s_o => s_o(1),
			co_o => aux_c(2) 
		);

	sum1b_2: sum1b
		port map(
			ci_i => aux_c(2),
			a_i => a_i(2),
			b_i => b_i(2),
			s_o => s_o(2),
			co_o => aux_c(3) 
		);

	sum1b_3: sum1b
		port map(
			ci_i => aux_c(3),
			a_i => a_i(3),
			b_i => b_i(3),
			s_o => s_o(3),
			co_o => aux_c(4) 
		);

end;
