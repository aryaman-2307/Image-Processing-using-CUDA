<#
Downloads the USC‑SIPI Textures volume (155 images, 30 MB),
extracts it to data\sample_images\ and deletes the zip.

If sipi.usc.edu is unreachable, it automatically falls back to
a GitHub mirror that contains the same 155 PNGs.
#>

param(
    [string]$Dest = "data\sample_images"
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$zipPath = "data\textures.zip"
$sipi    = "https://sipi.usc.edu/database/textures.zip"
$mirror  = "https://github.com/orukundo/Modified-USC-SIPI-Image-Database/archive/refs/heads/master.zip"

New-Item -ItemType Directory -Force -Path (Split-Path $zipPath) | Out-Null
New-Item -ItemType Directory -Force -Path $Dest               | Out-Null

function Download-Zip($url) {
    Write-Host "→ Downloading $url ..."
    Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
}

try   { Download-Zip $sipi }
catch {
    Write-Warning "SIPI server unreachable – using GitHub mirror"
    Download-Zip $mirror
}

Write-Host "→ Extracting ..."
Expand-Archive -Path $zipPath -DestinationPath $Dest -Force

# The GitHub mirror puts images under an extra folder;
# move *.png up one level if necessary.
Get-ChildItem -Path $Dest -Recurse -Filter *.png |
    ForEach-Object {
        if ($_.Directory.FullName -ne (Resolve-Path $Dest).Path) {
            Move-Item $_.FullName $Dest
        }
    }

Remove-Item $zipPath
$cnt = (Get-ChildItem $Dest -Filter *.png).Count
Write-Host " $cnt images ready in $Dest"
