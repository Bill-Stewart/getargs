#requires -version 3

$dirs = @(
  "x64"
  "x86"
)
foreach ( $dir in $dirs ) {
  Get-ChildItem -File $dir | Remove-Item -Verbose
}
