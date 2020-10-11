<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.181
	 Created on:   	2020-10-11 1:43 PM
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	FileName_Headers_ContentDisposition.ps1
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
	
	#Security layer bypass
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
	
	
	$webRequest = [System.Net.WebRequest]::Create($url)
	$Response = $webRequest.GetResponse()
	$dispositionHeader = $Response.Headers['Content-Disposition']
	$disposition = [System.Net.Mime.ContentDisposition]::new($dispositionHeader)
	$Response.Dispose()
	
	
	Return $disposition.FileName #Suggested FileName
}

#Test with VSCode URL
$VSCodeUrl = "https://aka.ms/win32-x64-user-stable"


Get-IWRFilename -url $VSCodeUrl
