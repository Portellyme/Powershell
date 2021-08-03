<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2020 v5.7.182
	 Created on:   	21/12/2020 14:19
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Get AD user from UPN with validation of UPN format using the Confirm-MailAddress function
#>
######################
#region Function Declaration 
######################
Import-Module ActiveDirectory
function Confirm-MailAddress
{
<#
	.SYNOPSIS
		Validate email address format
	
	.DESCRIPTION
		This will not validate an email address availability on the remote domain but the correct format.
	
	.PARAMETER mail
		A description of the mail parameter.
	
	.EXAMPLE
				PS C:\> Confirm-MailAddress -mailAddress <Email address to Control>
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding()]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]
		$mailAddress
	)
	#Internal Status
	$validEmail = $true
	
	#Internal Variables
	$domainMapperTimeout = [System.TimeSpan]::FromMilliseconds(200)
	$isMatchTimeout = [System.TimeSpan]::FromMilliseconds(300)
	
	if ([string]::IsNullOrWhiteSpace($mailAddress))
	{
		return $false
	}
	
	#Scriptblock for callback regexreplace 
	$domainMapper = {
		param ([System.Text.RegularExpressions.Match]
			$domainMatch)
		#Use IdnMapping class to convert Unicode domain names.
		$idn = [System.Globalization.IdnMapping]::new()
		
		[string]$domainName = $domainMatch.Groups[2].Value
		try
		{
			$domainName = $idn.GetAscii($domainName)
		}
		catch [ArgumentException]
		{
			$validEmail = $false
		}
		catch [System.Text.RegularExpressions.RegexMatchTimeoutException]
		{
			$validEmail = $false
		}
		return ([string]::Concat(($domainMatch.Groups[1].Value), $domainName))
	}
	
	
	$mailAddress = [System.Text.RegularExpressions.Regex]::Replace($mailAddress, "(@)(.+)$", $domainMapper, 'None', $domainMapperTimeout)
	if ($validEmail -eq $false)
	{
		Return $false
	}
	
	try
	{
		#Return true if $mailAddress is in valid e-mail format.
		[string]$mailAddressPattern = [string]::Concat("^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))",`
			"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,17}))$")
		Return [System.Text.RegularExpressions.Regex]::IsMatch($mailAddress, $mailAddressPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase, $isMatchTimeout)
	}
	catch [System.Text.RegularExpressions.RegexMatchTimeoutException]
	{
		$validEmail = $false
	}
	
	return $validEmail
}

#endregion


######################
#region Global Declaration 
######################
$UserUPN = Read-Host "Please enter user principal name"
#endregion 


##############################
# region Main
##############################

if (!(Confirm-MailAddress -mailAddress $UserUPN))
{
	Write-Output "Enter a valid email address"
}
else
{
	$userAccount = (Get-ADUser -filter "UserPrincipalname -like '$UserUPN'" -Properties Surname, GivenName, Name, SamAccountName, UserPrincipalName, DistinguishedName)
	$userAccount
}



