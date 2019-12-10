# SPDX-License-Identifier: AGPL-3.0-or-later

ls "$pshome/profile.d/*.ps1" | % { . $_.FullName }
