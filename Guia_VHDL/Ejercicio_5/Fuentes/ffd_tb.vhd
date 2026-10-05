library IEEE;
use IEEE.std_logic_1164.all;

entity ffd_tb is
end;

architecture ffd_tb_arq of ffd_tb is

    -- Declaracion de senales de prueba
    signal clk_tb: std_logic := '0' ;
	signal d_tb: std_logic := '0';
	signal rst_tb: std_logic := '0';
	signal ena_tb: std_logic := '0';
	signal q_tb: std_logic;
	

	component ffd is
        port(
            clk_i: in std_logic;
            d_i: in std_logic;
            rst_i: in std_logic;
            ena_i: in std_logic;
            q_o: out std_logic
        );
	end component;



begin

    -- el reloj sube en 10, 30, 50... ns. d, rst y ena cambian cada multiplo de 20 ns
    -- (flancos descendentes), asi nunca cambian justo en un flanco ascendente.
    -- el patron completo se repite cada 240 ns. Casos principales (flanco: rst/ena/d -> q):
    -- 50 ns:  1/0/0 -> q=0  reset con ena=0
    -- 70 ns:  1/1/1 -> q=0  el reset gana sobre ena y d
    -- 110 ns: 0/1/1 -> q=1  carga d=1
    -- 130 ns: 1/0/0 -> q=0  reset desde q=1
    -- 270 ns: 0/0/1 -> q=0  ena=0 ignora d=1
    clk_tb <= not clk_tb after 10 ns;
    d_tb <= not d_tb after 20 ns;
    rst_tb <= not rst_tb after 40 ns;
    ena_tb <= not ena_tb after 60 ns;

	DUT: ffd
		port map(
			clk_i => clk_tb,
			d_i => d_tb,
			rst_i => rst_tb,
			ena_i => ena_tb,
			q_o => q_tb
		);

end;