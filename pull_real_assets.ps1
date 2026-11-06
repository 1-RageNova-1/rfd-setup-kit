# Follows location URLs from temp_assets JSON and saves real files into AssetCache.
# Run this right after AssetsDownload.py — the signed links die after a bit.

$ErrorActionPreference = "Stop"

$temp = Join-Path $PSScriptRoot "temp_assets"
$out  = Join-Path $PSScriptRoot "AssetCache"

if (-not (Test-Path $temp)) {
    Write-Host "no temp_assets folder. run AssetsDownload.py first"
    exit 1
}

New-Item -ItemType Directory -Force -Path $out | Out-Null

$files = Get-ChildItem $temp -File
if ($files.Count -eq 0) {
    Write-Host "temp_assets is empty"
    exit 1
}

foreach ($f in $files) {
    $id = $f.Name
    try {
        $json = Get-Content $f.FullName -Raw | ConvertFrom-Json
    } catch {
        Write-Host "skip $id (not json)"
        continue
    }

    if (-not $json.location) {
        Write-Host "skip $id (no location field)"
        continue
    }

    Write-Host "fetching $id ..."
    try {
        Invoke-WebRequest -Uri $json.location -OutFile (Join-Path $out $id) -UserAgent "Roblox/WinInet"
        $len = (Get-Item (Join-Path $out $id)).Length
        Write-Host "  ok ($len bytes)"
        if ($len -lt 500) {
            Write-Host "  warning: tiny file, might still be a pointer or error page"
        }
    } catch {
        Write-Host "  fail: $_"
    }
}

Write-Host "`ndone. files are in $out"
