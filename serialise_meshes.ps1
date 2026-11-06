# Converts AssetCache files to 2021-friendly meshes using RFD source.
# Set $SourceDir to your rfd-source\Source folder.

$SourceDir = "C:\rfd-source\Source"   # <-- change this
$CacheDir  = Join-Path $PSScriptRoot "AssetCache"

# only these ids, or leave empty to try everything in AssetCache
$OnlyIds = @(
    # "107953688200475",
    # "110641361449817",
)

if (-not (Test-Path (Join-Path $SourceDir "_main.py"))) {
    Write-Host "cant find _main.py in $SourceDir"
    Write-Host "clone the RFD repo and point SourceDir at the Source folder"
    exit 1
}

if (-not (Test-Path $CacheDir)) {
    Write-Host "no AssetCache folder"
    exit 1
}

Push-Location $SourceDir
try {
    $targets = if ($OnlyIds.Count -gt 0) {
        $OnlyIds | ForEach-Object { Join-Path $CacheDir $_ } | Where-Object { Test-Path $_ }
    } else {
        Get-ChildItem $CacheDir -File | ForEach-Object { $_.FullName }
    }

    foreach ($path in $targets) {
        $name = Split-Path $path -Leaf
        # skip obvious non-meshes
        if ($name -match "\.(dds|png|jpg|ogg|mp3)$") {
            Write-Host "skip texture/audio $name"
            continue
        }
        Write-Host "serialise $name"
        python _main.py serialise --load $path --save $path --method mesh
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  (failed, maybe not a mesh or missing DracoPy)"
        }
    }
} finally {
    Pop-Location
}

Write-Host "finished"
