<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.181
	 Created on:   	2020-10-11 10:14 AM
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-VSCode.ps1
	===========================================================================
	.DESCRIPTION
		Download and Install latest VSCode version


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

function Get-IWRFilename
{
<#
	.SYNOPSIS
		Get the filename of a file embedded in the payload
	
	.DESCRIPTION
		Look in the Response data from IWR to find the filename of the payload embedded in the direct url
	
	.PARAMETER url
		A description of the url parameter.
	
	.EXAMPLE
		Additional example about the function.
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding()]
	[OutputType([string])]
	param
	(
		[ValidateNotNullOrEmpty()]
		[string]
		$url
	)
	
	#Sometimes request is rejected due to security
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
	
	
	$webRequest = [System.Net.WebRequest]::Create($url)
	$Response = $webRequest.GetResponse()
	$Segments = $Response.ResponseUri.Segments
	$Response.Dispose()
	
	#	$Segments[$Segments.GetUpperBound(0)]
	return $Segments[$Segments.GetUpperBound(0)]
}


#endregion


#######################
#region Classes
#######################
Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
             ServicePoint srvPoint, X509Certificate certificate,
             WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = [TrustAllCertsPolicy]::new()



#endregion


######################
#region Global Declaration 
######################
$ScriptDirectory = Get-ScriptDirectory
$ScriptName = ($MyInvocation.MyCommand.Name.Split("."))[0]
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#endregion 

##############################
# region Main
##############################
# Get latest VSCode Installer
$VSCodeUrl = "https://aka.ms/win32-x64-user-stable"

$webRequest = [System.Net.WebRequest]::Create($VSCodeUrl)
$Response = $webRequest.GetResponse()
$Segments = $Response.ResponseUri.Segments
$installer = $Segments[$Segments.GetUpperBound(0)]

$SourceUri = $Response.ResponseUri.AbsoluteUri
$DonwloadFile = "$ScriptDirectory\$installer"

Invoke-WebRequest -Uri $SourceUri -OutFile $DonwloadFile

# run installer
$InstallInf = "$ScriptDirectory\VSCodeInstall.inf"
$InstallArgs = "/SP- /SILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$InstallInf"""
Start-Process -FilePath $DonwloadFile -ArgumentList $InstallArgs -Wait


#endregion 




