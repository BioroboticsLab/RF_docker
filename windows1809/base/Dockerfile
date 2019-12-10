# SPDX-License-Identifier: AGPL-3.0-or-later

FROM microsoft/dotnet-framework:3.5-runtime-windowsservercore-ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
RUN mkdir $PSHome/profile.d | out-null
ADD powershell/Profile.ps1 /Windows/System32/WindowsPowerShell/v1.0/Profile.ps1

ADD powershell/00-Must-Run.ps1 /Windows/System32/WindowsPowerShell/v1.0/profile.d/00-Must-Run.ps1
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    Must-Run choco install -y dotnetfx --version 4.7.2.20180712; \
    Must-Run choco install -y cmake --version 3.15.5 --installargs "ADD_CMAKE_TO_PATH=System"; \
    Must-Run choco install -y kitware-ninja --version 1.8.2.8127911; \
    Must-Run choco install -y \
        git \
        curl \
        7zip \
        wixtoolset; \
    Must-Run choco install -y python --version 3.7.5; \
    $env:PATH = "\"$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::User));$([Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine))\""; \
    Must-Run python -m pip --no-cache-dir install --no-warn-script-location wheel; \
    Must-Run choco install -y visualstudio2017buildtools; \
    Must-Run choco install -y visualstudio2017-workload-vctools; \
    Start-Process "\"C:/Program Files (x86)/Microsoft Visual Studio/Installer/vs_installer.exe\"" -NoNewWindow -Wait -ArgumentList 'modify --installPath \"C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools\" --quiet --norestart --remove Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.Tools.14.16 --add Microsoft.VisualStudio.Component.VC.ATL'
ADD powershell/10-VSDevEnv.ps1 /Windows/System32/WindowsPowerShell/v1.0/profile.d/10-VSDevEnv.ps1
ADD powershell/20-MSVC-15.9.ps1 /Windows/System32/WindowsPowerShell/v1.0/profile.d/20-MSVC-15.9.ps1

COPY qtifwsilent.qs C:/qtifwsilent.qs
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://download.qt.io/official_releases/qt/5.12/5.12.6/qt-opensource-windows-x86-5.12.6.exe', 'C:/qt.exe'); \
    $env:QT_INSTALL_DIR = 'C:/Qt'; \
    Start-Process C:/qt.exe -NoNewWindow -Wait -ArgumentList '--verbose --script C:/qtifwsilent.qs'; \
    Remove-Item -Force C:/qtifwsilent.qs; \
    Remove-Item -Force C:/qt.exe; \
    [Environment]::SetEnvironmentVariable('Qt5_DIR', 'C:/Qt/5.12.6/msvc2017_64', [EnvironmentVariableTarget]::Machine)

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    (New-Object Net.WebClient).DownloadFile('https://www.baslerweb.com/fp-1551786641/media/downloads/software/pylon_software/Basler_pylon_5.2.0.13457.exe', 'C:/Basler_pylon_5.2.0.13457.exe'); \
    Start-Process C:/Basler_pylon_5.2.0.13457.exe -NoNewWindow -Wait -ArgumentList '/quiet /install=SDKs /targetpath=C:/Pylon5'; \
    Remove-Item -Force C:/Basler_pylon_5.2.0.13457.exe; \
    [Environment]::SetEnvironmentVariable('Pylon5_DIR', 'C:/Pylon5/Development', [EnvironmentVariableTarget]::Machine);

RUN $vcpkg_dir = 'C:/vcpkg'; \
    git clone https://git.imp.fu-berlin.de/bioroboticslab/robofish/vcpkg.git $vcpkg_dir; \
    cd $vcpkg_dir; \
    git checkout c05eb1ab83ddb9d4799fb9f3cd10bb385f05469b; \
    ./scripts/bootstrap.ps1; \
    [Environment]::SetEnvironmentVariable('VCPKG_DIR', "\"$vcpkg_dir\"", [EnvironmentVariableTarget]::Machine);
ADD powershell/30-vcpkg-cmake.ps1 /Windows/System32/WindowsPowerShell/v1.0/profile.d/30-vcpkg-cmake.ps1
