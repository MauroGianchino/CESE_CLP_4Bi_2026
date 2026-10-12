-------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2015 10:24:29 AM
-- Design Name: 
-- Module Name: uart_top
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--////////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.std_logic_1164.all;

entity uart_top is
	port(
		clk_pin:	in std_logic;	-- Clock input (from pin)
		rst_pin:	in std_logic;	-- Active HIGH reset (from pin)
		rxd_pin:	in std_logic;	-- RS232 RXD pin - directly from pin
		ppm_pin:	out std_logic;	-- Salida PPM
		sync_pin:	out std_logic	-- Marca de comienzo de trama
	);
end;

architecture uart_top_arq of uart_top is

	component uart_ppm is
        generic(
		    BAUD_RATE: integer := 115200;
		    CLOCK_RATE: integer := 125E6
	    );
	    port(
            clk_pin: in std_logic;	-- Clock input (from pin)
            rst_pin: in std_logic;	-- Active HIGH reset (from pin)
            rxd_pin: in std_logic;	-- RS232 RXD pin - directly from pin
            ppm_pin: out std_logic;	-- Salida PPM
            sync_pin: out std_logic	-- Marca de comienzo de trama
	    );
	end component;

begin

	UPPM0: uart_ppm
		generic map(
			BAUD_RATE => 115200,
			CLOCK_RATE => 125E6
		)
		port map(
			clk_pin => clk_pin,  	-- Clock input (from pin)
			rst_pin => rst_pin,  	-- Active HIGH reset (from pin)
			rxd_pin => rxd_pin,  	-- RS232 RXD pin - directly from pin
            ppm_pin => ppm_pin, 	-- Salida PPM
			sync_pin => sync_pin 	-- Marca de comienzo de trama
		);
end;