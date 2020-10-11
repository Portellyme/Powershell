<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.181
	 Created on:   	2020-10-11 10:14 AM
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-Git.ps1
	===========================================================================
	.DESCRIPTION
		Download and Install lastrest version of Git
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
$ScriptDirectory = Get-ScriptDirectory
$ScriptName = ($MyInvocation.MyCommand.Name.Split("."))[0]


#endregion 


##############################
# region Main
##############################
# Get latest git-for-windows 64-bit 
$GitUrl = "https://api.github.com/repos/git-for-windows/git/releases/latest"
$GitReleases = Invoke-RestMethod -Method Get -Uri $git_url


$Release = $GitReleases.assets | Where-Object { $_.name -Like "*64-bit.exe" }

# Get Git Installer
$DownloadURL = $Release.browser_download_url
$installer = $Release.name
$DonwloadFile  = "$ScriptDirectory\$installer"

Invoke-WebRequest -Uri $DownloadURL -OutFile $DonwloadFile


# run installer
$InstallInf = "$ScriptDirectory\gitinstall.inf"
$InstallArgs = "/SP- /SILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$InstallInf"""
Start-Process -FilePath $DonwloadFile -ArgumentList $InstallArgs -Wait


#endregion 




