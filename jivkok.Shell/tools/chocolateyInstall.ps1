$package = 'jivkok.Shell'

try {
  $git_exe = 'git.exe'
  if ((Get-Command $git_exe -ErrorAction SilentlyContinue) -eq $null) {
    if (Test-Path "${Env:ProgramFiles(x86)}\Git\bin\git.exe") {
      $git_exe = "${Env:ProgramFiles(x86)}\Git\bin\git.exe"
      } else {
        throw 'Could not find git.exe'
      }
  }

  $dotfiles = "$Home\dotfiles"

  if (Test-Path "$dotfiles\.git") {
    . $git_exe -C $dotfiles pull --quiet --prune --recurse-submodules 2> $null
    . $git_exe -C $dotfiles submodule init --quiet 2> $null
    . $git_exe -C $dotfiles submodule update --quiet --remote --recursive 2> $null
  } else {
    if (Test-Path $dotfiles) {
      if (Test-Path "$dotfiles.BACKUP") { Remove-Item "$dotfiles.BACKUP" -Recurse -Force }
      Rename-Item $dotfiles "$dotfiles.BACKUP" -Force
    }
    . $git_exe clone --quiet --recursive https://github.com/jivkok/dotfiles.git $dotfiles 2> $null
  }

  . "$dotfiles\setup_windows.ps1"
} catch {
  Write-ChocolateyFailure $package "$_"
  throw
}
