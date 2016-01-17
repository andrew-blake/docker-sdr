#!/bin/bash -ex

mkdir -p /data/sdr/gnuradio
cd /data/sdr/gnuradio

apt-get update

#wget http://www.sbrac.org/files/build-gnuradio

#free
#dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
#mkswap /var/swap.img
#swapon /var/swap.img
#free

/build-gnuradio-modified -ja -v

rm -rf /var/lib/apt/lists/*
