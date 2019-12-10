FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:base-windows1809

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://developer.download.nvidia.com/compute/cuda/10.1/Prod/network_installers/cuda_10.1.243_win10_network.exe', 'C:/cuda_10.1.243_win10_network.exe'); \
    (New-Object Net.WebClient).DownloadFile('https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.1/cudnn-10.1-windows10-x64-v7.6.1.34.zip', 'C:/cudnn-10.1-windows10-x64-v7.6.1.34.zip'); \
    Start-Process C:/cuda_10.1.243_win10_network.exe -NoNewWindow -Wait -ArgumentList '-s nvcc_10.1 cublas_10.1 cublas_dev_10.1 cudart_10.1 cufft_10.1 cufft_dev_10.1 curand_10.1 curand_dev_10.1 cusolver_10.1 cusolver_dev_10.1 cusparse_10.1 cusparse_dev_10.1 npp_10.1 npp_dev_10.1 nvrtc_10.1 nvrtc_dev_10.1 nvml_dev_10.1'; \
    Remove-Item -Force C:/cuda_10.1.243_win10_network.exe; \
    7z x C:/cudnn-10.1-windows10-x64-v7.6.1.34.zip; \
    Copy-Item -Force -Recurse "./cuda/*" "$([Environment]::GetEnvironmentVariable('CUDA_PATH', [EnvironmentVariableTarget]::Machine))"; \
    Remove-Item -Force -Recurse "./cuda"; \
    Remove-Item -Force C:/cudnn-10.1-windows10-x64-v7.6.1.34.zip

COPY opengl32.dll C:/Windows/System32/opengl32.dll
COPY glu32.dll C:/Windows/System32/glu32.dll
COPY ddraw.dll C:/Windows/System32/ddraw.dll
COPY nvcuda.dll C:/Windows/System32/nvcuda.dll
RUN cd $env:VCPKG_DIR; \
    $vcpkg_triplet = 'x64-windows-14.16'; \
    Must-Run ./vcpkg install --triplet "$vcpkg_triplet"  \
        libepoxy \
        glm \
        cgal \
        "\"hdf5[cpp]\"" \
        pybind11 \
        boost-program-options \
        boost-property-tree \
        boost-circular-buffer \
        boost-timer \
        jsoncpp \
        websocketpp \
        freetype \
        harfbuzz \
        rpclib \
        eigen3 \
        "\"opencv3[cuda,ffmpeg,ximea,opengl,contrib,ipp,dnn]\"" \
        "\"mxnet[cpp,opencv,cuda,cudnn]\""; \
    [Environment]::SetEnvironmentVariable('VCPKG_TRIPLET', "\"$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('VCPKG_INSTALL_DIR', "\"$env:VCPKG_DIR/installed/$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    Remove-Item -Force -Recurse ./downloads; \
    Remove-Item -Force -Recurse ./buildtrees; \
    Remove-Item -Force -Recurse ./packages;
