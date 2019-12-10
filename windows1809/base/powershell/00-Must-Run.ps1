# SPDX-License-Identifier: MIT

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
