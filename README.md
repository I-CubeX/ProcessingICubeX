##Processing Interface for I-CubeX digitizers 

Tested with: USB-microDig and Wi-microDig, OSX and Windows. (Should work in Linux as well). Can be made to work with the MIDI Digitizer too (see comment below)

###Overview

This is a small demo example showing how one might start talking to an I-CubeX digitizer directly in a standalone Processing sketch with minimal external dependencies. The only thing needed is the [serial  driver](https://www.silabs.com/products/mcu/Pages/USBtoUARTBridgeVCPDrivers.aspx) driver for the USB-microDig if it hasn't been installed on your system already. For the Wi-microDig, the virtual bluetooth COM port is provided by the operating system.

###What does it do?
In this example we manually construct the configuration messages required to activate two analog sensor ports (1 and 2, which are the second and third physical connectors), and read data from it. Finally, we use the values from the two ports to adjust variables that affect the visual rendering of the sketch, using the built in "WaveGraident" color example.

This application is designed as a proof of concept with minimal abstraction and optimizing of the code, and we expect to build a more featured and user friendly library in the future. In the mean time anyone wanting to get a sketch quickly connected with sensors can make use of it.

###Notes for the MIDI Digitizer
For the MIDI based Digitizer, instead of a serial object, the example can be made to work by connecting to the MIDI port instead. In this case, for OSX you would have to use a MIDI library that supports SysEx, such as [CoreMidi4J](https://github.com/DerekCook/CoreMidi4J) or [MMJ](http://www.humatic.de/htools/mmj.htm). Let us know if you need help regarding this step. 

Any questions/comments/suggestions please let us know!

The I-CubeX Team

January 2016
