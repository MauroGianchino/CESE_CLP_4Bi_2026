library IEEE;
use IEEE.std_logic_1164.all;

entity ffd is
	port(
		clk_i: in std_logic;
		d_i: in std_logic;
		rst_i: in std_logic;
		ena_i: in std_logic;
		q_o: out std_logic
	);
end;

--Declaracion de arquitectura / funcionamiento

architecture ffd_arq of ffd is

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                q_o <= '0';
            elsif ena_i = '1' then
                q_o <= d_i;
            end if;
        end if;
    end process;
end;