#!/bin/sh
echo $1
if [ -d "$1" ]
then
	cd $1

CC="gcc"
CXX="c++"
CFLAGS="-Wall -O3 -fomit-frame-pointer -pipe"    # for speed #CFLAGS="-Wall -g -pipe" # for development
CXXFLAGS="$CFLAGS"
export CC
export CXX
export CFLAGS
export CXXFLAGS

./configure --prefix=/usr/local/bochs \
            --enable-sb16 \
            --enable-ne2000 \
            --enable-all-optimizations \
            --enable-cpu-level=6 \
            --enable-x86-64 \
            --enable-vmx=2 \
            --enable-pci \
            --enable-clgd54xx \
            --enable-voodoo \
            --enable-usb \
            --enable-usb-ohci \
            --enable-usb-ehci \
            --enable-usb-xhci \
            --enable-busmouse \
            --enable-es1370 \
            --enable-e1000 \
            --enable-plugins \
            --enable-show-ips \
            --with-all-libs \
            --enable-smp \
            --enable-avx \
            --enable-3dnow \
            --enable-vmx \
            --enable-svm \
            ${CONFIGURE_ARGS}

# make && sudo make install
else
	echo "please select bochs source directory."
fi
