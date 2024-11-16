# Raw ADC Data Capture Tool with DCA100 and Matlab

MMWAVE-SDK OOB (out-of-box) demo supports raw ADC data streaming through the LVDS interface. When the radar EVM board connected with the DCA1000EVM board. Users can use the DCA1000EVM CLI application to capture the raw data without starting the mmWaveStudio GUI interface.
This instruction will provide the details how to setup hardware (awr1843boost + DCA1000 fpga ethernet card) and run matlab application for raw ADC data (IQ data) collection, post processing once the capture is done.

## Hardware setup
Please follow the below check points for properly hardware setup
### awr1843boost
    1. SOP2:0 --> 011
    2. S2 mux --> SPI
    3. 5V power supply
    4. Plug micro USB for command UART
### dca1000 
    1. LVDS mode sel --> as per Figure 1
    2. 5V power supply
    3. Plug micro USB for RADAR_FTDI
    4. Ethernet cable PC <--> DCA1000
</br>
<img src="media/awr1843boost_dca1000_settings.jpg" width="953" height="478" />
<figcaption><b>Figure 1: AWR1843 + DCA1000 hardware setup</b></figcaption>
</br>
</br>
<img src="media/awr1843boost_dca100_wiringdiagram.jpg" width="953" height="478" />
<figcaption><b>Figure 1: AWR1843 + DCA1000 wiring diagram</b></figcaption>
</br>

## Raw ADC capture using Mmwave Studio

## Raw ADC capture using Matlab and DCA1000VM_CLI (Mmwave Studio not required)
