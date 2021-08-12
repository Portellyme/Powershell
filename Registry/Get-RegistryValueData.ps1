<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
	 Created on:   	11/08/2021 15:43
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-RegistryValueData.ps1
	===========================================================================
	.DESCRIPTION
		Get remote registry data of computer(s)
#>


######################
#region Function Declaration 
######################
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}


#endregion


#######################
#region Classes
#######################




#endregion


######################
#region Global Declaration 
######################
[string]$ScriptDirectory = Get-ScriptDirectory
[string]$ScriptName = ($MyInvocation.MyCommand.Name.Split("."))[0]


#endregion 


##############################
# region Main
##############################
function Get-RegistryValueData
{
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[Alias('Computer')]
		[String[]]
		$ComputerName,
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1)]
		[ValidateSet('ClassesRoot', 'CurrentUser', 'LocalMachine', 'Users', 'CurrentConfig')]
		[Alias('Hive')]
		[String]
		$RegistryHive,
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 2)]
		[Alias('KeyPath')]
		[String]
		$RegistryKeyPath,
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 3)]
		[Alias('Value')]
		[String]
		$ValueName
	)
	
	Begin
	{
		$RegistryRoot = "[{0}]::{1}" -f 'Microsoft.Win32.RegistryHive', $RegistryHive
		try
		{
			$RegistryHive = Invoke-Expression $RegistryRoot -ErrorAction Stop
		}
		catch
		{
			Write-Host "Incorrect Registry Hive mentioned, $RegistryHive does not exist"
		}
	}
	Process
	{
		Foreach ($Computer in $ComputerName)
		{
			if (Test-Connection $computer -Count 2 -Quiet)
			{
				$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $Computer)
				$key = $reg.OpenSubKey($RegistryKeyPath)
				$Data = $key.GetValue($ValueName)
				$Obj = New-Object psobject
				$Obj | Add-Member -Name Computer -MemberType NoteProperty -Value $Computer
				$Obj | Add-Member -Name RegistryValueName -MemberType NoteProperty -Value "$RegistryKeyPath\$ValueName"
				$Obj | Add-Member -Name RegistryValueData -MemberType NoteProperty -Value $Data
				$Obj
			}
			else
			{
				Write-Host "$Computer not reachable" -BackgroundColor DarkRed
			}
		}
	}
	End
	{
		#[Microsoft.Win32.RegistryHive]::ClassesRoot
		#[Microsoft.Win32.RegistryHive]::CurrentUser
		#[Microsoft.Win32.RegistryHive]::LocalMachine
		#[Microsoft.Win32.RegistryHive]::Users
		#[Microsoft.Win32.RegistryHive]::CurrentConfig
	}
}


Get-RegistryValueData -ComputerName '<remoteserverhostname>' -RegistryHive LocalMachine -RegistryKeyPath 'SYSTEM\CurrentControlSet\Control\LSA\Kerberos\Parameters' -ValueName 'MaxTokenSize'


#endregion 


