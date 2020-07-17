#requires -version 2

param(
  [Switch] $Debug
)

function Start-Command {
  [CmdletBinding()]
  param(
    [String]
    $commandName,

    [String[]]
    $commandArgs
  )
  $OFS = " "
  & $commandName $commandArgs
}

$windres = (Get-Command "windres.exe" -ErrorAction Stop).Path

$sourceName = "getargs"

$platforms = "x86","x64"
foreach ( $platform in $platforms ) {
  if ( $platform -eq "x86" ) {
    $compiler = "fpc"
  }
  elseif ( $platform -eq "x64" ) {
    $compiler = "ppcrossx64"
  }
  Get-Command $compiler -ErrorAction Stop | Out-Null

  # console
  & $windres -i ("{0}.rc" -f $sourceName) -o ("{0}.res" -f $sourceName)
  $params = @(
    "-CX",("-FE{0}" -f $platform),"-O3","-Xs","-XX"
  )
  if ( $Debug ) {
    $params += "-dDEBUG","-gh","-gl"
  }
  $params += ("-o{0}.exe" -f $sourceName),("{0}.pp" -f $sourceName)
  Start-Command $compiler $params
  if ( $LASTEXITCODE -ne 0 ) { break }

  # GUI
  & $windres -i ("{0}g.rc" -f $sourceName) -o ("{0}g.res" -f $sourceName)
  $params = @(
    "-CX",("-FE{0}" -f $platform),"-O3","-Xs","-XX","-dGUI"
  )
  if ( $Debug ) {
    $params += "-dDEBUG","-gh","-gl"
  }
  $params += ("-o{0}g.exe" -f $sourceName),("{0}.pp" -f $sourceName)
  Start-Command $compiler $params
  if ( $LASTEXITCODE -ne 0 ) { break }
}
