#!/bin/bash
set -euo pipefail

# Cross-compile libsamplerate for GKD Pixel (MIPS)
SRC_VERSION=0.2.2

echo "Building libsamplerate ${SRC_VERSION}..."

cd /tmp
wget https://github.com/libsndfile/libsamplerate/releases/download/${SRC_VERSION}/libsamplerate-${SRC_VERSION}.tar.xz
tar xf libsamplerate-${SRC_VERSION}.tar.xz
cd libsamplerate-${SRC_VERSION}

./configure \
    --host=mipsel-gcw0-linux-uclibc \
    --prefix=${PREFIX} \
    CC=${CROSS_COMPILE}gcc \
    --disable-static \
    --enable-shared \
    --disable-sndfile \
    --disable-fftw

make -j$(nproc)
make install

cd /tmp
rm -rf /tmp/libsamplerate-${SRC_VERSION} /tmp/libsamplerate-${SRC_VERSION}.tar.xz

echo "libsamplerate installed to ${PREFIX}"
