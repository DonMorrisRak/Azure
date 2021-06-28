# Constants
$BASE_DIR = "C:\rs-pkgs\rs-config"
$GCS_BUCKET = "rs-gce-instances-scripts-master"
$GCS_FOLDER = "windows"
$RS_CONFIG_PATH = "HKLM:\SOFTWARE\Rackspace\rs-config"
$SCRIPT_NAME = "RS Config"

# Download file
Function Get-GcsFile {
    Param(
        [Parameter(Mandatory=$true)][string] $Url,
        [string] $SubDir = "",
        [switch] $IsDirectory
    )

    if (-not (Test-Path -Path "$BASE_DIR\$SubDir")) {
        New-Item -Path "$BASE_DIR\$SubDir" -ItemType Directory -Force | Out-Null
    }

    # Download file
    if ($IsDirectory) {
        $OutPath = "$BASE_DIR\$SubDir"
    } else {
        $OutPath = "$BASE_DIR\$SubDir\$($Url.Split("/")[-1])"
    }

    Start-Process -FilePath gsutil -ArgumentList @("cp", $Url, $OutPath) -Wait -PassThru | Out-Null
}

# Download Rackspace modules
Function Get-RsModule {
    # Copy the modules locally
    Get-GcsFile -Url "gs://$GCS_BUCKET/$GCS_FOLDER/modules/*.psm1" -SubDir modules -IsDirectory
}

# Download custom modules
Function Get-CustomModule {
    # Find the custom module bucket
    try {
        $CustomModulesUrl = Get-GcpMetadata -Type instance -Key "attributes/rs-config-custom-modules-url"

        # Copy the modules locally
        Get-GcsFile -Url $CustomModulesUrl -SubDir modules -IsDirectory
    } catch {

    }
}

# Create metadata object
Function New-MetadataObject {
    return New-Object -Type PSObject -Property @{
        Function = "";
        Description = "";
        Flag = "";
        Metadata = @();
    }
}

# Import modules
Function Import-RsConfigModule {
    # Get a list of modules in modules directory
    $AllModules = Get-ChildItem -Path "$BASE_DIR\modules" -File -Filter *.psm1

    # Loop through modules
    $Functions = @()

    foreach ($Module in $AllModules) {
        # Import module
        Import-Module -Name $Module.PSPath -Prefix $Module.BaseName

        # Read content
        $ModuleContent = Get-Content -Path $Module.PSPath

        # Extract metadata values
        $Metadata = $null;

        $ModuleContent | Select-String -Pattern "^(?:<#)?@(?:(?:(\w+) (.+))|(?:#>))$" | ForEach-Object {
            $Line = $_.Matches.Groups[0].Value

            if ($Line -eq "@#>") {
                $Functions += $Metadata
            } else {
                $Key = $_.Matches.Groups[1].Value
                $Value =  $_.Matches.Groups[2].Value

                if ($Key -eq "FUNCTION") {
                    $Metadata = New-MetadataObject
                    $Metadata.Function = $Value.Replace("-", "-$($Module.BaseName)")
                } elseif ($Key -eq "METADATA") {
                    $Metadata.Metadata += @{
                        Name = $Value.Split(" ")[0];
                        Type = $Value.Split(" ")[1];
                        Key = $Value.Split(" ")[2];
                    }
                } else {
                    $Metadata.$Key = $Value
                }
            }
        }
    }

    return $Functions
}

# Create event source
Function Assert-EventSource {
    Param(
        [string] $Name = "Powershell CLI"
    )

    If ([System.Diagnostics.EventLog]::Exists('Application') -eq $False -or [System.Diagnostics.EventLog]::SourceExists($Name) -eq $False)
    {
        New-EventLog -LogName Application -Source $Name
    }

    return $Name
}

# Write log
Function Write-Log {
    Param(
        [Parameter(Mandatory=$true)][string] $EventSource,
        [Parameter(Mandatory=$true)][string] $Message
    )

    Write-EventLog -LogName Application -Source $EventSource -EntryType Information -EventId 1 -Message $Message
    Write-Output $Message
}

# Invoke task
Function Invoke-Task {
    Param(
        [Parameter(Mandatory=$true)][string] $Name,
        [Parameter(Mandatory=$true)][boolean] $Flag,
        [Parameter(Mandatory=$true)][ScriptBlock] $ScriptBlock,
        $FlagName
    )

    # Create event source if necessary
    Assert-EventSource -Name $SCRIPT_NAME | Out-Null

    if ($Flag) {
        Write-Log -EventSource $SCRIPT_NAME -Message "Task STARTING - $($Name)"
    
        try {
            Invoke-Command -ScriptBlock $ScriptBlock | Out-Null
            Write-Log -EventSource $SCRIPT_NAME -Message "Task SUCCEEDED - $($Name)"
        } catch {
            Write-Log -EventSource $SCRIPT_NAME -Message "Task FAILED - $($Name): $($_.Exception.Message)"

            if ($FlagName) {
                Remove-ItemProperty -Path $RS_CONFIG_PATH -Name $FlagName
            }
        }
    } else {
        Write-Log -EventSource $SCRIPT_NAME -Message "Task SKIPPED - $($Name)"
    }
}

