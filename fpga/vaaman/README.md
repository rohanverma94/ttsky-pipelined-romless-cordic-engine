## Implementation of Romless Cordic on Vaaman 

[Vaaman](https://www.crowdsupply.com/vicharak/vaaman) is SBC from [Vicharak.in](https://vicharak.in/) it has an Efinix Trion T120 FPGA along with a Rockchip RK3399. 




<p align="center">
  <img src="vaaman.JPG" alt="Vaaman SBC" width="800"/>
</p>


### Required :
- All the wires should be of identical lengths. 
- You will need a dummy SPI device in your Linux kernel (e.g., `/dev/spidev1.0`, here 1 is bus and 0 is device).


Here are the steps you can follow for creating the dummy SPI.

 ### Enable spidev on VAAMAN
 
 To enable `spidev` on your `Vaaman boards`, do as per the below instructions. 

```bash 
sudo apt update  

sudo apt upgrade 

sudo apt install linux-headers-5.10.238 linux-image-5.10.238-vaaman linux-libc-dev

```

 Use `vicharak-config` to enable `[ ] Enable SPI 2 [dummy dev] Controller on 40-Pin GPIO`

```bash 
sudo reboot
```

#### Pin assignments:

| Pin    | CPU Pin | FPGA Pin |
|---------|-------------|---------------|
|`sclk`  |7              |H13 - 7    |
|`mosi`|29       |E9 - 29|
|`miso`|31|L15 - 31|
|`cs_n`|33|L18 - 33|
--------------------------------------------------------------------------------------------

Thank You
Regards
Deepak Sharda 
