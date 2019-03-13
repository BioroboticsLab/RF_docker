FROM git.imp.fu-berlin.de:5000/bioroboticslab/robofish/docker:base-windows

COPY opengl32.dll C:/Windows/System32/opengl32.dll
COPY glu32.dll C:/Windows/System32/glu32.dll
COPY ddraw.dll C:/Windows/System32/ddraw.dll
RUN . $Profile; \
    cd $env:VCPKG_DIR; \
    $vcpkg_triplet = 'x64-windows-14.16'; \
    Must-Run ./vcpkg install \
        libepoxy:$vcpkg_triplet \
        glm:$vcpkg_triplet \
        cgal:$vcpkg_triplet \
        hdf5:$vcpkg_triplet \
        pybind11:$vcpkg_triplet \
        boost-program-options:$vcpkg_triplet \
        boost-property-tree:$vcpkg_triplet \
        jsoncpp:$vcpkg_triplet \
        websocketpp:$vcpkg_triplet \
        freetype:$vcpkg_triplet \
        harfbuzz:$vcpkg_triplet \
        "\"opencv[ffmpeg,ximea,opengl,contrib,ipp,dnn]:$vcpkg_triplet\"" \
        "\"mxnet[cpp,opencv]:$vcpkg_triplet\""; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/flang.dll ./installed/$vcpkg_triplet/bin/; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/flangrti.dll ./installed/$vcpkg_triplet/bin/; \
    Copy-Item ./downloads/tools/flang/5.0.0/Library/bin/libomp.dll ./installed/$vcpkg_triplet/bin/; \
    [Environment]::SetEnvironmentVariable('VCPKG_TRIPLET', "\"$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('VCPKG_INSTALL_DIR', "\"$env:VCPKG_DIR/installed/$vcpkg_triplet\"", [EnvironmentVariableTarget]::Machine); \
    Remove-Item -Force -Recurse ./downloads; \
    Remove-Item -Force -Recurse ./buildtrees; \
    Remove-Item -Force -Recurse ./packages;
