# SPDX-License-Identifier: AGPL-3.0-or-later

FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:base-windows1809

COPY opengl32.dll C:/Windows/System32/opengl32.dll
COPY glu32.dll C:/Windows/System32/glu32.dll
COPY ddraw.dll C:/Windows/System32/ddraw.dll
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
        "\"opencv3[ffmpeg,ximea,opengl,contrib,ipp,dnn]\"" \
        "\"mxnet[cpp,opencv]\""; \
    [Environment]::SetEnvironmentVariable('VCPKG_TRIPLET', "\"$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('CMAKE_TOOLCHAIN_FILE', "\"/vcpkg/scripts/buildsystems/vcpkg.cmake\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('VCPKG_TARGET_TRIPLET', "\"$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('VCPKG_INSTALL_DIR', "\"$env:VCPKG_DIR/installed/$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    Remove-Item -Force -Recurse ./downloads; \
    Remove-Item -Force -Recurse ./buildtrees; \
    Remove-Item -Force -Recurse ./packages;
ADD powershell/30-Vcpkg-CMake.ps1 /Windows/System32/WindowsPowerShell/v1.0/profile.d/30-Vcpkg-CMake.ps1
