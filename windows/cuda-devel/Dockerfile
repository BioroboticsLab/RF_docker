FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:base-windows

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://developer.nvidia.com/compute/cuda/10.0/Prod/network_installers/cuda_10.0.130_win10_network', 'C:/cuda_10.0.130_win10_network.exe'); \
    (New-Object Net.WebClient).DownloadFile('http://developer.download.nvidia.com/compute/redist/cudnn/v7.4.1/cudnn-10.0-windows10-x64-v7.4.1.5.zip', 'C:/cudnn-10.0-windows10-x64-v7.4.1.5.zip'); \
    Start-Process C:/cuda_10.0.130_win10_network.exe -NoNewWindow -Wait -ArgumentList '-s nvcc_10.0 cublas_10.0 cublas_dev_10.0 cudart_10.0 cufft_10.0 cufft_dev_10.0 curand_10.0 curand_dev_10.0 cusolver_10.0 cusolver_dev_10.0 cusparse_10.0 cusparse_dev_10.0 npp_10.0 npp_dev_10.0 nvrtc_10.0 nvrtc_dev_10.0 nvml_dev_10.0'; \
    Remove-Item -Force C:/cuda_10.0.130_win10_network.exe; \
    7z x C:/cudnn-10.0-windows10-x64-v7.4.1.5.zip; \
    Copy-Item -Force -Recurse "./cuda/*" "$([Environment]::GetEnvironmentVariable('CUDA_PATH', [EnvironmentVariableTarget]::Machine))"; \
    Remove-Item -Force -Recurse "./cuda"; \
    Remove-Item -Force C:/cudnn-10.0-windows10-x64-v7.4.1.5.zip

COPY opengl32.dll C:/Windows/System32/opengl32.dll
COPY glu32.dll C:/Windows/System32/glu32.dll
COPY ddraw.dll C:/Windows/System32/ddraw.dll
COPY nvcuda.dll C:/Windows/System32/nvcuda.dll
RUN . $Profile; \
    cd $env:VCPKG_DIR; \
    $vcpkg_triplet = 'x64-windows-14.16'; \
    Must-Run ./vcpkg install \
        zlib:$vcpkg_triplet \
        libepoxy[egl]:$vcpkg_triplet \
        glm:$vcpkg_triplet \
        cgal:$vcpkg_triplet \
        hdf5:$vcpkg_triplet \
        openblas:$vcpkg_triplet \
        pybind11:$vcpkg_triplet \
        boost-program-options:$vcpkg_triplet \
        boost-bimap:$vcpkg_triplet \
        boost-property-tree:$vcpkg_triplet \
        jsoncpp:$vcpkg_triplet \
        websocketpp:$vcpkg_triplet; \
    Must-Run ./vcpkg install "\"opencv[cuda,ffmpeg,ximea,opengl,contrib,ipp,dnn]:$vcpkg_triplet\""; \
    Must-Run ./vcpkg install "\"mxnet[cpp,opencv,cuda,cudnn]:$vcpkg_triplet\""; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/flang.dll ./installed/$vcpkg_triplet/bin/; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/flangrti.dll ./installed/$vcpkg_triplet/bin/; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/libomp.dll ./installed/$vcpkg_triplet/bin/; \
    [Environment]::SetEnvironmentVariable('VCPKG_TRIPLET', "\"$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('VCPKG_INSTALL_DIR', "\"$env:VCPKG_DIR/installed/$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    Remove-Item -Force -Recurse ./downloads; \
    Remove-Item -Force -Recurse ./buildtrees; \
    Remove-Item -Force -Recurse ./packages;
