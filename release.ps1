#requires -version 3

$SevenZip = Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles)) "7-Zip\7z.exe"
if ( -not (Test-Path $SevenZip) ) {
  throw "File not found - '$SevenZip'"
}

$BinaryPath  = Join-Path $PSScriptRoot "x86\getargs.exe"
if ( -not (Test-Path $BinaryPath) ) {
  throw "File not found - '$BinaryPath'"
}
$VersionInfo = (Get-Item $BinaryPath).VersionInfo

$Version = "{0}.{1}" -f $VersionInfo.FileMajorPart,$VersionInfo.FileMinorPart

$SourceFiles = Get-Content (Join-Path $PSScriptRoot "source.txt") -ErrorAction Stop

$ReleaseDir = Join-Path $PSScriptRoot "release"

if ( -not (Test-Path $ReleaseDir) ) {
  New-Item $ReleaseDir -ItemType Directory -ErrorAction Stop | Out-Null
}

# Clean release dir
Remove-Item (Join-Path $ReleaseDir "*") -Recurse -Force -ErrorAction Stop

# Update release dir
$Platforms = @("x64","x86")
foreach ( $Platform in $Platforms ) {
  $TargetDir = New-Item (Join-Path $ReleaseDir $Platform) -ItemType Directory -ErrorAction Stop
  Get-ChildItem (Join-Path $PSScriptRoot "$Platform\getargs*.exe") | ForEach-Object {
    Copy-Item $_ $TargetDir -ErrorAction Stop
  }
}
$SourceFiles | ForEach-Object {
  Copy-Item (Join-Path $PSScriptRoot $_) $ReleaseDir -ErrorAction Stop
}

# Remove zip file if it exists
$ZipName = Join-Path $PSScriptRoot ("getargs-{0}.zip" -f $Version)
if ( Test-Path $ZipName ) { Remove-Item $ZipName }

# Build zip file
Push-Location $ReleaseDir
& $SevenZip a -bb1 -stl -mx=7 $ZipName
Pop-Location
