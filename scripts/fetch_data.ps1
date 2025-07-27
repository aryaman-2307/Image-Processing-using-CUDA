$ErrorActionPreference = "Stop"
$target = "data/sample_images"
New-Item -ItemType Directory -Force -Path $target | Out-Null

for ($i = 1; $i -le 155; $i++) {
    $idx  = "{0:d3}" -f $i
    $url  = "http://sipi.usc.edu/database/preview/texture/$idx/$idx.png"
    Write-Host "Downloading $idx.png"
    Invoke-WebRequest -Uri $url -OutFile "$target/$idx.png"
}
Write-Host "`n 155 images downloaded to $target"
