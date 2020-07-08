function Disable-Firewall
{
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

}

function Format-DataDisks
{
    $labels = @("Data","Logs")
    Write-Host "Initializing and formatting raw disks"
 
    $disks = Get-Disk |   Where partitionstyle -eq 'raw' | sort number
 
    ## start at S: 
    $letters = 83..89 | ForEach-Object { ([char]$_) }
    $count = 0
 
    foreach($d in $disks) {
        $driveLetter = $letters[$count].ToString()
        $d | 
        Initialize-Disk -PartitionStyle GPT -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $driveLetter |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel $labels[$count] `
            -Confirm:$false -Force 
        $count++
    }

}

function Disable-ServerManager
{
    Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask

}

function Set-DefaultLocale 
{
Set-WinSystemLocale en-nz
Set-WinUserLanguageList -LanguageList en-nz -Force
Set-Culture -CultureInfo en-nz
Set-WinHomeLocation -GeoId 10210825
Set-TimeZone -Name "New Zealand Standard Time"

$pwd = (Get-Location).Path
$loc = "\Region.xml"   
$RegionalSettings = -join ($pwd,$loc)

& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$RegionalSettings`""

}

Disable-Firewall
Format-DataDisks
Disable-ServerManager
Set-DefaultLocale 