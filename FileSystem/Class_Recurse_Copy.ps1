<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	05/07/2021 14:48
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Class_Recurse_Copy
	===========================================================================
	.DESCRIPTION
		Class for recurse copy because i'm bored to always rewrite it 
#>


######################
#region Function Declaration 
######################
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}


#endregion


#######################
#region Classes
#######################

class DirectoryCopy  {
	
	# Properties
	[string]$source
	[string]$destination
	[bool]$subDirectories
	
	# Constructors
	DirectoryCopy ([string]$sourceFolder, [string]$destinationFolder)
	{
		#Move to next constructor 
		$this.DirectoryCopy($sourceFolder, $destinationFolder, $true)
	}
	
	DirectoryCopy ([string]$sourceFolder, [string]$destinationFolder, [bool]$subDirectories)
	{
		$this.source = $sourceFolder
		$this.destination = $destinationFolder
		$this.subDirectories = $subDirectories
	}
	
	
	#Methods
	static CopyDir([string]$sourceDirName, [string]$destDirName, [bool]$copySubDirs)
	{
		
		$directory = [System.IO.DirectoryInfo]::new($sourceDirName)
		if (!$directory.Exists)
		{
			throw [system.IO.DirectoryNotFoundException]::new("Source directory $sourceDirName does not exist or could not be found.")
		}
		
		#Get the subdirectories for the specified directory.
		$directoriesCollection = $directory.GetDirectories()
		
		# If the destination directory doesn't exist, create it.    
		if (![System.io.Directory]::Exists($destDirName))
		{
			try
			{
				[System.io.Directory]::CreateDirectory($destDirName)
			}
			catch
			{
				Write-Host $_.Exception.Message
			}
			
		}
		
		#Get the files in the directory and copy them to the new location.
		$filesToCopy = $directory.GetFiles()
		foreach ($file in $filesToCopy)
		{
			$tempPath = [System.IO.Path]::Combine($destDirName, $file.Name)
			try
			{
				$file.CopyTo($tempPath, $false)
				Write-Host ("{0} has been copied to {1}" -f $file.Name, $tempPath)
			}
			catch [System.io.IOException]
			{
				Write-Host $_.Exception.Message
			}
		}
		
		#If copying subdirectories, copy them and their contents to new location.
		if ($copySubDirs)
		{
			foreach ($subdir in $directoriesCollection)
			{
				$tempPath = [System.IO.Path]::Combine($destDirName, $subdir.Name);
				[DirectoryCopy]::CopyDir($subdir.FullName, $tempPath, $copySubDirs);
			}
		}
	}
	
}

#endregion


######################
#region Global Declaration 
######################
[string]$ScriptDirectory = Get-ScriptDirectory
[string]$ScriptName = ($MyInvocation.MyCommand.Name.Split("."))[0]
[string]$local = 'localpath'
[string]$remoteRoot= 'remotepath'


#endregion 


##############################
# region Main
##############################

if ([System.IO.Directory]::Exists($local))
{
	try
	{
		if (!([System.IO.Directory]::Exists($remoteRoot)))
		{
			[System.IO.Directory]::CreateDirectory($remoteRoot)
		}
	}
	catch
	{
		Write-Host $_.Exception.Message
	}
}

if ([System.IO.Directory]::Exists($remoteRoot))
{
	[DirectoryCopy]::CopyDir($local, $remoteRoot, $true)
}

#endregion 


