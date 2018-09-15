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

RUN git clone --depth=1 https://github.com/BioroboticsLab/RF_vcpkg.git C:/vcpkg; \
    cd C:/vcpkg; \
    git checkout 247c77cbdee32767707f0390e1b4b4d16c2a9fef; \
    ./scripts/bootstrap.ps1

RUN cd C:/vcpkg; \
    ./vcpkg install \
        zlib:x64-windows \
        libepoxy[egl]:x64-windows \
        glm:x64-windows \
        cgal:x64-windows \
        hdf5:x64-windows \
        openblas:x64-windows \
        pybind11:x64-windows; \
    ./vcpkg install opencv:x64-windows; \
    ./vcpkg install mxnet[cpp,opencv]:x64-windows; \
    Remove-Item -Recurse -Force -Path C:/vcpkg/downloads; \
    Remove-Item -Recurse -Force -Path C:/vcpkg/buildtrees; \
    Remove-Item -Recurse -Force -Path C:/vcpkg/packages;

RUN python -m pip --no-cache-dir install --no-warn-script-location \
        numpy \
        scipy \
        matplotlib \
        pandas

RUN choco install -y \
    wixtoolset
