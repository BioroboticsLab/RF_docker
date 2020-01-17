# SPDX-License-Identifier: AGPL-3.0-or-later
FROM centos:7

LABEL maintainer="Moritz Maxeiner <moritz.maxeiner@fu-berlin.de>"
LABEL authors="Moritz Maxeiner <moritz.maxeiner@fu-berlin.de>"

# GCC
ENV BASH_ENV "/etc/profile"
RUN yum install -y centos-release-scl && \
    yum install -y epel-release && \
    yum install -y devtoolset-8 && \
    yum clean all
ADD bash/gcc-8.sh /etc/profile.d/gcc-8.sh
ADD bash/ld-library-path.sh /etc/profile.d/ld-library-path.sh

# CMake
RUN version=3.15.5 && \
    yum install -y \
        curl-devel \
        expat-devel \
        zlib-devel \
        bzip2-devel \
        xz-devel \
        libzstd-devel \
        rhash-devel \
        libuv-devel \
        && \
    yum clean all && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSLO https://cmake.org/files/v${version%.*}/cmake-${version}.tar.gz && \
    tar -xf cmake-${version}.tar.gz && \
    cd cmake-${version} && \
    ./bootstrap --system-libs --no-system-libarchive --no-system-jsoncpp  --prefix=/usr/local && \
    make install -j$(nproc --all) && \
    cd .. && \
    rm -rf cmake-${version}*

# Ninja
RUN yum install -y ninja-build && \
    ln -s /usr/bin/ninja-build /usr/local/bin/ninja && \
    yum clean all

# Python 3.6
RUN yum install -y \
        python36-devel \
        python36-numpy \
        && \
    yum clean all

# CUDA
RUN yum install -y dkms && \
    cd /tmp && \
    curl -sSLO https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-10.1.243-1.x86_64.rpm && \
    rpm -i cuda-repo-rhel7-*.rpm && \
    rm -f cuda-repo-rhel7-*.rpm && \
    yum install -y cuda-10-1 && \
    yum clean all

# FFmpeg
RUN version=4.2.1 && \
    yum install -y \
        nasm \
        libass-devel \
        libtheora-devel \
        libvorbis-devel \
        freetype-devel  \
        && \
    yum clean all && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSLO http://ffmpeg.org/releases/ffmpeg-${version}.tar.gz && \
    tar -xf ffmpeg-${version}.tar.gz && \
    cd ffmpeg-${version} && \
    ./configure --prefix=/usr/local --enable-gpl --enable-libfreetype --enable-avresample --enable-shared --disable-static --enable-pic && \
    make install && \
    cd .. && \
    rm -rf ffmpeg-${version}*

# HDF
RUN version=1.10.5 && \
    yum install -y \
        bzip2 \
        && \
    yum clean all && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSLO https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${version%.*}/hdf5-${version}/src/hdf5-${version}.tar.bz2 && \
    tar -xf hdf5-${version}.tar.bz2 && \
    cd hdf5-${version} && \
    cmake -S. -B build  -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        && \
    ninja -C build install && \
    cd .. && \
    rm -rf hdf5-${version}*

# Qt
ENV Qt5_DIR /opt/qt5/5.12.6/gcc_64/lib/cmake/Qt5
ADD qtifwsilent.qs /tmp/qtifwsilent.qs
RUN version=5.12.6 && \
    cd /tmp && \
    curl -sSLO https://download.qt.io/official_releases/qt/${version%.*}/${version}/qt-opensource-linux-x64-${version}.run && \
    chmod +x qt-opensource-linux-x64-${version}.run && \
    env QT_INSTALL_DIR=/opt/qt5 ./qt-opensource-linux-x64-${version}.run --script qtifwsilent.qs -platform minimal && \
    rm -f qt-opensource-linux-x64-${version}.run && \
    rm -f qtifwsilent.qs

# linuxdeployqt
RUN version=6 && \
    yum install -y \
        desktop-file-utils \
        && \
    cd /opt && \
    curl -sSLO https://github.com/probonopd/linuxdeployqt/releases/download/${version}/linuxdeployqt-${version}-x86_64.AppImage && \
    chmod +x linuxdeployqt-${version}-x86_64.AppImage && \
    ./linuxdeployqt-${version}-x86_64.AppImage --appimage-extract && \
    rm -f linuxdeployqt-${version}-x86_64.AppImage && \
    mv squashfs-root linuxdeployqt-${version} && \
    ln -s /opt/linuxdeployqt-${version}/AppRun /usr/local/bin/linuxdeployqt

