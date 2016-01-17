#!/bin/bash -ex

mkdir -p /data/sdr/
cd /data/sdr/
git clone git://git.osmocom.org/rtl-sdr.git /data/sdr/rtl-sdr/

mkdir -p /data/sdr/rtl-sdr/build
cd /data/sdr/rtl-sdr/build

cmake ..

make 

make install

ldconfig
