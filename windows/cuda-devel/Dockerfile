FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:base-windows

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://developer.nvidia.com/compute/cuda/9.2/Prod2/network_installers2/cuda_9.2.148_win10_network', 'C:/cuda_9.2.148_win10_network.exe'); \
    (New-Object Net.WebClient).DownloadFile('https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_windows', 'C:/cuda_9.2.148.1_windows.exe'); \
    (New-Object Net.WebClient).DownloadFile('http://developer.download.nvidia.com/compute/redist/cudnn/v7.1.4/cudnn-9.2-windows10-x64-v7.1.zip', 'C:/cudnn-9.2-windows10-x64-v7.1.zip'); \
    Start-Process C:/cuda_9.2.148_win10_network.exe -NoNewWindow -Wait -ArgumentList '-s nvcc_9.2 cublas_9.2 cublas_dev_9.2 cudart_9.2 cufft_9.2 cufft_dev_9.2 curand_9.2 curand_dev_9.2 cusolver_9.2 cusolver_dev_9.2 cusparse_9.2 cusparse_dev_9.2 npp_9.2 npp_dev_9.2 nvrtc_9.2 nvrtc_dev_9.2 nvml_dev_9.2'; \
    Remove-Item -Force C:/cuda_9.2.148_win10_network.exe; \
    Start-Process C:/cuda_9.2.148.1_windows.exe -NoNewWindow -Wait -ArgumentList '-s cublas_9.2 cublas_dev_9.2'; \
    Remove-Item -Force C:/cuda_9.2.148.1_windows.exe; \
    7z x C:/cudnn-9.2-windows10-x64-v7.1.zip; \
    Copy-Item -Force -Recurse "./cuda/*" "$([Environment]::GetEnvironmentVariable('CUDA_PATH', [EnvironmentVariableTarget]::Machine))"; \
    Remove-Item -Force -Recurse "./cuda"; \
    Remove-Item -Force C:/cudnn-9.2-windows10-x64-v7.1.zip

COPY opengl32.dll C:/Windows/System32/opengl32.dll
COPY glu32.dll C:/Windows/System32/glu32.dll
COPY ddraw.dll C:/Windows/System32/ddraw.dll
COPY nvcuda.dll C:/Windows/System32/nvcuda.dll
RUN . /Library.ps1; \
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
