# Basys 3 Rev B, Artix-7 xc7a35tcpg236-1
# TOP: top_basys3 (mantiene los 16 puertos fisicos del top original)
set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports CLK]
create_clock -name sys_clk -period 10.000 -waveform {0 5} [get_ports CLK]

# Switches SW0=A, SW1=B, SW2=C, SW3=SENSOR
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports A]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports B]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports C]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports SENSOR]

# Reset BTN_CENTER
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports RST]

# LEDs 0..9
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports CERRADA]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports ABRIENDO]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports ABIERTA]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports CERRANDO]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports CODIGO_OK]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports ALARMA]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports PASO_1]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports PASO_2]
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports Q0]
set_property -dict { PACKAGE_PIN V3 IOSTANDARD LVCMOS33 } [get_ports Q1]
