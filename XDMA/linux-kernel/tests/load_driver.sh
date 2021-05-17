#!/bin/bash

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Remove the existing xdma kernel module
lsmod | grep xdma
if [ $? -eq 0 ]; then
   rmmod xdma
fi
echo -n "Loading xdma driver..."

# TODO: autoload this modules
#this modules must be loaded for v4l2 device 
modprobe videobuf2-memops
#modprobe videobuf2-common
#modprobe videobuf-common
modprobe v4l2-mem2mem
modprobe videobuf2-dma-contig
modprobe videobuf2-v4l2
modprobe videobuf2-dvb
modprobe videobuf2-dma-sg
modprobe videobuf2-core
modprobe videobuf2-vmalloc
modprobe videobuf-vmalloc

# Use the following command to Load the driver in the default 
# or interrupt drive mode. This will allow the driver to use 
# interrupts to signal when DMA transfers are completed.
insmod ../xdma/xdma.ko 
# Use the following command to Load the driver in Polling
# mode rather than than interrupt mode. This will allow the
# driver to use polling to determ when DMA transfers are 
# completed.
#insmod ../xdma/xdma.ko poll_mode=1

if [ ! $? == 0 ]; then
  echo "Error: Kernel module did not load properly."
  echo " FAILED"
  exit 1
fi

# Check to see if the xdma devices were recognized
echo ""
cat /proc/devices | grep xdma > /dev/null
returnVal=$?
if [ $returnVal == 0 ]; then
  # Installed devices were recognized.
  echo "The Kernel module installed correctly and the xmda devices were recognized."
else
  # No devices were installed.
  echo "Error: The Kernel module installed correctly, but no devices were recognized."
  echo " FAILED"
  exit 1
fi


echo "tready signal bind to 1 (camera mode on)"
../tools/reg_rw /dev/xdma0_user 0x60 -w 0x00

echo "set freq divider 0xcb735"
../tools/reg_rw /dev/xdma0_user 0x40 -w 0xcb735


echo "set pattern with frame counter"
../tools/reg_rw /dev/xdma0_user 0x50 -w 0x02


echo "set frame size 0x780 width and 0x1e0 height"
../tools/reg_rw /dev/xdma0_user 0x20 -w 0x780
../tools/reg_rw /dev/xdma0_user 0x30 -w 0x1e0


echo "apply settings"
../tools/reg_rw /dev/xdma0_user 0x80 -w 0x01
sleep 1

../tools/reg_rw /dev/xdma0_user 0x84 -w 

echo "go reset"
../tools/reg_rw /dev/xdma0_user 0x10 -w 0x00
sleep 1
../tools/reg_rw /dev/xdma0_user 0x10 -w 0x01


echo " DONE"
