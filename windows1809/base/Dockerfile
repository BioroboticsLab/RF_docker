FROM microsoft/dotnet-framework:3.5-runtime-windowsservercore-ltsc2019

SHELL ["powershell", "-NoProfile", "-ExecutionPolicy Bypass", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y cmake --version 3.13.4 --installargs "ADD_CMAKE_TO_PATH=System"; \
    choco install -y kitware-ninja --version 1.8.2.8127911; \
    choco install -y \
        git \
        curl \
        7zip \
        wixtoolset; \
    choco install -y python --version 3.7.2; \
    $env:PATH = "\"$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::User));$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))\""; \
    python -m pip --no-cache-dir install --no-warn-script-location wheel; \
    choco install -y visualstudio2017buildtools; \
    choco install -y visualstudio2017-workload-vctools; \
    Start-Process "\"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vs_installer.exe\"" -NoNewWindow -Wait -ArgumentList 'modify --installPath \"C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools\" --quiet --norestart --remove Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.Tools.14.16 --add Microsoft.VisualStudio.Component.VC.ATL'
COPY Profile.ps1 C:/Users/ContainerAdministrator/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1

COPY qtifwsilent.qs C:/qtifwsilent.qs
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://download.qt.io/official_releases/qt/5.12/5.12.4/qt-opensource-windows-x86-5.12.4.exe', 'C:/qt.exe'); \
    $env:QT_INSTALL_DIR = 'C:/Qt'; \
    Start-Process C:/qt.exe -NoNewWindow -Wait -ArgumentList '--verbose --script C:/qtifwsilent.qs'; \
    Remove-Item -Force C:/qtifwsilent.qs; \
    Remove-Item -Force C:/qt.exe; \
    [Environment]::SetEnvironmentVariable('Qt5_DIR', 'C:/Qt/5.12.4/msvc2017_64', [EnvironmentVariableTarget]::Machine)

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://www.baslerweb.com/fp-1551786641/media/downloads/software/pylon_software/Basler_pylon_5.2.0.13457.exe', 'C:/Basler_pylon_5.2.0.13457.exe'); \
    Start-Process C:/Basler_pylon_5.2.0.13457.exe -NoNewWindow -Wait -ArgumentList '/quiet /install=SDKs /targetpath=C:/Pylon5'; \
    Remove-Item -Force C:/Basler_pylon_5.2.0.13457.exe; \
    [Environment]::SetEnvironmentVariable('Pylon5_DIR', 'C:/Pylon5/Development', [EnvironmentVariableTarget]::Machine);

RUN $vcpkg_dir = 'C:/vcpkg'; \
    git clone --depth=1 https://git.imp.fu-berlin.de/bioroboticslab/robofish/vcpkg.git $vcpkg_dir; \
    cd $vcpkg_dir; \
    git checkout eb5d273da698585ef24d0ef91be40e4d269cb04e; \
    ./scripts/bootstrap.ps1; \
    [Environment]::SetEnvironmentVariable('VCPKG_DIR', "\"$vcpkg_dir\"", [EnvironmentVariableTarget]::Machine);
