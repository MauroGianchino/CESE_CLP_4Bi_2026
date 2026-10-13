-------------------------------------------------------------------------------
--  Module   : uart_ppm.vhd
--  Parent   : uart_top
--
--  Description:
--     Une el receptor UART con el modulador PPM. El byte recibido por rxd_pin
--     se modula en la posicion del pulso de ppm_pin. sync_pin marca el comienzo
--     de cada trama.
--
--  Parameters:
--     BAUD_RATE  : velocidad del UART (115200 por defecto)
--     CLOCK_RATE : frecuencia del clock de entrada (125 MHz en la Arty Z7)
--
--  Notes:
--     Los parametros del modulador (CYCLES_PER_SLOT, NUM_SLOTS y W_SYNC) usan
--     los valores por defecto de mod_ppm, pensados para 125 MHz.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity uart_ppm is
	generic(
		BAUD_RATE: integer := 115200;
		CLOCK_RATE: integer := 125E6
	);
	port(
		clk_pin:	in std_logic;	-- Clock input (from pin)
		rst_pin:	in std_logic;	-- Active HIGH reset (from pin)
		rxd_pin:	in std_logic;	-- RS232 RXD pin - directly from pin
		ppm_pin:	out std_logic;	-- Salida PPM
		sync_pin:	out std_logic	-- Marca de comienzo de trama
	);
end;

architecture uart_ppm_arq of uart_ppm is

	component meta_harden is
		port(
			clk_dst: 	in std_logic;	-- Destination clock
			rst_dst: 	in std_logic;	-- Reset - synchronous to destination clock
			signal_src: in std_logic;	-- Asynchronous signal to be synchronized
			signal_dst: out std_logic	-- Synchronized signal
		);
	end component;

	component uart_rx is
		generic(
			BAUD_RATE: integer := 115200; 	-- Baud rate
			CLOCK_RATE: integer := 50E6
		);
		port(
			clk_rx: in std_logic;       				-- Clock input
			rst_clk_rx: in std_logic;   				-- Active HIGH reset - synchronous to clk_rx

			rxd_i: in std_logic;        				-- RS232 RXD pin - Directly from pad
			rxd_clk_rx: out std_logic;					-- RXD pin after synchronization to clk_rx

			rx_data: out std_logic_vector(7 downto 0);	-- 8 bit data output
														--  - valid when rx_data_rdy is asserted
			rx_data_rdy: out std_logic;  				-- Ready signal for rx_data
			frm_err: out std_logic       				-- The STOP bit was not detected
		);
	end component;

	component mod_ppm is
		generic(
			CYCLES_PER_SLOT: positive := 1250;	-- ciclos de clock por ranura
			NUM_SLOTS: positive := 256;			-- cantidad de ranuras de la trama
			W_SYNC: positive := 125				-- ciclos de clock que dura sync_o en 1
		);
		port(
			clk_i:			in std_logic;						-- Clock input
			rst_i:			in std_logic;						-- Active HIGH reset - synchronous to clk_i
			rx_data_i:		in std_logic_vector(7 downto 0);	-- Byte recibido por la uart
			rx_data_rdy_i:	in std_logic;						-- Valid when rx_data_rdy_i is asserted
			ppm_o:			out std_logic;						-- Salida PPM
			sync_o:			out std_logic						-- Marca de comienzo de trama
		);
	end component;

	signal rst_clk_rx: std_logic;

	-- Between uart_rx and mod_ppm
	signal rx_data: std_logic_vector(7 downto 0); 	-- Data output of uart_rx
	signal rx_data_rdy: std_logic;  				-- Data ready output of uart_rx

begin

	-- Metastability harden the rst - this is an asynchronous input to the
	-- system (from a pushbutton), and is used in synchronous logic. Therefore
	-- it must first be synchronized to the clock domain (clk_pin in this case)
	-- prior to being used.
	meta_harden_rst_i0: meta_harden
		port map(
			clk_dst 	=> clk_pin,
			rst_dst 	=> '0',    		-- No reset on the hardener for reset!
			signal_src 	=> rst_pin,
			signal_dst 	=> rst_clk_rx
		);

	uart_rx_i0: uart_rx
		generic map(
			CLOCK_RATE 	=> CLOCK_RATE,
			BAUD_RATE  	=> BAUD_RATE
		)
		port map(
			clk_rx     	=> clk_pin,
			rst_clk_rx 	=> rst_clk_rx,

			rxd_i      	=> rxd_pin,
			rxd_clk_rx 	=> open,

			rx_data_rdy	=> rx_data_rdy,
			rx_data    	=> rx_data,
			frm_err    	=> open
		);

	mod_ppm_i0: mod_ppm
		port map(
			clk_i         => clk_pin,
			rst_i         => rst_clk_rx,
			rx_data_i     => rx_data,
			rx_data_rdy_i => rx_data_rdy,
			ppm_o         => ppm_pin,
			sync_o        => sync_pin
		);

end;
