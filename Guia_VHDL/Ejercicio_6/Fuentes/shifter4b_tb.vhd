library IEEE;
use IEEE.std_logic_1164.all;

entity shifter4b_tb is
end;

architecture shifter4b_tb_arq of shifter4b_tb is

    -- Declaracion de senales de prueba
    signal clk_tb: std_logic := '0' ;
	signal d_tb: std_logic := '0';
	signal rst_tb: std_logic := '0';
	signal q_tb: std_logic;
	

	component shifter4b is
        port(
            clk_i: in std_logic;
            d_i: in std_logic;
            rst_i: in std_logic;
            q_o: out std_logic
        );
	end component;



begin

    clk_tb <= not clk_tb after 10 ns;
    d_tb <= '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;

	DUT: shifter4b
		port map(
			clk_i => clk_tb,
			d_i => d_tb,
			rst_i => rst_tb,
			q_o => q_tb
		);

end;