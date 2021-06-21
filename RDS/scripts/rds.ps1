# Install RDS Services
# DSC

# Connection Broker / # Licensing Server
configuration Broker
{
    param 
    ( 
        [Parameter(Mandatory)]
        [String]$domainName,

        [Parameter(Mandatory)]
        [PSCredential]$adminCreds,

        # Connection Broker Node name
        [String]$connectionBroker,
        
        # Web Access Node name
        [String]$webAccessServer,

        # Gateway external FQDN
        [String]$externalFqdn,
        
        # RD Session Host name
        [string]$SessionHost,

        # Collection Name
        [String]$collectionName,

        # Connection Description
        [String]$collectionDescription

    ) 
    
    Import-DscResource -ModuleName xComputerManagement -Moduleversion 1.2.2
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName xRemoteDesktopSessionHost -ModuleVersion 1.0.1

    $localhost = [System.Net.Dns]::GetHostByName((hostname)).HostName

    $username = $adminCreds.UserName -split '\\' | select -last 1
    $domainCreds = New-Object System.Management.Automation.PSCredential ("$domainName\$username", $adminCreds.Password)

    if (-not $collectionName)         { $collectionName = "Desktop Collection" }
    if (-not $collectionDescription)  { $collectionDescription = "A sample RD Session collection up in cloud." }

    $SessionHosts = @($SessionHost.split(','))

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = "ApplyOnly"
        }

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

        WindowsFeature RSAT-RDS-Tools
        {
            Ensure = "Present"
            Name = "RSAT-RDS-Tools"
            IncludeAllSubFeature = $true
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
# Gateway / # Web Access 
configuration Gateway
{
    Import-DscResource -ModuleName xComputerManagement -Moduleversion 1.2.2

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
    }
}
# Session Hosts
configuration Session
{
    Import-DscResource -ModuleName xComputerManagement -Moduleversion 1.2.2

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = "ApplyOnly"
        }

        WindowsFeature RDS-RD-Server
        {
            Ensure = "Present"
            Name = "RDS-RD-Server"
        }
    }
}