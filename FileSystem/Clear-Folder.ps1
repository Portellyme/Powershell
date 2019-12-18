<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.170
	 Created on:   	18/12/2019 14:07
	 Created by:   	Gabriel Gaulet
	 Organization: 	LVM
	 Filename:     	Clear-Folder
	===========================================================================
	.DESCRIPTION
		Recursively clean folder structure with option 
			Path : Path Clean everything top of that
			Root : Bool Remove root path too 
#>


Function Clear-Folder
{
<#
	.SYNOPSIS
		Clean target folder recursively while keeping root directory
	
	.DESCRIPTION
		Attempt to empty the folder. Return false if it fails (locked files...).
	
	.PARAMETER Path
		Root path of the folder to clean
	
	.EXAMPLE
		PS C:\> Clear-Folder -Path $value1
	
	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[ValidateScript({
				If (-Not ([System.IO.Directory]::Exists($_)))
				{
					Throw "Folder `"{0}`" does not exist" -f $_
				}
				Return $True
			})]
		[ValidateNotNullOrEmpty()]
		[System.IO.DirectoryInfo]
		$Path
	)
	
	[bool]$FuncError = $false
	
	ForEach ($FileInfo In $Path.EnumerateFiles())
	{
		Try
		{
			$FileInfo.IsReadOnly = $false
			$FileInfo.delete()
			#Wait for the item to disapear (avoid 'dir not empty' error).
			While ($FileInfo.Exists)
			{
				[System.Threading.Thread]::Sleep(10)
				$FileInfo.refresh()
			}
		}
		Catch
		{
			Write-Output ("The process {0} failed." -f $_.Exception.Message)
			$FuncError = $true
		}
	}
	
	ForEach ($DirectoryInfo In $Path.EnumerateDirectories())
	{
		Try
		{
			Clear-Folder -Path $DirectoryInfo.FullName
			$DirectoryInfo.Delete()
			
			#Wait for the item to disapear (avoid 'dir not empty' error).
			While ($DirectoryInfo.Exists)
			{
				[System.Threading.Thread]::Sleep(10)
				$DirectoryInfo.Refresh()
			}
		}
		Catch
		{
			Write-Output ("The process {0} failed." -f $_.Exception.Message)
			$FuncError = $true
		}
	}
	Return !$FuncError
}



