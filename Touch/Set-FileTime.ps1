<#
	.SYNOPSIS
		Change the date/time of a file.
	
	.DESCRIPTION
		The function below implements a fully featured PowerShell version of the Unix touch command. 
		It accepts piped input and if the file does not already exist it will be created. 
		There are options to change only the Modification time or Last access time (-only_modification or -only_access)
	
	.NOTES
		===========================================================================
		Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.165
		Created on:   	19/06/2019 08:19
		Created by:   	See Readme.MD
		Organization: 	Portelly
		Filename:     	Set-FileTime.PS1
		===========================================================================
#>


Function Set-FileTime
{
	Param
	(
		[string[]]
		$Paths,
		[ValidateSet($false, $true)]
		[bool]
		$only_modification = $False,
		[ValidateSet($false, $true)]
		[bool]
		$only_access
	)
	
	
	BEGIN 
	{
		Function updateFileSystemInfo([System.IO.FileSystemInfo]$fsInfo)
		{
			$datetime = get-date
			If ($only_access)
			{
				$fsInfo.LastAccessTime = $datetime
			}
			ElseIf ($only_modification)
			{
				$fsInfo.LastWriteTime = $datetime
			}
			Else
			{
				$fsInfo.CreationTime = $datetime
				$fsInfo.LastWriteTime = $datetime
				$fsInfo.LastAccessTime = $datetime
			}
		}
		
		Function touchExistingFile($arg)
		{
			If ($arg -is [System.IO.FileSystemInfo])
			{
				updateFileSystemInfo($arg)
			}
			Else
			{
				$resolvedPaths = resolve-path $arg
				ForEach ($rpath In $resolvedPaths) {
					If (test-path -PathType Container $rpath)
					{
						$fsInfo = new-object System.IO.DirectoryInfo($rpath)
					}
					Else
					{
						$fsInfo = new-object System.IO.FileInfo($rpath)
					}
					updateFileSystemInfo($fsInfo)
				}
			}
		}
		
		Function touchNewFile([string]$path)
		{
			Set-Content -Path $path -value $null;
		}
	}
	
	Process
	{
		If ($_)
		{
			If (test-path $_)
			{
				touchExistingFile($_)
			}
			Else
			{
				touchNewFile($_)
			}
		}
	}
	
	End
	{
		If ($paths)
		{
			ForEach ($path In $paths) {
				If (test-path $path)
				{
					touchExistingFile($path)
				}
				Else
				{
					touchNewFile($path)
				}
			}
		}
	}
}

New-Alias -Name 'touch' -Value 'Set-FileTime'




