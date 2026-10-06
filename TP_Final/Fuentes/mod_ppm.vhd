-------------------------------------------------------------------------------
--  Module   : mod_ppm.vhd
--  Parent   : top del TP
--  Children : None
--
--  Description:
--     Modulador PPM. Recibe un byte (0 a 255) del receptor UART y genera una
--     trama periodica de NUM_SLOTS ranuras de CYCLES_PER_SLOT ciclos cada una.
--     ppm_o vale '1' durante la ranura cuyo numero es igual al byte recibido
--     (ancho de pulso w = ranura). La ultima ranura de la trama es de guarda:
--     el pulso nunca cae ahi.
--     Cada byte genera un unico pulso: si al comenzar una trama no hay un byte
--     nuevo esperando, la trama va vacia (sin pulso).
--     sync_o sube al comienzo de cada trama (haya pulso o no) y se mantiene
--     en '1' durante W_SYNC ciclos de clock. Sirve de referencia de tiempo.
--
--  Parameters:
--     CYCLES_PER_SLOT : ciclos de clock por ranura (10 us a 10 MHz = 100)
--     NUM_SLOTS       : 256 posiciones + 1 ranura de guarda = 257
--     W_SYNC          : ciclos de clock que dura sync_o en '1' (por defecto 10)
--
--  Notes:
--     El byte se captura en el flanco de subida de rx_data_rdy_i. Si ya hay un
--     byte esperando, los que lleguen despues se ignoran (gana el primero).
--     El byte esperando se pasa al registro de comparacion solo al comienzo
--     de la trama siguiente, para que ninguna trama tenga dos pulsos o ninguno.
--     ppm_o y sync_o salen registradas: aparecen 1 ciclo de clock despues de
--     que arranca la ranura. Reset sincronico, activo en alto.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Declaracion de identidad

entity mod_ppm is
    generic(
		CYCLES_PER_SLOT: positive := 100; --ancho de cada ranura expresado en ciclos de clock. ancho = CYCLES * (1/fclock)
		NUM_SLOTS: positive := 257; -- cantidad de ranuras dentro de la trama
        W_SYNC: positive := 10 --cantidad de ciclos de clock que dura en 1 el pin de sincronismo al comienzo de cada trama

	);
	port(
        -- entradas
		clk_i: in std_logic; --clock
		rst_i: in std_logic; --señal de reset
		rx_data_i: in std_logic_vector(7 downto 0); --vector de entrada con los 8 bits de la uart
		rx_data_rdy_i: in std_logic; --señal de ok de data de la uart
		ppm_o: out std_logic; --pin de salida con la modulacion ppm
        sync_o: out std_logic -- pin que indica comienzo de trama, es para sincronizar
	);
end;

architecture mod_ppm_arq of mod_ppm is

    --contadores
    signal cycle_count: integer range 0 to CYCLES_PER_SLOT - 1; --cuenta la cantidad de ciclos que dura una ranura
    signal window_count: integer range 0 to NUM_SLOTS - 1; -- cuenta la cantidad de ranuras
    -- senales de proceso de byte
    signal old_rx_data_rdy: std_logic; --senal para guardar el dato de rdy y saber cuando para de 0 a 1
    signal byte_waiting: std_logic; -- flag para que cuando este queriendo modular un byte, no usar otro que me llegue antes de modular el anterior
    signal arrival_byte: std_logic_vector(7 downto 0); -- registro que guarda el byte que llega
    signal compare_byte: std_logic_vector(7 downto 0); -- registro que tiene el byte que voy a comparar su valor con el contador de ranuras
    signal empty_msg: std_logic; -- flag de trama vacia: 1 = sin mensaje, 0 = la trama lleva un pulso

    begin
    process(clk_i) --process dedicado a los contadores
    begin
        if rising_edge(clk_i) then
            
            if rst_i = '1' then -- miro el rst
                cycle_count <= 0; --si es 1, reinicio el contador de ciclos
                window_count <= 0; --si es 1, reinicio el contador de ventanas
            elsif cycle_count = CYCLES_PER_SLOT - 1 then -- termino la ranura
                cycle_count <= 0; -- arranca la ranura siguiente
                if window_count = NUM_SLOTS - 1 then -- era la ultima ranura: termina la trama
                    window_count <= 0; --reinicio contador de ventana
                else
                    window_count <= window_count + 1; --cuando el contador de ciclos se reinicia, se suma 1 al contador de ventana si no llego al maximo
                end if; 
            else
                cycle_count <= cycle_count + 1; -- sigo contando ciclos dentro de la ranura
            end if;

        end if;
        
    end process;

    process(clk_i) --process dedicado a gestionar la recepcion del byte
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then -- miro el rst
                byte_waiting <= '0'; -- sin byte esperando
                arrival_byte <= "00000000"; -- byte capturado en cero
                compare_byte <= "00000000"; -- byte a comparar en cero
                old_rx_data_rdy <= '0'; -- sin valor previo de rdy
                empty_msg <= '1'; -- arranca como trama vacia
            else
                old_rx_data_rdy <= rx_data_rdy_i; --guardo en old el actual
                if (rx_data_rdy_i = '1' and old_rx_data_rdy = '0' and byte_waiting = '0') then --si hubo un cambio, asigno el byte
					arrival_byte <= rx_data_i; -- capturo el byte que llega
                    byte_waiting <= '1'; -- levanto el flag	
				end if; 
                if(cycle_count = CYCLES_PER_SLOT - 1 and window_count = NUM_SLOTS - 1) then -- comienzo de trama: ultimo ciclo de la ultima ranura
                    if byte_waiting = '1' then -- si hay un byte listo a ser transmitido
                        compare_byte <= arrival_byte; -- paso el byte esperando al registro de comparacion
                        byte_waiting <= '0'; -- ya no queda byte esperando
                        empty_msg <= '0'; -- la trama tiene un mensaje
                    else
                        empty_msg <= '1'; -- la trama no tiene mensaje
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(clk_i) --process que genera la salida del ppm
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                ppm_o <= '0'; -- salida ppm en reposo
                sync_o <= '0'; -- salida sync en reposo
            else
                if (empty_msg = '0' and to_integer(unsigned(compare_byte)) = window_count) then -- pulso si la trama tiene mensaje y la ranura actual es igual al byte
                    ppm_o <= '1';
                else
                    ppm_o <= '0';
                end if;
                if(window_count = 0 and cycle_count < W_SYNC) then -- sync en alto los primeros W_SYNC ciclos de la trama
                    sync_o <= '1';
                else
                    sync_o <= '0';
                end if;
                    
            end if;
        end if;    
    end process;


end;