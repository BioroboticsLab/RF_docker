# SPDX-License-Identifier: MIT
ls "$pshome/profile.d/*.ps1" | % { . $_.FullName }
