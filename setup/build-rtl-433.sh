#!/bin/bash -ex

mkdir -p /data/rtl/
cd /data/rtl/
git clone https://github.com/merbanan/rtl_433.git /data/rtl/rtl-433

mkdir -p /data/rtl/rtl-433/build
cd /data/rtl/rtl-433/build

cmake ..

make 

make install

ldconfig
