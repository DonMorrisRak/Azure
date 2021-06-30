# Metadata
$Headers = @{"Metadata-Flavor" = "Google";}
$Role = Invoke-RestMethod -Uri "http://metadata.google.internal/computeMetadata/v1/instance/attributes/role" -Headers $Headers

# Constants
$BASE_DIR = "C:\rs-pkgs\rs-config"
$GCS_FOLDER = "rds"
$GCS_BUCKET = "don-rax-rds"
$MODULE_DIR="$env:ProgramFiles\WindowsPowerShell\Modules"

function Get-GcsRds {

if (-not (Test-Path -Path "$BASE_DIR")) {
    New-Item -Path "$BASE_DIR" -ItemType Directory -Force | Out-Null
}
    gsutil cp -r "gs://$GCS_BUCKET/$GCS_FOLDER" $BASE_DIR


if (-not (Test-Path -Path "$MODULE_DIR\xDSCDomainjoin")) {
    Copy-Item -Path "$BASE_DIR\$GCS_FOLDER\xDSCDomainjoin" -Destination "$MODULE_DIR" -Recurse
    Import-Module -Name xDSCDomainjoin
}
}

function Set-RdsGw {
Set-Location -Path $BASE_DIR\$GCS_FOLDER
& ./$role.ps1
}


Get-GcsRds

Set-RdsGw
