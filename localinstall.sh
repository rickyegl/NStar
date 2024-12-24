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

# Download OpenCV and OpenCV contrib
wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/refs/tags/4.6.0.tar.gz
wget -O opencv_contrib.tar.gz https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.tar.gz

# Extract OpenCV and OpenCV contrib
tar -xvzf opencv.tar.gz
tar -xvzf opencv_contrib.tar.gz

# Build and install OpenCV
cd opencv-4.6.0
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.6.0/modules \
      -D ENABLE_NEON=ON \
      -D ENABLE_VFPV3=ON \
      -D BUILD_TESTS=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF ..

make -j$(nproc)
make install
ldconfig
