library IEEE;
use IEEE.std_logic_1164.all;

entity uart_top_tb is
end;

architecture uart_top_tb_arq of uart_top_tb is

    -- Declaracion de senales de prueba
    signal clk_tb: std_logic := '0'; -- clock
    signal rst_tb: std_logic := '1'; -- reset, empieza activo
    signal rxd_tb: std_logic := '1'; -- linea del uart, en reposo vale 1
    signal ppm_tb: std_logic; -- salida ppm
    signal sync_tb: std_logic; -- marca de comienzo de trama

    -- Declaracion del componente a probar
    component uart_top is
        port(
            clk_pin:	in std_logic;	-- Clock input (from pin)
            rst_pin:	in std_logic;	-- Active HIGH reset
            rxd_pin:	in std_logic;	-- RXD pin
            ppm_pin:	out std_logic;	-- Salida PPM
            sync_pin:	out std_logic	-- Marca de comienzo de trama
        );
    end component;

    constant BIT_T: time := 8680 ns;
    constant T0: time := 100 us; -- inicio del primer byte
    constant T1: time := 3000 us; -- inicio del segundo byte
    constant T2: time := 6000 us; -- inicio del tercer byte

begin

    clk_tb <= not clk_tb after 4 ns; -- periodo de 8 ns (125 MHz)
    rst_tb <= '0' after 200 ns;

    rxd_tb <= -- primer byte: 5 = 00000101, primero el bit menos significativo
              '0' after T0,              -- bit de start
              '1' after T0 + BIT_T,      -- bit 0
              '0' after T0 + 2*BIT_T,    -- bit 1
              '1' after T0 + 3*BIT_T,    -- bit 2
              '0' after T0 + 4*BIT_T,    -- bit 3
              '0' after T0 + 5*BIT_T,    -- bit 4
              '0' after T0 + 6*BIT_T,    -- bit 5
              '0' after T0 + 7*BIT_T,    -- bit 6
              '0' after T0 + 8*BIT_T,    -- bit 7
              '1' after T0 + 9*BIT_T,    -- bit de stop
              -- segundo byte: 65 ('A') = 01000001, primero el bit menos significativo
              '0' after T1,              -- bit de start
              '1' after T1 + BIT_T,      -- bit 0
              '0' after T1 + 2*BIT_T,    -- bit 1
              '0' after T1 + 3*BIT_T,    -- bit 2
              '0' after T1 + 4*BIT_T,    -- bit 3
              '0' after T1 + 5*BIT_T,    -- bit 4
              '0' after T1 + 6*BIT_T,    -- bit 5
              '1' after T1 + 7*BIT_T,    -- bit 6
              '0' after T1 + 8*BIT_T,    -- bit 7
              '1' after T1 + 9*BIT_T,    -- bit de stop
              -- tercer byte: 122 ('z') = 01111010, primero el bit menos significativo
              '0' after T2,              -- bit de start
              '0' after T2 + BIT_T,      -- bit 0
              '1' after T2 + 2*BIT_T,    -- bit 1
              '0' after T2 + 3*BIT_T,    -- bit 2
              '1' after T2 + 4*BIT_T,    -- bit 3
              '1' after T2 + 5*BIT_T,    -- bit 4
              '1' after T2 + 6*BIT_T,    -- bit 5
              '1' after T2 + 7*BIT_T,    -- bit 6
              '0' after T2 + 8*BIT_T,    -- bit 7
              '1' after T2 + 9*BIT_T;    -- bit de stop

    DUT: uart_top
        port map(
            clk_pin => clk_tb,
            rst_pin => rst_tb,
            rxd_pin => rxd_tb,
            ppm_pin => ppm_tb,
            sync_pin => sync_tb
        );

end;
