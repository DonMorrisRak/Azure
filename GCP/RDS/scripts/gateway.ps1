configuration Gateway
{
    Import-DscResource -ModuleName xComputerManagement -Moduleversion 1.2.2
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    
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

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
        }
    )
}

Gateway -ConfigurationData $ConfigData -Verbose
Start-DscConfiguration -Wait -Force -Path .\Gateway -Verbose