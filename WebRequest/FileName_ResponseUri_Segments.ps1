<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.181
	 Created on:   	2020-10-11 1:43 PM
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	FileName_ResponseUri_Segments.ps1
	===========================================================================
	.DESCRIPTION
		Get the filename of a download from the response URI
#>

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

#Test with VSCode URL
$VSCodeUrl = "https://aka.ms/win32-x64-user-stable"


Get-IWRFilename -url $VSCodeUrl
