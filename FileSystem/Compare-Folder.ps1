<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.192
	 Created on:   	05/08/2021 17:14
	 Created by:   	Adam Bertram
	 Organization: 	Adam the Automator
	 Filename:     	Compare-Folder.ps1
	===========================================================================
	.DESCRIPTION
		Compare Folder 
#>

function Compare-Folder
{

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ Test-Path -Path $_ -PathType Container })]
		[string]$ReferenceFolder,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ Test-Path -Path $_ -PathType Container })]
		[string]$DifferenceFolder,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^\\')]
		[string]$ExcludeFilePath
		
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
		function Get-FileHashesInFolder
		{
			param (
				[string]$Folder
			)
			$files = Get-ChildItem -Path $Folder -Recurse -File
			foreach ($s in $files)
			{
				$selectObjects = @('Hash', @{ n = 'Path'; e = { $_.Path.SubString($Folder.Length) } })
				Get-FileHash $s.Fullname | Select-Object $selectObjects -ExcludeProperty Path
			}
		}
	}
	process
	{
		try
		{
			$refHashes = Get-FileHashesInFolder -Folder $ReferenceFolder
			$destHashes = Get-FileHashesInFolder -Folder $DifferenceFolder
			if ($PSBoundParameters.ContainsKey('ExcludeFilePath'))
			{
				$refHashes = $refHashes.Where({ $_.Path -ne $ExcludeFilePath })
				$destHashes = $destHashes.Where({ $_.Path -ne $ExcludeFilePath })
			}
			
			$refHashes.Where({ $_.Path -notin $destHashes.Path }).foreach({
				[pscustomobject]@{
					'Path' = $_.Path
					'Reason' = 'NotInDifferenceFolder'
				}
			})
			$destHashes.Where({ $_.Path -notin $refHashes.Path }).foreach({
				[pscustomobject]@{
					'Path' = $_.Path
					'Reason' = 'NotInReferenceFolder'
				}
			})
			$refHashes.Where({ $_.Hash -notin $destHashes.Hash -and $_.Path -in $destHashes.Path }).foreach({
				[pscustomobject]@{
					'Path' = $_.Path
					'Reason' = 'HashDifferent'
				}
			})
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}