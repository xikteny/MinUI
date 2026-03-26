#!/bin/bash
set -euo pipefail

# Cross-compile lz4 for GKD Pixel (MIPS)
LZ4_VERSION=v1.10.0

echo "Building lz4 ${LZ4_VERSION}..."

git clone --depth=1 --branch ${LZ4_VERSION} https://github.com/lz4/lz4.git /tmp/lz4
cd /tmp/lz4
make CC=${CROSS_COMPILE}gcc PREFIX=${PREFIX} -j$(nproc)
make CC=${CROSS_COMPILE}gcc PREFIX=${PREFIX} install
cd /tmp
rm -rf /tmp/lz4

echo "lz4 installed to ${PREFIX}"
