<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.195
	 Created on:   	19/11/2021 10:52
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-ADSystemInfo.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


function Get-ADSystemInfo
{
<#
	.LINK
		https://technet.microsoft.com/en-us/library/ee198776.aspx
#>
	$properties = @(
		'UserName',
		'ComputerName',
		'SiteName',
		'DomainShortName',
		'DomainDNSName',
		'ForestDNSName',
		'PDCRoleOwner',
		'SchemaRoleOwner',
		'IsNativeMode'
	)
	$ads = New-Object -ComObject ADSystemInfo
	$type = $ads.GetType()
	$hash = @{ }
	foreach ($p in $properties)
	{
		$hash.Add($p, $type.InvokeMember($p, 'GetProperty', $Null, $ads, $Null))
	}
	[pscustomobject]$hash
}
Get-ADSystemInfo