# Get metadata
Function Get-GcpMetadata {
    Param(
        [ValidateSet("project", "instance")][string] $Type = "instance",
        [Parameter(Mandatory=$true)][string] $Key
    )

    $Headers = @{
        "Metadata-Flavor" = "Google";
    }

    $Metadata = Invoke-RestMethod -Uri "http://metadata.google.internal/computeMetadata/v1/$Type/$Key" -Headers $Headers

    return $Metadata
}

# Script initialisation
# Create event source if necessary
Assert-EventSource -Name $SCRIPT_NAME | Out-Null
Write-Log -EventSource $SCRIPT_NAME -Message "Starting $SCRIPT_NAME script"

# Determine if this has been run before
if (-not (Test-Path -Path $RS_CONFIG_PATH)) {
    New-Item -Path $RS_CONFIG_PATH -Force | Out-Null
    New-Item -Path $RS_CONFIG_PATH -Name metadata | Out-Null
}

# Self-update
Get-GcsFile -Url "gs://$GCS_BUCKET/$GCS_FOLDER/rs-config.ps1"

# Import modules
Get-RsModule
Get-CustomModule
$Functions = Import-RsConfigModule

# Loop through modules
foreach ($Function in $Functions) {
    # Check to see if this has been configured already
    $AlreadyRunProperty = Get-ItemProperty -Path $RS_CONFIG_PATH -Name $Function.Flag -ErrorAction SilentlyContinue
    $AlreadyRun = $false
    $Changed = $false

    if ($AlreadyRunProperty.$($Function.Flag) -ne $null) {
        $AlreadyRun = $true
    }

    # Get metadata
    try {
        $Flag = Get-GcpMetadata -Type "instance" -Key "attributes/$($Function.Flag)"
    } catch {
        $Flag = $false
    }
    
    if ($AlreadyRunProperty.$($Function.Flag) -ne $Flag) {
        $Changed = $true
    }
    
    Set-ItemProperty -Path $RS_CONFIG_PATH -Name $Function.Flag -Value $Flag -Type String | Out-Null

    # Check to see if the module should run
    if ([Convert]::ToBoolean($Flag)) {
        $Metadata = @{}

        foreach ($MetadataItem in $Function.Metadata) {
            try {
                $Key = "$($MetadataItem.Type)/$($MetadataItem.Key)"
                $Metadata[$MetadataItem.Name] = Get-GcpMetadata -Type $MetadataItem.Type -Key $MetadataItem.Key
                $Value = Get-ItemProperty -Path "$RS_CONFIG_PATH\metadata" -Name $Key -ErrorAction SilentlyContinue

                if ((-not $Value) -or ($Value.$Key -ne $Metadata[$MetadataItem.Name])) {
                    $Changed = $true
                    Set-ItemProperty -Path "$RS_CONFIG_PATH\metadata" -Name $Key -Value $Metadata[$MetadataItem.Name] -Type String | Out-Null
                }
            } catch {

            }
        }
   
        # Invoke task
        if ($Changed) {
            $CommandString = "$($Function.Function)"

            if ($Metadata.Count -gt 0) {
                $CommandString += " -Metadata `$Metadata"
            }

            Invoke-Task -Name $Function.Description -Flag $true -FlagName $Function.Flag -ScriptBlock { Invoke-Expression -Command $CommandString }   
        }
    } elseif (-not $AlreadyRun) {
        Invoke-Task -Name $Function.Description -Flag $false -ScriptBlock { Out-Null }
    }
}

# Schedule script to run every hour
$ScheduledTask = Get-ScheduledTask -TaskName $SCRIPT_NAME -ErrorAction SilentlyContinue

if (-not $ScheduledTask) {
    Invoke-Task -Name "Schedule the configuration script" -Flag $true -ScriptBlock {
        $ScheduledTaskAction = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-NonInteractive -NoLogo -NoProfile -ExecutionPolicy Bypass -File $BASE_DIR\rs-config.ps1"
        $ScheduledTaskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date -Minute 0 -Second 0).AddHours(1) -RepetitionInterval (New-TimeSpan -Hours 1)
        $ScheduledTaskSettings = New-ScheduledTaskSettingsSet
        $ScheduledTaskPrincipal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
        Register-ScheduledTask -TaskName $SCRIPT_NAME -Action $ScheduledTaskAction -Trigger $ScheduledTaskTrigger -Settings $ScheduledTaskSettings -Principal $ScheduledTaskPrincipal | Out-Null
    }
}

Write-Log -EventSource $SCRIPT_NAME -Message "Finishing $SCRIPT_NAME script"
