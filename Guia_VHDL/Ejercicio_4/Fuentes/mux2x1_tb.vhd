library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1_tb is
end;

architecture mux2x1_tb_arq of mux2x1_tb is

		-- Declaracion de senales de prueba
	signal sel_tb: std_logic := '0';
	signal a_tb: std_logic := '0';
	signal b_tb: std_logic := '0';
	signal sal_tb: std_logic;

	component mux2x1 is
		port(
			sel_i: in std_logic;
			a_i: in std_logic;
			b_i: in std_logic;
			sal_o: out std_logic
		);
	end component;


begin

	-- cambio el sel luego de 400 ns en una simulacion de 800ns. paso por todos los valores posibles de a y b (00, 01, 10, 11) y luego cambio el sel para repetir la secuencia
	sel_tb <= '1' after 400 ns;
	a_tb <= '1' after 200 ns, '0' after 400 ns, '1' after 600 ns ;
	b_tb <= '1' after 100 ns, '0' after 200 ns,'1' after 300 ns, '0' after 400 ns, '1' after 500 ns,'0' after 600 ns, '1' after 700 ns;

	DUT: mux2x1
		port map(
			sel_i => sel_tb,
			a_i => a_tb,
			b_i => b_tb,
			sal_o => sal_tb
		);

end;
