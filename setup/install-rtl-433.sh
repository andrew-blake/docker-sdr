#!/bin/bash -ex

mkdir -p /data/sdr/
cd /data/sdr/
git clone https://github.com/merbanan/rtl_433.git /data/sdr/rtl-433

mkdir -p /data/sdr/rtl-433/build
cd /data/sdr/rtl-433/build

cmake ..

make 

make install

ldconfig
