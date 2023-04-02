<#
	.NOTES
		===========================================================================
		Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2023 v5.8.219
		Created on:   	27/03/2023 09:52
		Created by:   	Portelly
		Organization: 	Portelly
		Filename:
		===========================================================================
#>

Function ConvertFrom-SID
{
#	[cmdletbinding(DefaultParameterSetName = 'Standard')]
	Param (
#		[Parameter(ParameterSetName = 'Standard')]
#		[Parameter(ParameterSetName = 'OnlyWellKnown')]
#		[Parameter(ParameterSetName = 'OnlyWellKnownAdministrative')]
#		[string[]]$SID,
#		[Parameter(ParameterSetName = 'OnlyWellKnown')]
#		[switch]$OnlyWellKnown,
#		[Parameter(ParameterSetName = 'OnlyWellKnownAdministrative')]
#		[switch]$OnlyWellKnownAdministrative,
#		[Parameter(ParameterSetName = 'Standard')]
#		[switch]$DoNotResolve
		[string[]]$SID
		)
	<#
	S-1-5-32-544

This SID has four components:

A revision level (1)
An identifier authority value (5, NT Authority)
A domain identifier (32, Builtin)
A relative identifier (544, Administrators)
	
	
	#>
	
class SecurityIdentifiers {
		
		# Properties
		[string]$Value
		[string]$DisplayName
		[string]$Description
		[string]$RevisionLevel
		[string]$IdentifierAuthority
		[string]$DomainIdentifier
		[string]$RelativeIdentifier
		[string]$DomainName
		[string]$Type
		[string]$Error
		
		# Constructors
		
		SecurityIdentifiers ()
		{
			
		}
		
		#Methods
		
	}
	
	$AlphaSID = [SecurityIdentifiers]::new()
	
	return $AlphaSID
	
	
	
	
	
	
}

$B = ConvertFrom-SID
$B.gettype()