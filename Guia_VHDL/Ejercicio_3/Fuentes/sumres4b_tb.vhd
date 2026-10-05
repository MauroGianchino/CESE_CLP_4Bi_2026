library IEEE;
use IEEE.std_logic_1164.all;

entity sumres4b_tb is
end;

architecture sumres4b_tb_arq of sumres4b_tb is

		-- Declaracion de senales de prueba
	signal sr_tb: std_logic := '0';
	signal a_tb: std_logic_vector(3 downto 0) := "0000";
	signal b_tb: std_logic_vector(3 downto 0) := "0000";
	signal s_tb: std_logic_vector(3 downto 0);
	signal co_tb: std_logic;

	component sumres4b is
		port(
			sr_i: in std_logic;
			a_i: in std_logic_vector(3 downto 0);
			b_i: in std_logic_vector(3 downto 0);
			s_o: out std_logic_vector(3 downto 0);
			co_o: out std_logic
		);
	end component;


begin

	-- hago 4 operaciones, en los primeros 400ns hago en suma y los restantes 400ns en resta.
	-- 3+1 / 3-1
	-- 5+2 / 5-2
	-- 7+1 / 7-1
	-- 15+1 / 15-1
	a_tb <= "0011" after 100 ns, "0101" after 200 ns, "0111" after 300 ns, "1111" after 400 ns, "0011" after 500 ns, "0101" after 600 ns, "0111" after 700 ns, "1111" after 800 ns;
	b_tb <= "0001" after 100 ns, "0010" after 200 ns, "0001" after 300 ns, "0001" after 400 ns, "0001" after 500 ns, "0010" after 600 ns, "0001" after 700 ns, "0001" after 800 ns;
	sr_tb <= '1' after 500 ns;
	DUT: sumres4b
		port map(
			sr_i => sr_tb,
			a_i => a_tb,
			b_i => b_tb,
			s_o => s_tb,
			co_o => co_tb
		);

end;
