function Get-ADUserFromSid
{
<#
	.SYNOPSIS
		Find User from its SID in PowerShell
	
	.DESCRIPTION
		Identify user by SID 
		Query for the a SID of the user in the current domain
	
	.PARAMETER Sid
		SID to query in Active Directory.

	
	.EXAMPLE
		PS C:\> Get-ADUserFromSid -Sid 'S-1-5-21-1234567890-987654321-1234567890-098765'

	.NOTES
		===========================================================================
		 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
		 Created on:   	13/08/2021 14:26
		 Created by:   	Portelly
		 Organization: 	Portelly
		 Filename:     	Get-ADUserFromSid.ps1
		===========================================================================
#>
	
	[CmdletBinding()]
	Param (
		[string]
		$Sid
	)
	
	$SecurityIdent = New-Object System.Security.Principal.SecurityIdentifier $Sid
	
	$User = $SecurityIdent.Translate([System.Security.Principal.NTAccount])
	
	$UserAccount = $User.Value
	$Domain = ''
	
	If ($UserAccount.Contains('\'))
	{
		$Chunks = $User.Value.Split('\')
		$Domain = $Chunks[0]
		$UserAccount = $Chunks[1]
	}
	
	
	New-Object -TypeName PSObject -Property (@{
			UserName = $UserAccount
			Domain   = $Domain
			SID	     = $Sid
		})
}

