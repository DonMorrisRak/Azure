# Constants
$BASE_DIR = "C:\rs-pkgs\rs-config"
$GCS_BUCKET = "don-rax-rds"
$GCS_FOLDER = "rds"
$RS_CONFIG_PATH = "HKLM:\SOFTWARE\Rackspace\rs-config"
$SCRIPT_NAME = "RS Config"

Function Get-GcsFile {

    if (-not (Test-Path -Path $BASE_DIR)) {
        New-Item -Path $BASE_DIR -ItemType Directory -Force | Out-Null
    }

    Start-Process -FilePath gsutil -ArgumentList @("cp -r", "gs://$GCS_BUCKET/$GCS_FOLDER", $BASE_DIR) -Wait -PassThru | Out-Null
}

Get-GcsFile
Set-Location -Path $BASE_DIR\$GCS_FOLDER
$env:PSModulePath = $env:PSModulePath + "$([System.IO.Path]::PathSeparator)$BASE_DIR\$GCS_FOLDER"
& .\gateway.ps1