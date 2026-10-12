# ArtyZ7 xdc
#modulador ppm

# CLK source 125 MHz
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { clk_pin }];

# Rst Btn[3]
set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { rst_pin }]; 

# UART
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { rxd_pin }]; #IO_L17P_T2_34 Sch=JA1_P

#ppm
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { ppm_pin }]; #Sch=JA2_P

#sync_ppm
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { sync_pin }]; #Sch=JA2_N


