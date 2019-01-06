FROM microsoft/dotnet-framework:3.5-runtime-windowsservercore-ltsc2016

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy Bypass", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y visualstudio2017buildtools; \
    choco install -y visualstudio2017-workload-vctools; \
    Start-Process "\"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vs_installer.exe\"" -NoNewWindow -Wait -ArgumentList 'modify --installPath \"C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools\" --quiet --norestart --remove Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.Tools.14.16 --add Microsoft.VisualStudio.Component.VC.ATL'; \
    choco install -y cmake --version 3.13.1 --installargs "ADD_CMAKE_TO_PATH=System"; \
    choco install -y \
        git \
        curl \
        7zip \
        wixtoolset; \
    (New-Object Net.WebClient).DownloadFile('https://github.com/Kitware/ninja/releases/download/v1.8.2.g972a7.kitware.dyndep-1/ninja-1.8.2.g972a7.kitware.dyndep-1_i686-pc-windows-msvc.zip', 'C:/ninja.zip'); \
    7z e C:/ninja.zip -oC:/ninja -y; \
    Remove-Item -Force C:/ninja.zip; \
    [Environment]::SetEnvironmentVariable('PATH', "$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))" + ';C:/ninja', [EnvironmentVariableTarget]::Machine); \
    choco install -y python --version 3.7.1; \
    $env:PATH = "\"$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::User));$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))\""; \
    python -m pip --no-cache-dir install --no-warn-script-location wheel
COPY Profile.ps1 C:/Users/ContainerAdministrator/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1

COPY qtifwsilent.qs C:/qtifwsilent.qs
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://download.qt.io/official_releases/qt/5.11/5.11.2/qt-opensource-windows-x86-5.11.2.exe', 'C:/qt.exe'); \
    $env:QT_INSTALL_DIR = 'C:/Qt'; \
    Start-Process C:/qt.exe -NoNewWindow -Wait -ArgumentList '--verbose --script C:/qtifwsilent.qs'; \
    Remove-Item -Force C:/qtifwsilent.qs; \
    Remove-Item -Force C:/qt.exe; \
    [Environment]::SetEnvironmentVariable('Qt5_DIR', 'C:/Qt/5.11.2/msvc2017_64', [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('EGL_PLATFORM_DIR', 'C:/Qt/5.11.2/msvc2017_64/include/QtANGLE', [EnvironmentVariableTarget]::Machine)

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://www.baslerweb.com/fp-1535524585/media/downloads/software/pylon_software/Basler_pylon_5.1.0.12681.exe', 'C:/Basler_pylon_5.1.0.12681.exe'); \
    Start-Process C:/Basler_pylon_5.1.0.12681.exe -NoNewWindow -Wait -ArgumentList '/quiet /install=SDKs /targetpath=C:/Pylon5'; \
    Remove-Item -Force C:/Basler_pylon_5.1.0.12681.exe; \
    [Environment]::SetEnvironmentVariable('Pylon5_DIR', 'C:/Pylon5/Development', [EnvironmentVariableTarget]::Machine);

RUN $vcpkg_dir = 'C:/vcpkg'; \
    git clone --depth=1 https://git.imp.fu-berlin.de/bioroboticslab/robofish/vcpkg.git $vcpkg_dir; \
    cd $vcpkg_dir; \
    git checkout 2afab7acd3f8d7c7cf7046c032174af9cdbdbe2f; \
    ./scripts/bootstrap.ps1; \
    [Environment]::SetEnvironmentVariable('VCPKG_DIR', "\"$vcpkg_dir\"", [EnvironmentVariableTarget]::Machine);
