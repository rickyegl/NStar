l#!/bin/bash

# Update system
apt-get update -y
apt-get update -y && (apt-get install -y gfortran-aarch64-linux-gnu || apt-get install -y gfortran)

# Install dependencies for ARM64 platform
TARGETPLATFORM=linux/arm64 xx-apt-get update -y
TARGETPLATFORM=linux/arm64 xx-apt-get install -y libopenblas-dev libjpeg-dev build-essential cmake git pkg-config libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev gfortran openexr python3-dev python3-numpy libtbb2 libtbb-dev libdc1394-22-dev

# Download and install numpy
wget https://files.pythonhosted.org/packages/a4/9b/027bec52c633f6556dba6b722d9a0befb40498b9ceddd29cbe67a45a127c/numpy-1.24.4.tar.gz
tar -zvxf numpy-1.24.4.tar.gz
cp numpy-aarch64-linux-gnu-site.cfg numpy-1.24.4/site.cfg
pip3 install -v ./numpy-1.24.4

# Install pyntcore and robotpy libraries
pip3 install --find-links https://tortall.net/~robotpy/wheels/2023/raspbian pyntcore
pip3 install --find-links https://tortall.net/~robotpy/wheels/2023/raspbian robotpy-wpimath==2023.4.3.1

# Install Pillow with specific flags
LDFLAGS="-L/usr/lib/aarch64-linux-gnu" CFLAGS="-I/usr/include/aarch64-linux-gnu" pip3 install -v pillow

sh installOpenCV.sh
