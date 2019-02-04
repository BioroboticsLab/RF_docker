FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

LABEL maintainer="Moritz Maxeiner <moritz.maxeiner@fu-berlin.de>"
LABEL authors="Moritz Maxeiner <moritz.maxeiner@fu-berlin.de>"

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    echo $TZ > /etc/timezone && \
    apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        gcc-8 g++-8 \
        ninja-build \
        curl \
        git \
        p7zip-full \
        file && \
    apt-get install -y \
        libgfortran3 \
        protobuf-compiler \
        graphviz \
        fuse \
        qt5-default \
        qtbase5-dev \
        qtmultimedia5-dev \
        libqt5charts5-dev \
        libboost-all-dev \
        libopenblas-dev \
        liblapack-dev \
        libcurl4-openssl-dev \
        libzmq3-dev \
        libprotobuf-dev \
        libepoxy-dev \
        libglm-dev \
        libegl1-mesa-dev \
        libcgal-dev \
        libcgal-qt5-dev \
        libjsoncpp-dev \
        libwebsocketpp-dev \
        libfreetype6-dev \
        libharfbuzz-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-distutils && \
    curl -sSL -o /usr/local/bin/linuxdeployqt https://github.com/probonopd/linuxdeployqt/releases/download/5/linuxdeployqt-5-x86_64.AppImage && \
    chmod +x /usr/local/bin/linuxdeployqt

RUN python3.6 -m pip --no-cache-dir install \
        graphviz \
        opencv-python \
        nose \
        nose-timer \
        pylint \
        requests \
        Pillow \
        wheel \
        twine \
        h5py \
        joblib \
        psutil

RUN cd /tmp && \
    curl -sSLO https://cmake.org/files/v3.13/cmake-3.13.3.tar.gz && \
    tar -xf cmake-3.13.3.tar.gz && \
    cd cmake-3.13.3 && \
    ./configure --prefix=/usr/local && \
    make install -j$(nproc --all) && \
    cd .. && \
    rm -rf cmake-3.13.3*

COPY hdf5-1.10.2-no-trailing-attributes.patch /tmp
RUN cd /tmp && \
    curl -sSLO https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.2/src/hdf5-1.10.2.tar.bz2 && \
    tar -xf hdf5-1.10.2.tar.bz2 && \
    cd hdf5-1.10.2 && \
    patch -p1 -i /tmp/hdf5-1.10.2-no-trailing-attributes.patch && \
    cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -G Ninja && \
    ninja -C build install && \
    cd .. && \
    rm -rf hdf5-1.10.2*

RUN cd /tmp && \
    curl -sSLO https://github.com/pybind/pybind11/archive/v2.2.4.tar.gz && \
    tar -xf v2.2.4.tar.gz && \
    cd pybind11-2.2.4 && \
    cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DPYBIND11_TEST=off -G Ninja && \
    ninja -C build install && \
    cd .. && \
    rm -f v2.2.4.tar.gz && \
    rm -rf pybind11-2.2.4

ADD agki-nas01.imp.fu-berlin.de-ca-cert.crt /usr/local/share/ca-certificates/agki-nas01.imp.fu-berlin.de-ca-cert.crt
RUN update-ca-certificates

RUN apt-get clean
COPY profile.sh /etc/profile.d/robofish.sh
