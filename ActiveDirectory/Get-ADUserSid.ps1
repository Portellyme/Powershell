function Get-ADUserSid
{
<#
	.SYNOPSIS
		Find a User SID in PowerShell
	
	.DESCRIPTION
		Identify user by SID 
		Query for the a user in a specific domain, defaulting to the current user if no parameters are specified.
	
	.PARAMETER UserAccount
		Username of the user for which you want to get the SID.
	
	.PARAMETER Domain
		Domain of the user for which you want to get the SID.
	
	.EXAMPLE
		PS C:\> Get-ADUserSid -UserAccount '<Username>'
		PS C:\> Get-ADUserSid -UserAccount '<Username>'
		PS C:\> Get-ADUserSid -UserAccount '<Username>'
		PS C:\> Get-ADUserSid -UserAccount '<Username>'

		#If the user is not in the current domain you need to specify it.
		PS C:\> Get-ADUserSid -UserAccount '<Username>' -Domain 'UserDomain'
		PS C:\> Get-ADUserSid -UserAccount '<Username>' -Domain 'UserDomain'
		PS C:\> Get-ADUserSid -UserAccount '<Username>' -Domain 'UserDomain'
		PS C:\> Get-ADUserSid -UserAccount '<Username>' -Domain 'UserDomain'
	
	.NOTES
		===========================================================================
		Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
		Created on:   	13/08/2021 11:52
		Created by:   	Portelly
		Organization: 	Portelly
		Filename:     	Get-ADUserSid.ps1
		===========================================================================
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		[Alias('User', 'UserName', 'Identity')]
		[string]
		$UserAccount = $env:USERNAME,
		[string]
		$Domain = $env:USERDOMAIN
	)
	
	$User = [System.Security.Principal.NTAccount]::new($Domain, $UserAccount)
	$Ident = $User.Translate([System.Security.Principal.SecurityIdentifier])
	
	New-Object -TypeName PSObject -Property (@{
			UserName = $UserAccount
			Domain   = $Domain
			SID	     = $Ident.Value
		})
}