# OpenCV
RUN version=3.4.8 && \
    yum install -y \
        libpng-devel \
        jasper-devel \
        libwebp-devel \
        libjpeg-turbo-devel \
        freeglut-devel \
        mesa-libGL-devel \
        libtiff-devel \
        libdc1394-devel \
        eigen3-devel \
        boost-devel \
        boost-thread \
        libv4l-devel \
        openblas-devel \
        lapack-devel \
        gstreamer-plugins-base-devel \
        tesseract-devel \
        harfbuzz-devel \
        && \
    yum clean all && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSL -o opencv-${version}.zip https://github.com/opencv/opencv/archive/${version}.zip && \
    unzip opencv-${version}.zip && \
    curl -sSL -o opencv_contrib-${version}.zip https://github.com/opencv/opencv_contrib/archive/${version}.zip && \
    unzip opencv_contrib-${version}.zip && \
    cd opencv-${version} && \
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig && \
    cmake -S. -B build -G Ninja \
        -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
        -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-${version}/modules \
        -D ENABLE_CXX11=ON \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_PACKAGE=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_DOCS=OFF \
        -D BUILD_opencv_apps= \
        -D BUILD_WITH_DEBUG_INFO=OFF \
        -D ENABLE_PROFILING=OFF \
        -D ENABLE_COVERAGE=OFF \
        -D OPENCV_ENABLE_NONFREE=OFF \
        -D WITH_OPENMP=ON \
        -D WITH_OPENCL=ON \
        -D WITH_IPP=OFF \
        -D WITH_CUDA=ON \
        -D WITH_CUBLAS=ON \
        -D CUDA_ARCH_BIN="61" \
        -D CUDA_ARCH_PTX="30 52 75" \
        -D BUILD_opencv_cudacodec=OFF \
        -D WITH_EIGEN=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_JASPER=ON -D BUILD_JASPER=OFF \
        -D WITH_JPEG=ON -D BUILD_JPEG=OFF \
        -D WITH_LAPACK=ON \
        -D WITH_MATLAB=OFF \
        -D WITH_OPENCLAMDBLAS=OFF \
        -D WITH_OPENEXR=OFF -D BUILD_OPENEXR=OFF \
        -D WITH_OPENGL=ON \
        -D WITH_PNG=ON -D BUILD_PNG=OFF \
        -D WITH_PROTOBUF=ON -D BUILD_PROTOBUF=OFF\
        -D WITH_QT=ON \
        -D WITH_TBB=OFF \
        -D WITH_TIFF=ON -D BUILD_TIFF=OFF \
        -D WITH_WEBP=ON -D BUILD_WEBP=OFF \
        -D WITH_ZLIB=ON -D BUILD_ZLIB=OFF \
        -D WITH_V4L=ON \
        && \
    ninja -C build install && \
    cd .. && \
    rm -rf opencv-${version}* opencv_contrib-${version}*

# MXNet
ENV MXNet_DIR /opt/mxnet-1.5.1
RUN version=1.5.1 && \
    source /etc/profile && \
    cd /opt && \
    curl -sSLO https://github.com/apache/incubator-mxnet/releases/download/${version}/apache-mxnet-src-${version}-incubating.tar.gz && \
    tar -xf apache-mxnet-src-${version}-incubating.tar.gz && \
    rm -f apache-mxnet-src-${version}-incubating.tar.gz && \
    mv apache-mxnet-src-${version}-incubating mxnet-${version} && \
    cd mxnet-${version} && \
    cmake  -S. -B build -G Ninja \
        -D CMAKE_CXX_STANDARD=14 -D USE_CXX14_IF_AVAILABLE=ON \
        -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D USE_CUDA=ON -D USE_CUDNN=ON -D USE_NCCL=OFF \
        -D CUDA_ARCH_NAME=Manual \
        -D CUDA_ARCH_BIN="61" \
        -D CUDA_ARCH_PTX="30 52 75" \
        -D USE_OPENCV=ON -D USE_OPENMP=ON \
        -D USE_LAPACK=ON -D USE_MKL_IF_AVAILABLE=OFF \
        -D USE_PROFILER=ON \
        -D USE_DIST_KVSTORE=OFF \
        -D USE_CPP_PACKAGE=ON \
        -D USE_SIGNAL_HANDLER=ON \
        -D ENABLE_CUDA_RTC=ON \
        -D BUILD_CPP_EXAMPLES=OFF \
        -D USE_GPERFTOOLS=OFF \
        -D USE_JEMALLOC=OFF \
        && \
    ninja -C build

