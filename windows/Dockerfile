FROM microsoft/dotnet-framework:3.5-runtime-windowsservercore-ltsc2016

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy Bypass", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y visualstudio2017buildtools; \
    choco install -y visualstudio2017-workload-vctools; \
    Start-Process "\"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vs_installer.exe\"" -ArgumentList 'modify --installPath \"C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools\" --quiet --norestart --remove Microsoft.VisualStudio.Component.VC.CMake.Project' -NoNewWindow -Wait; \
    choco install -y cmake --version 3.12.2 --installargs "ADD_CMAKE_TO_PATH=System"; \
    choco install -y git 7zip; \
    (New-Object Net.WebClient).DownloadFile('https://github.com/Kitware/ninja/releases/download/v1.8.2.g972a7.kitware.dyndep-1/ninja-1.8.2.g972a7.kitware.dyndep-1_i686-pc-windows-msvc.zip', 'C:/ninja.zip'); \
    7z e C:/ninja.zip -oC:/ninja -y; \
    Remove-Item C:/ninja.zip -Force; \
    [Environment]::SetEnvironmentVariable('PATH', "$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))" + ';C:/ninja', [EnvironmentVariableTarget]::Machine)

COPY qtifwsilent.qs C:/qtifwsilent.qs
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://download.qt.io/official_releases/qt/5.11/5.11.1/qt-opensource-windows-x86-5.11.1.exe', 'C:/qt.exe'); \
    $Env:QT_INSTALL_DIR = 'C:/Qt'; \
    Start-Process C:/qt.exe -ArgumentList '--verbose --script C:/qtifwsilent.qs' -NoNewWindow -Wait; \
    Remove-Item C:/qtifwsilent.qs -Force; \
    Remove-Item C:/qt.exe -Force; \
    [Environment]::SetEnvironmentVariable('Qt5_DIR', 'C:/Qt/5.11.1/msvc2017_64', [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('EGL_PLATFORM_DIR', 'C:/Qt/5.11.1/msvc2017_64/include/QtANGLE', [EnvironmentVariableTarget]::Machine)

RUN choco install -y python --version 3.6.6; \
    $Env:PATH = "\"$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::User));$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))\""; \
    python -m pip --no-cache-dir install --no-warn-script-location \
        wheel \
        twine;

RUN $vcpkg_dir = 'C:/vcpkg'; \
    git clone --depth=1 https://github.com/BioroboticsLab/RF_vcpkg.git $vcpkg_dir; \
    cd $vcpkg_dir; \
    git checkout 247c77cbdee32767707f0390e1b4b4d16c2a9fef; \
    ./scripts/bootstrap.ps1; \
    [Environment]::SetEnvironmentVariable('VCPKG_DIR', "\"$vcpkg_dir\"", [EnvironmentVariableTarget]::Machine);

RUN cd $Env:VCPKG_DIR; \
    $vcpkg_triplet = 'x64-windows'; \
    ./vcpkg install \
        zlib:$vcpkg_triplet \
        libepoxy[egl]:$vcpkg_triplet \
        glm:$vcpkg_triplet \
        cgal:$vcpkg_triplet \
        hdf5:$vcpkg_triplet \
        openblas:$vcpkg_triplet \
        pybind11:$vcpkg_triplet; \
    ./vcpkg install opencv:$vcpkg_triplet; \
    ./vcpkg install mxnet[cpp,opencv]:$vcpkg_triplet; \
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

RUN choco install -y \
    wixtoolset
