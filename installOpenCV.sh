#!/usr/bin/env bash

# Stop on errors and print commands
set -euxo pipefail

###############################################################################
# 1) Install dependencies
###############################################################################
sudo apt-get update -y

# Core libraries for building OpenCV with gstreamer support, codecs, etc.
sudo apt-get install -y \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libtbb-dev libjpeg-dev libpng-dev \
    libtiff-dev libdc1394-dev gfortran openexr libatlas-base-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base \
    libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-gl \
    clang wget cmake build-essential pkg-config

###############################################################################
# 2) Download OpenCV source (4.6.0) and contrib modules
###############################################################################
wget -O opencv.tar.gz https://github.com/opencv/opencv/archive/refs/tags/4.6.0.tar.gz
wget -O opencv_contrib.tar.gz https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.tar.gz

tar -zvxf opencv.tar.gz
tar -zvxf opencv_contrib.tar.gz

###############################################################################
# 3) Build and install OpenCV
###############################################################################
cd opencv-4.6.0
mkdir -p build
cd build

# Dynamically determine Python3 details
PYTHON3_EXECUTABLE=$(which python3)
PYTHON3_VERSION_MAJOR=$(python3 -c "import sys; print(sys.version_info.major)")
PYTHON3_VERSION_MINOR=$(python3 -c "import sys; print(sys.version_info.minor)")
PYTHON3_VERSION="${PYTHON3_VERSION_MAJOR}.${PYTHON3_VERSION_MINOR}"
PYTHON3_LIB_PATH=$(python3 -c "import sysconfig; print(sysconfig.get_path('purelib'))")
PYTHON3_INCLUDE_DIR=$(python3 -c "import sysconfig; print(sysconfig.get_path('include'))")
PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())")

# Find Python library - more robust method
PYTHON3_LIB_NAME="python${PYTHON3_VERSION}"
PYTHON3_LIBRARIES=$(find /usr/lib* -name "lib${PYTHON3_LIB_NAME}.so" -o -name "lib${PYTHON3_LIB_NAME}.a" 2>/dev/null | head -n 1)

cmake \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DWITH_GSTREAMER=ON \
  -DWITH_FFMPEG=OFF \
  -DPYTHON3_EXECUTABLE="$PYTHON3_EXECUTABLE" \
  -DPYTHON3_LIBRARIES="$PYTHON3_LIBRARIES" \
  -DPYTHON3_NUMPY_INCLUDE_DIRS="$PYTHON3_NUMPY_INCLUDE_DIRS" \
  -DPYTHON3_INCLUDE_PATH="$PYTHON3_INCLUDE_DIR" \
  -DPYTHON3_CVPY_SUFFIX=".cpython-${PYTHON3_VERSION_MAJOR}${PYTHON3_VERSION_MINOR}-x86_64-linux-gnu.so" \
  -DBUILD_NEW_PYTHON_SUPPORT=ON \
  -DBUILD_opencv_python3=ON \
  -DHAVE_opencv_python3=ON \
  -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.6.0/modules \
  -DBUILD_LIST=aruco,python3,videoio \
  -DENABLE_LTO=ON \
  ..

make -j"$(nproc)"
sudo make install

echo "OpenCV 4.6.0 installation complete!"