# pybind11
RUN version=2.3.0 && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSL -o pybind11-${version}.tar.gz https://github.com/pybind/pybind11/archive/v${version}.tar.gz && \
    tar -xf pybind11-${version}.tar.gz && \
    cd pybind11-${version} && \
    cmake -S. -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DPYBIND11_TEST=off \
        && \
    ninja -C build install && \
    cd .. && \
    rm -rf pybind11-${version}*

# rpclib
RUN version=2.2.1 && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSL -o rpclib-${version}.tar.gz https://github.com/rpclib/rpclib/archive/v2.2.1.tar.gz && \
    tar -xf rpclib-${version}.tar.gz && \
    cd rpclib-${version} && \
    cmake -S. -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        && \
    ninja -C build install && \
    cd .. && \
    rm -rf rpclib-${version}*

# Python 3.7
RUN version=3.7.5 && \
    yum install -y \
        openssl-devel \
        libffi-devel \
        && \
    yum clean all && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSLO https://www.python.org/ftp/python/${version}/Python-${version}.tgz && \
    tar -xf Python-${version}.tgz && \
    cd Python-${version} && \
    ./configure \
        --prefix=/usr \
        --enable-optimizations \
        --enable-shared \
        --with-ensurepip=install \
        --with-system-expat \
        --with-system-ffi \
        && \
    make -j$(nproc) altinstall && \
    cd .. && \
    rm -rf Python-${version}* && \
    ldconfig

# pylon (Basler cameras)
RUN version=5.2.0.13457 && \
    cd /tmp && \
    curl -sSLO https://www.baslerweb.com/fp-1551786516/media/downloads/software/pylon_software/pylon-${version}-x86_64.tar.gz && \
    tar -xf pylon-${version}-x86_64.tar.gz && \
    cd pylon-${version}-x86_64 && \
    tar -xf pylonSDK-${version}-x86_64.tar.gz && \
    mv pylon5 /opt/pylon5 && \
    cd .. && \
    rm -rf pylon-${version}*
ADD bash/pylon.sh /etc/profile.d/pylon.sh

# CGAL
RUN version=4.14.2 && \
    yum install -y \
        gmp-devel \
        mpfr-devel \
        && \
    yum clean all && \
    source /etc/profile && \
    cd /tmp && \
    curl -sSLO https://github.com/CGAL/cgal/releases/download/releases/CGAL-${version}/CGAL-${version}.tar.xz && \
    tar -xf CGAL-${version}.tar.xz && \
    cd CGAL-${version} && \
    cmake -S. -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCGAL_HEADER_ONLY=ON \
        -DWITH_CGAL_Qt5=ON \
        && \
    ninja -C build install && \
    cd .. && \
    rm -rf CGAL-${version}*

# glm
RUN version=0.9.9.5 && \
    cd /tmp && \
    curl -sSLO https://github.com/g-truc/glm/releases/download/${version}/glm-${version}.zip && \
    unzip glm-${version}.zip && \
    cd glm && \
    cmake -S. -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        && \
    ninja -C build install && \
    cd .. && \
    rm -rf glm*

# SSL access to custom pypiserver
ADD agki-nas01.imp.fu-berlin.de-ca-cert.crt /etc/pki/ca-trust/source/anchors/agki-nas01.imp.fu-berlin.de-ca-cert.crt
RUN update-ca-trust

# Potential runtime dependencies for AppImages
RUN yum install -y \
        libxkbcommon-x11 \
        && \
    yum clean all

# Additional development dependencies
RUN yum install -y \
        git \
        libepoxy-devel \
        && \
    yum clean all && \
    python3.6 -m pip --no-cache-dir install \
        wheel \
        twine \
        && \
    python3.7 -m pip --no-cache-dir install \
        wheel \
        twine

ADD ldconfig/local.conf /etc/ld.so.conf.d/local.conf
RUN ldconfig
