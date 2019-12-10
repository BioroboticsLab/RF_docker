# SPDX-License-Identifier: AGPL-3.0-or-later

#
# Executes CMake with vcpkg toolchain file
#
function vcpkg-cmake {
	Must-Run "Program Files/CMake/bin/cmake.exe" '-DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake'
}

# Use vcpkg-cmake by default
Set-Alias -Name cmake -Value vcpkg-cmake
