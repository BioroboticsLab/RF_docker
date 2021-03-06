# SPDX-License-Identifier: AGPL-3.0-or-later

#
# Sets up Visual Studio Development environment
#
function VSDevEnv {
    pushd "C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/Common7/Tools"
    cmd /c "VsDevCmd.bat $args & set" |
    foreach {
        if ($_ -match "=") {
            $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
        }
    }
    popd
}

