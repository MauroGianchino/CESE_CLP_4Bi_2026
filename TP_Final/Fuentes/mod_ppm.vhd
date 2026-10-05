-------------------------------------------------------------------------------
--  Module   : mod_ppm.vhd
--  Parent   : top del TP
--  Children : None
--
--  Description:
--     Modulador PPM. Recibe un byte (0 a 255) y genera una trama periodica
--     de NUM_SLOTS ranuras de CYCLES_PER_SLOT ciclos cada una. ppm_out vale
--     '1' durante la ranura cuyo numero es igual al byte recibido (ancho de
--     pulso w = ranura). La ultima ranura de la trama es de guarda: el pulso
--     nunca cae ahi.
--
--  Parameters:
--     CYCLES_PER_SLOT : ciclos de clock por ranura (10 us a 10 MHz = 100)
--     NUM_SLOTS       : 256 posiciones + 1 ranura de guarda = 257
--
--  Notes:
--     El byte nuevo se guarda en un registro pendiente y recien se usa al
--     comienzo de la trama siguiente, para que ninguna trama tenga dos
--     pulsos o ninguno.
--     ppm_out sale registrada: aparece 1 ciclo de clock despues de que
--     arranca la ranura.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Declaracion de identidad

entity mod_ppm is
    generic(
		CYCLES_PER_SLOT: positive := 100; --ancho de cada ranura expresado en ciclos de clock. ancho = CYCLES * (1/fclock)
		NUM_SLOTS: positive := 257

	);
	port(
        -- entradas
		clk_i: in std_logic; --clock
		rst_i: in std_logic; --señal de reset
		rx_data_i: in std_logic_vector(7 downto 0); --vector de entrada con los 8 bits de la uart
		rx_data_rdy_i: in std_logic; --señal de ok de data de la uart
		ppm_o: out std_logic --pin de salida con la modulacion ppm
	);
end;

architecture mod_ppm_arq of mod_ppm is

    --contadores
    signal cycle_count: integer range 0 to CYCLES_PER_SLOT - 1; --cuenta la cantidad de ciclos que dura una ranura
    signal window_count: integer range 0 to NUM_SLOTS - 1; -- cuenta la cantidad de ranuras

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            
            if rst_i = '1' then -- miro el rst
                cycle_count <= 0; --si es 1, reinicio el contador de ciclos
                window_count <= 0; --si es 1, reinicio el contador de ventanas
            elsif cycle_count = CYCLES_PER_SLOT - 1 then
                cycle_count <= 0;
                if window_count = NUM_SLOTS - 1 then
                    window_count <= 0; --reinicio contador de ventana
                else
                    window_count <= window_count + 1; --cuando el contador de ciclos se reinicia, se suma 1 al contador de ventana si no llego al maximo
                end if; 
            else
                cycle_count <= cycle_count + 1; 
            end if;

        end if;
        

    end process;

end;