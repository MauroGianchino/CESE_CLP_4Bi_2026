library IEEE;
use IEEE.std_logic_1164.all;

entity sum4b_tb is
end;

architecture sum4b_tb_arq of sum4b_tb is

		-- Declaracion de senales de prueba. Empieza todo en cero.
	signal ci_tb: std_logic := '0';
	signal a_tb: std_logic_vector(3 downto 0) := "0000";
	signal b_tb: std_logic_vector(3 downto 0) := "0000";
	signal s_tb: std_logic_vector(3 downto 0);
	signal co_tb: std_logic;

	component sum4b is
		port(
			ci_i: in std_logic;
			a_i: in std_logic_vector(3 downto 0);
			b_i: in std_logic_vector(3 downto 0);
			s_o: out std_logic_vector(3 downto 0);
			co_o: out std_logic
		);
	end component;


begin

	-- Casos de prueba, uno cada 100 ns (ci + a + b = co s):
	--   0 ns: 0 + 0000 + 0000 = 0 0000  (todo en cero)
	-- 100 ns: 0 + 0011 + 0001 = 0 0100  (acarreo entre bits)
	-- 200 ns: 0 + 0101 + 0010 = 0 0111  (sin acarreos)
	-- 300 ns: 0 + 0111 + 0001 = 0 1000  (acarreo propagado a bit 3)
	-- 400 ns: 0 + 1111 + 0001 = 1 0000  (acarreo propagado a la salida)
	-- 500 ns: 1 + 0000 + 1111 = 1 0000  (acarreo de entrada propagado)
	-- 600 ns: 1 + 1111 + 1111 = 1 1111  (maximo)
	-- 700 ns: 0 + 1010 + 0101 = 0 1111  (bits complementarios)
	
	a_tb <= "0011" after 100 ns, "0101" after 200 ns, "0111" after 300 ns, "1111" after 400 ns, "0000" after 500 ns, "1111" after 600 ns, "1010" after 700 ns;
	b_tb <= "0001" after 100 ns, "0010" after 200 ns, "0001" after 300 ns, "0001" after 400 ns, "1111" after 500 ns, "1111" after 600 ns, "0101" after 700 ns;
	ci_tb <= '1' after 500 ns, '0' after 700 ns;
	DUT: sum4b
		port map(
			ci_i => ci_tb,
			a_i => a_tb,
			b_i => b_tb,
			s_o => s_tb,
			co_o => co_tb
		);

end;
