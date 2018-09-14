FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu18.04

LABEL maintainer="Moritz Maxeiner <moritz.maxeiner@fu-berlin.de>"
LABEL authors="Moritz Maxeiner <moritz.maxeiner@fu-berlin.de>"

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common

RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y

RUN apt-get update

RUN echo $TZ > /etc/timezone && \
    apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y --no-install-recommends \
        build-essential \
        pkg-config \
        gcc-8 g++-8 \
        ninja-build \
        curl \
        git \
        libboost-all-dev

RUN apt-get install -y \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-distutils

RUN cd /tmp && \
    curl -sSLO https://cmake.org/files/v3.12/cmake-3.12.0.tar.gz && \
    tar -xf cmake-3.12.0.tar.gz && \
    cd cmake-3.12.0 && \
    ./configure --prefix=/usr/local && \
    make install -j$(nproc --all) && \
    cd .. && \
    rm -rf cmake-3.12.0*

RUN apt-get install -y \
        libopenblas-dev \
        liblapack-dev \
        libopencv-dev \
        libcurl4-openssl-dev \
        libzmq3-dev \
        libprotobuf-dev \
        protobuf-compiler \
        python-opencv \
        libgfortran3 \
        graphviz

RUN python3.6 -m pip --no-cache-dir install \
        graphviz \
        nose \
        nose-timer \
        pylint \
        requests \
        Pillow \
        wheel \
        twine

RUN cd /opt && \
    curl -sSLO https://github.com/apache/incubator-mxnet/releases/download/1.2.1/apache-mxnet-src-1.2.1-incubating.tar.gz && \
    tar -xf apache-mxnet-src-1.2.1-incubating.tar.gz && \
    rm -f apache-mxnet-src-1.2.1-incubating.tar.gz && \
    mv apache-mxnet-src-1.2.1-incubating mxnet-1.2.1 && \
    cd mxnet-1.2.1 && \
    cmake -Bbuild -H. \
        -DCMAKE_CXX_STANDARD=14 -DUSE_CXX14_IF_AVAILABLE=ON \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DUSE_CUDA=ON -DUSE_CUDNN=ON -DUSE_NCCL=ON \
        -DUSE_OPENCV=ON -DUSE_OPENMP=ON \
        -DUSE_LAPACK=ON -DUSE_MKL_IF_AVAILABLE=OFF \
        -DUSE_DIST_KVSTORE=ON \
        -DUSE_CPP_PACKAGE=ON \
        -DUSE_SIGNAL_HANDLER=ON \
        -DENABLE_CUDA_RTC=ON \
        -DBUILD_CPP_EXAMPLES=OFF \
        -DUSE_GPERFTOOLS=OFF \
        -DUSE_JEMALLOC=OFF \
        -G Ninja && \
    ninja -C build && \
    cd python && \
    python3 setup.py install

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
    curl -sSLO https://github.com/pybind/pybind11/archive/v2.2.3.tar.gz && \
    tar -xf v2.2.3.tar.gz && \
    cd pybind11-2.2.3 && \
    cmake -Bbuild -H. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DPYBIND11_TEST=off -G Ninja && \
    ninja -C build install && \
    cd .. && \
    rm -f v2.2.3.tar.gz && \
    rm -rf pybind11-2.2.3

RUN apt-get install -y \
        libepoxy-dev \
        libglm-dev \
        libegl1-mesa-dev \
        libcgal-dev \
        libcgal-qt5-dev \
        qtbase5-dev \
        qtmultimedia5-dev \
        libqt5charts5-dev

RUN python3.6 -m pip --no-cache-dir install \
        numpy \
        scipy \
        matplotlib \
        pandas \
        jupyterlab


RUN apt-get install -y  openssh-server && \
    mkdir -p /var/run/sshd && \
    mkdir /root/.ssh && \
    chmod 700 /root/.ssh && \
    touch /root/.ssh/authorized_keys

RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8 en_GB.UTF-8

RUN apt-get install -y \
        file \
        p7zip

COPY jupyter_notebook_config.py /root/.jupyter/
ADD mxnet_profile.sh /etc/profile.d/mxnet.sh
COPY launch.sh /sbin
COPY sshd_config /etc/ssh/sshd_config

RUN apt-get clean

WORKDIR "/root"
ENTRYPOINT [ "/sbin/launch.sh" ]
CMD [ "sshd" ]

EXPOSE 22
EXPOSE 8080
