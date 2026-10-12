library IEEE;
use IEEE.std_logic_1164.all;

entity mod_ppm_tb4_rdylargo is
end;

architecture mod_ppm_tb4_rdylargo_arq of mod_ppm_tb4_rdylargo is

    -- Declaracion de senales de prueba
        signal clk_tb: std_logic := '0'; --clock
		signal rst_tb: std_logic := '1'; --señal de reset que empieza en 1 para dar valores inciales
		signal rx_data_tb: std_logic_vector(7 downto 0) := "00000000"; --vector de entrada con los 8 bits de la uart
		signal rx_data_rdy_tb: std_logic := '0'; --señal de ok de data de la uart
		signal ppm_tb: std_logic; --pin de salida con la modulacion ppm
        signal sync_tb: std_logic; -- pin que indica comienzo de trama, es para sincronizar

    -- Declaracion del componente a probar
    component mod_ppm is
        generic(
            CYCLES_PER_SLOT: positive := 100; -- ciclos de clock por ranura
            NUM_SLOTS: positive := 257; -- cantidad de ranuras de la trama
            W_SYNC: positive := 10 -- ciclos de clock que dura sync_o en 1
        );
        port(
            clk_i: in std_logic; -- clock
            rst_i: in std_logic; -- reset
            rx_data_i: in std_logic_vector(7 downto 0); -- byte recibido por la uart
            rx_data_rdy_i: in std_logic; -- byte valido
            ppm_o: out std_logic; -- salida ppm
            sync_o: out std_logic -- salida de sincronismo
        );
    end component;

begin
    clk_tb <= not clk_tb after 50 ns; --periodo de 100ns
    rst_tb <= '0' after 200 ns;
    -- Test B: rdy en alto 87 ciclos (el byte se captura una sola vez)
    -- estimulos a completar
    rx_data_tb <= "00000011" after 900 ns;
    rx_data_rdy_tb <= '1' after 1000 ns, '0' after 9700 ns;


    DUT: mod_ppm
        generic map(
            CYCLES_PER_SLOT => 4, --cada trama dura 3200 ns
            NUM_SLOTS => 8,
            W_SYNC => 1
        )
        port map(
            clk_i => clk_tb,
            rst_i => rst_tb,
            rx_data_i => rx_data_tb,
            rx_data_rdy_i => rx_data_rdy_tb,
            ppm_o => ppm_tb,
            sync_o => sync_tb
        );

end;