
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

#
# Sets exit to error when the command fails
#
function Must-Run {
  $command = $args[0]
  $arguments = $args[1..($args.Length)]
  & $command @arguments
  if (!$?) {
    $Host.SetShouldExit(1)
    Write-Error "Exit code $LastExitCode while running $command $arguments"
    Exit(1)
  }
}

#
# Fetches GitLab CI job artifacts
#
function GitLab-Fetch-Artifacts {
    & curl.exe -o artifacts.zip --header "JOB-TOKEN: $CI_JOB_TOKEN" "https://git.imp.fu-berlin.de/api/v4/projects/$($args[0])/jobs/artifacts/$($args[1])/download?job=$($args[2])"
    7z e artifacts.zip; Remove-Item -Force artifacts.zip
}

#
# Sets up a CMake package for find_package from a tarball without copying
#
function CMake-Integrate-Package {
    $name = $args[0]
    7z e $name-*.tar.xz; Remove-Item -Force $name-*.tar.xz
    7z x $name-*.tar; Remove-Item -Force $name-*.tar
    [Environment]::SetEnvironmentVariable("${name}_ROOT", "$(resolve-path $name-*)")
}

#
# Sets up a CMake package for find_package from a tarball
#
function CMake-Install-Package {
    $name = $args[0]
    7z e $name-*.tar.xz; Remove-Item -Force $name-*.tar.xz
    7z x $name-*.tar; Remove-Item -Force $name-*.tar
    Copy-Item -Recurse $name-* "C:/Program Files/"
    Remove-Item -Recurse -Force $name-*
}
