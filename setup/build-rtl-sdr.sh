#!/bin/bash -ex

mkdir -p /data/rtl/
cd /data/rtl/
git clone git://git.osmocom.org/rtl-sdr.git /data/rtl/rtl-sdr/

mkdir -p /data/rtl/rtl-sdr/build
cd /data/rtl/rtl-sdr/build

cmake ..

make 

make install

ldconfig
