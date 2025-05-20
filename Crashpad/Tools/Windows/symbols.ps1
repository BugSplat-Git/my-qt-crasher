param(
    [Parameter(Mandatory=$true)][string]$rootPath,      # %1
    [Parameter(Mandatory=$true)][string]$symbolsDir,    # %2
    [Parameter(Mandatory=$true)][string]$database,      # %3
    [Parameter(Mandatory=$true)][string]$appName,       # %4
    [Parameter(Mandatory=$true)][string]$version,       # %5
    [Parameter(Mandatory=$true)][string]$username,      # %6
    [Parameter(Mandatory=$true)][string]$password       # %7
)

$symbolUploader = Join-Path $rootPath "Crashpad\Tools\Windows\symbol-upload-windows.exe"
$symbolFile = "$appName.exe"

if (-not (Test-Path $symbolUploader)) {
    Write-Host "Downloading symbol-upload-windows.exe..."
    $downloaderDir = Split-Path -Parent $symbolUploader
    if (-not (Test-Path $downloaderDir)) {
        New-Item -ItemType Directory -Path $downloaderDir -Force | Out-Null
    }
    try {
        Invoke-WebRequest -Uri "https://app.bugsplat.com/download/symbol-upload-windows.exe" -OutFile $symbolUploader
        if (-not (Test-Path $symbolUploader)) {
            Write-Error "Failed to download symbol-upload-windows.exe"
            exit 1
        }
        Write-Host "Successfully downloaded symbol-upload-windows.exe"
    }
    catch {
        Write-Error "Failed to download symbol-upload-windows.exe: $_"
        exit 1
    }
}

& $symbolUploader -b $database -a $appName -v $version -d $symbolsDir -f $symbolFile -u $username -p $password -m

if ($LASTEXITCODE -ne 0) {
    Write-Error "Symbol upload failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
} 