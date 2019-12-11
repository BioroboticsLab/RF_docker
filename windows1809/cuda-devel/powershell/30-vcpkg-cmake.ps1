# SPDX-License-Identifier: AGPL-3.0-or-later

#
# Executes CMake with vcpkg toolchain file
#
function Vcpkg-CMake {
	if ($args[0] -eq "--build") {
		Must-Run "/Program Files/CMake/bin/cmake.exe" $args
	} else {
		Must-Run "/Program Files/CMake/bin/cmake.exe" '-DCMAKE_TOOLCHAIN_FILE=${venv:CMAKE_TOOLCHAIN_FILE}' "-DVCPKG_TARGET_TRIPLET=${env:VCPKG_TARGET_TRIPLET}" $args
	}
}

# Use vcpkg-cmake by default
Set-Alias -Name cmake -Value Vcpkg-CMake
