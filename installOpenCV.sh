#!/bin/bash

# Set -e to exit on any error
set -e

# Install dependencies
apt-get clean -y && apt-get update -y && apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libtbbmalloc2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-dev gfortran openexr libatlas-base-dev
apt-get clean -y && apt-get update -y && apt-get install -y libgstreamer1.0-dev
apt-get clean -y && apt-get update -y && apt-get install -y libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base
apt-get clean -y && apt-get update -y && apt-get install -y libgstreamer-plugins-bad1.0-dev  gstreamer1.0-plugins-bad
apt-get clean -y && apt-get update -y && apt-get install -y gstreamer1.0-plugins-good
apt-get clean -y && apt-get update -y && apt-get install -y gstreamer1.0-plugins-ugly
apt-get clean -y && apt-get update -y && apt-get install -y gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-gl

# Download OpenCV and OpenCV Contrib
wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/refs/tags/4.6.0.tar.gz
wget -O opencv_contrib.tar.gz https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.tar.gz

# Extract archives
tar -zvxf opencv.tar.gz
tar -zvxf opencv_contrib.tar.gz

# Build OpenCV
mkdir -p opencv-4.6.0/build
cd opencv-4.6.0/build

# Assuming you have python3 installed on your host
PYTHON3_EXECUTABLE=$(which python3)
PYTHON3_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
PYTHON3_LIB_PATH=$(python3 -c "import sysconfig; print(sysconfig.get_path('purelib'))")
PYTHON3_INCLUDE_DIR=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))")
PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())")

# Determine Python library path based on version
if [[ "$PYTHON3_VERSION" == "3.10" ]]; then
  PYTHON3_LIBRARIES=$(python3-config --prefix)/lib/libpython3.10.so
else
  echo "Error: Unsupported Python version. This script is designed for Python 3.10."
  exit 1
fi

# Configure CMake - Customize the following options as needed
cmake \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DWITH_GSTREAMER=ON \
  -DWITH_FFMPEG=OFF \
  -DPYTHON3_EXECUTABLE="$PYTHON3_EXECUTABLE" \
  -DPYTHON3_LIBRARIES="$PYTHON3_LIBRARIES" \
  -DPYTHON3_NUMPY_INCLUDE_DIRS="$PYTHON3_NUMPY_INCLUDE_DIRS" \
  -DPYTHON3_INCLUDE_PATH="$PYTHON3_INCLUDE_DIR" \
  -DPYTHON3_CVPY_SUFFIX=".cpython-${PYTHON3_VERSION}-x86_64-linux-gnu.so" \
  -DBUILD_NEW_PYTHON_SUPPORT=ON \
  -DBUILD_opencv_python3=ON \
  -DHAVE_opencv_python3=ON \
  -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.6.0/modules \
  -DBUILD_LIST=aruco,python3,videoio \
  -DENABLE_LTO=ON \
  ..

# Build and install
make -j$(nproc)
make install

echo "OpenCV installed successfully!"
