##Processing Interface for ICubeX digitizers 

Tested with: USB-microDig and Wi-microDig

This is a small demo example showing how one might start talking to an ICubeX digitizer directly in a standalone Processing sketch with minimal external dependencies. The only thing needed is the [serial  driver](https://www.silabs.com/products/mcu/Pages/USBtoUARTBridgeVCPDrivers.aspx) driver for the USB-microDig if it hasn't been installed on your system already. For the Wi-microDig, the virtual bluetooth COM port is provided by the operating system.


In this example we manually construct the configuration messages required to activate two analog sensor ports (1 and 2, which are the second and third physical connectors), and read data from it.

This application is designed as a proof of concept with minimal abstraction and optimizing of the code, and we expect to build a more featured and user friendly library in the future. In the mean time anyone wanting to get a sketch quickly connected with sensors can make use of it.

Any questions/comments/suggestions please let us know!

The I-CubeX Team

January 2016
