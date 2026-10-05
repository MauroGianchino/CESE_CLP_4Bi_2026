library IEEE;
use IEEE.std_logic_1164.all;

entity shifter4b is
	port(
		clk_i: in std_logic;
		d_i: in std_logic;
		rst_i: in std_logic;
		q_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture shifter4b_arq of shifter4b is

	-- parte declarativa
	component ffd is
		port(
			clk_i: in std_logic;
			d_i: in std_logic;
			rst_i: in std_logic;
			ena_i: in std_logic;
			q_o: out std_logic
		);
	end component;

	-- array auxiliar para ver los 5 datos en los desplazamientos
	signal d_aux : std_logic_vector(0 to 4);

begin

	d_aux(0) <= d_i; --el primer valor del arreglo recibe el primer dato de entrada
	q_o <= d_aux(4); --conecto la salida al altumo valor del arreglo

	shifter_gen: for i in 0 to 3 generate --loop
		ffd_inst_i: ffd 
		port map(
			clk_i => clk_i,
			d_i => d_aux(i),
			rst_i => rst_i,
			ena_i => '1', -- siempre lo tengo habilitado
			q_o => d_aux(i+1)

		);
	end generate;

end;