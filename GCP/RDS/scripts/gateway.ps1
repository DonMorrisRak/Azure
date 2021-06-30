# Constants
$BASE_DIR = "C:\rs-pkgs\rs-config"
$GCS_FOLDER = "rds"
$GCS_BUCKET = "don-rax-rds"
$localhost = [System.Net.Dns]::GetHostByName((hostname)).HostName
$adUsername = gcloud secrets versions access 1 --secret="ad-username"
$adPassword = gcloud secrets versions access 1 --secret="ad-password" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList @($adUsername,$adPassword)
$domainName = gcloud secrets versions access 1 --secret="ad-domain"
$MODULE_DIR="$env:ProgramFiles\WindowsPowerShell\Modules"

configuration DomainJoin 
{ 
   param 
    ( 
        [Parameter(Mandatory)]
        [String]$domainName,
        [Parameter(Mandatory)]
        [PSCredential]$adminCreds
    ) 
    Import-DscResource -ModuleName 'xDSCDomainjoin' -ModuleVersion 1.2
    $domainCreds = New-Object System.Management.Automation.PSCredential ("$domainName\$($adminCreds.UserName)", $adminCreds.Password)
   
    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = "ApplyOnly"
        }

        WindowsFeature ADPowershell
        {
            Name = "RSAT-AD-PowerShell"
            Ensure = "Present"
        } 

        xDSCDomainjoin JoinDomain
        {
            Domain = $Domainname 
            Credential = $domainCreds
        } 
   }
}

Configuration InitialConfiguration
{
   param 
    ( 
        [String]$BASE_DIR,
        [String]$MODULE_DIR,
        [String]$GCS_FOLDER,
        [String]$GCS_BUCKET,
        [String]$domainName,
        [PSCredential]$cred
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node localhost
    {

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = "ApplyOnly"
        }

        WindowsFeature RDS-Gateway
        {
            Ensure = "Present"
            Name = "RDS-Gateway"
        }

        WindowsFeature RDS-Web-Access
        {
            Ensure = "Present"
            Name = "RDS-Web-Access"
        }

        DomainJoin DomainJoin
        {
            domainName = $domainName 
            adminCreds = $cred
        }
    }
}


$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
        }
    )
}


InitialConfiguration -BASE_DIR $BASE_DIR -GCS_FOLDER $GCS_FOLDER -GCS_BUCKET $GCS_BUCKET -domainname $domainname -cred $cred -MODULE_DIR $MODULE_DIR -ConfigurationData $ConfigData -Verbose
Start-DscConfiguration -Wait -Force -Path .\InitialConfiguration -Verbose