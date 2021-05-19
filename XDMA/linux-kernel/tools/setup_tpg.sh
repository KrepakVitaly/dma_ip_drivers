#!/bin/bash


./reg_rw /dev/xdma0_user 0x20 -w 0x1e0
./reg_rw /dev/xdma0_user 0x30 -w 0x1e0
./reg_rw /dev/xdma0_user 0x40 -w 0x196e6a
./reg_rw /dev/xdma0_user 0x50 -w 0x05

./reg_rw /dev/xdma0_user 0x60 -w 0x01

./reg_rw /dev/xdma0_user 0x80 -w 0x01

./reg_rw /dev/xdma0_user 0x10 -w 0x00
./reg_rw /dev/xdma0_user 0x80 -w 0x01
sleep 1
./reg_rw /dev/xdma0_user 0x10 -w 0x01
./reg_rw /dev/xdma0_user 0x80 -w 0x01


sudo ./dma_from_device -v -d /dev/xdma0_c2h_0 -f output_data.bin -s 0xE1000
#./dma_from_device -v -d /dev/xdma0_c2h_0 -f output_data.bin -s 0x000a0000
