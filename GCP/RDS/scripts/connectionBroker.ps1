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

[DSCLocalConfigurationManager()]
configuration lcm
{
    Node localhost
    {
        Settings
        {
            ActionAfterReboot = "ContinueConfiguration"
            ConfigurationMode = "ApplyOnly"
            RebootNodeIfNeeded = $true

        }
    }
}

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

Configuration connectionBroker
{
   param 
    ( 
        [String]$BASE_DIR,
        [String]$MODULE_DIR,
        [String]$GCS_FOLDER,
        [String]$GCS_BUCKET,
        [String]$domainName,
        # Collection Name
        [String]$collectionName,
        # Connection Description
        [String]$collectionDescription,
        # Connection Broker Node name
        [String]$connectionBroker,
        # Web Access Node name
        [String]$webAccessServer,
        # Gateway external FQDN
        [String]$externalFqdn,
        # RD Session Host name
        [string]$SessionHost,
        [PSCredential]$cred
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xRemoteDesktopSessionHost' -ModuleVersion '1.0.1'

    $domainCreds = New-Object System.Management.Automation.PSCredential ("$domainName\$($cred.UserName)", $cred.Password)

    if (-not $collectionName)         { $collectionName = "Desktop Collection" }
    if (-not $collectionDescription)  { $collectionDescription = "A sample RD Session collection up in cloud." }

    #SessionHosts = @($SessionHost.split(','))
    $connectionBroker = "uksrdscbls1.don.local"
    $webAccessServer = "uksrdsgwweb1.don.local"
    $SessionHosts = "uksrdssh1.don.local"
    $externalFqdn = "uksrdscbls1.c.mpc-donavan-morris.internal"

    Node localhost
    {
        WindowsFeature RDS-Connection-Broker
        {
            Ensure = "Present"
            Name = "RDS-Connection-Broker"
        }

        WindowsFeature RDS-Licensing
        {
            Ensure = "Present"
            Name = "RDS-Licensing"
        }

        DomainJoin DomainJoin
        {
            domainName = $domainName 
            adminCreds = $cred
        }

        Registry RdmsEnableUILog
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
            ValueName = "EnableUILog"
            ValueType = "Dword"
            ValueData = "1"
        }
 
        Registry EnableDeploymentUILog
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
            ValueName = "EnableDeploymentUILog"
            ValueType = "Dword"
            ValueData = "1"
        }
 
        Registry EnableTraceLog
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
            ValueName = "EnableTraceLog"
            ValueType = "Dword"
            ValueData = "1"
        }
 
        Registry EnableTraceToFile
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RDMS"
            ValueName = "EnableTraceToFile"
            ValueType = "Dword"
            ValueData = "1"
        }

        xRDSessionDeployment Deployment
        {
            DependsOn        = "[DomainJoin]DomainJoin"
            ConnectionBroker = $connectionBroker
            WebAccessServer  = $webAccessServer
            SessionHosts     = $SessionHosts
            PsDscRunAsCredential = $domainCreds
        }
        xRDServer AddLicenseServer
        {
            DependsOn = "[xRDSessionDeployment]Deployment"
            Role    = 'RDS-Licensing'
            Server  = $connectionBroker
            PsDscRunAsCredential = $domainCreds
        }
        xRDLicenseConfiguration LicenseConfiguration
        {
            DependsOn = "[xRDServer]AddLicenseServer"
            ConnectionBroker = $connectionBroker
            LicenseServers   = @( $connectionBroker )
            LicenseMode = 'PerUser'
            PsDscRunAsCredential = $domainCreds
        }
        xRDServer AddGatewayServer
        {
            DependsOn = "[xRDLicenseConfiguration]LicenseConfiguration"
            Role    = 'RDS-Gateway'
            Server  = $webAccessServer
            GatewayExternalFqdn = $externalFqdn
            PsDscRunAsCredential = $domainCreds
        }
        xRDGatewayConfiguration GatewayConfiguration
        {
            DependsOn = "[xRDServer]AddGatewayServer"
            ConnectionBroker = $connectionBroker
            GatewayServer    = $webAccessServer
            ExternalFqdn = $externalFqdn
            GatewayMode = 'Custom'
            LogonMethod = 'Password'
            UseCachedCredentials = $true
            BypassLocal = $false
            PsDscRunAsCredential = $domainCreds
        }
        xRDSessionCollection Collection
        {
            DependsOn = "[xRDGatewayConfiguration]GatewayConfiguration"
            ConnectionBroker = $connectionBroker
            CollectionName = $collectionName
            CollectionDescription = $collectionDescription
            SessionHosts = $sessionHosts
            PsDscRunAsCredential = $domainCreds
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


Start-Sleep -s 300

lcm
Set-DscLocalConfigurationManager -Path .\lcm

connectionBroker -BASE_DIR $BASE_DIR -GCS_FOLDER $GCS_FOLDER -GCS_BUCKET $GCS_BUCKET -domainname $domainname -cred $cred -MODULE_DIR $MODULE_DIR -ConfigurationData $ConfigData -Verbose
Start-DscConfiguration -Wait -Force -Path .\connectionBroker -Verbose
####Remove-DscConfigurationDocument