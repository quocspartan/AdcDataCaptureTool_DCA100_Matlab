# Raw ADC Data Capture Tool with DCA100 and Matlab

MMWAVE-SDK OOB (out-of-box) demo supports raw ADC data streaming through the LVDS interface. When the radar EVM board connected with the DCA1000EVM board. Users can use the DCA1000EVM CLI application to capture the raw data without starting the mmWaveStudio GUI interface.
This instruction will provide the details how to setup hardware (awr1843boost + DCA1000 fpga ethernet card) and run matlab application for raw ADC data (IQ data) collection, post processing once the capture is done.

## Hardware setup
Please follow the below check points for properly hardware setup
1. awr1843boost
    a. SOP2:0 --> 011
    b. S2 mux --> SPI
    c. 5V power supply
    d. Plug micro USB for command UART
2. dca1000 
    a. LVDS mode sel --> as per attached picture
    b. 5V power supply
    c. Plug micro USB for RADAR_FTDI
    d. Ethernet cable PC <--> DCA1000
</br>
<img src="media/awr1843boost_dca1000_settings.jpg" width="953" height="478" />
<figcaption><b>Figure 1: AWR1843 + DCA1000 hardware setup</b></figcaption>
</br> 
## Raw ADC capture using Mmwave Studio

## Raw ADC capture using Matlab and DCA1000VM_CLI (Mmwave Studio not required)
