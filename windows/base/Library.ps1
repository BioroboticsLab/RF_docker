
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
