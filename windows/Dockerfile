FROM microsoft/dotnet-framework:3.5-runtime-windowsservercore-ltsc2016

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy Bypass", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y visualstudio2017buildtools; \
    choco install -y visualstudio2017-workload-vctools; \
    Start-Process "\"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vs_installer.exe\"" -NoNewWindow -Wait -ArgumentList 'modify --installPath \"C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools\" --quiet --norestart --remove Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.Tools.14.13'; \
    choco install -y cmake --version 3.12.2 --installargs "ADD_CMAKE_TO_PATH=System"; \
    choco install -y \
        git \
        curl \
        7zip \
        wixtoolset; \
    (New-Object Net.WebClient).DownloadFile('https://github.com/Kitware/ninja/releases/download/v1.8.2.g972a7.kitware.dyndep-1/ninja-1.8.2.g972a7.kitware.dyndep-1_i686-pc-windows-msvc.zip', 'C:/ninja.zip'); \
    7z e C:/ninja.zip -oC:/ninja -y; \
    Remove-Item C:/ninja.zip -Force; \
    [Environment]::SetEnvironmentVariable('PATH', "$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))" + ';C:/ninja', [EnvironmentVariableTarget]::Machine); \
    choco install -y python --version 3.6.6; \
    $Env:PATH = "\"$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::User));$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))\""; \
    python -m pip --no-cache-dir install --no-warn-script-location \
        wheel \
        twine
COPY VsDevEnv.ps1 C:/VsDevEnv.ps1

RUN curl.exe -L -o C:/cuda_9.2.148_win10_network.exe https://developer.nvidia.com/compute/cuda/9.2/Prod2/network_installers2/cuda_9.2.148_win10_network; \
    Start-Process C:/cuda_9.2.148_win10_network.exe -NoNewWindow -Wait -ArgumentList '-s nvcc_9.2 cublas_9.2 cublas_dev_9.2 cudart_9.2 cufft_9.2 cufft_dev_9.2 curand_9.2 curand_dev_9.2 cusolver_9.2 cusolver_dev_9.2 cusparse_9.2 cusparse_dev_9.2 npp_9.2 npp_dev_9.2 nvrtc_9.2 nvrtc_dev_9.2 nvml_dev_9.2'; \
    Remove-Item C:/cuda_9.2.148_win10_network.exe -Force; \
    curl.exe -L -o C:/cuda_9.2.148.1_windows.exe https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_windows; \
    Start-Process C:/cuda_9.2.148.1_windows.exe -NoNewWindow -Wait -ArgumentList '-s cublas_9.2 cublas_dev_9.2'; \
    Remove-Item C:/cuda_9.2.148.1_windows.exe -Force; \
    curl.exe -L -o C:/cudnn-9.2-windows10-x64-v7.1.zip http://developer.download.nvidia.com/compute/redist/cudnn/v7.1.4/cudnn-9.2-windows10-x64-v7.1.zip; \
    7z x C:/cudnn-9.2-windows10-x64-v7.1.zip; \
    Copy-Item -Recurse -Force "./cuda/*" "$([Environment]::GetEnvironmentVariable('CUDA_PATH', [EnvironmentVariableTarget]::Machine))"; \
    Remove-Item -Recurse -Force "./cuda"; \
    Remove-Item -Force C:/cudnn-9.2-windows10-x64-v7.1.zip

COPY qtifwsilent.qs C:/qtifwsilent.qs
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://download.qt.io/official_releases/qt/5.11/5.11.1/qt-opensource-windows-x86-5.11.1.exe', 'C:/qt.exe'); \
    $Env:QT_INSTALL_DIR = 'C:/Qt'; \
    Start-Process C:/qt.exe -ArgumentList '--verbose --script C:/qtifwsilent.qs' -NoNewWindow -Wait; \
    Remove-Item C:/qtifwsilent.qs -Force; \
    Remove-Item C:/qt.exe -Force; \
    [Environment]::SetEnvironmentVariable('Qt5_DIR', 'C:/Qt/5.11.1/msvc2017_64', [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('EGL_PLATFORM_DIR', 'C:/Qt/5.11.1/msvc2017_64/include/QtANGLE', [EnvironmentVariableTarget]::Machine)

RUN curl.exe -L -o C:/Basler_pylon_5.1.0.12681.exe https://www.baslerweb.com/fp-1535524585/media/downloads/software/pylon_software/Basler_pylon_5.1.0.12681.exe; \
    Start-Process C:/Basler_pylon_5.1.0.12681.exe -NoNewWindow -Wait -ArgumentList '/quiet /install=SDKs /targetpath=C:/Pylon5'; \
    Remove-Item -Force C:/Basler_pylon_5.1.0.12681.exe; \
    [Environment]::SetEnvironmentVariable('Pylon5_DIR', 'C:/Pylon5/Development', [EnvironmentVariableTarget]::Machine);

RUN $vcpkg_dir = 'C:/vcpkg'; \
    git clone --depth=1 https://github.com/BioroboticsLab/RF_vcpkg.git $vcpkg_dir; \
    cd $vcpkg_dir; \
    git checkout 247c77cbdee32767707f0390e1b4b4d16c2a9fef; \
    ./scripts/bootstrap.ps1; \
    [Environment]::SetEnvironmentVariable('VCPKG_DIR', "\"$vcpkg_dir\"", [EnvironmentVariableTarget]::Machine);

COPY opengl32.dll C:/Windows/System32/opengl32.dll
COPY nvcuda.dll C:/Windows/System32/nvcuda.dll
RUN cd $Env:VCPKG_DIR; \
    $vcpkg_triplet = 'x64-windows-14.13'; \
    ./vcpkg install \
        zlib:$vcpkg_triplet \
        libepoxy[egl]:$vcpkg_triplet \
        glm:$vcpkg_triplet \
        cgal:$vcpkg_triplet \
        hdf5:$vcpkg_triplet \
        openblas:$vcpkg_triplet \
        pybind11:$vcpkg_triplet; \
    ./vcpkg install opencv[ffmpeg,ximea,cuda]:$vcpkg_triplet; \
    ./vcpkg install mxnet[cpp,opencv,cuda,cudnn]:$vcpkg_triplet; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/flang.dll ./installed/$vcpkg_triplet/bin/; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/flangrti.dll ./installed/$vcpkg_triplet/bin/; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/libomp.dll ./installed/$vcpkg_triplet/bin/; \
    Remove-Item -Recurse -Force -Path ./downloads; \
    Remove-Item -Recurse -Force -Path ./buildtrees; \
    Remove-Item -Recurse -Force -Path ./packages; \
    [Environment]::SetEnvironmentVariable('VCPKG_TRIPLET', "\"$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('VCPKG_INSTALL_DIR', "\"$Env:VCPKG_DIR/installed/$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine);

RUN python -m pip --no-cache-dir install --no-warn-script-location \
        numpy \
        scipy \
        matplotlib \
        pandas
