library IEEE;
use IEEE.std_logic_1164.all;

entity sum1b_tb is
end;

architecture sum1b_tb_arq of sum1b_tb is

	component sum1b is
		port(
			ci_i: in std_logic;
			a_i: in std_logic;
			b_i: in std_logic;
			s_o: out std_logic;
			co_o: out std_logic
		);
	end component;

	-- Declaracion de senales de prueba
	signal ci_tb: std_logic := '0';
	signal a_tb: std_logic := '0';
	signal b_tb: std_logic := '0';
	signal s_tb: std_logic;
	signal co_tb: std_logic;

begin

	-- la variable a_tb va a cambiar cada 100ns, b_tb cada 200ns y ci_tb cada 400ns.
	a_tb <= not a_tb after 100 ns;
	b_tb <= not b_tb after 200 ns;
	ci_tb <= not ci_tb after 400 ns;

	DUT: sum1b
		port map(
			ci_i => ci_tb,
			a_i => a_tb,
			b_i => b_tb,
			s_o => s_tb,
			co_o => co_tb
		);

end;
