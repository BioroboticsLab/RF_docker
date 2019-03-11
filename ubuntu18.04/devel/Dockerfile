FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:base-ubuntu18.04

RUN apt-get update && \
    apt-get install -y libopencv-dev && \
    cd /opt && \
    curl -sSLO https://github.com/apache/incubator-mxnet/releases/download/1.4.0/apache-mxnet-src-1.4.0-incubating.tar.gz && \
    tar -xf apache-mxnet-src-1.4.0-incubating.tar.gz --owner root --group root --no-same-owner && \
    rm -f apache-mxnet-src-1.4.0-incubating.tar.gz && \
    mv apache-mxnet-src-1.4.0-incubating mxnet-1.4.0 && \
    cd mxnet-1.4.0 && \
    cmake -Bbuild -H. \
        -DCMAKE_CXX_STANDARD=14 -DUSE_CXX14_IF_AVAILABLE=ON \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DUSE_CUDA=OFF -DUSE_CUDNN=OFF -DUSE_NCCL=OFF \
        -DUSE_OPENCV=ON -DUSE_OPENMP=ON \
        -DUSE_LAPACK=ON -DUSE_MKL_IF_AVAILABLE=OFF \
        -DUSE_DIST_KVSTORE=ON \
        -DUSE_CPP_PACKAGE=ON \
        -DUSE_SIGNAL_HANDLER=ON \
        -DENABLE_CUDA_RTC=OFF \
        -DBUILD_CPP_EXAMPLES=OFF \
        -DDO_NOT_BUILD_EXAMPLES=ON \
        -DUSE_GPERFTOOLS=OFF \
        -DUSE_JEMALLOC=OFF \
        -G Ninja && \
    ninja -C build && \
    cd python && \
    python3 setup.py install && \
    apt-get clean
ADD mxnet_profile.sh /etc/profile.d/mxnet.sh
